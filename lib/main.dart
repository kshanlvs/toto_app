import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:toto_app/auth/services/google_sign_in_provider.dart';
import 'package:toto_app/firebase_options.dart';

import 'auth/screens/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final MaterialColor myCustomColor = MaterialColor(
      0xFFE65100, // Replace with your desired color value
      <int, Color>{
        50: Color(0xFFFFF3E0),
        100: Color(0xFFFFE0B2),
        200: Color(0xFFFFCC80),
        300: Color(0xFFFFB74D),
        400: Color(0xFFFFA726),
        500: Color(0xFFc56358), // This is the primary color
        600: Color(0xFFFB8C00),
        700: Color(0xFFF57C00),
        800: Color(0xFFEF6C00),
        900: Color(0xFFE65100),
      },
    );

    return MultiProvider(
      providers: provider,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: myCustomColor,
          ),
          home: ChangeNotifierProvider(
            child: const GoogleLoginPage(),
            create: (context) {
              return GoogleSignInProvider();
            },
          )),
    );
  }

  List<SingleChildWidget> provider = [
    ChangeNotifierProvider(
      create: (context) {
        return GoogleSignInProvider();
      },
    )
  ];
}
