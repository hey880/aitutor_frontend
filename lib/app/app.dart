import 'package:flutter/material.dart';
import 'theme.dart';
import 'routes.dart';

/// LingoDash App Entry Point
/// Handles MaterialApp setup, theme configuration, and routing.

class LingoDashApp extends StatelessWidget {
  const LingoDashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LingoDash',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      routes: getRoutes(),
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => _PlaceholderScreen(routeName: settings.name),
        );
      },
    );
  }
}

/// Temporary placeholder screen for routes that don't have screens yet.
class _PlaceholderScreen extends StatelessWidget {
  final String? routeName;

  const _PlaceholderScreen({this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(routeName ?? 'Unknown'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: AppColors.slate400,
            ),
            const SizedBox(height: 16),
            Text(
              'Screen Coming Soon',
              style: AppTextStyles.titleMedium(),
            ),
            const SizedBox(height: 8),
            Text(
              routeName ?? 'Unknown Route',
              style: AppTextStyles.bodyMedium(color: AppColors.slate500),
            ),
          ],
        ),
      ),
    );
  }
}
