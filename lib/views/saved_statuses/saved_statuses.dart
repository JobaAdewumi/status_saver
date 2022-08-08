import 'package:flutter/material.dart';

class SavedStatusPage extends StatelessWidget {
  const SavedStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Statuses Page'),
      ),
      body: const Center(
        child: ElevatedButton(
          onPressed: null,
          child: Text('Saved Statuses page'),
        ),
      ),
    );
  }
}
