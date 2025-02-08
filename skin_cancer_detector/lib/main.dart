import 'package:my_tflit_app/Chat/chatapp.dart';
import 'package:my_tflit_app/Dashboard.dart';
import 'package:my_tflit_app/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:my_tflit_app/widget/plant_recogniser.dart';
import 'Auth/Signup.dart';
import 'home1.dart';
import 'divider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Splash_Screen.dart';
import 'package:my_tflit_app/Controller/language_change_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key, });
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LanguageChangeController()),
        ],
        child: Consumer<LanguageChangeController>(
            builder: (context, provider, child) {
        
          return MaterialApp(
           
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],

            supportedLocales: [Locale('en'), Locale('hi'), Locale('pa')],
            debugShowCheckedModeBanner: false,
            title: 'Plant Classification',
            theme: ThemeData(scaffoldBackgroundColor: Colors.white),
            initialRoute: Utils().login() ? '/dash' : '/',
            routes: {
              '/': (context) => WelcomeScreen(),
              '/plant': (context) =>
                  const MyHomePage(title: 'Flutter Demo Home Page'),
              '/disease': (context) => Recogniser(),
              '/chat': (context) => ChatApp(),
              '/dash': (context) => Dashboard(),
              '/signup': (context) => const Signup()
            },
            // home: Div()
            // home: const MyHomePage(title: 'Flutter Demo Home Page'),
          );
        }));
  }
}
