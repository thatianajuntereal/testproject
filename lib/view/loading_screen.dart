import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test_project/view/social_media_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  final List<String> loadingMessages = ["Logging in...", "Fetching data..."];
  int _messageIndex = 0;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 1), () {
      setState(() {
        _messageIndex = 1;
      });
    });

    Timer(const Duration(seconds: 2), () {
      setState(() {
        _messageIndex = 1;
      });
    });

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SocialScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(loadingMessages[_messageIndex]),
          ],
        ),
      ),
    );
  }
}
