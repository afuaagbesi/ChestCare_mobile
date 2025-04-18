import 'package:flutter/foundation.dart';

class AppointmentProvider with ChangeNotifier {
  final List<Appointment> _appointments = [
    // Initial mock data
    Appointment(
      id: '1',
      doctorName: 'Dr. Sarah Johnson',
      specialty: 'Pulmonologist',
      date: DateTime.now().add(const Duration(days: 2)),
      time: '10:00 AM',
      status: AppointmentStatus.upcoming,
      location: 'Main Hospital, Room 205',
      reason: 'Follow-up consultation',
      notes: '',
    ),
    Appointment(
      id: '2',
      doctorName: 'Dr. Michael Chen',
      specialty: 'General Physician',
      date: DateTime.now().add(const Duration(days: 5)),
      time: '2:30 PM',
      status: AppointmentStatus.upcoming,
      location: 'Health Center, Room 101',
      reason: 'Regular checkup',
      notes: '',
    ),
    Appointment(
      id: '3',
      doctorName: 'Dr. Emily Wilson',
      specialty: 'Radiologist',
      date: DateTime.now().subtract(const Duration(days: 1)),
      time: '11:00 AM',
      status: AppointmentStatus.completed,
      location: 'Imaging Center, Room 304',
      reason: 'Chest X-Ray',
      notes: 'Results pending',
    ),
  ];

  // Get all appointments
  List<Appointment> get appointments => [..._appointments];

  // Get upcoming appointments
  List<Appointment> get upcomingAppointments => _appointments
      .where((appointment) => appointment.status == AppointmentStatus.upcoming)
      .toList();

  // Get completed appointments
  List<Appointment> get completedAppointments => _appointments
      .where((appointment) => appointment.status == AppointmentStatus.completed)
      .toList();

  // Get cancelled appointments
  List<Appointment> get cancelledAppointments => _appointments
      .where((appointment) => appointment.status == AppointmentStatus.cancelled)
      .toList();

  // Add new appointment
  void addAppointment(Appointment appointment) {
    _appointments.add(appointment);
    notifyListeners();
  }

  // Cancel appointment
  void cancelAppointment(String id) {
    final index =
        _appointments.indexWhere((appointment) => appointment.id == id);
    if (index != -1) {
      _appointments[index] = _appointments[index].copyWith(
        status: AppointmentStatus.cancelled,
      );
      notifyListeners();
    }
  }

  // Reschedule appointment
  void rescheduleAppointment(String id, DateTime newDate, String newTime) {
    final index =
        _appointments.indexWhere((appointment) => appointment.id == id);
    if (index != -1) {
      _appointments[index] = _appointments[index].copyWith(
        date: newDate,
        time: newTime,
      );
      notifyListeners();
    }
  }

  // Get appointment by date
  List<Appointment> getAppointmentsByDate(DateTime date) {
    return _appointments
        .where((appointment) =>
            appointment.date.year == date.year &&
            appointment.date.month == date.month &&
            appointment.date.day == date.day)
        .toList();
  }

  // Get appointments for today
  List<Appointment> get todayAppointments {
    final today = DateTime.now();
    return getAppointmentsByDate(today);
  }

  // Get appointments for tomorrow
  List<Appointment> get tomorrowAppointments {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return getAppointmentsByDate(tomorrow);
  }

  // Get appointments for this week
  List<Appointment> get thisWeekAppointments {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return _appointments
        .where((appointment) =>
            appointment.date
                .isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
            appointment.date.isBefore(endOfWeek.add(const Duration(days: 1))))
        .toList();
  }
}

enum AppointmentStatus {
  upcoming,
  completed,
  cancelled;

  String get name {
    switch (this) {
      case AppointmentStatus.upcoming:
        return 'Upcoming';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class Appointment {
  final String id;
  final String doctorName;
  final String specialty;
  final DateTime date;
  final String time;
  final AppointmentStatus status;
  final String location;
  final String reason;
  final String notes;

  const Appointment({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
    required this.status,
    required this.location,
    required this.reason,
    this.notes = '',
  });

  // Copy with method to create a new Appointment with some changed fields
  Appointment copyWith({
    String? id,
    String? doctorName,
    String? specialty,
    DateTime? date,
    String? time,
    AppointmentStatus? status,
    String? location,
    String? reason,
    String? notes,
  }) {
    return Appointment(
      id: id ?? this.id,
      doctorName: doctorName ?? this.doctorName,
      specialty: specialty ?? this.specialty,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      location: location ?? this.location,
      reason: reason ?? this.reason,
      notes: notes ?? this.notes,
    );
  }
}
