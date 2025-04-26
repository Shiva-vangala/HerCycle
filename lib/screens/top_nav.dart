import 'package:flutter/material.dart';
import 'profile_screen.dart';
import '../theme/app_colors.dart';

// Placeholder screens for Blogs, About Us, and Contact Us
class BlogsScreen extends StatelessWidget {
  const BlogsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blogs'),
        backgroundColor: AppColors.blushRose,
      ),
      body: const Center(child: Text('Blogs Screen')),
    );
  }
}

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: AppColors.blushRose,
      ),
      body: const Center(child: Text('About Us Screen')),
    );
  }
}

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        backgroundColor: AppColors.blushRose,
      ),
      body: const Center(child: Text('Contact Us Screen')),
    );
  }
}

// Top Navigation Bar Widget
class TopNav extends StatelessWidget implements PreferredSizeWidget {
  final ValueChanged<int>? onTabSelected; // Callback to update the selected tab

  const TopNav({Key? key, this.onTabSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.blushRose,
            ),
            child: const Text(
              'H+',
              style: TextStyle(
                fontFamily: 'Serif',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.deepPlum,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'HerCycle+',
            style: TextStyle(
              fontFamily: 'Serif',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.deepPlum,
            ),
          ),
        ],
      ),
      actions: [
        if (!isSmallScreen) ...[
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BlogsScreen()),
              );
            },
            child: const Text(
              'Blogs',
              style: TextStyle(
                fontFamily: 'Serif',
                fontSize: 16,
                color: AppColors.deepPlum,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsScreen()),
              );
            },
            child: const Text(
              'About Us',
              style: TextStyle(
                fontFamily: 'Serif',
                fontSize: 16,
                color: AppColors.deepPlum,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactUsScreen()),
              );
            },
            child: const Text(
              'Contact Us',
              style: TextStyle(
                fontFamily: 'Serif',
                fontSize: 16,
                color: AppColors.deepPlum,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
        Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.notifications,
                color: AppColors.deepPlum,
                size: 24,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notifications tapped')),
                );
              },
            );
          },
        ),
        const SizedBox(width: 8),
        // Profile Button
        GestureDetector(
          onTap: () {
            // Call the callback to switch to the Profile tab (index 4)
            onTabSelected?.call(4); // Profile tab index
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.blushRose,
            ),
            child: const Text(
              'JD',
              style: TextStyle(
                fontFamily: 'Serif',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.deepPlum,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
      leading: isSmallScreen
          ? Builder(
              builder: (context) => IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: AppColors.deepPlum,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Drawer for small screens
class TopNavDrawer extends StatelessWidget {
  const TopNavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.blushRose,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Text(
                    'H+',
                    style: TextStyle(
                      fontFamily: 'Serif',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepPlum,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'HerCycle+',
                  style: TextStyle(
                    fontFamily: 'Serif',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepPlum,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text(
              'Blogs',
              style: TextStyle(
                fontFamily: 'Serif',
                fontSize: 16,
                color: AppColors.deepPlum,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BlogsScreen()),
              );
            },
          ),
          ListTile(
            title: const Text(
              'About Us',
              style: TextStyle(
                fontFamily: 'Serif',
                fontSize: 16,
                color: AppColors.deepPlum,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsScreen()),
              );
            },
          ),
          ListTile(
            title: const Text(
              'Contact Us',
              style: TextStyle(
                fontFamily: 'Serif',
                fontSize: 16,
                color: AppColors.deepPlum,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactUsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}