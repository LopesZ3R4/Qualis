// File: lib/services/qualis_services.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/qualificacao.dart';
import 'database_helper.dart';

class ApiService {
  final String baseUrl = 'https://qualis.ic.ufmt.br';
  final dbHelper = DatabaseHelper.instance;

  Future<void> getConferencias() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/qualis_conferencias_2016.json')).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        List<dynamic> data = map['data'];
        for (var item in data) {
          Qualificacao qualificacao = Qualificacao(
            id: item[0],
            type: 'Conferencia',
            description: item[1],
            sigla: item[2],
          );
          await dbHelper.insert(qualificacao.toMap());
        }
      } else {
      }
    } catch (e) {
    }
  }

  Future<void> getPeriodico() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/periodico.json')).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        List<dynamic> data = map['data'];
        for (var item in data) {
          Qualificacao qualificacao = Qualificacao(
            id: item[0],
            type: 'Periodicos',
            description: item[1],
            sigla: item[2],
          );
          await dbHelper.insert(qualificacao.toMap());
        }
      } else {
      }
    } catch (e) {
    }
  }

  Future<void> getTodos() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/todos2.json')).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        List<dynamic> data = map['data'];
        for (var item in data) {
          Qualificacao qualificacao = Qualificacao(
            id: item[0],
            type: 'Todos',
            description: item[1],
            sigla: item[2],
          );
          await dbHelper.insert(qualificacao.toMap());
        }
      } else {
      }
    } catch (e) {
    }
  }
}