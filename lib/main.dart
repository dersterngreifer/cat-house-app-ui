import 'package:cat_store_app/screens/home_screen.dart';
import 'package:cat_store_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CatHouse',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppTheme.primaryColor,
        scaffoldBackgroundColor: AppTheme.backgroundColor,
        colorScheme: ColorScheme.light(
          primary: AppTheme.primaryColor,
          secondary: AppTheme.secondaryColor,
          surface: AppTheme.backgroundColor,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppTheme.surfaceColor,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppTheme.textPrimary),
          titleTextStyle: AppTheme.heading3.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppTheme.cardColor,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: AppTheme.textLight,
            elevation: 8,
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing24,
              vertical: AppTheme.spacing16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            textStyle: AppTheme.subtitle1,
          ),
        ),
        fontFamily: 'System',
        textTheme: const TextTheme(
          displayLarge: AppTheme.heading1,
          displayMedium: AppTheme.heading2,
          displaySmall: AppTheme.heading3,
          titleLarge: AppTheme.subtitle1,
          titleMedium: AppTheme.subtitle2,
          bodyLarge: AppTheme.body1,
          bodyMedium: AppTheme.body2,
          bodySmall: AppTheme.caption,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      navigatorObservers: [HeroController()],
      home: const HomeScreen(),
    );
  }
}
