// File: lib/models/qualificacao.dart

class Qualificacao {
  final String id;
  final String type;
  final String description;
  final String sigla;

  Qualificacao({
    required this.id,
    required this.type,
    required this.description,
    required this.sigla,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'description': description,
      'sigla': sigla,
    };
  }

  factory Qualificacao.fromMap(Map<String, dynamic> map) {
    return Qualificacao(
      id: map['id'],
      type: map['type'],
      description: map['description'],
      sigla: map['sigla'],
    );
  }
}