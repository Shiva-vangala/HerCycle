import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/mood_button.dart';
import '../widgets/recommendation_card.dart';
import '../chatbot/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedMood;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HerCycle+'),
        backgroundColor: AppColors.blushRose,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          CircleAvatar(
            backgroundColor: AppColors.blushRose,
            child: const Text('JD'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Jane\nYour Cycle: Day 10',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 26),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Cycle',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: AppColors.deepPlum,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blushRose.withOpacity(0.2),
                            foregroundColor: AppColors.deepPlum,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: const Text('Follicular Phase'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0,bottom: 25.0),
                              child: Text('Menstrual', style: TextStyle(color: Colors.grey)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 25),
                              child: Text('Follicular', style: TextStyle(color: Colors.grey)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 25),
                              child: Text('Ovulation', style: TextStyle(color: Colors.grey)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 18.0,bottom: 25),
                              child: Text('Luteal', style: TextStyle(color: Colors.grey)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 20 ,
                          child: Container(
                            height: 5,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 26),
                        Positioned(
                          left: (MediaQuery.of(context).size.width - 64) * 0.333 + 18, // Adjust position to align under "Follicular"
                          top: 19,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Text('Next period in'),
                            Text('14 days', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blushRose.withOpacity(0.2),
                            foregroundColor: AppColors.deepPlum,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: const Text('Log Today'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'How are you feeling today?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MoodButton(
                  mood: 'Happy',
                  icon: Icons.sentiment_very_satisfied,
                  onTap: () {
                    setState(() {
                      selectedMood = 'Happy';
                    });
                  },
                ),
                MoodButton(
                  mood: 'Calm',
                  icon: Icons.sentiment_satisfied,
                  onTap: () {
                    setState(() {
                      selectedMood = 'Calm';
                    });
                  },
                ),
                MoodButton(
                  mood: 'Tired',
                  icon: Icons.sentiment_neutral,
                  onTap: () {
                    setState(() {
                      selectedMood = 'Tired';
                    });
                  },
                ),
                MoodButton(
                  mood: 'Stressed',
                  icon: Icons.sentiment_dissatisfied,
                  onTap: () {
                    setState(() {
                      selectedMood = 'Stressed';
                    });
                  },
                ),
                MoodButton(
                  mood: 'Sad',
                  icon: Icons.sentiment_very_dissatisfied,
                  onTap: () {
                    setState(() {
                      selectedMood = 'Sad';
                    });
                  },
                ),
              ],
            ),
            if (selectedMood != null) ...[
              const SizedBox(height: 16),
              Text(
                'You selected: $selectedMood',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'For Today',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('VIEW ALL'),
                ),
              ],
            ),
            RecommendationCard(
              title: 'Follicular Phase Nutrition',
              description:
                  'Try incorporating leafy greens and fermented foods to support estrogen metabolism.',
              icon: Icons.food_bank,
            ),
            RecommendationCard(
              title: 'Gentle Movement',
              description:
                  'Your energy is rising! Try a light cardio workout or yoga flow today.',
              icon: Icons.directions_run,
            ),
            RecommendationCard(
              title: '3-Minute Meditation',
              description:
                  'Take a moment to breathe and center yourself with this quick practice.',
              icon: Icons.self_improvement,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                       MaterialPageRoute(builder: (context) => ChatScreen()),
                       );
                  },
                  child: const Text('Ask a Question'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Join Community'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}