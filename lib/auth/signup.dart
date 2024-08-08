import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/auth/login.dart';
import 'package:my_app/screens/homepage.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCont = TextEditingController();
  final TextEditingController _passwordCont = TextEditingController();
  final TextEditingController _passConfCont = TextEditingController();
  final TextEditingController _usernameCont = TextEditingController();

  @override
  void dispose() {
    _emailCont.dispose();
    _passwordCont.dispose();
    _passConfCont.dispose();
    _usernameCont.dispose();
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
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromARGB(255, 5, 9, 237),
                  Color.fromARGB(255, 8, 1, 134),
                  Color.fromARGB(255, 5, 0, 74),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft, // Same direction as the AppBar
            end: Alignment.centerRight,
            colors: [
              Color.fromARGB(255, 5, 9, 237),
              Color.fromARGB(255, 8, 1, 134),
              Color.fromARGB(255, 5, 0, 74),
            ],
          ),
        ),
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
                    height: deviceHeight / 48,
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
                    height: 60,
                  ),
                  TextFormField(
                    controller: _emailCont,
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
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    controller: _usernameCont,
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
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    controller: _passwordCont,
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
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    controller: _passConfCont,
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
                    ),
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
                    onPressed: () =>
                        Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return const LoginPage();
                      },
                    )),
                    style: ElevatedButton.styleFrom(
                        elevation: 9,
                        shadowColor: Colors.white,
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
