class User {
  final String id;
  final String name;
  final String email;
  final String? profilePicture;
  final String? disease;
  final List<String> medications;
  final List<Appointment> appointments;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profilePicture,
    this.disease,
    this.medications = const [],
    this.appointments = const [],
  });
}

class Appointment {
  final String id;
  final DateTime date;
  final String doctorName;
  final String reason;

  Appointment({
    required this.id,
    required this.date,
    required this.doctorName,
    required this.reason,
  });
}
