// import 'package:e_wallet/indexpage.dart';
// import 'package:e_wallet/pages/homepage.dart';
// import 'package:flutter/material.dart';
// // import 'package:flutter/rendering.dart';
// import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

// const double _bottomPaddingForButton = 150.0;
// const double _buttonHeight = 56.0;
// // const double _buttonWidth = 200.0;
// const double _pagePadding = 16.0;
// const double _heroImageHeight = 250.0;

// class SendMoney extends StatefulWidget {
//   const SendMoney({Key? key}) : super(key: key);

//   @override
//   State<SendMoney> createState() => _SendMoneyState();
// }

// class _SendMoneyState extends State<SendMoney> {
//   late ValueNotifier<int> pageIndexNotifier;

//   @override
//   void initState() {
//     super.initState();
//     pageIndexNotifier = ValueNotifier(0);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       WoltModalSheet.show<void>(
//         pageIndexNotifier: pageIndexNotifier,
//         context: context,
//         pageListBuilder: (modalSheetContext) {
//           final textTheme = Theme.of(context).textTheme;
//           return [
//             page1(modalSheetContext, textTheme),
//             page2(modalSheetContext, textTheme),
//           ];
//         },
//         modalTypeBuilder: (context) => WoltModalType.bottomSheet,
//         onModalDismissedWithBarrierTap: () {
//           Navigator.of(context).pop();
//           pageIndexNotifier.value = 0;
//         },
//         maxDialogWidth: 560,
//         minDialogWidth: 400,
//         minPageHeight: 0.0,
//         maxPageHeight: 0.9,
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }

//   SliverWoltModalSheetPage page1(
//       BuildContext modalSheetContext, TextTheme? textTheme) {
//     return WoltModalSheetPage(
//       hasSabGradient: false,
//       stickyActionBar: Padding(
//         padding: const EdgeInsets.all(_pagePadding),
//         child: Column(
//           children: [
//             //Cancel
//             ElevatedButton(
//               // onPressed: () => Navigator.of(modalSheetContext).pop(),
//               onPressed: () => Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const MyApp()),
//               ),
//               child: const SizedBox(
//                 height: _buttonHeight,
//                 width: double.infinity,
//                 child: Center(child: Text('Cancel')),
//               ),
//             ),
//             const SizedBox(height: 8),
//             //Next Page
//             ElevatedButton(
//               onPressed: () =>
//                   pageIndexNotifier.value = pageIndexNotifier.value + 1,
//               child: const SizedBox(
//                 height: _buttonHeight,
//                 width: double.infinity,
//                 child: Center(child: Text('Next page')),
//               ),
//             ),
//           ],
//         ),
//       ),
//       topBarTitle: Text('Pagination', style: textTheme!.titleLarge),
//       isTopBarLayerAlwaysVisible: true,
//       trailingNavBarWidget: IconButton(
//         padding: const EdgeInsets.all(_pagePadding),
//         icon: const Icon(Icons.close),
//         onPressed: () => Navigator.of(modalSheetContext).pop(),
//       ),
//       child: const Padding(
//         padding: EdgeInsets.fromLTRB(
//           _pagePadding,
//           _pagePadding,
//           _pagePadding,
//           _bottomPaddingForButton,
//         ),
//         child: Text(
//           '''
// Pagination involves a sequence of screens the user navigates sequentially. We chose a lateral motion for these transitions. When proceeding forward, the next screen emerges from the right; moving backward, the screen reverts to its original position. We felt that sliding the next screen entirely from the right could be overly distracting. As a result, we decided to move and fade in the next page using 30% of the modal side.
// ''',
//           style: TextStyle(fontSize: 16),
//         ),
//       ),
//     );
//   }

//   SliverWoltModalSheetPage page2(
//       BuildContext modalSheetContext, TextTheme? textTheme) {
//     return SliverWoltModalSheetPage(
//       pageTitle: Padding(
//         padding: const EdgeInsets.all(_pagePadding),
//         child: Text(
//           'Material Colors',
//           style: textTheme!.titleLarge!.copyWith(fontWeight: FontWeight.bold),
//         ),
//       ),
//       heroImage: const Image(
//         image: AssetImage('assets/img/dev.png'),
//         fit: BoxFit.cover,
//         height: _heroImageHeight,
//       ),
//       leadingNavBarWidget: IconButton(
//         padding: const EdgeInsets.all(_pagePadding),
//         icon: const Icon(Icons.arrow_back_rounded),
//         onPressed: () => pageIndexNotifier.value = pageIndexNotifier.value - 1,
//       ),
//       trailingNavBarWidget: IconButton(
//         padding: const EdgeInsets.all(_pagePadding),
//         icon: const Icon(Icons.close),
//         onPressed: () {
//           Navigator.of(modalSheetContext).pop();
//           pageIndexNotifier.value = 0;
//         },
//       ),
//       mainContentSlivers: [
//         SliverPadding(
//           padding: const EdgeInsets.all(_pagePadding),
//           sliver: SliverToBoxAdapter(
//             child: TextButton(
//               onPressed: Navigator.of(modalSheetContext).pop,
//               child: const Text('Close'),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';

