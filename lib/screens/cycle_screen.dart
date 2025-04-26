import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../theme/app_colors.dart';

class CycleScreen extends StatefulWidget {
  const CycleScreen({Key? key}) : super(key: key);

  @override
  _CycleScreenState createState() => _CycleScreenState();
}

class _CycleScreenState extends State<CycleScreen> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
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

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Cycle Tracking'),
            backgroundColor: AppColors.blushRose,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      'Red Alert ON',
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.red),
                    ),
                  ],
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
                _buildFlowSection(context, user),
                const SizedBox(height: 16),
                _buildSymptomsSection(context, user),
                const SizedBox(height: 16),
                _buildInsightsSection(context),
                const SizedBox(height: 16),
                _buildSaveButton(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendarCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12),
                      ),
                      IconButton(icon: const Icon(Icons.arrow_forward_ios, size: 12), onPressed: _nextMonth),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Text('Su', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      Text('Mo', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      Text('Tu', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      Text('We', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      Text('Th', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      Text('Fr', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      Text('Sa', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 4),
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
      childAspectRatio: 1.5,
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
        );
      }),
    );
  }

  Map<String, String> _getCycleStage(int day) {
    // Simplified cycle stage logic (adjust based on actual cycle data)
    if (day <= 5) {
      return {'stage': 'Menstrual', 'emoji': '🩸', 'color': 'Colors.red'};
    } else if (day <= 13) {
      return {'stage': 'Follicular', 'emoji': '🌸', 'color': 'Colors.pink'};
    } else if (day <= 16) {
      return {'stage': 'Ovulation', 'emoji': '🥚', 'color': 'Colors.blue'};
    } else {
      return {'stage': 'Luteal', 'emoji': '🌙', 'color': 'Colors.purple'};
    }
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
                      color: stage['color'] as Color, // Ensured type safety
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildFlowSection(BuildContext context, User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Period Flow',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.deepPlum,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildFlowButton(context, user, 'None', Icons.water_drop, 1),
            _buildFlowButton(context, user, 'Light', Icons.water_drop, 2),
            _buildFlowButton(context, user, 'Medium', Icons.water_drop, 3),
            _buildFlowButton(context, user, 'Heavy', Icons.water_drop, 4),
          ],
        ),
      ],
    );
  }

  Widget _buildFlowButton(BuildContext context, User user, String flow, IconData icon, int dropCount) {
    bool isSelected = user.selectedFlow == flow;
    return ElevatedButton(
      onPressed: () => user.setFlow(flow),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.blushRose : Colors.white,
        foregroundColor: AppColors.deepPlum,
        side: const BorderSide(color: AppColors.blushRose),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: List.generate(dropCount, (_) => Icon(icon, size: 12, color: AppColors.deepPlum))),
          const SizedBox(width: 4), // Corrected typo from Boxwidth to width
          Text(flow, style: const TextStyle(fontSize: 15, color: AppColors.deepPlum)),
        ],
      ),
    );
  }

  Widget _buildSymptomsSection(BuildContext context, User user) {
    final selected = user.selectedSymptoms;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Track your symptoms',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.deepPlum,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 2.5,
          children: [
            _buildSymptomButton(context, user, 'Cramps', Icons.sick),
            _buildSymptomButton(context, user, 'Headache', Icons.face),
            _buildSymptomButton(context, user, 'Bloating', Icons.bubble_chart),
            _buildSymptomButton(context, user, 'Fatigue', Icons.bedtime),
            _buildSymptomButton(context, user, 'Acne', Icons.face_retouching_natural),
            _buildSymptomButton(context, user, 'Back Pain', Icons.person),
            _buildSymptomButton(context, user, 'Breast Tenderness', Icons.favorite),
            _buildSymptomButton(context, user, 'Nausea', Icons.sick),
          ],
        ),
        if (selected.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              'Selected Symptoms: ${selected.join(', ')}',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.deepPlum),
            ),
          ),
      ],
    );
  }

  Widget _buildSymptomButton(BuildContext context, User user, String symptom, IconData icon) {
    final isSelected = user.selectedSymptoms.contains(symptom);
    return ElevatedButton(
      onPressed: () => user.toggleSymptom(symptom),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.blushRose : Colors.white,
        foregroundColor: AppColors.deepPlum,
        side: const BorderSide(color: AppColors.blushRose),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.deepPlum),
          const SizedBox(width: 4),
          Text(symptom, style: const TextStyle(fontSize: 15, color: AppColors.deepPlum)),
        ],
      ),
    );
  }

  Widget _buildInsightsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI Cycle Insights',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.deepPlum,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _insightTitle('FOLLICULAR PHASE'),
                _insightText('Your estrogen levels are rising, which may give you more energy and a boost in mood.'),
                const SizedBox(height: 16),
                _insightTitle('UPCOMING OVULATION'),
                _insightText('Your ovulation is predicted in 2 days. You may notice increased energy and libido.'),
                const SizedBox(height: 16),
                Container(
                  color: AppColors.blushRose,
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'RED ALERT: PMS SYMPTOMS PREDICTED\nBased on your past cycles, you may experience mood changes and fatigue in 5-7 days.',
                          style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _insightTitle('WEARABLE INSIGHTS'),
                _insightText('Your sleep quality improved by 15% this week. Continue your current bedtime routine for optimal hormonal balance.'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _insightTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.deepPlum, fontSize: 13),
    );
  }

  Widget _insightText(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.grey[800], fontSize: 13),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Today\'s log saved successfully!'), duration: Duration(seconds: 2)),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.deepPlum,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        child: const Text('SAVE TODAY\'S LOG', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ),
    );
  }
}