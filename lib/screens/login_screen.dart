import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haajir/bloc/auth_bloc.dart';
import 'package:haajir/main.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Haajir App"),
        actions: [
          ValueListenableBuilder(
            valueListenable: isDarkTheme,
            builder: (context, value, child) {
              return IconButton(
                onPressed: () {
                  isDarkTheme.value = !value;
                },
                icon: Icon(value ? Icons.dark_mode_outlined : Icons.light_mode),
              );
            },
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: Column(
          crossAxisAlignment: .center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fingerprint, size: 125, color: Colors.blue),
            SizedBox(width: MediaQuery.of(context).size.width, height: 30),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(SignInWithGooglePressed());
              },
              child: Text("Sign in with Google"),
            ),
          ],
        ),
      ),
    );
  }
}
