import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class TestHistoryScreen extends StatefulWidget {
  const TestHistoryScreen({super.key});

  @override
  State<TestHistoryScreen> createState() => _TestHistoryScreenState();
}

class _TestHistoryScreenState extends State<TestHistoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _searchQuery = '';
  TestCategory _selectedCategory = TestCategory.all;

  // Mock data - In real app, this would come from a provider or API
  final List<TestResult> _testResults = [
    TestResult(
      id: '1',
      testName: 'Chest X-Ray',
      date: DateTime.now().subtract(const Duration(days: 30)),
      result: 'Normal',
      status: TestStatus.completed,
      notes: 'No abnormalities detected. Follow-up in 3 months.',
      category: TestCategory.imaging,
      doctorName: 'Dr. Emily Wilson',
      pdfUrl: 'https://example.com/xray_results.pdf',
      hasFiles: true,
    ),
    TestResult(
      id: '2',
      testName: 'Sputum Test',
      date: DateTime.now().subtract(const Duration(days: 15)),
      result: 'Negative',
      status: TestStatus.completed,
      notes: 'No TB bacteria detected in the sample.',
      category: TestCategory.laboratory,
      doctorName: 'Dr. Michael Chen',
      pdfUrl: 'https://example.com/sputum_results.pdf',
      hasFiles: true,
    ),
    TestResult(
      id: '3',
      testName: 'Blood Test - Complete Blood Count',
      date: DateTime.now().subtract(const Duration(days: 7)),
      result: 'Pending',
      status: TestStatus.pending,
      notes: 'Results expected within 2-3 business days.',
      category: TestCategory.laboratory,
      doctorName: 'Dr. Sarah Johnson',
      pdfUrl: '',
      hasFiles: false,
    ),
    TestResult(
      id: '4',
      testName: 'Pulmonary Function Test',
      date: DateTime.now().subtract(const Duration(days: 60)),
      result: 'Mild Obstruction',
      status: TestStatus.completed,
      notes:
          'Shows mild airway obstruction consistent with early COPD. Recommended follow-up in 6 months.',
      category: TestCategory.functional,
      doctorName: 'Dr. Sarah Johnson',
      pdfUrl: 'https://example.com/pft_results.pdf',
      hasFiles: true,
    ),
    TestResult(
      id: '5',
      testName: 'CT Scan - High Resolution',
      date: DateTime.now().subtract(const Duration(days: 45)),
      result: 'Abnormal',
      status: TestStatus.completed,
      notes:
          'Small nodule detected in right upper lobe. Follow-up recommended in 3 months.',
      category: TestCategory.imaging,
      doctorName: 'Dr. Emily Wilson',
      pdfUrl: 'https://example.com/ct_scan_results.pdf',
      hasFiles: true,
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

  List<TestResult> get _filteredResults {
    return _testResults.where((test) {
      final matchesSearch = test.testName
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          test.result.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          test.doctorName.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory = _selectedCategory == TestCategory.all ||
          test.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppTheme.darkBgBlueBlack : Colors.grey[50],
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.help_outline,
              color: isDarkMode ? AppTheme.lightBlue : AppTheme.accentColor,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    'About Test Results',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text(
                    'This screen shows your medical test history. You can filter by category or search for specific tests.',
                    style: GoogleFonts.inter(),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Got it',
                        style: TextStyle(
                          color: isDarkMode
                              ? AppTheme.lightBlue
                              : AppTheme.accentColor,
                        ),
                      ),
                    ),
                  ],
                  backgroundColor:
                      isDarkMode ? AppTheme.darkCardBlueBlack : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              );
            },
          ),
        ],
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppTheme.lightBlue.withOpacity(0.2)
                            : AppTheme.accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.biotech_outlined,
                        color: isDarkMode
                            ? AppTheme.lightBlue
                            : AppTheme.accentColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Medical Tests',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          'View and track your test history',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isDarkMode ? AppTheme.darkCardBlueBlack : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search tests, results, or doctors',
                      hintStyle: GoogleFonts.inter(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                      filled: false,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    style: GoogleFonts.inter(
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
                margin: const EdgeInsets.only(top: 16),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildCategoryChip(TestCategory.all, isDarkMode),
                    _buildCategoryChip(TestCategory.imaging, isDarkMode),
                    _buildCategoryChip(TestCategory.laboratory, isDarkMode),
                    _buildCategoryChip(TestCategory.functional, isDarkMode),
                  ],
                ),
              ),
              Expanded(
                child: _filteredResults.isEmpty
                    ? _buildEmptyState(isDarkMode)
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        physics: const BouncingScrollPhysics(),
                        itemCount: _filteredResults.length,
                        itemBuilder: (context, index) {
                          final testResult = _filteredResults[index];
                          return _buildTestResultCard(testResult, isDarkMode);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(TestCategory category, bool isDarkMode) {
    final isSelected = _selectedCategory == category;
    final Color chipColor = isSelected
        ? isDarkMode
            ? AppTheme.navyBlue
            : AppTheme.navyBlue
        : isDarkMode
            ? AppTheme.darkCardBlueBlack
            : Colors.white;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: chipColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppTheme.navyBlue.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Text(
          _getCategoryName(category),
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : isDarkMode
                    ? Colors.grey[400]
                    : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  String _getCategoryName(TestCategory category) {
    switch (category) {
      case TestCategory.all:
        return 'All';
      case TestCategory.imaging:
        return 'Imaging';
      case TestCategory.laboratory:
        return 'Laboratory';
      case TestCategory.functional:
        return 'Functional';
    }
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No test results found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestResultCard(TestResult testResult, bool isDarkMode) {
    final isCompleted = testResult.status == TestStatus.completed;
    final Color statusColor = _getStatusColor(testResult.status, isDarkMode);
    final Color cardColor =
        isDarkMode ? AppTheme.darkCardBlueBlack : Colors.white;
    final Color categoryColor = _getCategoryColor(testResult.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
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
          onTap: () => _showTestDetails(testResult, isDarkMode),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _getCategoryIcon(testResult.category),
                        color: categoryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            testResult.testName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            testResult.doctorName,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[700],
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
                        testResult.status.name,
                        style: TextStyle(
                          fontSize: 12,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoItem(
                      Icons.calendar_today_outlined,
                      'Date: ${_formatDate(testResult.date)}',
                      isDarkMode,
                    ),
                    _buildInfoItem(
                      Icons.assignment_outlined,
                      'Result: ${testResult.result}',
                      isDarkMode,
                    ),
                  ],
                ),
                if (testResult.hasFiles) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.picture_as_pdf,
                        size: 16,
                        color: Colors.red[400],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'PDF Report Available',
                        style: TextStyle(
                          color: Colors.red[400],
                          fontWeight: FontWeight.w500,
                        ),
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
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(TestStatus status, bool isDarkMode) {
    switch (status) {
      case TestStatus.completed:
        return isDarkMode ? Colors.green[300]! : Colors.green[700]!;
      case TestStatus.pending:
        return isDarkMode ? Colors.orange[300]! : Colors.orange[700]!;
      case TestStatus.cancelled:
        return isDarkMode ? Colors.red[300]! : Colors.red[700]!;
    }
  }

  IconData _getCategoryIcon(TestCategory category) {
    switch (category) {
      case TestCategory.imaging:
        return Icons.image;
      case TestCategory.laboratory:
        return Icons.science;
      case TestCategory.functional:
        return Icons.show_chart;
      case TestCategory.all:
        return Icons.list_alt;
    }
  }

  Color _getCategoryColor(TestCategory category) {
    switch (category) {
      case TestCategory.imaging:
        return Colors.purple;
      case TestCategory.laboratory:
        return Colors.blue;
      case TestCategory.functional:
        return Colors.teal;
      case TestCategory.all:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }

  void _showTestDetails(TestResult testResult, bool isDarkMode) {
    final Color categoryColor = _getCategoryColor(testResult.category);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: isDarkMode ? AppTheme.darkCardBlueBlack : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getCategoryIcon(testResult.category),
                      color: categoryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          testResult.testName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          _getCategoryName(testResult.category),
                          style: TextStyle(
                            color: categoryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.only(right: 20, top: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(testResult.status, isDarkMode)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  testResult.status.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(testResult.status, isDarkMode),
                  ),
                ),
              ),
            ),
            const Divider(height: 32),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailSection(
                      'Test Information',
                      [
                        {
                          'label': 'Date',
                          'value': _formatDate(testResult.date)
                        },
                        {'label': 'Result', 'value': testResult.result},
                        {
                          'label': 'Ordering Doctor',
                          'value': testResult.doctorName
                        },
                      ],
                      isDarkMode,
                    ),
                    if (testResult.notes.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildDetailSection(
                        'Notes',
                        [
                          {'label': 'Medical Notes', 'value': testResult.notes},
                        ],
                        isDarkMode,
                        icon: Icons.note,
                      ),
                    ],
                    const SizedBox(height: 24),
                    if (testResult.hasFiles) ...[
                      Text(
                        'Test Results Documents',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildPdfCard(testResult, isDarkMode),
                      const SizedBox(height: 24),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(
      String title, List<Map<String, String>> details, bool isDarkMode,
      {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: isDarkMode ? AppTheme.lightBlue : AppTheme.navyBlue,
              ),
              const SizedBox(width: 8),
            ],
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
        const SizedBox(height: 16),
        ...details.map((detail) => _buildDetailRow(
              detail['label']!,
              detail['value']!,
              isDarkMode,
            )),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPdfCard(TestResult testResult, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.darkSurfaceBlueBlack : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _viewPdf(testResult),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.picture_as_pdf,
                    color: Colors.red[400],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${testResult.testName} Report.pdf',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'View test results document',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.open_in_new,
                  size: 20,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _viewPdf(TestResult testResult) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? AppTheme.darkCardBlueBlack : Colors.white,
        title: Text(
          'PDF Viewer',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.picture_as_pdf,
              color: Colors.red[400],
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'In a complete implementation, this would open a PDF viewer to display:',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${testResult.testName} Report.pdf',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            if (testResult.pdfUrl.isNotEmpty)
              Text(
                'URL: ${testResult.pdfUrl}',
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

enum TestStatus {
  completed,
  pending,
  cancelled;

  String get name {
    switch (this) {
      case TestStatus.completed:
        return 'Completed';
      case TestStatus.pending:
        return 'Pending';
      case TestStatus.cancelled:
        return 'Cancelled';
    }
  }
}

enum TestCategory {
  all,
  imaging,
  laboratory,
  functional;
}

class TestResult {
  final String id;
  final String testName;
  final DateTime date;
  final String result;
  final TestStatus status;
  final String notes;
  final TestCategory category;
  final String doctorName;
  final String pdfUrl;
  final bool hasFiles;

  const TestResult({
    required this.id,
    required this.testName,
    required this.date,
    required this.result,
    required this.status,
    required this.notes,
    required this.category,
    required this.doctorName,
    required this.pdfUrl,
    required this.hasFiles,
  });
}
