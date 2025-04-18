import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/theme_provider.dart';
import '../providers/appointment_provider.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'book_appointment_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class AppointmentListScreen extends StatefulWidget {
  const AppointmentListScreen({super.key});

  @override
  State<AppointmentListScreen> createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Define vibrant colors for status indicators and buttons
  static const Map<String, Color> statusColors = {
    'confirmed': Color(0xFF00C853), // Vibrant green
    'pending': Color(0xFFFFAB00), // Vibrant amber
    'cancelled': Color(0xFFFF5252), // Vibrant red
  };

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
    final appointmentProvider = Provider.of<AppointmentProvider>(context);
    final appointments = appointmentProvider.appointments;

    return Scaffold(
      backgroundColor: isDarkMode ? AppTheme.darkBgBlueBlack : Colors.grey[50],
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'My Appointments',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
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
          child: appointments.isEmpty
              ? _buildEmptyState(isDarkMode)
              : _buildAppointmentList(appointments, isDarkMode),
        ),
      ),
      floatingActionButton: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [AppTheme.navyBlue, AppTheme.lightBlue]
                : [AppTheme.deepNavy, AppTheme.accentColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? AppTheme.lightBlue.withOpacity(0.3)
                  : AppTheme.navyBlue.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const BookAppointmentScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 300),
              ),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          label: Row(
            children: [
              const Icon(Icons.add, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'Book Now',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          isExtended: true,
        ),
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
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [
                        AppTheme.navyBlue.withOpacity(0.5),
                        AppTheme.lightBlue.withOpacity(0.2)
                      ]
                    : [
                        AppTheme.navyBlue.withOpacity(0.2),
                        AppTheme.accentColor.withOpacity(0.1)
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.calendar_today_outlined,
              size: 50,
              color: isDarkMode ? AppTheme.lightBlue : AppTheme.navyBlue,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Appointments Yet',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Schedule your first appointment with our specialists',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [AppTheme.navyBlue, AppTheme.lightBlue]
                    : [AppTheme.deepNavy, AppTheme.accentColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? AppTheme.lightBlue.withOpacity(0.2)
                      : AppTheme.navyBlue.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const BookAppointmentScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 300),
                  ),
                );
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Text(
                  'Book Appointment',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentList(dynamic appointments, bool isDarkMode) {
    List<Map<String, dynamic>> appointmentMaps = [];

    if (appointments is List && appointments.isNotEmpty) {
      for (var appointment in appointments) {
        Map<String, dynamic> appointmentMap = {
          'id': appointment.id,
          'doctorName': appointment.doctorName,
          'specialty': appointment.specialty,
          'date': appointment.date,
          'time': appointment.time,
          'status': appointment.status.toString().split('.').last,
          'location': appointment.location,
          'reason': appointment.reason,
          'notes': appointment.notes,
        };
        appointmentMaps.add(appointmentMap);
      }
    } else if (appointments is List<Map<String, dynamic>>) {
      appointmentMaps = appointments;
    }

    final Map<String, List<Map<String, dynamic>>> groupedAppointments = {};

    for (var appointment in appointmentMaps) {
      final dateString =
          DateFormat('EEEE, MMMM d, y').format(appointment['date']);
      if (!groupedAppointments.containsKey(dateString)) {
        groupedAppointments[dateString] = [];
      }
      groupedAppointments[dateString]!.add(appointment);
    }

    final sortedDates = groupedAppointments.keys.toList()
      ..sort((a, b) {
        final dateA = DateFormat('EEEE, MMMM d, y').parse(a);
        final dateB = DateFormat('EEEE, MMMM d, y').parse(b);
        return dateA.compareTo(dateB);
      });

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final dateAppointments = groupedAppointments[date]!;

        final dateObj = DateFormat('EEEE, MMMM d, y').parse(date);
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final tomorrow = today.add(const Duration(days: 1));
        final isToday = dateObj.year == today.year &&
            dateObj.month == today.month &&
            dateObj.day == today.day;
        final isTomorrow = dateObj.year == tomorrow.year &&
            dateObj.month == tomorrow.month &&
            dateObj.day == tomorrow.day;

        String dateLabel;
        if (isToday) {
          dateLabel = 'Today';
        } else if (isTomorrow) {
          dateLabel = 'Tomorrow';
        } else {
          dateLabel = date;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
                      Icons.event,
                      size: 18,
                      color:
                          isDarkMode ? AppTheme.lightBlue : AppTheme.navyBlue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    dateLabel,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            ...dateAppointments.map((appointment) => _buildAppointmentCard(
                  appointment,
                  isDarkMode,
                  isToday || isTomorrow ? dateLabel : null,
                )),
            if (index < sortedDates.length - 1) const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildAppointmentCard(
      Map<String, dynamic> appointment, bool isDarkMode, String? dateLabel) {
    Color statusColor;
    if (appointment['status'] == 'confirmed') {
      statusColor = Colors.green;
    } else if (appointment['status'] == 'pending') {
      statusColor = Colors.orange;
    } else if (appointment['status'] == 'cancelled') {
      statusColor = Colors.red;
    } else {
      statusColor = isDarkMode ? AppTheme.navyBlue : AppTheme.deepNavy;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.darkCardBlueBlack : Colors.white,
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
          onTap: () => _showAppointmentDetails(appointment),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            statusColor,
                            Color.lerp(statusColor, Colors.black, 0.3)!,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: statusColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.medical_services_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment['doctorName'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            appointment['specialty'],
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        appointment['status'].toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoItem(
                      Icons.calendar_today_outlined,
                      dateLabel ??
                          DateFormat('MMM d, y').format(appointment['date']),
                      isDarkMode,
                    ),
                    const SizedBox(width: 16),
                    _buildInfoItem(
                      Icons.access_time_outlined,
                      appointment['time'],
                      isDarkMode,
                    ),
                    const SizedBox(width: 16),
                    _buildInfoItem(
                      Icons.location_on_outlined,
                      appointment['location'] ?? 'ChestCare Center',
                      isDarkMode,
                      isLocation: true,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (appointment['status'] != 'cancelled')
                      TextButton.icon(
                        onPressed: () => _showRescheduleDialog(appointment),
                        icon: Icon(
                          Icons.edit_calendar_outlined,
                          size: 16,
                          color: isDarkMode
                              ? AppTheme.lightBlue
                              : AppTheme.navyBlue,
                        ),
                        label: Text(
                          'Reschedule',
                          style: TextStyle(
                            color: isDarkMode
                                ? AppTheme.lightBlue
                                : AppTheme.navyBlue,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    if (appointment['status'] != 'cancelled')
                      TextButton.icon(
                        onPressed: () => _showCancelDialog(appointment),
                        icon: Icon(
                          Icons.cancel_outlined,
                          size: 16,
                          color: isDarkMode ? Colors.red.shade300 : Colors.red,
                        ),
                        label: Text(
                          'Cancel',
                          style: TextStyle(
                            color:
                                isDarkMode ? Colors.red.shade300 : Colors.red,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, bool isDarkMode,
      {bool isLocation = false}) {
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
              maxLines: isLocation ? 1 : 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showAppointmentDetails(Map<String, dynamic> appointment) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

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
              Text(
                'Appointment Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              _buildDetailRow(
                'Doctor',
                appointment['doctorName'],
                Icons.person,
                isDarkMode,
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                'Specialty',
                appointment['specialty'],
                Icons.medical_services,
                isDarkMode,
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                'Date',
                DateFormat('EEEE, MMMM d, y').format(appointment['date']),
                Icons.calendar_today,
                isDarkMode,
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                'Time',
                appointment['time'],
                Icons.access_time,
                isDarkMode,
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                'Location',
                appointment['location'] ?? 'ChestCare Medical Center',
                Icons.location_on,
                isDarkMode,
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                'Status',
                appointment['status'].toUpperCase(),
                Icons.info,
                isDarkMode,
                isStatus: true,
                status: appointment['status'],
              ),
              if (appointment['reason'] != null &&
                  appointment['reason'].isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildDetailRow(
                  'Reason',
                  appointment['reason'],
                  Icons.healing,
                  isDarkMode,
                ),
              ],
              if (appointment['notes'] != null &&
                  appointment['notes'].isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildDetailRow(
                  'Notes',
                  appointment['notes'],
                  Icons.note,
                  isDarkMode,
                ),
              ],
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        color:
                            isDarkMode ? AppTheme.lightBlue : AppTheme.navyBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      String label, String value, IconData icon, bool isDarkMode,
      {bool isStatus = false, String? status}) {
    Color iconColor;
    if (isStatus) {
      if (status == 'confirmed') {
        iconColor = Colors.green;
      } else if (status == 'pending') {
        iconColor = Colors.orange;
      } else if (status == 'cancelled') {
        iconColor = Colors.red;
      } else {
        iconColor = isDarkMode ? AppTheme.lightBlue : AppTheme.navyBlue;
      }
    } else {
      iconColor = isDarkMode ? AppTheme.lightBlue : AppTheme.navyBlue;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: iconColor,
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
                  fontWeight: isStatus ? FontWeight.bold : null,
                  color: isStatus
                      ? iconColor
                      : isDarkMode
                          ? Colors.white
                          : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showRescheduleDialog(Map<String, dynamic> appointment) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    DateTime selectedDate = appointment['date'];
    TimeOfDay selectedTime = TimeOfDay(
      hour: int.parse(appointment['time'].split(':')[0]),
      minute: 0,
    );

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor:
                isDarkMode ? AppTheme.darkCardBlueBlack : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reschedule Appointment',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Current Date & Time:',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppTheme.darkSurfaceBlueBlack
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.event,
                          color: isDarkMode
                              ? AppTheme.lightBlue
                              : AppTheme.navyBlue,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('EEEE, MMMM d, y')
                                    .format(appointment['date']),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                appointment['time'],
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Select New Date:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 90)),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: isDarkMode
                                  ? const ColorScheme.dark(
                                      primary: AppTheme.navyBlue,
                                      onPrimary: Colors.white,
                                      surface: AppTheme.darkCardBlueBlack,
                                      onSurface: Colors.white,
                                    )
                                  : const ColorScheme.light(
                                      primary: AppTheme.navyBlue,
                                      onPrimary: Colors.white,
                                      onSurface: Colors.black,
                                    ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppTheme.darkSurfaceBlueBlack
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDarkMode
                              ? Colors.grey[800]!
                              : Colors.grey[300]!,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('EEEE, MMMM d, y').format(selectedDate),
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          Icon(
                            Icons.calendar_today,
                            color: isDarkMode
                                ? AppTheme.lightBlue
                                : AppTheme.navyBlue,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Select New Time:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: isDarkMode
                                  ? const ColorScheme.dark(
                                      primary: AppTheme.navyBlue,
                                      onPrimary: Colors.white,
                                      surface: AppTheme.darkCardBlueBlack,
                                      onSurface: Colors.white,
                                    )
                                  : const ColorScheme.light(
                                      primary: AppTheme.navyBlue,
                                      onPrimary: Colors.white,
                                      onSurface: Colors.black,
                                    ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedTime != null) {
                        setState(() {
                          selectedTime = pickedTime;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppTheme.darkSurfaceBlueBlack
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDarkMode
                              ? Colors.grey[800]!
                              : Colors.grey[300]!,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedTime.format(context),
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          Icon(
                            Icons.access_time,
                            color: isDarkMode
                                ? AppTheme.lightBlue
                                : AppTheme.navyBlue,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[700],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          final appointmentProvider =
                              Provider.of<AppointmentProvider>(context,
                                  listen: false);
                          appointmentProvider.rescheduleAppointment(
                            appointment['id'].toString(),
                            selectedDate,
                            selectedTime.format(context),
                          );
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Appointment rescheduled successfully',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode
                              ? AppTheme.navyBlue
                              : AppTheme.deepNavy,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Reschedule'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCancelDialog(Map<String, dynamic> appointment) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

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
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Cancel Appointment?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to cancel your appointment with ${appointment['doctorName']} on ${DateFormat('MMMM d, y').format(appointment['date'])} at ${appointment['time']}?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: isDarkMode
                              ? Colors.grey[700]!
                              : Colors.grey[300]!,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Keep',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final appointmentProvider =
                            Provider.of<AppointmentProvider>(context,
                                listen: false);
                        appointmentProvider.cancelAppointment(
                          appointment['id'].toString(),
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Appointment cancelled',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
