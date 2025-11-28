import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/feedback_model.dart';

class FeedbackRepository {
  final SupabaseClient _client;

  FeedbackRepository(this._client);

  Future<void> insertFeedback(FeedbackModel feedback) async {
    try {
      await _client.from('feedback').insert(feedback.toMap());
    } catch (e) {
      throw Exception('Failed to insert feedback: $e');
    }
  }

  Future<List<FeedbackModel>> getFeedbackForAppointment(String appointmentId) async {
    try {
      final response = await _client
          .from('feedback')
          .select()
          .eq('appointment_info_id', appointmentId);

      return (response as List)
          .map((item) => FeedbackModel.fromMap(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch feedback: $e');
    }
  }
}
