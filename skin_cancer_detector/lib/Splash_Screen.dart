// import 'package:flutter/material.dart';
// import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'package:page_transition/page_transition.dart';
// import 'main.dart';

// class Splash extends StatelessWidget {

//   const Splash({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Vrikshveda',
//         home: AnimatedSplashScreen(
//             // disableNavigation: true,
//             splashIconSize: 200,
//             // centered: false,
//             duration: 3000,
//             splash: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Image.asset(
//                   'assets/icon.png',
//                   width: 100,
//                 ),
//                 const Text(
//                   "Skin Cancer Detection",
//                   style: TextStyle(
//                       fontSize: 70,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontStyle: FontStyle.italic),
//                 ),
//                 const Text(
//                   "Abstinence is better than cure",
//                   style: TextStyle(color: Colors.white, fontSize: 15),
//                 )
//               ],
//             ),
//             nextScreen: MyApp(),
//             splashTransition: SplashTransition.slideTransition,
//             pageTransitionType: PageTransitionType.topToBottom,
//             backgroundColor: const Color(0xFF4C53A5)));
//   }
// }
