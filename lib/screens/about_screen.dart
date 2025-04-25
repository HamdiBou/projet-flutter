import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'This Quiz App is developed using Flutter and utilizes the Open Trivia Database (OpenTDB) API to fetch quiz questions. It offers a variety of categories and difficulty levels for an engaging quiz experience.\nDevelopped by Mohamed Amin Hadj Kacem & Hamdi Boussarsar',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}