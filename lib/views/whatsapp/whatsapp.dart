import 'package:flutter/material.dart';

class WhatsappPage extends StatelessWidget {
  const WhatsappPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhatsApp Buisness Page'),
      ),
      body: const Center(
        child: ElevatedButton(
          onPressed: null,
          child: Text('Whatsapp Buisness page'),
        ),
      ),
    );
  }
}
