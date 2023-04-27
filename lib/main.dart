import 'dart:developer';

import 'package:equb/provider/auth_state.dart';
import 'package:equb/provider/conectivity.dart';
import 'package:equb/screens/user_profile.dart';
import 'package:equb/utils/theme.dart';
import 'package:equb/screens/home.dart';
import 'package:equb/screens/onboarding_screen/onboarding.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    androidProvider: AndroidProvider.debug,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthState()),
        ChangeNotifierProvider(create: (_) => Connection())
      ],
      child: Equb(),
    ),
  );
}

class Equb extends StatefulWidget {
  const Equb({super.key});

  @override
  State<Equb> createState() => EqubState();
}

class EqubState extends State<Equb> {
  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'equb',
      theme: CustomTheme.lightTheme(context),
      darkTheme: CustomTheme.darkTheme(context),
      themeMode: currentTheme.currentTheme,
      home: const MyHomePage(
        title: 'equb addis',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Center(
          child: Builder(
            builder: (context) {
              return StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.metadata.creationTime ==
                        snapshot.data!.metadata.lastSignInTime) {
                      return UserProifle();
                    } else {
                      return Home(); 
                    }
                  } else {
                    return OnBoardingScreen();
                  }
                },
              );
            },
          ),
        )
      ]),
      // body: Stack(
      //   children: [
      //     Center(
      //       child: Consumer<AuthState>(
      //         builder: (context, auth, child) {
      //           if (auth.user == null) {
      //             return OnBoardingScreen();
      //           } else if (auth.isNewUser) {
      //             return UserProifle();
      //           } else {
      //             return Home();
      //           }
      //         },
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
