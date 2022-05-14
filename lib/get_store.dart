

import 'dart:convert';

import 'config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

String storee = 'k';
Future<void> getStoreName(var s,var p) async {

  final response = await http.post(Uri.parse(CONFIG.STORE_DET),
      body: {
        'store_id': s.toString(),
        'prd_id': p.toString()
      }
  );
  // setState(() {
  storee=jsonDecode(response.body);
  // });
}