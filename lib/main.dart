import 'package:flutter/material.dart';
import 'package:haajir/screens/login_screen.dart';

final ValueNotifier<bool> isDarkTheme = ValueNotifier(false);

void main() {
  runApp(const HaajirApp());
}

class HaajirApp extends StatelessWidget {
  const HaajirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkTheme,
      builder: (context, value, child) {
        return MaterialApp(
          title: 'Haajir App',
          theme: ThemeData(
            colorScheme: .fromSeed(seedColor: Colors.deepPurple),
          ),
          darkTheme: ThemeData.dark().copyWith(
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: WidgetStateColor.resolveWith(
                  (s) => Colors.black,
                ),
              ),
            ),
          ),
          themeMode: value ? ThemeMode.dark : ThemeMode.light,
          home: LoginScreen(),
        );
      },
    );
  }
}
