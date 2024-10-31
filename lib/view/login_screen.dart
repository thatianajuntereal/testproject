import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_project/utils/constants.dart';
import 'package:test_project/utils/global_button.dart';
import 'package:test_project/utils/otp_dialog.dart';
import 'package:test_project/view/loading_screen.dart';
import 'package:test_project/view/social_media_screen.dart';
import 'package:test_project/view_model/login_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController userNameController = TextEditingController();
  bool isButtonEnabled = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    userNameController.addListener(buttonState);
  }

  @override
  void dispose() {
    userNameController.dispose();
    super.dispose();
  }

  void buttonState() {
    final userName = userNameController.text;
    if (specialCharactersChecker(userName)) {
      setState(() {
        errorMessage = "Values must be alphanumeric";
        isButtonEnabled = false;
      });
    } else if (userName.length > 24) {
      setState(() {
        errorMessage = "Must not exceed 24 characters";
        isButtonEnabled = false;
      });
    } else if (userName.isEmpty) {
      setState(() {
        errorMessage = "Please enter your username";
        isButtonEnabled = false;
      });
    } else {
      setState(() {
        errorMessage = null;
        isButtonEnabled = userName.isNotEmpty;
      });
    }
  }

  bool specialCharactersChecker(String input) {
    final RegExp specialCharacterRegex = RegExp(r'[!@#\$%^&*(),.?":{}|<>_~`]');
    return specialCharacterRegex.hasMatch(input);
  }

  void showStatusDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            message.contains("Successful") ? "Success" : "Error",
            textAlign: TextAlign.center,
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                child: const Text(
                  "Close",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<LoginViewModel>(
          builder: (context, model, child) {
            if (model.statusMessage == "Login Successful") {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const SocialScreen()),
                );
              });
            } else if (model.statusMessage.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showStatusDialog(model.statusMessage);
              });
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 160,
                    width: 220,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 30,
                          left: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            height: 80,
                            width: 80,
                            alignment: Alignment.center,
                            child: Image.asset(
                              AppImages.youtube,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 60,
                          left: 65,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            height: 80,
                            width: 80,
                            alignment: Alignment.center,
                            child: Image.asset(
                              AppImages.spotify,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 80,
                          left: 135,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            height: 80,
                            width: 80,
                            alignment: Alignment.center,
                            child: Image.asset(
                              AppImages.facebook,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 90.0),
                  TextField(
                    textAlign: TextAlign.center,
                    controller: userNameController,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              errorMessage == null ? Colors.blue : Colors.red,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              errorMessage == null ? Colors.grey : Colors.red,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (errorMessage != null)
                    Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 10),
                  GlobalButton(
                    onPressed:
                        isButtonEnabled ? () => showOtpDialog(context) : () {},
                    text: 'Enter',
                    isActive: isButtonEnabled,
                    backgroundColor:
                        isButtonEnabled ? Colors.green : Colors.grey,
                    textColor: isButtonEnabled ? Colors.white : Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  if (model.isLoading) const CircularProgressIndicator(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void showOtpDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return OTPDialog(
          onEnter: (String otp) {
            Navigator.of(context).pop();
            if (otp == "123123" || otp == "123456") {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoadingScreen(),
                ),
              );
              Provider.of<LoginViewModel>(context, listen: false)
                  .login(userNameController.text, otp);
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    title: const Text(
                      "Error",
                      textAlign: TextAlign.center,
                    ),
                    content: const Text(
                      "The OTP you entered is incorrect. Please try again.",
                      textAlign: TextAlign.center,
                    ),
                    actions: <Widget>[
                      Center(
                        child: TextButton(
                          child: const Text(
                            "Close",
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          },
          onClose: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
