import 'package:flutter/material.dart';

enum MedicationStatus {
  active,
  completed,
  skipped;

  String get name {
    switch (this) {
      case MedicationStatus.active:
        return 'Active';
      case MedicationStatus.completed:
        return 'Completed';
      case MedicationStatus.skipped:
        return 'Skipped';
    }
  }
}

class Medication {
  final String id;
  final String name;
  final String dosage;
  final String frequency;
  final DateTime startDate;
  final DateTime endDate;
  final MedicationStatus status;
  final DateTime lastTaken;
  final String notes;
  final Color color;
  final DateTime? nextDue;
  final int totalDoses;
  final int remainingDoses;

  const Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.lastTaken,
    this.notes = '',
    required this.color,
    this.nextDue,
    required this.totalDoses,
    required this.remainingDoses,
  });
}
