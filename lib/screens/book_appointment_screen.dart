import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/theme_provider.dart';
import '../providers/appointment_provider.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Enhanced doctor data with vibrant professional colors
  final List<Map<String, dynamic>> _doctors = [
    {
      'name': 'Dr. Sarah Johnson',
      'specialty': 'Pulmonologist',
      'color': const Color(0xFF4285F4), // Google Blue
      'icon': Icons.healing
    },
    {
      'name': 'Dr. Michael Chen',
      'specialty': 'General Physician',
      'color': const Color(0xFF0F9D58), // Google Green
      'icon': Icons.medical_services_outlined
    },
    {
      'name': 'Dr. Emily Wilson',
      'specialty': 'Radiologist',
      'color': const Color(0xFF9C27B0), // Purple
      'icon': Icons.radio_outlined
    },
    {
      'name': 'Dr. James Smith',
      'specialty': 'Cardiologist',
      'color': const Color(0xFFEA4335), // Google Red
      'icon': Icons.favorite_outline
    },
    {
      'name': 'Dr. Maria Rodriguez',
      'specialty': 'Neurologist',
      'color': const Color(0xFFFBBC05), // Google Yellow
      'icon': Icons.psychology_outlined
    },
  ];

  // Form values
  String? _selectedDoctor;
  String? _selectedSpecialty;
  Color? _selectedDoctorColor;
  IconData? _selectedDoctorIcon;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  String _reason = '';
  String _notes = '';

  // Available time slots
  final List<TimeOfDay> _availableTimeSlots = [
    const TimeOfDay(hour: 9, minute: 0),
    const TimeOfDay(hour: 10, minute: 0),
    const TimeOfDay(hour: 11, minute: 0),
    const TimeOfDay(hour: 13, minute: 30),
    const TimeOfDay(hour: 14, minute: 30),
    const TimeOfDay(hour: 15, minute: 30),
    const TimeOfDay(hour: 16, minute: 30),
  ];

  // Enhanced color palette for time slots
  final List<Color> timeSlotColors = [
    const Color(0xFF4285F4), // Google Blue
    const Color(0xFF0F9D58), // Google Green
    const Color(0xFF9C27B0), // Purple
    const Color(0xFFEA4335), // Google Red
    const Color(0xFFFBBC05), // Google Yellow
    const Color(0xFF34A853), // Emerald Green
    const Color(0xFF1A73E8), // Sky Blue
  ];

  // Color palette for appointment detail icons
  final Map<String, Color> _iconColors = {
    'reason': const Color(0xFF4285F4), // Google Blue
    'notes': const Color(0xFF0F9D58), // Google Green
    'clock': const Color(0xFFFBBC05), // Google Yellow
    'calendar': const Color(0xFF9C27B0), // Purple
    'doctor': const Color(0xFFEA4335), // Google Red
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

    return Scaffold(
      backgroundColor: isDarkMode ? AppTheme.darkBgBlueBlack : Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Book Appointment',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor:
            isDarkMode ? AppTheme.darkBgBlueBlack : Colors.grey[50],
        foregroundColor: isDarkMode ? Colors.white : AppTheme.navyBlue,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDarkMode
                  ? AppTheme.darkCardBlueBlack.withOpacity(0.8)
                  : Colors.white.withOpacity(0.9),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back,
              color: isDarkMode ? Colors.white : AppTheme.navyBlue,
              size: 20,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Select Doctor', Icons.person_outlined,
                      _iconColors['doctor']!),
                  _buildDoctorSelector(),
                  const SizedBox(height: 28),
                  _buildSectionTitle('Select Date',
                      Icons.calendar_today_outlined, _iconColors['calendar']!),
                  _buildDateSelector(),
                  const SizedBox(height: 28),
                  _buildSectionTitle('Select Time', Icons.access_time_outlined,
                      _iconColors['clock']!),
                  _buildTimeSelector(),
                  const SizedBox(height: 28),
                  _buildSectionTitle('Appointment Details',
                      Icons.description_outlined, _iconColors['notes']!),
                  _buildAppointmentDetailRow(
                      'Reason for visit',
                      _reason,
                      Icons.medical_information_outlined,
                      _iconColors['reason']!, (value) {
                    setState(() {
                      _reason = value;
                    });
                  }, 'Enter reason for visit'),
                  const SizedBox(height: 20),
                  _buildAppointmentDetailRow('Additional notes', _notes,
                      Icons.note_outlined, _iconColors['notes']!, (value) {
                    setState(() {
                      _notes = value;
                    });
                  }, 'Any special requests or notes (optional)',
                      isRequired: false),
                  const SizedBox(height: 36),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _selectedDoctorColor ?? _iconColors['doctor']!,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: isDarkMode ? 8 : 4,
                        shadowColor:
                            (_selectedDoctorColor ?? _iconColors['doctor']!)
                                .withOpacity(0.4),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_month, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Book Appointment',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color iconColor) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    // Professional gradient colors for section headers
    Color gradientStart = iconColor;
    Color gradientEnd = Color.lerp(iconColor, Colors.black, 0.3)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [gradientStart, gradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: gradientStart.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorSelector() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _doctors.length,
        itemBuilder: (context, index) {
          final doctor = _doctors[index];
          final isSelected = _selectedDoctor == doctor['name'];

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDoctor = doctor['name'];
                _selectedSpecialty = doctor['specialty'];
                _selectedDoctorColor = doctor['color'];
                _selectedDoctorIcon = doctor['icon'];
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.only(right: 12),
              width: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isSelected
                      ? [
                          doctor['color'],
                          Color.lerp(doctor['color'], Colors.black, 0.3)!,
                        ]
                      : isDarkMode
                          ? [
                              AppTheme.darkCardBlueBlack,
                              AppTheme.darkSurfaceBlueBlack,
                            ]
                          : [
                              Colors.white,
                              Colors.grey.shade50,
                            ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? doctor['color'].withOpacity(0.4)
                        : Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
                    blurRadius: isSelected ? 12 : 8,
                    offset: Offset(0, isSelected ? 6 : 3),
                  ),
                ],
                border: Border.all(
                  color: isSelected
                      ? doctor['color']
                      : isDarkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.9)
                          : doctor['color'].withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      doctor['icon'],
                      color: isSelected
                          ? doctor['color']
                          : isDarkMode
                              ? doctor['color'].withOpacity(0.9)
                              : doctor['color'],
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    doctor['name'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : isDarkMode
                              ? Colors.white
                              : Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    doctor['specialty'],
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected
                          ? Colors.white.withOpacity(0.8)
                          : isDarkMode
                              ? Colors.grey.shade400
                              : Colors.grey.shade700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 4,
                    width: isSelected ? 80 : 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.9)
                          : doctor['color'].withOpacity(isDarkMode ? 0.5 : 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateSelector() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Date:',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _iconColors['calendar']!,
                      Color.lerp(_iconColors['calendar']!, Colors.black, 0.3)!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: _iconColors['calendar']!.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.calendar_today,
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
                      DateFormat('EEEE, MMMM d, y').format(_selectedDate),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('d MMM').format(_selectedDate) ==
                              DateFormat('d MMM').format(DateTime.now().add(
                                const Duration(days: 1),
                              ))
                          ? 'Tomorrow'
                          : DateFormat('d MMM').format(_selectedDate) ==
                                  DateFormat('d MMM').format(DateTime.now())
                              ? 'Today'
                              : '${_selectedDate.difference(DateTime.now()).inDays} days from now',
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
              IconButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 60)),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: isDarkMode
                              ? ColorScheme.dark(
                                  primary: _iconColors['calendar']!,
                                  onPrimary: Colors.white,
                                  surface: AppTheme.darkCardBlueBlack,
                                  onSurface: Colors.white,
                                )
                              : ColorScheme.light(
                                  primary: _iconColors['calendar']!,
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
                      _selectedDate = pickedDate;
                    });
                  }
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDarkMode
                        ? _iconColors['calendar']!.withOpacity(0.2)
                        : _iconColors['calendar']!.withOpacity(0.1),
                  ),
                  child: Icon(
                    Icons.edit_calendar,
                    size: 18,
                    color: isDarkMode ? Colors.white : _iconColors['calendar'],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final clockColor = _iconColors['clock']!;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
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
                      clockColor,
                      Color.lerp(clockColor, Colors.black, 0.3)!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: clockColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.access_time,
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
                      'Available Time Slots',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Select your preferred appointment time',
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
            ],
          ),
          const SizedBox(height: 16),
          // Colorful time slots
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _availableTimeSlots.length,
              itemBuilder: (context, index) {
                final timeSlot = _availableTimeSlots[index];
                final isSelected = _selectedTime.hour == timeSlot.hour &&
                    _selectedTime.minute == timeSlot.minute;

                // Use modulo to cycle through colors
                final slotColor = timeSlotColors[index % timeSlotColors.length];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTime = timeSlot;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [
                                slotColor,
                                Color.lerp(slotColor, Colors.black, 0.3)!,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isSelected
                          ? null
                          : isDarkMode
                              ? AppTheme.darkSurfaceBlueBlack
                              : slotColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: slotColor.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time,
                          color: isSelected
                              ? Colors.white
                              : isDarkMode
                                  ? slotColor
                                  : slotColor,
                          size: 18,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          timeSlot.format(context),
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : isDarkMode
                                    ? slotColor
                                    : slotColor,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentDetailRow(String label, String value, IconData icon,
      Color color, Function(String) onChanged, String hintText,
      {bool isRequired = true}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color,
                  Color.lerp(color, Colors.black, 0.3)!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              icon,
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
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: value,
                  onChanged: onChanged,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: isDarkMode
                          ? Colors.grey.shade500
                          : Colors.grey.shade400,
                    ),
                    filled: true,
                    fillColor: isDarkMode
                        ? AppTheme.darkSurfaceBlueBlack
                        : Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: color,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  maxLines: label.contains('notes') ? 3 : 1,
                  validator: isRequired
                      ? (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter $label';
                          }
                          return null;
                        }
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedDoctor != null) {
      final appointmentProvider =
          Provider.of<AppointmentProvider>(context, listen: false);

      // Create a new appointment using the Appointment constructor
      final appointment = Appointment(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(), // Generate unique ID
        doctorName: _selectedDoctor!,
        specialty: _selectedSpecialty!,
        date: _selectedDate,
        time: _selectedTime.format(context),
        status: AppointmentStatus.upcoming,
        location: 'ChestCare Medical Center',
        reason: _reason,
        notes: _notes,
      );

      // Add the appointment to the provider
      appointmentProvider.addAppointment(appointment);

      // Show success message and close
      _showSuccessDialog();
    } else if (_selectedDoctor == null) {
      // Show error if no doctor selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a doctor'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showSuccessDialog() {
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
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _selectedDoctorColor ?? _iconColors['doctor']!,
                      Color.lerp(_selectedDoctorColor ?? _iconColors['doctor']!,
                          Colors.black, 0.3)!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (_selectedDoctorColor ?? _iconColors['doctor']!)
                          .withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Appointment Booked!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your appointment has been scheduled successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 24),

              // Appointment details
              _buildSuccessDetailRow(
                'Doctor',
                _selectedDoctor!,
                _selectedDoctorIcon ?? Icons.person,
                _selectedDoctorColor ?? _iconColors['doctor']!,
                isDarkMode,
              ),
              const SizedBox(height: 12),
              _buildSuccessDetailRow(
                'Date & Time',
                '${DateFormat('EEE, MMM d').format(_selectedDate)} at ${_selectedTime.format(context)}',
                Icons.event,
                _iconColors['calendar']!,
                isDarkMode,
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Return to previous screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _selectedDoctorColor ?? _iconColors['doctor']!,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessDetailRow(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDarkMode,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: color,
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
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
