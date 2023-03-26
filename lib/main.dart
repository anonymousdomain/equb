import 'package:equb/provider/auth_state.dart';
import 'package:equb/utils/theme.dart';
import 'package:equb/screens/home.dart';
import 'package:equb/screens/onboarding_screen/onboarding.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    androidProvider: AndroidProvider.debug,
  );
  runApp(ChangeNotifierProvider(
    create: (_) => AuthState(),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            padding: EdgeInsets.all(10),
            onPressed: () {
              currentTheme.toggleTheme();
            },
            icon: currentTheme.currentTheme == ThemeMode.dark
                ? Icon(FeatherIcons.moon)
                : Icon(FeatherIcons.sun),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Consumer<AuthState>(
              builder: (context, auth, child) {
                if (auth.user == null ||
                    auth.status != AuthStatus.authenticated) {
                  return OnBoardingScreen();
                } else {
                  return Home();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
