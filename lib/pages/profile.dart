import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy/pages/login_page.dart';
import 'package:pharmacy/utility/localization_lang.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
// Import the localization map

class SettingsPage extends StatefulWidget {
  final String fullName;
  final Function(String) onChangeLanguage; // Add callback for language change

  const SettingsPage(
      {super.key, required this.fullName, required this.onChangeLanguage});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  bool isNotificationsOn = true;
  String language = 'en'; // Default language code

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
      language = prefs.getString('languageCode') ??
          'en'; // Default to English if not set
    });
  }

  _toggleDarkMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', value);
    setState(() {
      isDarkMode = value;
    });
  }

  Future<void> _changeLanguage(String langCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Remove the current language state
    await prefs.remove('languageCode');

    // Add the selected language
    await prefs.setString('languageCode', langCode);

    setState(() {
      language = langCode; // Store the language code directly
    });

    // Call the callback to notify the parent about the language change
    widget.onChangeLanguage(langCode);
  }

  String _translate(String key) {
    String langCode =
        language == 'en' ? 'en' : 'am'; // Use the language code directly
    return localizedText[langCode]?[key] ?? key;
  }

  void _openHelpBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const Column(
          mainAxisSize: MainAxisSize.min,
          children: [Center(child: Text('Help'))],
        );
      },
    );
  }

  void _openLanguageBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () async {
                await _changeLanguage('en');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('አማርኛ'),
              onTap: () async {
                await _changeLanguage('am');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xff674fff),
              Color(0xff9775dc),
            ]),
          ),
          child: Column(
            children: [
              const SizedBox(height: 45.5),
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 12, right: 12),
                child: Row(
                  children: [
                    Text(
                      _translate('profile'),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        // Perform logout logic
                        await _logout(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.black.withOpacity(0.3)
                              : Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.black.withOpacity(0.3)
                        : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child:
                          Icon(Icons.person, size: 40, color: Colors.grey[500]),
                    ),
                    title: Text(
                      widget.fullName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      _translate('personalInfo'),
                      style: TextStyle(color: Colors.grey[200]),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AccountPage()),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 220.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              color: isDarkMode ? Colors.grey[900] : Colors.white,
            ),
            height: double.infinity,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(_translate('settings'),
                        style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: Icon(Icons.language,
                        color: isDarkMode ? Colors.white : Colors.black),
                    title: Text(_translate('language'),
                        style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black)),
                    subtitle: Text(language == 'en' ? 'English' : 'አማርኛ',
                        style: TextStyle(
                            color: isDarkMode ? Colors.grey : Colors.black)),
                    onTap: _openLanguageBottomSheet,
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  const Divider(
                      thickness: 1,
                      indent: 28,
                      endIndent: 28,
                      color: Colors.grey),
                  SwitchListTile(
                    title: Row(
                      children: [
                        Icon(IconlyLight.notification,
                            color: isDarkMode ? Colors.white : Colors.black),
                        const SizedBox(width: 10),
                        Text(_translate('notifications'),
                            style: TextStyle(
                                color:
                                    isDarkMode ? Colors.white : Colors.black)),
                      ],
                    ),
                    value: isNotificationsOn,
                    onChanged: (bool value) {
                      setState(() {
                        isNotificationsOn = value;
                      });
                    },
                  ),
                  const Divider(
                      thickness: 1,
                      indent: 28,
                      endIndent: 28,
                      color: Colors.grey),
                  SwitchListTile(
                    title: Text(
                        isDarkMode
                            ? _translate('lightMode')
                            : _translate('darkMode'),
                        style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black)),
                    value: isDarkMode,
                    onChanged: _toggleDarkMode,
                    secondary: Icon(
                        isDarkMode
                            ? Icons.wb_sunny_outlined
                            : Icons.dark_mode_outlined,
                        color: isDarkMode ? Colors.yellow : Colors.black),
                  ),
                  const Divider(
                      thickness: 1,
                      indent: 28,
                      endIndent: 28,
                      color: Colors.grey),
                  ListTile(
                    leading: Icon(Icons.help_outline,
                        color: isDarkMode ? Colors.white : Colors.black),
                    title: Text(_translate('help'),
                        style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black)),
                    onTap: _openHelpBottomSheet,
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String gender = 'Male';
  File? _image;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    var response = await http.get(Uri.parse('http://localhost:3000/user/123'));
    var user = json.decode(response.body);
    setState(() {
      nameController.text = user['name'];
      ageController.text = user['age'].toString();
      emailController.text = user['email'];
      gender = user['gender'];
    });
  }

  Future<void> _updateUserData() async {
    var body = json.encode({
      'name': nameController.text,
      'age': int.parse(ageController.text),
      'email': emailController.text,
      'gender': gender,
    });

    await http.put(
      Uri.parse('http://localhost:3000/user/123'),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
  }

  Future<void> _uploadImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost:3000/upload'),
      );
      request.files
          .add(await http.MultipartFile.fromPath('image', _image!.path));
      await request.send();
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff674fff), Color(0xff9775dc)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Account',
            style: TextStyle(color: Colors.white, fontSize: 24)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: () {
              _updateUserData();
            },
          ),
        ],
      ),
      body: Stack(children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xff674fff),
              Color(0xff9775dc),
            ]),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: _uploadImage,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[300],
                          backgroundImage:
                              _image != null ? FileImage(_image!) : null,
                          child: _image == null
                              ? Icon(Icons.person,
                                  size: 50, color: Colors.grey[500])
                              : null,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 42,
                        width: 130,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.black.withOpacity(0.2),
                        ),
                        child: TextButton(
                          onPressed: _uploadImage,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          child: const Text('Upload Image',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              )),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40)),
                      color: Colors.white,
                    ),
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 23,
                            ),
                            _buildAccountItem('Name', nameController),
                            _buildGenderSelector(),
                            _buildAccountItem('Age', ageController),
                            _buildAccountItem('Email', emailController),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildAccountItem(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            labelText: title,
            labelStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Gender',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Row(
            children: [
              const Text('Male'),
              Radio<String>(
                value: 'Male',
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value!;
                  });
                },
              ),
              const Text('Female'),
              Radio<String>(
                value: 'Female',
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value!;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _logout(BuildContext context) async {
  // Clear shared preferences (assuming token is stored here)
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.clear();
  await prefs.remove('token'); // Remove the token
  await prefs.remove('stayLoggedIn');
  // Remove the scan history
  await prefs.remove('scanHistory');

  // Navigate to the login screen
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) =>
          const LoginScreen(), // Replace IndexPage with your target page
    ),
  );
}