class BottomModal extends StatefulWidget {
  const BottomModal({Key? key}) : super(key: key);

  // const BottomModal({super.key});

  @override
  _BottomModalState createState() => _BottomModalState();
}

class _BottomModalState extends State<BottomModal> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.5,
      child: _pageIndex == 0 ? page1() : page2(),
    );
  }

  Widget page1() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        Expanded(
          child: Column(
            children: [
              const Row(
                children: [
                  Text(
                    'SEND OPTIONS',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _pageIndex = 1;
                  });
                },
                splashColor: const Color(0xff674fff).withOpacity(0.2),
                splashFactory: InkRipple.splashFactory,
                highlightColor: Colors.transparent,
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      15.0), // Custom border radius for InkWell
                ),
                child: Container(
                  height: 80,
                  margin: const EdgeInsets.only(top: 10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xff674fff)),
                      borderRadius: BorderRadius.circular(15)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Icon(IconlyBold.wallet,
                            size: 40, color: Color(0xff674fff)),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          'Send to hab wallet',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      ]),

                      Icon(
                        IconlyBold.arrow_right_2,
                        size: 40,
                        color: Color(0xffb8f53d),
                      ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(50),
                      //       border: Border.all(color: Colors.grey)),
                      //   height: 26,
                      //   width: 26,
                      // )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _pageIndex = 1;
                  });
                },
                splashColor: const Color(0xff674fff).withOpacity(0.2),
                splashFactory: InkRipple.splashFactory,
                highlightColor: Colors.transparent,
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      15.0), // Custom border radius for InkWell
                ),
                child: Container(
                  height: 80,
                  margin: const EdgeInsets.only(top: 10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xff674fff)),
                      borderRadius: BorderRadius.circular(15)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Icon(CupertinoIcons.creditcard_fill,
                            size: 40, color: Color(0xff674fff)),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          'Send to other wallet',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      ]),

                      Icon(
                        IconlyBold.arrow_right_2,
                        size: 40,
                        color: Color(0xffb8f53d),
                      ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(50),
                      //       border: Border.all(color: Colors.grey)),
                      //   height: 26,
                      //   width: 26,
                      // )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _pageIndex = 1;
                  });
                },
                splashColor: const Color(0xff674fff).withOpacity(0.2),
                splashFactory: InkRipple.splashFactory,
                highlightColor: Colors.transparent,
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      15.0), // Custom border radius for InkWell
                ),
                child: Container(
                  height: 80,
                  margin: const EdgeInsets.only(top: 10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xff674fff)),
                      borderRadius: BorderRadius.circular(15)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Icon(CupertinoIcons.building_2_fill,
                            size: 40, color: Color(0xff674fff)),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          'Send to bank',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      ]),

                      Icon(
                        IconlyBold.arrow_right_2,
                        size: 40,
                        color: Color(0xffb8f53d),
                      ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(50),
                      //       border: Border.all(color: Colors.grey)),
                      //   height: 26,
                      //   width: 26,
                      // )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget page2() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _pageIndex = 0;
                    });
                  },
                ),
                // IconButton(
                //   icon: const Icon(Icons.arrow_forward),
                //   onPressed: () {
                //     // Handle next button functionality
                //   },
                // ),
              ],
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Form(
                    child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10)
                      ],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                        filled:
                            true, // Fill the input field with a background color
                        fillColor: Color.fromARGB(255, 237, 237,
                            237), // Background color of the input field
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey), // Border color when enabled
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff674fff)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Colors.red), // Border color when error occurs
                        ),
                        errorStyle: TextStyle(color: Colors.red),

                        hintText: "Recivers Phone number",
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Icon(IconlyBroken.wallet),
                        ),
                      ),
                    )
                  ],
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
