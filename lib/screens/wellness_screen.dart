import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFF8A4AF3),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 18, color: Color(0xFF4A2C66)),
        ),
      ),
      home: const WellnessScreen(),
    );
  }
}

class WellnessScreen extends StatefulWidget {
  const WellnessScreen({super.key});

  @override
  _WellnessScreenState createState() => _WellnessScreenState();
}

class _WellnessScreenState extends State<WellnessScreen> {
  Timer? _timer;
  Timer? _alertTimer;
  int _secondsRemaining = 179; // 2:59 in seconds
  bool _isPaused = true;
  int _selectedTab = 0; // 0: Mind, 1: Nutrition, 2: Movement
  String? _alertMessage;
  Color? _alertColor;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _alertTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_isPaused) {
      setState(() {
        _isPaused = false;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsRemaining > 0) {
          setState(() {
            _secondsRemaining--;
          });
        } else {
          timer.cancel();
          setState(() {
            _isPaused = true;
          });
        }
      });
    } else {
      _pauseTimer();
    }
  }

  void _pauseTimer() {
    if (!_isPaused) {
      _timer?.cancel();
      setState(() {
        _isPaused = true;
      });
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 179;
      _isPaused = true;
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(1, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  void _showAlert(String message, Color color) {
    setState(() {
      _alertMessage = message;
      _alertColor = color;
    });
    _alertTimer?.cancel();
    _alertTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _alertMessage = null;
        _alertColor = null;
      });
    });
  }

  void _showTalkToSomeoneAlert() {
    _showAlert('Connecting to a Specialist', Colors.green);
  }

  void _showSOSAlert() {
    _showAlert('Emergency support activated. Please wait for assistance.', Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tabs = [
      {'title': 'Mind', 'content': _buildMindContent()},
      {'title': 'Nutrition', 'content': _buildNutritionContent()},
      {'title': 'Movement', 'content': _buildMovementContent()},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wellness', style: TextStyle(color: Color(0xFF4A2C66))),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE6E1F5), Color.fromARGB(255, 242, 235, 235)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Cycle-Synced Wellness',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A2C66),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Personalized recommendations for your follicular phase',
                            style: TextStyle(color: const Color.fromARGB(255, 118, 70, 70), fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildTabButton(0, 'Mind'),
                              _buildTabButton(1, 'Nutrition'),
                              _buildTabButton(2, 'Movement'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                tabs[_selectedTab]['content'] as Widget,
                const SizedBox(height: 16),
                const Text(
                  'Virtual Wellness Room',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A2C66),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          '3-Minute Breathing Space',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A2C66),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'A quick meditation to center yourself',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _formatTime(_secondsRemaining),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A2C66),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: _startTimer,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                                foregroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(_isPaused ? 'Start' : 'Pause'),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: _resetTimer,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                                foregroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text('Reset'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _startTimer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF4C2C2).withOpacity(0.2),
                          foregroundColor: const Color(0xFF4A2C66),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Breathing Exercise'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _showTalkToSomeoneAlert,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Talk to Someone'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _showSOSAlert,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('SOS Mode'),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Symptom Navigator',
                  style: TextStyle(fontSize: 18, color: Color(0xFF4A2C66)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Select a symptom to get personalized solutions:',
                  style: TextStyle(color: Color(0xFF4A2C66)),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildSymptomButton('Cramps'),
                    _buildSymptomButton('Mood Swings'),
                    _buildSymptomButton('Low Energy'),
                    _buildSymptomButton('Bloating'),
                    _buildSymptomButton('Headache'),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Need Support?',
                  style: TextStyle(fontSize: 18, color: Color(0xFF4A2C66)),
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B2D91),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Talk to a Professional'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF4C2C2).withOpacity(0.2),
                          foregroundColor: const Color(0xFF4A2C66),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Ask Anonymous Question'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('VIEW ALL', style: TextStyle(color: Color(0xFF2E7D32))),
                  ),
                ),
              ],
            ),
          ),
          if (_alertMessage != null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: _alertColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _alertMessage!,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String title) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedTab = index;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.8), // Background for all tabs
        foregroundColor: _selectedTab == index ? const Color(0xFF4A2C66) : Colors.grey[600],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide(color: Colors.grey[300]!),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ).copyWith(
        backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (_selectedTab == index) {
            return const Color(0xFFF4E1E6).withOpacity(0.5); // Light purple when selected
          }
          return Colors.white.withOpacity(0.8);
        }),
      ),
      child: Text(title),
    );
  }

  Widget _buildMindContent() {
    return Column(
      children: [
        _buildRecommendationCard(
          title: '3-Minute Breathing Space',
          description: 'A quick meditation to center yourself during a busy day.',
          icon: Icons.self_improvement,
          iconColor: const Color(0xFFF4A261),
          shadowColor: const Color(0xFFF4A261), // Orange shadow for Mind
        ),
        _buildRecommendationCard(
          title: 'Body Scan Practice',
          description: 'Release tension with this guided relaxation technique.',
          icon: Icons.star,
          iconColor: const Color(0xFFF4A261),
          shadowColor: const Color(0xFFF4A261),
        ),
        _buildRecommendationCard(
          title: 'Affirmations',
          description: 'Positive statements to boost your confidence and mood.',
          icon: Icons.lightbulb,
          iconColor: const Color(0xFF2E7D32),
          shadowColor: const Color(0xFFF4A261),
        ),
      ],
    );
  }

  Widget _buildNutritionContent() {
    return Column(
      children: [
        _buildRecommendationCard(
          title: 'Follicular Phase Foods',
          description: 'Foods that support estrogen production and energy.',
          icon: Icons.local_dining,
          iconColor: const Color(0xFFF4A261),
          shadowColor: Colors.grey.shade300, // Neutral shadow for Nutrition
        ),
        _buildRecommendationCard(
          title: 'Magnesium-Rich Recipe',
          description: 'Help reduce cramps with this delicious smoothie.',
          icon: Icons.local_drink,
          iconColor: const Color(0xFFF4A261),
          shadowColor: Colors.grey.shade300,
        ),
        _buildRecommendationCard(
          title: 'Iron Boosters',
          description: 'Foods to prevent fatigue during your period.',
          icon: Icons.fastfood,
          iconColor: const Color(0xFFF4A261),
          shadowColor: Colors.grey.shade300,
        ),
      ],
    );
  }

  Widget _buildMovementContent() {
    return Column(
      children: [
        _buildRecommendationCard(
          title: 'Low-Impact Cardio',
          description: '15-minute workout that\'s gentle on your joints.',
          icon: Icons.directions_walk,
          iconColor: const Color(0xFFF4A261),
          shadowColor: const Color(0xFF2E7D32), // Green shadow for Movement
        ),
        _buildRecommendationCard(
          title: 'Yoga for Cramps',
          description: '10-minute sequence to ease menstrual discomfort.',
          icon: Icons.self_improvement,
          iconColor: const Color(0xFFF4A261),
          shadowColor: const Color(0xFF2E7D32),
        ),
        _buildRecommendationCard(
          title: 'Energizing Stretch',
          description: '5-minute morning routine to wake up your body.',
          icon: Icons.fitness_center,
          iconColor: const Color(0xFFF4A261),
          shadowColor: const Color(0xFF2E7D32),
        ),
      ],
    );
  }

  Widget _buildRecommendationCard({
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required Color shadowColor,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.3),
              offset: const Offset(-4, 0), // Left shadow
              blurRadius: 6,
              spreadRadius: 0,
            ),
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(icon, color: iconColor),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(description),
          onTap: () {},
        ),
      ),
    );
  }

  Widget _buildSymptomButton(String symptom) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF4C2C2).withOpacity(0.2),
        foregroundColor: const Color(0xFF4A2C66),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(symptom),
    );
  }
}