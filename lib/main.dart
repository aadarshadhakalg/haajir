import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:haajir/bloc/attendance_cubit.dart';
import 'package:haajir/bloc/auth_bloc.dart';
import 'package:haajir/firebase_options.dart';
import 'package:haajir/repositories/attendance_repository.dart';
import 'package:haajir/screens/attendance_detail_screen.dart';
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
              useMaterial3: true,
              scaffoldBackgroundColor: const Color(0xFFF8F9FF),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF0058BE),
                primary: const Color(0xFF000000),
                secondary: const Color(0xFF0058BE),
                secondaryContainer: const Color(0xFF2170E4),
                onSecondaryContainer: const Color(0xFFFEFCFF),
                surface: const Color(0xFFF8F9FF),
                surfaceContainer: const Color(0xFFE5EEFF),
                surfaceContainerLowest: const Color(0xFFFFFFFF),
                surfaceContainerHighest: const Color(0xFFD3E4FE),
                onSurface: const Color(0xFF0B1C30),
                onSurfaceVariant: const Color(0xFF45464D),
                outlineVariant: const Color(0xFFC6C6CD),
              ),
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
          return BlocProvider(
            create: (context) =>
                AttendanceCubit(repository: AttendanceRepository())
                  ..loadAttendance(),
            child: const AttendanceHistoryScreen(),
          );
        } else if (state is AuthLoading) {
          return Center(child: CircularProgressIndicator());
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
