// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_element

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/auth/authservice.dart';
import 'package:my_app/auth/widgets/reset_password.dart';
import 'package:my_app/extensions/media_query.dart';
import 'package:my_app/screens/homepage.dart';
import 'package:get/get.dart';

import '../widgets/appColors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = context.deviceWidth;
    final double deviceHeight = context.deviceHeight;

    final double appBarHeight = deviceWidth * 0.28;

    // AuthController'ı kullan
    final AuthService _authService = Get.put(AuthService());

    @override
    void dispose() {
      _authService.passwordController.dispose();
      _authService.emailController.dispose();
      super.dispose();
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const Homepage(),
            )),
            icon: const Icon(Icons.arrow_back_ios_sharp),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: true,
          elevation: 0,
          title: Image.asset(
            'lib/assets/logo.png',
          ),
          centerTitle: true,
          backgroundColor: AppColors.defaultColor,
        ),
      ),
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        color: AppColors.defaultColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: deviceHeight / 14,
                  ),
                  Text(
                    'Log in',
                    style: GoogleFonts.zillaSlab(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  TextFormField(
                    controller: Get.find<AuthService>().emailController,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: 'Email',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 3,
                        ),
                      ),
                      labelStyle: TextStyle(
                        color: AppColors.defaultColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Obx(() => TextFormField(
                        controller: Get.find<AuthService>().passwordController,
                        obscureText: _authService.isObscure.value,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: 'Password',
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 3,
                            ),
                          ),
                          labelStyle: const TextStyle(
                            color: AppColors.defaultColor,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _authService.isObscure.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              _authService.togglePasswordVisibility();
                            },
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton.icon(
                    icon: Image.asset(
                      'lib/assets/log-in.png',
                      height: 32,
                      width: 32,
                    ),
                    onPressed: () => Get.find<AuthService>().signInWithEmail(
                        email: Get.find<AuthService>().emailController.text,
                        password:
                            Get.find<AuthService>().passwordController.text),
                    style: ElevatedButton.styleFrom(
                        elevation: 9,
                        minimumSize: const Size(369.1, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                    label: Text('Log In',
                        style: GoogleFonts.zillaSlab(
                            color: AppColors.defaultColor,
                            fontSize: 30,
                            fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextButton(
                    onPressed: () => showResetPasswordBottomSheet(context),
                    child: const Text(
                      'Forgot Password',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
