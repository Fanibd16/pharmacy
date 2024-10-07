import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class Hcard extends StatelessWidget {
  const Hcard({super.key});

  // const Hcard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: ClickableCard(
              key: UniqueKey(),
              title: 'Tadese Pharmacy',
              subtitle: '200 m',
              prefixImage: const AssetImage('assets/store.png'),
              suffixIcon: IconlyLight.bookmark,
              onPressed: () {
                // Add your onPressed logic here
                // print('Card clicked');
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ClickableCard(
              key: UniqueKey(),
              title: 'Eyasta pharmacy',
              subtitle: '1 km',
              prefixImage: const AssetImage('assets/store.png'),
              suffixIcon: IconlyLight.bookmark,
              onPressed: () {
                // Add your onPressed logic here
                // print('Card clicked');
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ClickableCard(
              key: UniqueKey(),
              title: 'Beza pharmacy',
              subtitle: '500 m',
              prefixImage:
                  // const AssetImage('assets/icons/pharmacy.png'),
                  const AssetImage('assets/store.png'),
              suffixIcon: IconlyLight.bookmark,
              onPressed: () {
                // Add your onPressed logic here
                // print('Card clicked');
              },
            ),
          ),
          // Center(
          //   child: ClickableCard(
          //     key: UniqueKey(),
          //     title: 'Title',
          //     subtitle: 'Subtitle',
          //     prefixImage: const AssetImage('assets/img/dev.png'),
          //     suffixIcon: IconlyLight.arrow_right_2,
          //     onPressed: () {
          //       // Add your onPressed logic here
          //       print('Card clicked');
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

class ClickableCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final ImageProvider prefixImage;
  final IconData suffixIcon;
  final VoidCallback onPressed;

  const ClickableCard({
    required Key key,
    required this.title,
    required this.subtitle,
    required this.prefixImage,
    required this.suffixIcon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(46, 0, 0, 0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onPressed,
        splashColor: const Color(0xff674fff)
            .withOpacity(0.3), // Customize the ripple color
        borderRadius: BorderRadius.circular(12.0), // Set the border radius
        splashFactory: InkRipple.splashFactory,
        child: ListTile(
          leading: Image(
            height: 40,
            image: prefixImage,
            // color: Colors.black,
            // backgroundColor: Colors.transparent,
            // backgroundImage: prefixImage,
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(color: Color(0xff674fff)),
          ),
          trailing: Icon(
            suffixIcon,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
