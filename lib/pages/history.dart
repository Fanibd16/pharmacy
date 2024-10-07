// import 'package:paybirr/json/utility.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy/json/utility.dart';

class Hcard extends StatefulWidget {
  const Hcard({Key? key}) : super(key: key);

  @override
  // const Hcard({super.key});

  @override
  State<Hcard> createState() => _HcardState();
}

class _HcardState extends State<Hcard> {
  // const Hcard({super.key});
  final List<Map<String, dynamic>> _allUsers = usersList();

  // This list holds the data for the list view
  List<Map<String, dynamic>> _foundUsers = [];

  @override
  initState() {
    _foundUsers = _allUsers;
    super.initState();
  }

  // This function is called whenever the text field changes

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        // height: BouncingScrollSimulation.maxSpringTransferVelocity,
        child: ListView.builder(
            itemCount: _foundUsers.length,
            itemBuilder: (context, index) {
              final userName = _foundUsers[index]['name'];
              final userId = _foundUsers[index]['id'];
              final dorm = _foundUsers[index]['dorm'];
              final block = _foundUsers[index]['block'];
              final bd = 'Block : ' '$block' ' | ' 'Dorm : ' '$dorm';
              return Card(
                key: ValueKey(_foundUsers[index]["id"]),
                // color: Color.fromARGB(255, 240, 236, 236),
                elevation: 1,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  // leading: Text(
                  //   _foundUsers[index]["no"].toString(),
                  //   style: const TextStyle(
                  //       // fontSize: 24, color: Colors.white
                  //       ),
                  // ),
                  title: Text(userId,
                      style: const TextStyle(
                          // color: Colors.white,
                          fontSize: 16)),
                  subtitle: Text(userName,
                      style: const TextStyle(
                          // color: Colors.white,
                          fontSize: 16)),
                  // subtitle: Text(
                  //     '${_foundUsers[index]["age"].toString()} years old',
                  //     style: const TextStyle(color: Colors.white)),

                  trailing: Text(bd,
                      style: const TextStyle(
                          // color: Colors.white,
                          fontSize: 16)),
                ),
              );
            }),
      ),
    );
  }
}
