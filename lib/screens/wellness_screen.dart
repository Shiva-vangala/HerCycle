import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// Placeholder Layout widget (same as profile_screen.dart)
class Layout extends StatelessWidget {
  final Widget child;

  const Layout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: child,
    );
  }
}

// Placeholder WellnessCard widget (mimics TSX WellnessCard)
class WellnessCard extends StatelessWidget {
  final String title;
  final String description;
  final String icon;
  final Color borderColor;

  const WellnessCard({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: borderColor, width: 2),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: borderColor.withOpacity(0.2),
              ),
              child: Center(child: Text(icon, style: TextStyle(fontSize: 20))),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepPlum,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// VirtualWellnessRoom widget with timer, breathing exercise, and popups
class VirtualWellnessRoom extends StatefulWidget {
  const VirtualWellnessRoom({Key? key}) : super(key: key);

  @override
  _VirtualWellnessRoomState createState() => _VirtualWellnessRoomState();
}

class _VirtualWellnessRoomState extends State<VirtualWellnessRoom> with SingleTickerProviderStateMixin {
  bool _showTimer = false;
  bool _showBreathingExercise = false;
  Timer? _timer;
  int _seconds = 171; // 2:51 in seconds
  String _breathingPhase = 'Inhale for 4s';
  Timer? _breathingTimer;
  int _breathingSeconds = 4;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.8, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _breathingTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _showTimer = true;
      _showBreathingExercise = false;
      _seconds = 171;
    });
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          _timer?.cancel();
          _showTimer = false;
        }
      });
    });
  }

  void _pauseTimer() {
    setState(() {
      _timer?.cancel();
    });
  }

  void _resetTimer() {
    setState(() {
      _timer?.cancel();
      _seconds = 171;
      _startTimer();
    });
  }

  void _startBreathingExercise() {
    setState(() {
      _showTimer = false;
      _showBreathingExercise = true;
      _breathingPhase = 'Inhale for 4s';
      _breathingSeconds = 4;
    });
    _breathingTimer?.cancel();
    _breathingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _breathingSeconds--;
        if (_breathingSeconds <= 0) {
          if (_breathingPhase == 'Inhale for 4s') {
            _breathingPhase = 'Hold for 4s';
            _breathingSeconds = 4;
          } else if (_breathingPhase == 'Hold for 4s') {
            _breathingPhase = 'Exhale for 4s';
            _breathingSeconds = 4;
          } else {
            _breathingPhase = 'Inhale for 4s';
            _breathingSeconds = 4;
          }
        }
      });
    });
  }

  void _showPopup(String message, Color backgroundColor) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        left: MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Virtual Wellness Room',
              style: TextStyle(
                fontFamily: 'Serif',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.deepPlum,
              ),
            ),
            SizedBox(height: 16),
            if (_showTimer) ...[
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      '${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.deepPlum),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _pauseTimer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.deepPlum,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: Text('Pause'),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: _resetTimer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.deepPlum,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: Text('Reset'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],
            if (_showBreathingExercise) ...[
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.softLavender, AppColors.blushRose],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Breathing Space',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepPlum,
                      ),
                    ),
                    SizedBox(height: 16),
                    ScaleTransition(
                      scale: _animation,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [Colors.white, AppColors.blushRose],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.blushRose.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      _breathingPhase,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.deepPlum),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '$_breathingSeconds',
                      style: TextStyle(fontSize: 32, color: AppColors.deepPlum),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],
            GestureDetector(
              onTap: () {
                setState(() {
                  if (_showTimer) {
                    _showTimer = false;
                    _timer?.cancel();
                  } else {
                    _startTimer();
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.deepPlum,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '3-Minute Breathing Space',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'A quick 3-Minute meditation to center yourself',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _startBreathingExercise,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blushRose,
                      foregroundColor: AppColors.deepPlum,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Breathing Exercise', style: TextStyle(fontSize: 16)),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showPopup('Finding Someone', AppColors.forestTeal);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.forestTeal,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Talk to Someone', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showPopup('Help is on the way', Colors.red);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning, size: 20),
                  SizedBox(width: 8),
                  Text('SOS Mode', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// SymptomNavigator widget with solutions
class SymptomNavigator extends StatefulWidget {
  const SymptomNavigator({Key? key}) : super(key: key);

  @override
  _SymptomNavigatorState createState() => _SymptomNavigatorState();
}

class _SymptomNavigatorState extends State<SymptomNavigator> {
  String? _selectedSymptom;

  final Map<String, List<Map<String, String>>> _solutions = {
    'Cramps': [
      {'emoji': '🔥', 'title': 'Heat Therapy', 'description': 'Apply a heating pad to your lower abdomen for 15-20 minutes.'},
      {'emoji': '🧘‍♀️', 'title': 'Gentle Stretching', 'description': 'Try child\'s pose or cat-cow stretches to relieve tension.'},
      {'emoji': '🍌', 'title': 'Magnesium Foods', 'description': 'Dark chocolate, bananas, and almonds can help relieve cramps.'},
    ],
    'Mood Swings': [
      {'emoji': '📓', 'title': '5-Minute Journaling', 'description': 'Write down your thoughts to process emotions.'},
      {'emoji': '🥑', 'title': 'B Vitamin Boost', 'description': 'Foods like avocados and legumes can stabilize mood.'},
      {'emoji': '👁️', 'title': 'Sensory Grounding', 'description': 'Focus on 5 things you can see, 4 touch, 3 hear, 2 smell, 1 taste.'},
    ],
    'Low Energy': [
      {'emoji': '😴', 'title': 'Power Nap', 'description': '20 minutes of rest can restore energy without grogginess.'},
      {'emoji': '🥗', 'title': 'Iron-Rich Snack', 'description': 'Try hummus, spinach, or a small piece of lean meat.'},
      {'emoji': '🚶‍♀️', 'title': 'Gentle Movement', 'description': 'A short walk can increase circulation and energy.'},
    ],
    'Bloating': [
      {'emoji': '🍵', 'title': 'Anti-Inflammatory Tea', 'description': 'Ginger or peppermint tea can reduce gas and bloating.'},
      {'emoji': '🧂', 'title': 'Avoid Salt', 'description': 'Reduce sodium intake to prevent water retention.'},
      {'emoji': '✋', 'title': 'Abdominal Massage', 'description': 'Gentle clockwise massage can help relieve gas.'},
    ],
    'Headache': [
      {'emoji': '💧', 'title': 'Hydration', 'description': 'Drink a full glass of water, as dehydration can cause headaches.'},
      {'emoji': '💆‍♀️', 'title': 'Temple Massage', 'description': 'Massage your temples in small circles for 2 minutes.'},
      {'emoji': '👁️', 'title': 'Eye Rest', 'description': 'Close your eyes and place a cool cloth over them for 10 minutes.'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select a symptom to get personalized solutions:',
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
        SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildSymptomButton(context, 'Cramps', '🩹'),
            _buildSymptomButton(context, 'Mood Swings', '😢'),
            _buildSymptomButton(context, 'Low Energy', '⚡'),
            _buildSymptomButton(context, 'Bloating', '😷'),
            _buildSymptomButton(context, 'Headache', '🤕'),
          ],
        ),
        if (_selectedSymptom != null) ...[
          SizedBox(height: 24),
          Text(
            'Solutions for $_selectedSymptom',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.deepPlum,
            ),
          ),
          SizedBox(height: 16),
          ..._solutions[_selectedSymptom]!.map((solution) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(solution['emoji']!, style: TextStyle(fontSize: 24)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          solution['title']!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.deepPlum,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          solution['description']!,
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.blushRose,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$_selectedSymptom Selected',
                  style: TextStyle(fontSize: 14, color: AppColors.deepPlum),
                ),
              ),
              Text(
                'Here are some solutions that might help you feel better.',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSymptomButton(BuildContext context, String label, String emoji) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSymptom = label;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _selectedSymptom == label ? AppColors.blushRose : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: TextStyle(fontSize: 16)),
            SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 14, color: AppColors.deepPlum)),
          ],
        ),
      ),
    );
  }
}

