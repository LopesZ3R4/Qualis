// File: lib/screens/base_screen.dart
import 'package:flutter/material.dart';
import 'package:qualis/services/database_helper.dart';
import '../model/qualificacao.dart';
import '../services/qualis_services.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  String _title = 'Periodicos';
  final dbHelper = DatabaseHelper.instance;
  final apiService = ApiService();
  String _searchQuery = '';
  String _selectedOrderDim = '';
  String _selectedOrder = '';
  IconData? _siglaIcon;
  IconData? _descricaoIcon;

  Widget? _ordenacaoAlertDialog;

  void _updateTitle(String title) {
    setState(() {
      _title = title;
    });
  }

  @override
  void initState() {
    super.initState();
    _ordenacaoAlertDialog = _getOrdenacaoPeriodicos();
  }

  void _removeOrder() {
    setState(() {
      _selectedOrderDim = '';
      _selectedOrder = '';
      _siglaIcon = null;
      _descricaoIcon = null;
    });
  }

  void _setOrder(electedOrderDim, selectedOrder) {
    setState(() {
      _selectedOrderDim = electedOrderDim;
      _selectedOrder = selectedOrder;
    });
  }

  void _updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery.toLowerCase();
    });
  }

  Future<void> _syncData() async {
    await apiService.getConferencias();
    await apiService.getPeriodico();
    await apiService.getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3F51B5),
        title: Text(_title),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  // Ordenador ?
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return _ordenacaoAlertDialog ?? Container();
                    },
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Buscar'),
                    content: TextField(
                      onChanged: _updateSearchQuery,
                      decoration: const InputDecoration(
                          //labelText: 'Search',
                          ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Limpar',
                            style: TextStyle(color: Colors.red)),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Buscar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.sync, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Sync'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 1) {
                _syncData();
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF3F51B5),
              ),
              child: Text('Qualis - IC/UFMT'),
            ),
            ListTile(
              title: const Text('Periodicos'),
              onTap: () {
                _updateTitle('Periodicos');
                _ordenacaoAlertDialog = _getOrdenacaoPeriodicos();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Todos'),
              onTap: () {
                _updateTitle('Todos');
                _ordenacaoAlertDialog = _getOrdenacaoTodos();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Conferencia'),
              onTap: () {
                _updateTitle('Conferencia');
                _ordenacaoAlertDialog = _getOrdenacaoConferencia();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Qualificacao>>(
        future: dbHelper.queryAllRows(_title),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Qualificacao> qualificacoes = snapshot.data!;
            qualificacoes = qualificacoes.where((qualificacao) {
              return qualificacao.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase());
            }).toList();
            if (_selectedOrderDim.isNotEmpty) {
              qualificacoes.sort((a, b) {
                if (_selectedOrderDim.endsWith("_periodico")) {
                  if (_selectedOrderDim == 'issn_periodico') {
                    return _selectedOrder == 'asc'
                        ? a.id.compareTo(b.id)
                        : b.id.compareTo(a.id);
                  } else if (_selectedOrderDim == 'descricao_periodico') {
                    return _selectedOrder == 'asc'
                        ? a.description.compareTo(b.description)
                        : b.description.compareTo(a.description);
                  } else if (_selectedOrderDim == 'qualis_periodico') {
                    return _selectedOrder == 'asc'
                        ? a.sigla.compareTo(b.sigla)
                        : b.sigla.compareTo(a.sigla);
                  }
                }
                if (_selectedOrderDim.endsWith("_todos")) {
                  if (_selectedOrderDim == 'issn_todos') {
                    return _selectedOrder == 'asc'
                        ? a.id.compareTo(b.id)
                        : b.id.compareTo(a.id);
                  } else if (_selectedOrderDim == 'descricao_todos') {
                    return _selectedOrder == 'asc'
                        ? a.description.compareTo(b.description)
                        : b.description.compareTo(a.description);
                  } else if (_selectedOrderDim == 'qualis_comp_todos') {
                    return _selectedOrder == 'asc'
                        ? a.sigla.compareTo(b.sigla)
                        : b.sigla.compareTo(a.sigla);
                  } else if (_selectedOrderDim == 'qualis_todos') {
                    return _selectedOrder == 'asc'
                        ? a.quarto.compareTo(b.quarto)
                        : b.quarto.compareTo(a.quarto);
                  } else if (_selectedOrderDim == 'area_todos') {
                    return _selectedOrder == 'asc'
                        ? a.quinto.compareTo(b.quinto)
                        : b.quinto.compareTo(a.quinto);
                  }
                } else {
                  if (_selectedOrderDim == 'descricao') {
                    return _selectedOrder == 'asc'
                        ? a.description.compareTo(b.description)
                        : b.description.compareTo(a.description);
                  } else if (_selectedOrderDim == 'sigla') {
                    return _selectedOrder == 'asc'
                        ? a.id.compareTo(b.id)
                        : b.id.compareTo(a.id);
                  } else if (_selectedOrderDim == 'qualis') {
                    return _selectedOrder == 'asc'
                        ? a.sigla.compareTo(b.sigla)
                        : b.sigla.compareTo(a.sigla);
                  }
                }

                return 0;
              });
            }
            return RefreshIndicator(
              onRefresh: _syncData,
              child: ListView.builder(
                itemCount: qualificacoes.length,
                itemBuilder: (context, index) {
                  Qualificacao qualificacao = qualificacoes[index];

                  if (_title == 'Periodicos') {
                    return ListTile(
                      title: Text(qualificacao.description),
                      subtitle: Text(
                          '${qualificacao.id} - Qualis: ${qualificacao.sigla}'),
                    );
                  } else if (_title == 'Todos') {
                    return ListTile(
                      title: Text(qualificacao.description),
                      isThreeLine: true,
                      subtitle: Text(
                        'ISSN: ${qualificacao.id}\nQualis computação: ${qualificacao.sigla}\nQualis: ${qualificacao.quarto}\nÁrea: ${qualificacao.quinto}',
                      ),
                    );
                  }

                  return ListTile(
                    title: Text(qualificacao.description),
                    subtitle: Text(
                        '${qualificacao.id} - QUALIS: ${qualificacao.sigla}'),
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  AlertDialog _getOrdenacaoPeriodicos() {
    return AlertDialog(
      title: const Text('Ordenar'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: const Text('ISSN'),
            trailing: IconButton(
              icon: Icon(_siglaIcon ?? Icons.arrow_upward,
                  color: _siglaIcon == null ? Colors.white : null),
              onPressed: () {
                setState(() {
                  _selectedOrderDim = 'issn_periodico';
                  _siglaIcon = _siglaIcon == Icons.arrow_upward
                      ? Icons.arrow_downward
                      : Icons.arrow_upward;
                  _descricaoIcon = null;
                  _selectedOrder =
                      _siglaIcon == Icons.arrow_upward ? 'asc' : 'desc';
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Descrição'),
            trailing: IconButton(
              icon: Icon(_descricaoIcon ?? Icons.arrow_upward,
                  color: _descricaoIcon == null ? Colors.white : null),
              onPressed: () {
                setState(() {
                  _selectedOrderDim = 'descricao_periodico';
                  _descricaoIcon = _descricaoIcon == Icons.arrow_upward
                      ? Icons.arrow_downward
                      : Icons.arrow_upward;
                  _siglaIcon = null;
                  _selectedOrder =
                      _descricaoIcon == Icons.arrow_upward ? 'asc' : 'desc';
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Qualis'),
            trailing: IconButton(
              icon: Icon(_descricaoIcon ?? Icons.arrow_upward,
                  color: _descricaoIcon == null ? Colors.white : null),
              onPressed: () {
                setState(() {
                  _selectedOrderDim = 'qualis_periodico';
                  _descricaoIcon = _descricaoIcon == Icons.arrow_upward
                      ? Icons.arrow_downward
                      : Icons.arrow_upward;
                  _siglaIcon = null;
                  _selectedOrder =
                      _descricaoIcon == Icons.arrow_upward ? 'asc' : 'desc';
                });
              },
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            _removeOrder();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Apply'),
          onPressed: () {
            _setOrder(_selectedOrderDim, _selectedOrder);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  AlertDialog _getOrdenacaoTodos() {
    return AlertDialog(
      title: const Text('Ordenar'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: const Text('ISSN'),
            trailing: IconButton(
              icon: Icon(_siglaIcon ?? Icons.arrow_upward,
                  color: _siglaIcon == null ? Colors.white : null),
              onPressed: () {
                setState(() {
                  _selectedOrderDim = 'issn_todos';
                  _siglaIcon = _siglaIcon == Icons.arrow_upward
                      ? Icons.arrow_downward
                      : Icons.arrow_upward;
                  _descricaoIcon = null;
                  _selectedOrder =
                      _siglaIcon == Icons.arrow_upward ? 'asc' : 'desc';
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Descrição'),
            trailing: IconButton(
              icon: Icon(_descricaoIcon ?? Icons.arrow_upward,
                  color: _descricaoIcon == null ? Colors.white : null),
              onPressed: () {
                setState(() {
                  _selectedOrderDim = 'descricao_todos';
                  _descricaoIcon = _descricaoIcon == Icons.arrow_upward
                      ? Icons.arrow_downward
                      : Icons.arrow_upward;
                  _siglaIcon = null;
                  _selectedOrder =
                      _descricaoIcon == Icons.arrow_upward ? 'asc' : 'desc';
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Qualis computação'),
            trailing: IconButton(
              icon: Icon(_descricaoIcon ?? Icons.arrow_upward,
                  color: _descricaoIcon == null ? Colors.white : null),
              onPressed: () {
                setState(() {
                  _selectedOrderDim = 'qualis_comp_todos';
                  _descricaoIcon = _descricaoIcon == Icons.arrow_upward
                      ? Icons.arrow_downward
                      : Icons.arrow_upward;
                  _siglaIcon = null;
                  _selectedOrder =
                      _descricaoIcon == Icons.arrow_upward ? 'asc' : 'desc';
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Qualis'),
            trailing: IconButton(
              icon: Icon(_descricaoIcon ?? Icons.arrow_upward,
                  color: _descricaoIcon == null ? Colors.white : null),
              onPressed: () {
                setState(() {
                  _selectedOrderDim = 'qualis_todos';
                  _descricaoIcon = _descricaoIcon == Icons.arrow_upward
                      ? Icons.arrow_downward
                      : Icons.arrow_upward;
                  _siglaIcon = null;
                  _selectedOrder =
                      _descricaoIcon == Icons.arrow_upward ? 'asc' : 'desc';
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Área'),
            trailing: IconButton(
              icon: Icon(_descricaoIcon ?? Icons.arrow_upward,
                  color: _descricaoIcon == null ? Colors.white : null),
              onPressed: () {
                setState(() {
                  _selectedOrderDim = 'area_todos';
                  _descricaoIcon = _descricaoIcon == Icons.arrow_upward
                      ? Icons.arrow_downward
                      : Icons.arrow_upward;
                  _siglaIcon = null;
                  _selectedOrder =
                      _descricaoIcon == Icons.arrow_upward ? 'asc' : 'desc';
                });
              },
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            _removeOrder();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Apply'),
          onPressed: () {
            _setOrder(_selectedOrderDim, _selectedOrder);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  AlertDialog _getOrdenacaoConferencia() {
    return AlertDialog(
      title: const Text('Ordenar'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: const Text('Sigla'),
            trailing: IconButton(
              icon: Icon(_siglaIcon ?? Icons.arrow_upward,
                  color: _siglaIcon == null ? Colors.white : null),
              onPressed: () {
                setState(() {
                  _selectedOrderDim = 'sigla';
                  _siglaIcon = _siglaIcon == Icons.arrow_upward
                      ? Icons.arrow_downward
                      : Icons.arrow_upward;
                  _descricaoIcon = null;
                  _selectedOrder =
                      _siglaIcon == Icons.arrow_upward ? 'asc' : 'desc';
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Descrição'),
            trailing: IconButton(
              icon: Icon(_descricaoIcon ?? Icons.arrow_upward,
                  color: _descricaoIcon == null ? Colors.white : null),
              onPressed: () {
                setState(() {
                  _selectedOrderDim = 'descricao';
                  _descricaoIcon = _descricaoIcon == Icons.arrow_upward
                      ? Icons.arrow_downward
                      : Icons.arrow_upward;
                  _siglaIcon = null;
                  _selectedOrder =
                      _descricaoIcon == Icons.arrow_upward ? 'asc' : 'desc';
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Qualis'),
            trailing: IconButton(
              icon: Icon(_descricaoIcon ?? Icons.arrow_upward,
                  color: _descricaoIcon == null ? Colors.white : null),
              onPressed: () {
                setState(() {
                  _selectedOrderDim = 'qualis';
                  _descricaoIcon = _descricaoIcon == Icons.arrow_upward
                      ? Icons.arrow_downward
                      : Icons.arrow_upward;
                  _siglaIcon = null;
                  _selectedOrder =
                      _descricaoIcon == Icons.arrow_upward ? 'asc' : 'desc';
                });
              },
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            _removeOrder();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Apply'),
          onPressed: () {
            _setOrder(_selectedOrderDim, _selectedOrder);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
