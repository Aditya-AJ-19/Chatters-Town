import 'dart:async';
import 'package:chatters_town/App%20Themes/theme.dart';
import 'package:chatters_town/Screens/Authentication/Controller/auth_controller.dart';
import 'package:chatters_town/Screens/main_home_screen.dart';
import 'package:chatters_town/Screens/welcome_screen.dart';
import 'package:chatters_town/router.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'Utlis/size_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatters Town',
      debugShowCheckedModeBanner: false,
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      themeMode: ThemeMode.system,
      onGenerateRoute: (settings) => generateRoute(settings),
      home: Builder(builder: (BuildContext context) {
        SizeConfig().init(context);
        return const ScreenSetter();
      }),
    );
  }
}

class ScreenSetter extends ConsumerStatefulWidget {
  const ScreenSetter({super.key});

  @override
  ConsumerState<ScreenSetter> createState() => _ScreenSetterState();
}

class _ScreenSetterState extends ConsumerState<ScreenSetter>
    with WidgetsBindingObserver {
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    getConnectivity();
    super.initState();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          // debugPrint("Connection 2 = $isDeviceConnected");
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() {
              isAlertSet = true;
            });
          }
        },
      );

  @override
  void dispose() {
    subscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser != null
        ? const MainHomeScreen()
        : const WelcomeScreen();
  }

  showDialogBox() => showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("No Connection"),
          content: const Text("Please check your Internet connection!"),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                isAlertSet = false;
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected) {
                  showDialogBox();
                  isAlertSet = true;
                }
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
}