// WellnessScreen widget
class WellnessScreen extends StatefulWidget {
  const WellnessScreen({Key? key}) : super(key: key);

  @override
  _WellnessScreenState createState() => _WellnessScreenState();
}

class _WellnessScreenState extends State<WellnessScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Wellness categories data
  final List<Map<String, dynamic>> wellnessCategories = [
    {
      'id': 'mindfulness',
      'items': [
        {
          'title': '3-Minute Breathing Space',
          'description': 'A quick meditation to center yourself during a busy day.',
          'icon': '🧘‍♀️',
          'color': AppColors.softLavender,
        },
        {
          'title': 'Body Scan Practice',
          'description': 'Release tension with this guided relaxation technique.',
          'icon': '✨',
          'color': AppColors.blushRose,
        },
        {
          'title': 'Affirmations',
          'description': 'Positive statements to boost your confidence and mood.',
          'icon': '💫',
          'color': AppColors.forestTeal,
        },
      ],
    },
    {
      'id': 'nutrition',
      'items': [
        {
          'title': 'Follicular Phase Foods',
          'description': 'Foods that support estrogen production and energy.',
          'icon': '🥗',
          'color': AppColors.blushRose,
        },
        {
          'title': 'Magnesium-Rich Recipe',
          'description': 'Help reduce cramps with this delicious smoothie.',
          'icon': '🥤',
          'color': AppColors.forestTeal,
        },
        {
          'title': 'Iron Boosters',
          'description': 'Foods to prevent fatigue during your period.',
          'icon': '🍲',
          'color': AppColors.softLavender,
        },
      ],
    },
    {
      'id': 'movement',
      'items': [
        {
          'title': 'Low-Impact Cardio',
          'description': '15-minute workout that\'s gentle on your joints.',
          'icon': '🚶‍♀️',
          'color': AppColors.forestTeal,
        },
        {
          'title': 'Yoga for Cramps',
          'description': '10-minute sequence to ease menstrual discomfort.',
          'icon': '🧘‍♀️',
          'color': AppColors.blushRose,
        },
        {
          'title': 'Energizing Stretch',
          'description': '5-minute morning routine to wake up your body.',
          'icon': '💪',
          'color': AppColors.softLavender,
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wellness header
          Text(
            'Wellness',
            style: TextStyle(
              fontFamily: 'Serif',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.deepPlum,
            ),
          ),
          SizedBox(height: 24),

          // Cycle-synced wellness card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.softLavender, AppColors.blushRose],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Cycle-Synced Wellness',
                        style: TextStyle(
                          fontFamily: 'Serif',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.deepPlum,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Personalized recommendations for your follicular phase',
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        labelColor: AppColors.deepPlum,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: AppColors.deepPlum,
                        tabs: [
                          Tab(text: 'Mind'),
                          Tab(text: 'Nutrition'),
                          Tab(text: 'Movement'),
                        ],
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        height: 300, // Adjust based on content
                        child: TabBarView(
                          controller: _tabController,
                          children: wellnessCategories.map((category) {
                            return ListView.separated(
                              itemCount: category['items'].length,
                              separatorBuilder: (context, index) => SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final item = category['items'][index];
                                return WellnessCard(
                                  title: item['title'],
                                  description: item['description'],
                                  icon: item['icon'],
                                  borderColor: item['color'],
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Virtual Wellness Room
          VirtualWellnessRoom(),
          SizedBox(height: 24),

          // Symptom Navigator
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Symptom Navigator',
                    style: TextStyle(
                      fontFamily: 'Serif',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepPlum,
                    ),
                  ),
                  SizedBox(height: 16),
                  SymptomNavigator(),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),

          // Support section
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Need Support?',
                      style: TextStyle(
                        fontFamily: 'Serif',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepPlum,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Implement View All action
                      },
                      child: Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.forestTeal,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _buildSupportButton(
                  icon: '💬',
                  title: 'Talk to a Professional',
                  description: 'Access our network of verified experts',
                  backgroundColor: AppColors.deepPlum,
                  textColor: Colors.white,
                  iconBackgroundColor: Colors.white.withOpacity(0.2),
                ),
                SizedBox(height: 12),
                _buildSupportButton(
                  icon: '❓',
                  title: 'Ask Anonymous Question',
                  description: 'Get answers from gynecologists & experts',
                  backgroundColor: AppColors.blushRose.withOpacity(0.8),
                  textColor: AppColors.deepPlum,
                  iconBackgroundColor: AppColors.deepPlum.withOpacity(0.1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build support buttons
  Widget _buildSupportButton({
    required String icon,
    required String title,
    required String description,
    required Color backgroundColor,
    required Color textColor,
    required Color iconBackgroundColor,
  }) {
    return InkWell(
      onTap: () {
        // TODO: Implement action
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconBackgroundColor,
              ),
              child: Center(child: Text(icon, style: TextStyle(fontSize: 20, color: textColor))),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}