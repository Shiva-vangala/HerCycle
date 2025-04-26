import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';
import 'community_screen.dart';
import 'community_detail_screen.dart';

// Placeholder Layout widget (mimics TSX Layout component)
class Layout extends StatelessWidget {
  final Widget child;

  const Layout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: child,
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Set<String> joinedCommunities = {};

  @override
  void initState() {
    super.initState();
    _loadJoinedCommunities();
  }

  Future<void> _loadJoinedCommunities() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? saved = prefs.getStringList('joined_communities');
    if (saved != null) {
      setState(() {
        joinedCommunities = saved.toSet();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Layout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile',
                style: TextStyle(
                  fontFamily: 'Serif',
                  fontSize: isSmallScreen ? 20 : 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepPlum,
                ),
              ),
              IconButton(
                icon: Icon(Icons.settings, color: AppColors.deepPlum),
                onPressed: () {
                  // TODO: Implement settings action
                },
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  shape: const CircleBorder(),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 16 : 24),

          // Profile card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: isSmallScreen ? 32 : 40,
                    backgroundColor: AppColors.blushRose,
                    child: Text(
                      'JD',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 20 : 24,
                        color: AppColors.deepPlum,
                      ),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 12),
                  Text(
                    'Jane Doe',
                    style: TextStyle(
                      fontFamily: 'Serif',
                      fontSize: isSmallScreen ? 18 : 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepPlum,
                    ),
                  ),
                  Text(
                    'Member since April 2023',
                    style: TextStyle(fontSize: isSmallScreen ? 11 : 12, color: Colors.grey[500]),
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            '28',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.deepPlum,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                          ),
                          Text(
                            'Avg Cycle',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 11 : 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '5',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.deepPlum,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                          ),
                          Text(
                            'Period Days',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 11 : 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '122',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.deepPlum,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                          ),
                          Text(
                            'Insights',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 11 : 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: isSmallScreen ? 16 : 24),

          // Action buttons
          Column(
            children: [
              _buildActionButton(
                icon: Icons.calendar_today,
                label: 'Cycle History',
                backgroundColor: AppColors.softLavender,
              ),
              SizedBox(height: 12),
              _buildActionButton(
                icon: Icons.favorite,
                label: 'Health Insights',
                backgroundColor: AppColors.blushRose,
              ),
              SizedBox(height: 12),
              _buildActionButton(
                icon: Icons.notifications,
                label: 'Notifications',
                backgroundColor: AppColors.forestTeal.withOpacity(0.2),
              ),
              SizedBox(height: 12),
              _buildActionButton(
                icon: Icons.info,
                label: 'Help & Resources',
                backgroundColor: AppColors.deepPlum.withOpacity(0.1),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 16 : 24),

          // Community Circles
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Community Circles',
                style: TextStyle(
                  fontFamily: 'Serif',
                  fontSize: isSmallScreen ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepPlum,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CommunityScreen()),
                  );
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    color: AppColors.forestTeal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Conditional rendering for joined communities
          joinedCommunities.isEmpty
              ? Column(
                  children: [
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    Text(
                      "You haven't joined any community",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CommunityScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.forestTeal,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 16 : 24,
                          vertical: isSmallScreen ? 8 : 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Join Community',
                        style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                  ],
                )
              : Column(
                  children: [
                    if (joinedCommunities.contains("Women's Health"))
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                          leading: const Icon(Icons.group, color: AppColors.deepPlum),
                          title: Text(
                            "Women's Health",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.deepPlum,
                            ),
                          ),
                          subtitle: Text(
                            'A space to discuss wellness, health tips, and everything about your body.',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommunityDetailScreen(
                                  communityTitle: "Women's Health",
                                  communityDescription: 'A space to discuss wellness, health tips, and everything about your body.',
                                  communityImage: 'assets/images/womens_health.jpg',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    if (joinedCommunities.contains('PCOS Support'))
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                          leading: const Icon(Icons.group, color: AppColors.deepPlum),
                          title: Text(
                            'PCOS Support',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.deepPlum,
                            ),
                          ),
                          subtitle: Text(
                            'Connect with others managing PCOS. Share your journey and advice.',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommunityDetailScreen(
                                  communityTitle: 'PCOS Support',
                                  communityDescription: 'Connect with others managing PCOS. Share your journey and advice.',
                                  communityImage: 'assets/images/pcos.jpg',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    if (joinedCommunities.contains('Mental Wellness'))
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                          leading: const Icon(Icons.group, color: AppColors.deepPlum),
                          title: Text(
                            'Mental Wellness',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.deepPlum,
                            ),
                          ),
                          subtitle: Text(
                            'Your safe place to talk about emotional health and self-care.',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommunityDetailScreen(
                                  communityTitle: 'Mental Wellness',
                                  communityDescription: 'Your safe place to talk about emotional health and self-care.',
                                  communityImage: 'assets/images/mental_wellness.jpg',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    if (joinedCommunities.contains('Nutrition & Fitness'))
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                          leading: const Icon(Icons.group, color: AppColors.deepPlum),
                          title: Text(
                            'Nutrition & Fitness',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.deepPlum,
                            ),
                          ),
                          subtitle: Text(
                            'Tips on eating well and moving your body mindfully through every phase.',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommunityDetailScreen(
                                  communityTitle: 'Nutrition & Fitness',
                                  communityDescription: 'Tips on eating well and moving your body mindfully through every phase.',
                                  communityImage: 'assets/images/nutrition_fitness.jpg',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
          SizedBox(height: isSmallScreen ? 16 : 24),

          // Invite a Friend button
          Center(
            child: ElevatedButton(
              onPressed: () {
                // TODO: Implement Invite a Friend action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.forestTeal,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16 : 24,
                  vertical: isSmallScreen ? 8 : 12,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                'Invite a Friend',
                style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build action buttons
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color backgroundColor,
  }) {
    return InkWell(
      onTap: () {
        // TODO: Implement action
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundColor,
              ),
              child: Icon(icon, size: 18, color: AppColors.deepPlum),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(fontSize: 16, color: AppColors.deepPlum),
            ),
          ],
        ),
      ),
    );
  }
}