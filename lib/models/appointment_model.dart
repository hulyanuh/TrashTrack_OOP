import 'appointment_waste.dart';

enum AppointmentStatus {
  pending('Pending'),
  confirmed('Confirmed'),
  completed('Completed'),
  cancelled('Cancelled');

  final String value;
  const AppointmentStatus(this.value);

  static AppointmentStatus fromString(String status) {
    return AppointmentStatus.values.firstWhere(
      (e) => e.value.toLowerCase() == status.toLowerCase(),
      orElse: () => AppointmentStatus.pending,
    );
  }

  String toSupabaseString() => value;
}

enum AppointmentType { pickUp, dropOff }

class Appointment {
  final String? appointmentInfoId;
  final String userInfoId;
  final String? userFullName; // Added field for user's full name
  final String serviceId;
  final AppointmentType appointmentType;
  final String? availSchedId;
  final DateTime appointmentDate;
  final DateTime? appointmentCreateDate;
  final DateTime? appointmentConfirmDate;
  final DateTime? appointmentCancelDate;
  final String appointmentLocation;
  final AppointmentStatus appointmentStatus;
  final String? appointmentNotes;
  final double? appointmentPriceFee;
  final List<AppointmentWaste> wasteMaterials;
  final String? qrCodeData; // New field for QR code data

  const Appointment({
    this.appointmentInfoId,
    required this.userInfoId,
    this.userFullName,
    required this.serviceId,
    required this.appointmentType,
    this.availSchedId,
    required this.appointmentDate,
    this.appointmentCreateDate,
    this.appointmentConfirmDate,
    this.appointmentCancelDate,
    required this.appointmentLocation,
    required this.appointmentStatus,
    this.appointmentNotes,
    this.appointmentPriceFee,
    this.wasteMaterials = const [],
    this.qrCodeData,
  });

  Map<String, dynamic> toMap() => {
    'appointment_info_id': appointmentInfoId,
    'user_info_id': userInfoId,
    'service_id': serviceId,
    'appointment_type': appointmentType == AppointmentType.pickUp
        ? 'Pick-Up'
        : 'Drop-Off',
    'avail_sched_id': availSchedId,
    'appointment_date': appointmentDate.toIso8601String(),
    'appointment_confirm_date': appointmentConfirmDate?.toIso8601String(),
    'appointment_cancel_date': appointmentCancelDate?.toIso8601String(),
    'appointment_location': appointmentLocation,
    'appointment_status': appointmentStatus.toSupabaseString(),
    'appointment_notes': appointmentNotes,
    'appointment_price_fee': appointmentPriceFee,
    'appointment_qr_code': qrCodeData,
  };

  factory Appointment.fromMap(Map<String, dynamic> map) {
    String? userFullName;

    // Check for nested user_info from join query
    if (map['user_info'] != null) {
      final userData = map['user_info'] as Map<String, dynamic>?;
      if (userData != null) {
        final firstName = userData['user_fname'] as String? ?? '';
        final lastName = userData['user_lname'] as String? ?? '';
        if (firstName.isNotEmpty || lastName.isNotEmpty) {
          userFullName = '$firstName $lastName'.trim();
        }
      }
    }
    // Check for user data from user field
    else if (map['user'] != null) {
      final userData = map['user'] as Map<String, dynamic>?;
      if (userData != null) {
        final firstName = userData['user_fname'] as String? ?? '';
        final lastName = userData['user_lname'] as String? ?? '';
        if (firstName.isNotEmpty || lastName.isNotEmpty) {
          userFullName = '$firstName $lastName'.trim();
        }
      }
    }
    return Appointment(
      appointmentInfoId: map['appointment_info_id'],
      userInfoId: map['user_info_id'],
      userFullName: userFullName,
      serviceId: map['service_id'],
      appointmentType: map['appointment_type'] == 'Pick-Up'
          ? AppointmentType.pickUp
          : AppointmentType.dropOff,
      availSchedId: map['avail_sched_id'],
      appointmentDate: DateTime.parse(map['appointment_date']),
      appointmentCreateDate: map['appointment_create_date'] != null
          ? DateTime.parse(map['appointment_create_date'])
          : null,
      appointmentConfirmDate: map['appointment_confirm_date'] != null
          ? DateTime.parse(map['appointment_confirm_date'])
          : null,
      appointmentCancelDate: map['appointment_cancel_date'] != null
          ? DateTime.parse(map['appointment_cancel_date'])
          : null,
      appointmentLocation: map['appointment_location'],
      appointmentStatus: AppointmentStatus.fromString(
        map['appointment_status'],
      ),
      appointmentNotes: map['appointment_notes'],
      appointmentPriceFee: map['appointment_price_fee'] != null
          ? (map['appointment_price_fee'] as num).toDouble()
          : null,
      wasteMaterials: map['appointment_trash'] != null
          ? (map['appointment_trash'] as List)
                .map((w) => AppointmentWaste.fromMap(w as Map<String, dynamic>))
                .toList()
          : [],
      qrCodeData: map['appointment_qr_code'],
    );
  }
}
