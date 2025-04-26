import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../theme/app_colors.dart';

// Enum definitions to match TSX types
enum Symptom { cramps, headache, bloating, fatigue, acne, backPain, breastTenderness, nausea }
enum FlowIntensity { none, light, medium, heavy }

class CycleScreen extends StatefulWidget {
  const CycleScreen({Key? key}) : super(key: key);

  @override
  _CycleScreenState createState() => _CycleScreenState();
}

class _CycleScreenState extends State<CycleScreen> {
  late DateTime _selectedDate;
  late List<Symptom> _selectedSymptoms;
  late FlowIntensity _flowIntensity;
  late bool _isRedAlertEnabled;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedSymptoms = [];
    _flowIntensity = FlowIntensity.medium;
    _isRedAlertEnabled = true;
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }

  void _previousMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
    });
  }

  void _toggleSymptom(Symptom symptom) {
    setState(() {
      if (_selectedSymptoms.contains(symptom)) {
        _selectedSymptoms.remove(symptom);
      } else {
        _selectedSymptoms.add(symptom);
      }
    });
  }

  void _toggleRedAlert() {
    setState(() {
      _isRedAlertEnabled = !_isRedAlertEnabled;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isRedAlertEnabled ? 'Red Alert Enabled' : 'Red Alert Disabled'),
        duration: const Duration(seconds: 2),
        backgroundColor: _isRedAlertEnabled ? AppColors.blushRose : Colors.grey[600],
      ),
    );
  }

  void _saveData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Your cycle data has been saved'),
        duration: Duration(seconds: 2),
        backgroundColor: AppColors.deepPlum,
      ),
    );
  }

  Map<String, String> _getCycleStage(int day) {
    if (day <= 5) {
      return {'stage': 'Menstrual', 'emoji': '🩸', 'color': Colors.red.value.toString()};
    } else if (day <= 13) {
      return {'stage': 'Follicular', 'emoji': '🌸', 'color': Colors.pink.value.toString()};
    } else if (day <= 16) {
      return {'stage': 'Ovulation', 'emoji': '🥚', 'color': Colors.blue.value.toString()};
    } else {
      return {'stage': 'Luteal', 'emoji': '🌙', 'color': Colors.purple.value.toString()};
    }
  }

  Widget _buildCalendarCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(icon: const Icon(Icons.arrow_back_ios, size: 12), onPressed: _previousMonth),
                      Text(
                        '${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),
                      ),
                      IconButton(icon: const Icon(Icons.arrow_forward_ios, size: 12), onPressed: _nextMonth),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Text('Su', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('Mo', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('Tu', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('We', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('Th', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('Fr', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('Sa', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildCalendar(),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildCycleLegend(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final lastDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7;
    const daysInWeek = 7;
    final totalCells = ((lastDayOfMonth.day + firstWeekday) / daysInWeek).ceil() * daysInWeek;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      childAspectRatio: 1.0,
      children: List.generate(totalCells, (index) {
        final dayIndex = index - firstWeekday;
        if (dayIndex < 0 || dayIndex >= lastDayOfMonth.day) {
          return const SizedBox.shrink();
        }
        final day = dayIndex + 1;
        final date = DateTime(_selectedDate.year, _selectedDate.month, day);
        final isToday = date.day == now.day && date.month == now.month && date.year == now.year;
        final cycleStage = _getCycleStage(day);
        return Center(
          child: GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: Container(
              decoration: BoxDecoration(
                color: isToday ? AppColors.blushRose : null,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    day.toString(),
                    style: TextStyle(
                      color: isToday ? AppColors.deepPlum : Colors.black,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    cycleStage['emoji']!,
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCycleLegend() {
    const List<Map<String, dynamic>> stages = [
      {'stage': 'Menstrual', 'emoji': '🩸', 'color': Colors.red},
      {'stage': 'Follicular', 'emoji': '🌸', 'color': Colors.pink},
      {'stage': 'Ovulation', 'emoji': '🥚', 'color': Colors.blue},
      {'stage': 'Luteal', 'emoji': '🌙', 'color': Colors.purple},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cycle Stages',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.deepPlum,
              ),
        ),
        const SizedBox(height: 8),
        ...stages.map((stage) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Text(
                    stage['emoji']!,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    stage['stage']!,
                    style: TextStyle(
                      color: stage['color'] as Color,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildFlowSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Period Flow',
              style: TextStyle(
                fontFamily: 'Serif',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.deepPlum,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: FlowIntensity.values.map((intensity) {
                final dropCount = {
                  FlowIntensity.none: 1,
                  FlowIntensity.light: 2,
                  FlowIntensity.medium: 3,
                  FlowIntensity.heavy: 4,
                }[intensity]!;
                return GestureDetector(
                  onTap: () => setState(() => _flowIntensity = intensity),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _flowIntensity == intensity ? AppColors.blushRose : Colors.white,
                      border: Border.all(color: AppColors.blushRose),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(dropCount, (_) => const Icon(Icons.water_drop, size: 16, color: AppColors.deepPlum)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          intensity.name.capitalize,
                          style: TextStyle(
                            fontSize: 14,
                            color: _flowIntensity == intensity ? AppColors.deepPlum : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomsSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Track Your Symptoms',
              style: TextStyle(
                fontFamily: 'Serif',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.deepPlum,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2.0,
              children: Symptom.values.map((symptom) {
                final isSelected = _selectedSymptoms.contains(symptom);
                return GestureDetector(
                  onTap: () => _toggleSymptom(symptom),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.blushRose : Colors.white,
                      border: Border.all(color: AppColors.blushRose),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getSymptomIcon(symptom),
                          size: 16,
                          color: isSelected ? AppColors.deepPlum : Colors.grey[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          symptom.name.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}').trim().capitalize,
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected ? AppColors.deepPlum : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            if (_selectedSymptoms.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'Selected Symptoms: ${_selectedSymptoms.map((s) => s.name.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}').trim().capitalize).join(', ')}',
                  style: TextStyle(fontSize: 14, color: AppColors.deepPlum),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getSymptomIcon(Symptom symptom) {
    switch (symptom) {
      case Symptom.cramps:
        return Icons.sick;
      case Symptom.headache:
        return Icons.face;
      case Symptom.bloating:
        return Icons.bubble_chart;
      case Symptom.fatigue:
        return Icons.bedtime;
      case Symptom.acne:
        return Icons.face_retouching_natural;
      case Symptom.backPain:
        return Icons.person;
      case Symptom.breastTenderness:
        return Icons.favorite;
      case Symptom.nausea:
        return Icons.sick;
      default:
        return Icons.help;
    }
  }

  Widget _buildInsightsSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Cycle Insights',
              style: TextStyle(
                fontFamily: 'Serif',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.deepPlum,
              ),
            ),
            const SizedBox(height: 16),
            _buildInsightItem('FOLLICULAR PHASE', 'Your estrogen levels are rising, which may give you more energy and a boost in mood.'),
            const SizedBox(height: 16),
            _buildInsightItem('UPCOMING OVULATION', 'Your ovulation is predicted in 2 days. You may notice increased energy and libido.'),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.blushRose, AppColors.blushRose.withOpacity(0.5)]),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'RED ALERT: PMS SYMPTOMS PREDICTED\nBased on your past cycles, you may experience mood changes and fatigue in 5-7 days.',
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildInsightItem('WEARABLE INSIGHTS', 'Your sleep quality improved by 15% this week. Continue your current bedtime routine for optimal hormonal balance.'),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(String title, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.deepPlum, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(color: Colors.grey[800], fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _saveData,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.deepPlum,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        child: const Text('SAVE TODAY\'S LOG', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Cycle Tracking',
              style: TextStyle(fontFamily: 'Serif', fontSize: 24, color: AppColors.deepPlum),
            ),
            backgroundColor: AppColors.blushRose,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GestureDetector(
                  onTap: _toggleRedAlert,
                  child: Row(
                    children: [
                      Icon(Icons.notifications, color: _isRedAlertEnabled ? AppColors.deepPlum : Colors.grey[600], size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Red Alert ${_isRedAlertEnabled ? 'ON' : 'OFF'}',
                        style: TextStyle(
                          fontSize: 16,
                          color: _isRedAlertEnabled ? AppColors.deepPlum : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCalendarCard(context),
                const SizedBox(height: 16),
                _buildFlowSection(),
                const SizedBox(height: 16),
                _buildSymptomsSection(),
                const SizedBox(height: 16),
                _buildInsightsSection(),
                const SizedBox(height: 16),
                _buildSaveButton(),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Extension to capitalize strings
extension StringExtension on String {
  String get capitalize {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}