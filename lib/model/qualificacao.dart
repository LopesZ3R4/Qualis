// File: lib/models/qualificacao.dart

class Qualificacao {
  final String id;
  final String type;
  final String description;
  final String sigla;
  final String? quarto;
  final String? quinto;

  Qualificacao({
    required this.type,
    required this.id,
    required this.description,
    required this.sigla,
    this.quarto,
    this.quinto,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'description': description,
      'sigla': sigla,
      'quarto': quarto,
      'quinto': quinto
    };
  }

  factory Qualificacao.fromMap(Map<String, dynamic> map) {
    return Qualificacao(
      id: map['id'],
      type: map['type'],
      description: map['description'],
      sigla: map['sigla'],
      quarto: map['quarto'] ?? '',
      quinto: map['quinto'] ?? '',
    );
  }
}
