enum Tipo {
  periodico('Periodico'),
  conferencia('Conferencia'),
  todos('Todos');

  const Tipo(this.tipo);
  final String tipo;
}

class Documento {
  final String tipo;
  final List<String> dados;

  Documento({required this.tipo, required this.dados});

  factory Documento.fromList(Tipo tipo, List<String> entry) {
    return Documento(
      tipo: tipo.tipo,
      dados: entry,
    );
  }
}
