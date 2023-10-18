// File: lib/screens/base_screen.dart
import 'package:flutter/material.dart';
import 'package:qualis/services/database_helper.dart';
import '../model/qualificacao.dart';
import '../services/qualis_services.dart';
import 'package:diacritic/diacritic.dart';

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
  IconData? _capesIcon;
  IconData? _tituloIcon;
  IconData? _areaIcon;
  IconData? _siglaIcon;

  void _updateTitle(String title) {
    setState(() {
      _title = title;
    });
  }

  void _removeOrder() {
    setState(() {
      _selectedOrderDim = '';
      _selectedOrder = '';
      _capesIcon = null;
      _tituloIcon = null;
      _areaIcon = null;
      _siglaIcon = null;
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
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: const Text('Ordenar'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: _title == 'Conferencia'
                                  ? const Text('Sigla')
                                  : const Text('ISSN'),
                              trailing: IconButton(
                                icon: Icon(_siglaIcon ?? Icons.arrow_upward,
                                    color: _siglaIcon == null
                                        ? Colors.white
                                        : null),
                                onPressed: () {
                                  setState(() {
                                    _selectedOrderDim = 'sigla';
                                    _siglaIcon =
                                        _siglaIcon == Icons.arrow_upward
                                            ? Icons.arrow_downward
                                            : Icons.arrow_upward;
                                    _tituloIcon = null;
                                    _areaIcon = null;
                                    _capesIcon = null;
                                    _selectedOrder =
                                        _siglaIcon == Icons.arrow_upward
                                            ? 'asc'
                                            : 'desc';
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text('Capes'),
                              trailing: IconButton(
                                icon: Icon(_capesIcon ?? Icons.arrow_upward,
                                    color: _capesIcon == null
                                        ? Colors.white
                                        : null),
                                onPressed: () {
                                  setState(() {
                                    _selectedOrderDim = 'capes';
                                    _capesIcon =
                                        _capesIcon == Icons.arrow_upward
                                            ? Icons.arrow_downward
                                            : Icons.arrow_upward;
                                    _tituloIcon = null;
                                    _areaIcon = null;
                                    _siglaIcon = null;
                                    _selectedOrder =
                                        _capesIcon == Icons.arrow_upward
                                            ? 'asc'
                                            : 'desc';
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text('Titulo'),
                              trailing: IconButton(
                                icon: Icon(_tituloIcon ?? Icons.arrow_upward,
                                    color: _tituloIcon == null
                                        ? Colors.white
                                        : null),
                                onPressed: () {
                                  setState(() {
                                    _selectedOrderDim = 'titulo';
                                    _tituloIcon =
                                        _tituloIcon == Icons.arrow_upward
                                            ? Icons.arrow_downward
                                            : Icons.arrow_upward;
                                    _capesIcon = null;
                                    _areaIcon = null;
                                    _siglaIcon = null;
                                    _selectedOrder =
                                        _tituloIcon == Icons.arrow_upward
                                            ? 'asc'
                                            : 'desc';
                                  });
                                },
                              ),
                            ),
                            (_title == 'Todos')
                                ? ListTile(
                                    title: const Text('Area'),
                                    trailing: IconButton(
                                      icon: Icon(
                                          _areaIcon ?? Icons.arrow_upward,
                                          color: _areaIcon == null
                                              ? Colors.white
                                              : null),
                                      onPressed: () {
                                        setState(() {
                                          _selectedOrderDim = 'area';
                                          _areaIcon =
                                              _areaIcon == Icons.arrow_upward
                                                  ? Icons.arrow_downward
                                                  : Icons.arrow_upward;
                                          _capesIcon = null;
                                          _tituloIcon = null;
                                          _siglaIcon = null;
                                          _selectedOrder =
                                              _areaIcon == Icons.arrow_upward
                                                  ? 'asc'
                                                  : 'desc';
                                        });
                                      },
                                    ),
                                  )
                                : Container()
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
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Todos'),
              onTap: () {
                _updateTitle('Todos');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Conferencia'),
              onTap: () {
                _updateTitle('Conferencia');
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
                if (_selectedOrderDim == 'titulo') {
                  return _selectedOrder == 'asc'
                      ? removeDiacritics(a.description)
                          .compareTo(removeDiacritics(b.description))
                      : removeDiacritics(b.description)
                          .compareTo(removeDiacritics(a.description));
                } else if (_selectedOrderDim == 'capes') {
                  return _selectedOrder == 'asc'
                      ? a.sigla.compareTo(b.sigla)
                      : b.sigla.compareTo(a.sigla);
                } else if (_selectedOrderDim == 'area' && _title == 'Todos') {
                  return _selectedOrder == 'asc'
                      ? removeDiacritics(a.quinto ?? '')
                          .compareTo(removeDiacritics(b.quinto ?? ''))
                      : removeDiacritics(b.quinto ?? '')
                          .compareTo(removeDiacritics(a.quinto ?? ''));
                } else if (_selectedOrderDim == 'sigla') {
                  return _selectedOrder == 'asc'
                      ? a.id.compareTo(b.id)
                      : b.id.compareTo(a.id);
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
                        'Capes: ${qualificacao.id}\nQualis: ${qualificacao.quarto}\nArea: ${qualificacao.quinto}',
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
}
