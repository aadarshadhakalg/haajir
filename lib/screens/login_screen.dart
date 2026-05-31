import 'package:flutter/material.dart';
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
      body: Column(
        crossAxisAlignment: .center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fingerprint, size: 125, color: Colors.blue),
          SizedBox(width: MediaQuery.of(context).size.width, height: 30),
          ElevatedButton(onPressed: () {}, child: Text("Sign in with Google")),
        ],
      ),
    );
  }
}
