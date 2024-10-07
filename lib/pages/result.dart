// import 'package:flutter/material.dart';

// class OnboardingApp extends StatelessWidget {
//   const OnboardingApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Onboarding App',
//       debugShowCheckedModeBanner: false,
//       home: OnboardingScreen(),
//     );
//   }
// }

// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});

//   @override
//   _OnboardingScreenState createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final PageController _pageController = PageController(initialPage: 0);
//   int _currentPage = 0;

//   List<Map<String, String>> onboardingData = [
//     {
//       'image': 'assets/img/dev.png',
//       'title': 'Welcome to Onboarding App',
//       'subtitle': 'This is the first screen of the onboarding.',
//     },
//     {
//       'image': 'assets/img/dev.png',
//       'title': 'Second Onboarding Page',
//       'subtitle': 'This is the second screen of the onboarding.',
//     },
//     {
//       'image': 'assets/img/dev.png',
//       'title': 'Last Onboarding Page',
//       'subtitle': 'This is the last screen of the onboarding.',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           PageView.builder(
//             controller: _pageController,
//             itemCount: onboardingData.length,
//             onPageChanged: (index) {
//               setState(() {
//                 _currentPage = index;
//               });
//             },
//             itemBuilder: (context, index) {
//               return OnboardingPage(
//                 imageData: onboardingData[index],
//               );
//             },
//           ),
//           Positioned(
//             bottom: 50.0,
//             left: 0,
//             right: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: _buildPageIndicator(),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: _currentPage == onboardingData.length - 1
//           ? FloatingActionButton.extended(
//               onPressed: () {
//                 // Perform action after clicking last button
//                 print("Last button clicked");
//               },
//               label: const Text('Get Started'),
//               icon: const Icon(Icons.arrow_forward),
//             )
//           : FloatingActionButton(
//               onPressed: () {
//                 _pageController.nextPage(
//                   duration: const Duration(milliseconds: 500),
//                   curve: Curves.ease,
//                 );
//               },
//               child: const Icon(Icons.arrow_forward),
//             ),
//     );
//   }

//   List<Widget> _buildPageIndicator() {
//     List<Widget> indicators = [];
//     for (int i = 0; i < onboardingData.length; i++) {
//       indicators.add(
//         i == _currentPage ? _indicator(true) : _indicator(false),
//       );
//     }
//     return indicators;
//   }

//   Widget _indicator(bool isActive) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 150),
//       margin: const EdgeInsets.symmetric(horizontal: 8.0),
//       height: 8.0,
//       width: isActive ? 24.0 : 16.0,
//       decoration: BoxDecoration(
//         color: isActive ? Colors.blue : Colors.grey,
//         borderRadius: const BorderRadius.all(Radius.circular(12)),
//       ),
//     );
//   }
// }

// class OnboardingPage extends StatelessWidget {
//   final Map<String, String> imageData;

//   const OnboardingPage({Key? key, required this.imageData}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Image.asset(
//           imageData['image']!,
//           height: 300.0,
//           width: 300.0,
//         ),
//         const SizedBox(height: 30.0),
//         Text(
//           imageData['title']!,
//           style: const TextStyle(
//             fontSize: 24.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 10.0),
//         Text(
//           imageData['subtitle']!,
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             fontSize: 16.0,
//           ),
//         ),
//         const SizedBox(height: 30.0),
//         ElevatedButton(
//           onPressed: () {
//             // Action to perform when skip button is pressed
//             print("Skip button pressed");
//           },
//           child: const Text('Skip'),
//         ),
//       ],
//     );
//   }
// }

