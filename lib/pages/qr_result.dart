import 'package:flutter/material.dart';

class QRResultPage extends StatelessWidget {
  final String result;

  const QRResultPage({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scan Result'),
      ),
      body: Center(
        child: Text(
          'Scanned Result: $result',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
