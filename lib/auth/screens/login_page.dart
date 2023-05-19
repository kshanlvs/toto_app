import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:toto_app/auth/services/google_sign_in_provider.dart';
import 'package:toto_app/todo/screens/todo_screen.dart';
import 'package:toto_app/todo/services/todo_list_provider.dart';

import '../../widgets/loder.dart';

class GoogleLoginPage extends StatefulWidget {
  const GoogleLoginPage({Key? key}) : super(key: key);

  @override
  State<GoogleLoginPage> createState() => _GoogleLoginPageState();
}

class _GoogleLoginPageState extends State<GoogleLoginPage> {
  @override
  void initState() {
    context.read<GoogleSignInProvider>().isUserSignedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/todo_image.jpg",
                height: 200,
                width: 200,
              ),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: SignInButton(
                    elevation: 5,
                    padding: const EdgeInsets.all(10),
                    Buttons.GoogleDark,
                    onPressed: () async {
                      OrangeLoaderOverlay.show(context);

                      final userEmail = await context
                          .read<GoogleSignInProvider>()
                          .handleGoogleLogin();
                      if (userEmail!=null) {
                        OrangeLoaderOverlay.hide();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ChangeNotifierProvider(
                                child:  TodoPage(userEmail: userEmail,),
                                create: (context) {
                                  return TodoListCrudProvider();
                                },
                              );
                            },
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Successfully logged in"),
                          ),
                        );
                      } else {
                        OrangeLoaderOverlay.hide();
                      }
                    },
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
