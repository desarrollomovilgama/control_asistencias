import 'package:flutter/material.dart';
import 'supabase_service.dart';

class TestConnection {
  static Future<void> test() async {
    try {
      final response = await SupabaseService.client
          .from('usuario')
          .select();

      debugPrint(response.toString());

      print('CONEXIÓN EXITOSA');
    } catch (e) {
      print('ERROR');
      print(e);
    }
  }
}