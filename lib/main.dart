import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/bottom_nav.dart';
import 'theme/app_theme.dart';
import 'models/user.dart';

  void main() {
    runApp(
      ChangeNotifierProvider(
        create: (context) => User(),
        child: const HerCyclePlusApp(),
      ),
    );
  }

  class HerCyclePlusApp extends StatelessWidget {
    const HerCyclePlusApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'HerCycle+',
        theme: AppTheme.lightTheme,
        home: const BottomNav(),
      );
    }
  }