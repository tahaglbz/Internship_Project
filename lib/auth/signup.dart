import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:form_field_validator/form_field_validator.dart'; // Import form_field_validator
import 'package:my_app/auth/authservice.dart';
import 'package:my_app/screens/homepage.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _authService = Get.put(AuthService());

  @override
  void dispose() {
    _authService.emailController;
    _authService.passwordController;
    _authService.usernameController;
    _authService.passwordConfirmController;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    final double appBarHeight = deviceWidth * 0.28;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const Homepage(),
            )), // Add parentheses to pop function
            icon: const Icon(Icons.arrow_back_ios_sharp),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: true,
          elevation: 0,
          title: Image.asset(
            'lib/assets/logo.png',
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 0, 9, 99),
        ),
      ),
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        color: const Color.fromARGB(255, 0, 9, 99),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: deviceHeight / 95,
                  ),
                  Text(
                    'Sign Up',
                    style: GoogleFonts.zillaSlab(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  TextFormField(
                    controller: _authService.emailController,
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
                          color: Color.fromARGB(255, 8, 1, 134),
                        ),
                        errorStyle: TextStyle(color: Colors.white)),
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Email is required'),
                      EmailValidator(errorText: 'Invalid email address'),
                    ]).call,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    controller: _authService.usernameController,
                    decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Username',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 3,
                          ),
                        ),
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 8, 1, 134),
                        ),
                        errorStyle: TextStyle(color: Colors.white)),
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Username is required'),
                      MinLengthValidator(3,
                          errorText:
                              'Username must be at least 3 characters long'),
                    ]).call,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    controller: _authService.passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Password',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 3,
                          ),
                        ),
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 8, 1, 134),
                        ),
                        errorStyle: TextStyle(color: Colors.white)),
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Password is required'),
                      MinLengthValidator(6,
                          errorText:
                              'Password must be at least 6 characters long'),
                    ]).call,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    controller: _authService.passwordConfirmController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Password Confirm',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 3,
                          ),
                        ),
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 8, 1, 134),
                        ),
                        errorStyle: TextStyle(color: Colors.white)),
                    validator: (value) {
                      if (value != _authService.passwordController.text) {
                        return 'Passwords does not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton.icon(
                    icon: Image.asset(
                      'lib/assets/add-friend.png',
                      height: 32,
                      width: 32,
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _authService.signUp();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 9,
                        minimumSize: const Size(369.1, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                    label: Text('Sign Up',
                        style: GoogleFonts.zillaSlab(
                            color: const Color.fromARGB(255, 8, 1, 134),
                            fontSize: 30,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
