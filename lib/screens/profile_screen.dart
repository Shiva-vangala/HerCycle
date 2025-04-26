import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.blushRose,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.blushRose,
              child: const Text('JD', style: TextStyle(fontSize: 30)),
            ),
            const SizedBox(height: 16),
            Text(
              'Jane Doe',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const Text('Member since April 2023'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text('28'),
                    Text(
                      'Avg. Cycle',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('5'),
                    Text(
                      'Period Days',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('122'),
                    Text(
                      'Insights',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Cycle History'),
                onTap: () {},
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.health_and_safety),
                title: const Text('Health Insights'),
                onTap: () {},
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notifications'),
                onTap: () {},
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Help & Resources'),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Community Circles',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('VIEW ALL'),
                ),
              ],
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.group),
                title: const Text('PCOS Warriors'),
                subtitle: const Text('8,542 members\nSupport for managing PCOS symptoms naturally.'),
                onTap: () {},
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.group),
                title: const Text('Mindful Cycles'),
                subtitle: const Text('12,423 members\nA space for cycle awareness and mindfulness practices.'),
                onTap: () {},
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.group),
                title: const Text('Fertility Journey'),
                subtitle: const Text('6,327 members\nSupport for those trying to conceive or navigating fertility.'),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}