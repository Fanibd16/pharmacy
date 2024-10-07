// import 'package:paybirr/utility/sendmoney.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:pharmacy/utility/sendmoney.dart';

class SmallCard extends StatelessWidget {
  const SmallCard({Key? key}) : super(key: key);

  // const SmallCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return const BottomModal();
                },
              );
            },
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(18)),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    IconlyBold.send,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const Text(
                  'Send',
                  style: TextStyle(color: Colors.white38),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return const BottomModal();
                },
              );
            },
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(18)),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    IconlyBold.arrow_down_square,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const Text(
                  'Requist',
                  style: TextStyle(color: Colors.white38),
                )
              ],
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return const BottomModal();
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(18)),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    IconlyBold.arrow_up_square,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              const Text(
                'Pay',
                style: TextStyle(color: Colors.white38),
              )
            ],
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return const BottomModal();
                },
              );
            },
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(18)),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    IconlyBold.document,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const Text(
                  'Bill',
                  style: TextStyle(color: Colors.white38),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return const BottomModal();
                },
              );
            },
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(18)),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    IconlyBold.document,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const Text(
                  'Bill',
                  style: TextStyle(color: Colors.white38),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
