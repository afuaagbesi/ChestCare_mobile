import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';
import '../models/medication.dart';
import 'dart:async';
import 'add_medication_screen.dart';

class MedicationListScreen extends StatefulWidget {
  const MedicationListScreen({super.key});

  @override
  State<MedicationListScreen> createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen>
    with SingleTickerProviderStateMixin {
  // Animation controller for smooth transitions
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Mock data - In real app, this would come from a provider or API
  final List<Medication> _medications = [
    Medication(
      id: '1',
      name: 'Isoniazid',
      dosage: '300mg',
      frequency: 'Once daily',
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now().add(const Duration(days: 60)),
      status: MedicationStatus.active,
      lastTaken: DateTime.now().subtract(const Duration(hours: 12)),
      notes: 'Take with food to reduce stomach discomfort',
      color: Colors.blue,
      nextDue: DateTime.now().add(const Duration(hours: 12)),
      totalDoses: 90,
      remainingDoses: 60,
    ),
    Medication(
      id: '2',
      name: 'Rifampin',
      dosage: '600mg',
      frequency: 'Once daily',
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now().add(const Duration(days: 60)),
      status: MedicationStatus.active,
      lastTaken: DateTime.now().subtract(const Duration(hours: 8)),
      notes: 'May cause urine to turn reddish-orange',
      color: Colors.orange,
      nextDue: DateTime.now().add(const Duration(hours: 16)),
      totalDoses: 90,
      remainingDoses: 60,
    ),
    Medication(
      id: '3',
      name: 'Pyrazinamide',
      dosage: '1500mg',
      frequency: 'Once daily',
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now().add(const Duration(days: 30)),
      status: MedicationStatus.completed,
      lastTaken: DateTime.now().subtract(const Duration(days: 1)),
      notes: 'Monitor for joint pain or gout symptoms',
      color: Colors.green,
      nextDue: null,
      totalDoses: 60,
      remainingDoses: 0,
    ),
    Medication(
      id: '4',
      name: 'Ethambutol',
      dosage: '1200mg',
      frequency: 'Once daily',
      startDate: DateTime.now().subtract(const Duration(days: 45)),
      endDate: DateTime.now().add(const Duration(days: 15)),
      status: MedicationStatus.active,
      lastTaken: DateTime.now().subtract(const Duration(hours: 4)),
      notes: 'Report any vision changes immediately',
      color: Colors.purple,
      nextDue: DateTime.now().add(const Duration(hours: 20)),
      totalDoses: 60,
      remainingDoses: 15,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    // Filter medications by status
    final activeMedications = _medications
        .where((med) => med.status == MedicationStatus.active)
        .toList();
    final completedMedications = _medications
        .where((med) => med.status == MedicationStatus.completed)
        .toList();

    return Scaffold(
      backgroundColor: isDarkMode ? AppTheme.darkBgBlueBlack : Colors.grey[50],
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.darkBgBlueBlack,
                    AppTheme.darkSurfaceBlueBlack.withOpacity(0.9),
                  ],
                )
              : null,
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: _medications.isEmpty
              ? _buildEmptyState(isDarkMode)
              : _buildMedicationsList(
                  activeMedications, completedMedications, isDarkMode),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewMedication(context),
        backgroundColor: isDarkMode ? AppTheme.navyBlue : AppTheme.deepNavy,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppTheme.navyBlue.withOpacity(0.2)
                  : AppTheme.navyBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.medication_outlined,
              size: 50,
              color: isDarkMode ? AppTheme.lightBlue : AppTheme.navyBlue,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Medications Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Add your prescribed medications to keep track of your treatment',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement new medication
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Add new medication feature coming soon'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Medication'),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDarkMode ? AppTheme.navyBlue : AppTheme.deepNavy,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationsList(List<Medication> activeMedications,
      List<Medication> completedMedications, bool isDarkMode) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        // Active medications section
        if (activeMedications.isNotEmpty) ...[
          _buildSectionHeader('Active Medications',
              Icons.assignment_turned_in_outlined, isDarkMode),
          ...activeMedications.map(
              (medication) => _buildMedicationCard(medication, isDarkMode)),
          const SizedBox(height: 16),
        ],

        // Completed medications section
        if (completedMedications.isNotEmpty) ...[
          _buildSectionHeader(
              'Completed Medications', Icons.check_circle_outline, isDarkMode),
          ...completedMedications.map(
              (medication) => _buildMedicationCard(medication, isDarkMode)),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppTheme.navyBlue.withOpacity(0.2)
                  : AppTheme.navyBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 18,
              color: isDarkMode ? AppTheme.lightBlue : AppTheme.navyBlue,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationCard(Medication medication, bool isDarkMode) {
    final isActive = medication.status == MedicationStatus.active;
    final Color baseColor = medication.color;
    final Color cardBgColor =
        isDarkMode ? AppTheme.darkCardBlueBlack : Colors.white;

    // Progress calculation
    final progress = isActive && medication.totalDoses > 0
        ? 1 - (medication.remainingDoses / medication.totalDoses)
        : 1.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showMedicationDetails(medication),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Medication icon with color
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            baseColor,
                            Color.lerp(baseColor, Colors.black, 0.3)!,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: baseColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.medication_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Medication name and details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            medication.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${medication.dosage} · ${medication.frequency}',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDarkMode
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(medication.status, isDarkMode)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        medication.status.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(medication.status, isDarkMode),
                        ),
                      ),
                    ),
                  ],
                ),

                // Progress bar for active medications
                if (isActive) ...[
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ),
                          Text(
                            '${(progress * 100).toInt()}% Complete',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: baseColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: baseColor.withOpacity(0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(baseColor),
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${medication.remainingDoses} doses remaining of ${medication.totalDoses}',
                        style: TextStyle(
                          fontSize: 11,
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),

                // Info rows
                Row(
                  children: [
                    _buildInfoItem(
                      Icons.calendar_today_outlined,
                      'Started: ${_formatDate(medication.startDate)}',
                      isDarkMode,
                    ),
                    const SizedBox(width: 16),
                    _buildInfoItem(
                      Icons.event_outlined,
                      'Ends: ${_formatDate(medication.endDate)}',
                      isDarkMode,
                    ),
                  ],
                ),

                // Action buttons for active medications
                if (isActive) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Next dose info
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Next dose',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ),
                          Text(
                            _formatTimeFromNow(medication.nextDue),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      // Action button
                      ElevatedButton(
                        onPressed: () => _markAsTaken(medication),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: baseColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                        ),
                        child: const Text('Take Now'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, bool isDarkMode) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 16,
            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Show medication details dialog
  void _showMedicationDetails(Medication medication) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final Color baseColor = medication.color;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isDarkMode ? AppTheme.darkCardBlueBlack : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        baseColor,
                        Color.lerp(baseColor, Colors.black, 0.3)!,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: baseColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.medication_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  medication.name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(medication.status, isDarkMode)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    medication.status.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(medication.status, isDarkMode),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Medication details
              _buildDetailRow('Dosage', medication.dosage,
                  Icons.medical_services_outlined, isDarkMode),
              const SizedBox(height: 12),
              _buildDetailRow('Frequency', medication.frequency, Icons.schedule,
                  isDarkMode),
              const SizedBox(height: 12),
              _buildDetailRow('Start Date', _formatDate(medication.startDate),
                  Icons.today, isDarkMode),
              const SizedBox(height: 12),
              _buildDetailRow('End Date', _formatDate(medication.endDate),
                  Icons.event, isDarkMode),

              if (medication.notes.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildDetailRow(
                    'Notes', medication.notes, Icons.note, isDarkMode),
              ],

              if (medication.status == MedicationStatus.active) ...[
                const SizedBox(height: 12),
                _buildDetailRow(
                    'Last Taken',
                    _formatDateTime(medication.lastTaken),
                    Icons.access_time,
                    isDarkMode),
                const SizedBox(height: 12),
                _buildDetailRow(
                    'Next Due',
                    _formatDateTime(medication.nextDue!),
                    Icons.alarm,
                    isDarkMode),
              ],

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor:
                          isDarkMode ? Colors.grey[400] : Colors.grey[700],
                    ),
                    child: const Text('Close'),
                  ),
                  if (medication.status == MedicationStatus.active) ...[
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _markAsTaken(medication);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: baseColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Take Now'),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      String label, String value, IconData icon, bool isDarkMode) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppTheme.navyBlue.withOpacity(0.1)
                : AppTheme.navyBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isDarkMode ? AppTheme.lightBlue : AppTheme.navyBlue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _markAsTaken(Medication medication) {
    // Calculate remaining doses
    final remainingDoses = medication.remainingDoses - 1;

    if (remainingDoses <= 0) {
      // If no doses remaining, mark as completed
      _updateMedicationStatus(medication, MedicationStatus.completed);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${medication.name} completed!'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } else {
      // Otherwise update with new "lastTaken" time and reduced remaining doses
      _updateMedicationStatus(medication, MedicationStatus.active);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${medication.name} marked as taken'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: medication.color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Color _getStatusColor(MedicationStatus status, bool isDarkMode) {
    switch (status) {
      case MedicationStatus.active:
        return isDarkMode ? Colors.green.shade300 : Colors.green.shade700;
      case MedicationStatus.completed:
        return isDarkMode ? Colors.blue.shade300 : Colors.blue.shade700;
      case MedicationStatus.skipped:
        return isDarkMode ? Colors.orange.shade300 : Colors.orange.shade700;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, h:mm a').format(dateTime);
  }

  String _formatTimeFromNow(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';

    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.isNegative) {
      return 'Overdue';
    } else if (difference.inHours < 1) {
      return 'In ${difference.inMinutes} minutes';
    } else if (difference.inHours < 24) {
      return 'In ${difference.inHours} hours';
    } else {
      return 'In ${difference.inDays} days';
    }
  }

  Future<void> _addNewMedication(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddMedicationScreen()),
    );

    if (result != null && result is Medication) {
      setState(() {
        _medications.add(result);
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${result.name} added to your medications'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: result.color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _updateMedicationStatus(
      Medication medication, MedicationStatus newStatus) {
    final index = _medications.indexWhere((med) => med.id == medication.id);
    if (index != -1) {
      setState(() {
        // Create a new medication with updated status
        final updatedMedication = Medication(
          id: medication.id,
          name: medication.name,
          dosage: medication.dosage,
          frequency: medication.frequency,
          startDate: medication.startDate,
          endDate: medication.endDate,
          status: newStatus,
          lastTaken: DateTime.now(),
          notes: medication.notes,
          color: medication.color,
          nextDue: newStatus == MedicationStatus.active
              ? _calculateNextDue(medication)
              : null,
          totalDoses: medication.totalDoses,
          remainingDoses: newStatus == MedicationStatus.completed
              ? 0
              : medication.remainingDoses -
                  (newStatus == MedicationStatus.active ? 1 : 0),
        );

        _medications[index] = updatedMedication;
      });
    }
  }

  DateTime? _calculateNextDue(Medication medication) {
    final now = DateTime.now();

    switch (medication.frequency) {
      case 'Once daily':
        return DateTime(now.year, now.month, now.day)
            .add(const Duration(days: 1, hours: 8));
      case 'Twice daily':
        final nextTime = now.hour < 14 ? 20 : 8;
        return DateTime(now.year, now.month, now.day, nextTime);
      case 'Three times daily':
        if (now.hour < 8) {
          return DateTime(now.year, now.month, now.day, 8);
        } else if (now.hour < 14) {
          return DateTime(now.year, now.month, now.day, 14);
        } else {
          return DateTime(now.year, now.month, now.day, 20);
        }
      case 'Every other day':
        return DateTime(now.year, now.month, now.day)
            .add(const Duration(days: 2, hours: 8));
      case 'Once weekly':
        return DateTime(now.year, now.month, now.day)
            .add(const Duration(days: 7, hours: 8));
      case 'As needed':
        return null;
      default:
        return DateTime(now.year, now.month, now.day)
            .add(const Duration(days: 1, hours: 8));
    }
  }
}
