// File: lib/services/qualis_services.dart

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../model/qualificacao.dart';
import 'database_helper.dart';

class ApiService {
  final String baseUrl = 'https://qualis.ic.ufmt.br';
  final dbHelper = DatabaseHelper.instance;

  Future<void> getConferencias() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/qualis_conferencias_2016.json'))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(utf8.decode(response.bodyBytes));
        List<dynamic> data = map['data'];
        for (var item in data) {
          Qualificacao qualificacao = Qualificacao(
            type: 'Conferencia',
            id: item[0],
            description: item[1],
            sigla: item[2],
            quarto: '',
            quinto: '',
          );
          await dbHelper.insert(qualificacao.toMap());
        }
      } else {}
    } catch (e) {}
  }

  Future<void> getPeriodico() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/periodico.json'))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(utf8.decode(response.bodyBytes));
        List<dynamic> data = map['data'];
        for (var item in data) {
          Qualificacao qualificacao = Qualificacao(
            type: 'Periodicos',
            id: item[0],
            description: item[1],
            sigla: item[2],
            quarto: '',
            quinto: '',
          );
          await dbHelper.insert(qualificacao.toMap());
        }
      } else {}
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getTodos() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/todos2.json'))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(utf8.decode(response.bodyBytes));
        List<dynamic> data = map['data'];
        for (var item in data) {
          Qualificacao qualificacao = Qualificacao(
            type: 'Todos',
            id: item[0],
            description: item[1],
            sigla: item[2],
            quarto: item[3],
            quinto: item[4],
          );
          await dbHelper.insert(qualificacao.toMap());
        }
      } else {}
    } catch (e) {}
  }
}
