import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/feedback_model.dart';
import '../repositories/feedback_repository.dart';

// Repository Provider
final feedbackRepositoryProvider = Provider<FeedbackRepository>((ref) {
  final client = Supabase.instance.client;
  return FeedbackRepository(client);
});

// Submit Feedback Provider
final submitFeedbackProvider = FutureProvider.family<void, FeedbackModel>((ref, feedback) async {
  final repository = ref.read(feedbackRepositoryProvider);
  await repository.insertFeedback(feedback);
});

// Get Feedback by Appointment ID
final feedbackListProvider = FutureProvider.family<List<FeedbackModel>, String>((ref, appointmentId) async {
  final repository = ref.read(feedbackRepositoryProvider);
  return repository.getFeedbackForAppointment(appointmentId);
});
