import 'package:reto_obile/models/propiety_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PropertyService {
  final supabase = Supabase.instance.client;

  // Leer todas las propiedades
  Future<List<Property>> getAllProperties() async {
    try {
      final data = await supabase.from('properties').select() as List<dynamic>?;

      if (data == null || data.isEmpty) return [];

      return data.map((e) => Property.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e, stack) {
      print('Error en getAllProperties: $e');
      print(stack);
      return [];
    }
  }

  // Leer propiedad por ID
  Future<Property?> getPropertyById(int id) async {
    try {
      final data = await supabase
          .from('properties')
          .select()
          .eq('id', id)
          .maybeSingle() as Map<String, dynamic>?;

      if (data == null) return null;

      return Property.fromMap(data);
    } catch (e, stack) {
      print('Error en getPropertyById: $e');
      print(stack);
      return null;
    }
  }

  // Crear propiedad
  Future<Property?> createProperty(Property property) async {
    try {
      final data = await supabase
          .from('properties')
          .insert(property.toMap())
          .select() as List<dynamic>?;

      if (data == null || data.isEmpty) return null;

      return Property.fromMap(data.first as Map<String, dynamic>);
    } catch (e, stack) {
      print('Error en createProperty: $e');
      print(stack);
      return null;
    }
  }

  // Actualizar propiedad
  Future<Property?> updateProperty(int id, Map<String, dynamic> updates) async {
    try {
      final data = await supabase
          .from('properties')
          .update(updates)
          .eq('id', id)
          .select() as List<dynamic>?;

      if (data == null || data.isEmpty) return null;

      return Property.fromMap(data.first as Map<String, dynamic>);
    } catch (e, stack) {
      print('Error en updateProperty: $e');
      print(stack);
      return null;
    }
  }

  // Eliminar propiedad
  Future<bool> deleteProperty(int id) async {
    try {
      final response = await supabase.from('properties').delete().eq('id', id);
      return response != null;
    } catch (e, stack) {
      print('Error en deleteProperty: $e');
      print(stack);
      return false;
    }
  }

  // Paginación
  Future<List<Property>> getPropertiesPaginated({int from = 0, int to = 9}) async {
    try {
      final data = await supabase
          .from('properties')
          .select()
          .range(from, to) as List<dynamic>?;

      if (data == null || data.isEmpty) return [];

      return data.map((e) => Property.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e, stack) {
      print('Error en getPropertiesPaginated: $e');
      print(stack);
      return [];
    }
  }
}
