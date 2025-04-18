import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import '../models/medication.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  String _frequency = 'Once daily';
  Color _selectedColor = Colors.blue;
  int _totalDoses = 30;

  // Predefined frequencies and colors
  final List<String> _frequencies = [
    'Once daily',
    'Twice daily',
    'Three times daily',
    'Every other day',
    'Once weekly',
    'As needed'
  ];

  final List<Color> _medicationColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
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
    _nameController.dispose();
    _dosageController.dispose();
    _notesController.dispose();
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
          'Add Medication',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Medication illustration
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _selectedColor,
                            Color.lerp(_selectedColor, Colors.black, 0.3)!,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _selectedColor.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.medication_rounded,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Medication name
                  _buildSectionTitle('Medication Name',
                      Icons.medication_liquid_outlined, isDarkMode),
                  _buildTextFormField(
                    controller: _nameController,
                    hintText: 'Enter medication name',
                    isDarkMode: isDarkMode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the medication name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Dosage
                  _buildSectionTitle(
                      'Dosage', Icons.medical_services_outlined, isDarkMode),
                  _buildTextFormField(
                    controller: _dosageController,
                    hintText: 'Enter dosage (e.g. 500mg)',
                    isDarkMode: isDarkMode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the dosage';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Frequency
                  _buildSectionTitle(
                      'Frequency', Icons.schedule_outlined, isDarkMode),
                  _buildDropdownField(
                    value: _frequency,
                    items: _frequencies,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _frequency = value;
                        });
                      }
                    },
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 24),

                  // Treatment duration
                  _buildSectionTitle('Treatment Duration',
                      Icons.date_range_outlined, isDarkMode),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateField(
                          label: 'Start Date',
                          date: _startDate,
                          onTap: () => _selectDate(context, true),
                          isDarkMode: isDarkMode,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDateField(
                          label: 'End Date',
                          date: _endDate,
                          onTap: () => _selectDate(context, false),
                          isDarkMode: isDarkMode,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Total doses
                  _buildSectionTitle('Total Doses',
                      Icons.format_list_numbered_outlined, isDarkMode),
                  _buildTotalDosesSelector(isDarkMode),
                  const SizedBox(height: 24),

                  // Color selection
                  _buildSectionTitle(
                      'Color Label', Icons.color_lens_outlined, isDarkMode),
                  _buildColorSelector(isDarkMode),
                  const SizedBox(height: 24),

                  // Notes
                  _buildSectionTitle(
                      'Notes (Optional)', Icons.note_outlined, isDarkMode),
                  _buildTextFormField(
                    controller: _notesController,
                    hintText: 'Add any additional notes or instructions',
                    isDarkMode: isDarkMode,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 36),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: isDarkMode ? 8 : 4,
                        shadowColor: _selectedColor.withOpacity(0.4),
                      ),
                      child: const Text(
                        'Add Medication',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required bool isDarkMode,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.darkCardBlueBlack : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(16),
        ),
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
        maxLines: maxLines,
        validator: validator,
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    required bool isDarkMode,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.darkCardBlueBlack : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(16),
        ),
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
        dropdownColor: isDarkMode ? AppTheme.darkCardBlueBlack : Colors.white,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        icon: Icon(
          Icons.arrow_drop_down,
          color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.darkCardBlueBlack : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode
                        ? Colors.grey.shade500
                        : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        DateFormat('MMM d, y').format(date),
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: isDarkMode
                          ? Colors.grey.shade400
                          : Colors.grey.shade700,
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

  Widget _buildTotalDosesSelector(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.darkCardBlueBlack : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total number of doses: $_totalDoses',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              Row(
                children: [
                  _buildStepperButton(
                    icon: Icons.remove,
                    onPressed: () {
                      if (_totalDoses > 1) {
                        setState(() {
                          _totalDoses--;
                        });
                      }
                    },
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(width: 12),
                  _buildStepperButton(
                    icon: Icons.add,
                    onPressed: () {
                      setState(() {
                        _totalDoses++;
                      });
                    },
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 6,
              activeTrackColor: _selectedColor,
              inactiveTrackColor: _selectedColor.withOpacity(0.2),
              thumbColor: _selectedColor,
              overlayColor: _selectedColor.withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            ),
            child: Slider(
              value: _totalDoses.toDouble(),
              min: 1,
              max: 180,
              divisions: 179,
              onChanged: (value) {
                setState(() {
                  _totalDoses = value.toInt();
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1 dose',
                style: TextStyle(
                  fontSize: 12,
                  color:
                      isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600,
                ),
              ),
              Text(
                '180 doses',
                style: TextStyle(
                  fontSize: 12,
                  color:
                      isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepperButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDarkMode,
  }) {
    return Container(
      decoration: BoxDecoration(
        color:
            isDarkMode ? AppTheme.darkSurfaceBlueBlack : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: 18,
          color: isDarkMode ? AppTheme.lightBlue : AppTheme.navyBlue,
        ),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(
          minWidth: 36,
          minHeight: 36,
        ),
      ),
    );
  }

  Widget _buildColorSelector(bool isDarkMode) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.darkCardBlueBlack : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _medicationColors.length,
        itemBuilder: (context, index) {
          final color = _medicationColors[index];
          final isSelected = color == _selectedColor;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = color;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: Colors.white, width: 3)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: isSelected ? 8 : 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime initialDate = isStartDate ? _startDate : _endDate;
    final DateTime firstDate = isStartDate ? DateTime.now() : _startDate;

    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
        if (isStartDate) {
          _startDate = pickedDate;
          // If end date is before start date, update it
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 1));
          }
        } else {
          _endDate = pickedDate;
        }

        // Update total doses based on frequency and duration
        _updateTotalDoses();
      });
    }
  }

  void _updateTotalDoses() {
    // Calculate difference in days
    final duration = _endDate.difference(_startDate).inDays + 1;

    // Determine multiplier based on frequency
    int multiplier;
    switch (_frequency) {
      case 'Once daily':
        multiplier = 1;
        break;
      case 'Twice daily':
        multiplier = 2;
        break;
      case 'Three times daily':
        multiplier = 3;
        break;
      case 'Every other day':
        multiplier = 1;
        _totalDoses = (duration / 2).ceil();
        return;
      case 'Once weekly':
        _totalDoses = (duration / 7).ceil();
        return;
      case 'As needed':
        // Don't update, leave as manual entry
        return;
      default:
        multiplier = 1;
    }

    _totalDoses = duration * multiplier;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Create a new medication
      final newMedication = Medication(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        dosage: _dosageController.text,
        frequency: _frequency,
        startDate: _startDate,
        endDate: _endDate,
        status: MedicationStatus.active,
        lastTaken: DateTime.now(),
        notes: _notesController.text,
        color: _selectedColor,
        nextDue: _calculateNextDue(),
        totalDoses: _totalDoses,
        remainingDoses: _totalDoses,
      );

      // Show success message
      _showSuccessDialog(newMedication);
    }
  }

  DateTime? _calculateNextDue() {
    // Calculate next due based on frequency
    final now = DateTime.now();
    switch (_frequency) {
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

  void _showSuccessDialog(Medication medication) {
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
                      _selectedColor,
                      Color.lerp(_selectedColor, Colors.black, 0.3)!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _selectedColor.withOpacity(0.3),
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
                'Medication Added!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your medication has been added to your list.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 24),

              // Medication details
              _buildSuccessDetailRow(
                'Name',
                medication.name,
                Icons.medication_rounded,
                isDarkMode,
              ),
              const SizedBox(height: 12),
              _buildSuccessDetailRow(
                'Dosage',
                medication.dosage,
                Icons.medical_services_outlined,
                isDarkMode,
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Stay on add medication screen for adding another
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          isDarkMode ? Colors.grey[400] : Colors.grey[700],
                      side: BorderSide(
                        color:
                            isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    child: const Text('Add Another'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context,
                          medication); // Return to medication list with new medication
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      elevation: 2,
                    ),
                    child: const Text('Done'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessDetailRow(
      String label, String value, IconData icon, bool isDarkMode) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _selectedColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: _selectedColor,
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
