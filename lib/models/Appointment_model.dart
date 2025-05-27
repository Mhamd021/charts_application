class AppointmentModel {
  final int id;
  final int doctorId;
  final String doctorName;
  final DateTime requestedAt;
  final DateTime? appointmentDate;
  final String centerName;
  final int centerId;
  final String? doctorNotes;
  final int status;

  AppointmentModel({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.requestedAt,
    this.appointmentDate,
    required this.centerName,
    required this.centerId,
    this.doctorNotes,
    required this.status,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      doctorId: json['doctorId'],
      doctorName: json['doctorName'],
      requestedAt: DateTime.parse(json['requestedAt']),
      appointmentDate: json['appointmentDate'] != "0001-01-01T00:00:00"
          ? DateTime.parse(json['appointmentDate'])
          : null, // Handles default API value
      centerName: json['centerName'],
      centerId: json['centerId'],
      doctorNotes: json['doctorNotes'],
      status: json['status'],
    );
  }
}
