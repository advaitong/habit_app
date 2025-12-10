import 'package:flutter/material.dart';
import 'package:habit_app/ad/banner_ad.dart'; // Ensure this import path is correct

class AdTestPage extends StatelessWidget {
  const AdTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ad Load Test'),
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.white,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Checking Ad Load Status Below:',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            SizedBox(height: 20),
            // The BannerAdWidget will appear here if loaded
            BannerAdWidget(),
            SizedBox(height: 20),
            Text(
              'If the ad loads, you will see a banner above.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}