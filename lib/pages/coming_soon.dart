import 'package:flutter/material.dart';

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({Key? key}) : super(key: key);

  // const ComingSoonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(
            height: 100.0,
          ),
          const Text(
            'SORRY!!',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 70.0,
          ),
          Center(
            child: Image.asset(
              'assets/img/dev.png',
              height: 300,
            ),
          ),
          const SizedBox(
            height: 50.0,
          ),
          const Center(
            child: Text(
              '\t\t\t\t\tP2P Exchange Area Is \nCurrently Under Development.',
              style: TextStyle(
                fontSize: 23,
                color: Colors.grey,
              ),
            ),
          )
        ],
      ),
    );
  }
}
