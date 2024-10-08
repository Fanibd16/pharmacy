// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// // import 'package:jwt_decoder/jwt_decoder.dart';
// // import 'package:paybirr/pages/indexpage.dart';
// import 'dart:convert';
// // import 'package:paybirr/pages/registration_page.dart';
// import 'package:pharmacy/pages/indexpage.dart';
// import 'package:pharmacy/pages/registration_page.dart';
// import 'package:quickalert/quickalert.dart'; // Import QuickAlert
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   bool _isPasswordHidden = true; // To toggle password visibility

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   late SharedPreferences pref;

//   @override
//   void initState() {
//     super.initState();
//     initSharedPref();
//   }

//   void initSharedPref() async {
//     pref = await SharedPreferences.getInstance();
//   }

//   void _togglePasswordView() {
//     setState(() {
//       _isPasswordHidden = !_isPasswordHidden;
//     });
//   }

//   void _navigateToSignUp(BuildContext context) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => const SignUpScreen(), // Sign up screen
//       ),
//     );
//   }

//   void _signIn() async {
//     // Check if any fields are empty
//     if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
//       QuickAlert.show(
//         context: context,
//         type: QuickAlertType.info,
//         title: 'Empty Fields',

//         confirmBtnColor: const Color.fromARGB(255, 255, 200, 1),
//         text: 'Please fill in both email and password fields!',
//         confirmBtnText: 'OK',
//         // confirmBtnTextStyle: TextStyle(color: Colors.white)
//       );
//       return; // Exit the function to avoid making the request
//     }

//     final response = await http.post(
//       Uri.parse('http://172.23.32.1:4000/api/auth/login'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'emailOrPhone': _emailController.text,
//         'password': _passwordController.text,
//       }),
//     );

//     if (response.statusCode == 200) {
//       // Successfully logged in
//       final data = jsonDecode(response.body);
//       String myToken = data['token'];
//       pref.setString('token', myToken);

//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => IndexPage(token: myToken),
//         ),
//       );

