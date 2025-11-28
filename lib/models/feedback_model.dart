import 'package:uuid/uuid.dart';

class FeedbackModel {
  final String feedbackId;
  final String appointmentInfoId;
  final int feedbackRating;
  final String feedbackComments;
  final DateTime feedbackDate;

  FeedbackModel({
    required this.feedbackId,
    required this.appointmentInfoId,
    required this.feedbackRating,
    required this.feedbackComments,
    required this.feedbackDate,
  });

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      feedbackId: map['feedback_id'],
      appointmentInfoId: map['appointment_info_id'],
      feedbackRating: map['feedback_rating'],
      feedbackComments: map['feedback_comments'],
      feedbackDate: DateTime.parse(map['feedback_date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'feedback_id': feedbackId,
      'appointment_info_id': appointmentInfoId,
      'feedback_rating': feedbackRating,
      'feedback_comments': feedbackComments,
      'feedback_date': feedbackDate.toIso8601String(),
    };
  }

  // Optional: helper to create new feedback (with UUID auto-generated)
  factory FeedbackModel.create({
    required String appointmentInfoId,
    required int feedbackRating,
    required String feedbackComments,
  }) {
    return FeedbackModel(
      feedbackId: const Uuid().v4(),
      appointmentInfoId: appointmentInfoId,
      feedbackRating: feedbackRating,
      feedbackComments: feedbackComments,
      feedbackDate: DateTime.now(),
    );
  }
}
