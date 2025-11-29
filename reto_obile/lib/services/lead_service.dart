import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/lead_model.dart';

class LeadService {
  final supabase = Supabase.instance.client;

  Future<List<Lead>> getLeads() async {
    final response = await supabase
        .from('leads')
        .select('id, full_name, category, email, phone, preferred_area, budget, urgency, intent_score, notes, status')
        .order('id', ascending: false);

    return response.map<Lead>((json) => Lead.fromJson(json)).toList();
  }

  Future<Lead?> getLeadById(int id) async {
    final response = await supabase
        .from('leads')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return Lead.fromJson(response);
  }
}