//       // QuickAlert.show(
//       //   context: context,
//       //   type: QuickAlertType.success,
//       //   text: 'Login successful!',
//       //   confirmBtnText: 'Continue',
//       //   confirmBtnColor: Colors.green,
//       //   onConfirmBtnTap: () {
//       //     Navigator.push(
//       //       context,
//       //       MaterialPageRoute(
//       //         builder: (context) => IndexPage(token: myToken),
//       //       ),
//       //     );
//       //   },
//       // );
//       print("Login successful, token: $myToken");
//     } else {
//       // Login failed
//       final Map<String, dynamic> responseBody = jsonDecode(response.body);
//       if (responseBody['message'] == 'User not found') {
//         QuickAlert.show(
//           context: context,
//           type: QuickAlertType.error,
//           confirmBtnColor: const Color.fromARGB(255, 255, 0, 0),
//           text: 'Invalid email or password!',
//           confirmBtnText: 'Try Again',
//           onConfirmBtnTap: () {
//             Navigator.pop(context);
//           },
//         );
//       } else {
//         QuickAlert.show(
//           context: context,
//           type: QuickAlertType.error,
//           confirmBtnColor: const Color.fromARGB(255, 232, 13, 13),
//           title: 'Error',
//           text: 'Login failed. Please try again.',
//           confirmBtnText: 'Try Again',
//           onConfirmBtnTap: () {
//             Navigator.pop(context);
//           },
//         );
//       }
//       print("Login failed: ${response.body}");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset:
//           true, // This allows the screen to adjust when the keyboard is on
//       body: Stack(
//         children: [
//           Container(
//             height: double.infinity,
//             width: double.infinity,
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(colors: [
//                 Color(0xff674fff),
//                 Color(0xff9775dc),
//               ]),
//             ),
//             child: const Padding(
//               padding: EdgeInsets.only(top: 60.0, left: 22),
//               child: Text(
//                 'Hello\nSign in!',
//                 style: TextStyle(
//                     fontSize: 30,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 200.0),
//             child: Container(
//               decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(40),
//                     topRight: Radius.circular(40)),
//                 color: Colors.white,
//               ),
//               height: double.infinity,
//               width: double.infinity,
//               child: SingleChildScrollView(
//                 // Wrap content in scrollable view
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 18.0, right: 18),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const SizedBox(height: 30),
//                       TextField(
//                         controller: _emailController,
//                         decoration: const InputDecoration(
//                           suffixIcon: Icon(
//                             Icons.check,
//                             color: Colors.grey,
//                           ),
//                           label: Text(
//                             'Gmail',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                       ),
//                       TextField(
//                         controller: _passwordController,
//                         obscureText: _isPasswordHidden,
//                         decoration: InputDecoration(
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _isPasswordHidden
//                                   ? Icons.visibility_off
//                                   : Icons.visibility,
//                               color: Colors.grey,
//                             ),
//                             onPressed: _togglePasswordView,
//                           ),
//                           label: const Text(
//                             'Password',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       const Align(
//                         alignment: Alignment.centerRight,
//                         child: Text(
//                           'Forgot Password?',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 17,
//                             color: Color(0xff281537),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 50),
//                       GestureDetector(
//                         onTap: _signIn, // Trigger sign-in logic
//                         child: Container(
//                           height: 55,
//                           width: 300,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(30),
//                             gradient: const LinearGradient(
//                               colors: [
//                                 Color(0xff674fff),
//                                 Color(0xff9775dc),
//                               ],
//                             ),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               'SIGN IN',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 20,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 50),
//                       Align(
//                         alignment: Alignment.bottomRight,
//                         child: GestureDetector(
//                           onTap: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   const SignUpScreen(), // The screen you want to navigate to
//                             ),
//                           ),
//                           child: const Column(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Text(
//                                 "Don't have an account?",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.grey),
//                               ),
//                               Text(
//                                 "Sign up",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 17,
//                                     color: Colors.black),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                           height: 20), // Add some padding at the bottom
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pharmacy/pages/indexpage.dart';
import 'package:pharmacy/pages/registration_page.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordHidden = true; // To toggle password visibility
  bool _stayLoggedIn = false; // For the "Stay Logged In" feature

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late SharedPreferences pref;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    pref = await SharedPreferences.getInstance();
  }

  void _togglePasswordView() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  void _navigateToSignUp(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  void _signIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.info,
        title: 'Empty Fields',
        confirmBtnColor: const Color.fromARGB(255, 255, 200, 1),
        text: 'Please fill in both email and password fields!',
        confirmBtnText: 'OK',
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://192.168.137.176:4000/api/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'emailOrPhone': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String myToken = data['token'];
      await pref.setString('token', myToken);
      await pref.setBool('stayLoggedIn', _stayLoggedIn); // Save the preference

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IndexPage(
            token: myToken,
            languageCode: '',
            onChangeLanguage: (String) {},
          ),
        ),
      );
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        confirmBtnColor: const Color.fromARGB(255, 255, 0, 0),
        text: responseBody['message'] == 'User not found'
            ? 'Invalid email or password!'
            : 'Login failed. Please try again.',
        confirmBtnText: 'Try Again',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xff674fff),
                Color(0xff9775dc),
              ]),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'Hello\nSign in!',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.check,
                            color: Colors.grey,
                          ),
                          label: Text(
                            'Gmail',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      TextField(
                        controller: _passwordController,
                        obscureText: _isPasswordHidden,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: _togglePasswordView,
                          ),
                          label: const Text(
                            'Password',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Color(0xff281537),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CheckboxListTile(
                        title: const Text(
                          'Stay Logged In',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        value: _stayLoggedIn,
                        onChanged: (bool? value) {
                          setState(() {
                            _stayLoggedIn = value ?? false;
                          });
                        },
                      ),
                      const SizedBox(height: 50),
                      GestureDetector(
                        onTap: _signIn,
                        child: Container(
                          height: 55,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xff674fff),
                                Color(0xff9775dc),
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'SIGN IN',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SignUpScreen(), // The screen you want to navigate to
                            ),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              Text(
                                "Sign up",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
