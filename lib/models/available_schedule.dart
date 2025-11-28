
class AvailableSchedule {
  final String availScheduleId;
  final String serviceId;
  final DateTime availDate;
  final String availStartTime;
  final String availEndTime;

  const AvailableSchedule({
    required this.availScheduleId,
    required this.serviceId,
    required this.availDate,
    required this.availStartTime,
    required this.availEndTime,
  });

  factory AvailableSchedule.fromMap(Map<String, dynamic> map) {
    return AvailableSchedule(
      availScheduleId: map['avail_sched_id'],
      serviceId: map['service_id'],
      availDate: DateTime.parse(map['avail_date']),
      availStartTime: map['avail_start_time'],
      availEndTime: map['avail_end_time'],
    );
  }

  Map<String, dynamic> toMap() => {
    'avail_sched_id': availScheduleId,
    'service_id': serviceId,
    'avail_date': availDate.toIso8601String(),
    'avail_start_time': availStartTime,
    'avail_end_time': availEndTime,
  };
}
