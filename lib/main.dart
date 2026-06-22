import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:haajir/bloc/auth_bloc.dart';
import 'package:haajir/firebase_options.dart';
import 'package:haajir/screens/dashboard_screen.dart';
import 'package:haajir/screens/login_screen.dart';

final ValueNotifier<bool> isDarkTheme = ValueNotifier(false);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await GoogleSignIn.instance.initialize();
  runApp(const HaajirApp());
}

class HaajirApp extends StatelessWidget {
  const HaajirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc()..add(AuthCheckRequested()),
      child: ValueListenableBuilder(
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
            home: AuthScreenRouter(),
          );
        },
      ),
    );
  }
}

class AuthScreenRouter extends StatelessWidget {
  const AuthScreenRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return DashboardScreen();
        } else if (state is AuthLoading) {
          return Center(child: CircularProgressIndicator());
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
