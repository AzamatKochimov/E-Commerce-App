import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:learn_http/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    var response = await http.post(
      Uri.parse('https://dummyjson.com/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': _usernameController.text,
        'password': _passwordController.text,
      }),
    );

    Navigator.pop(context);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var box = Hive.box('authBox');
      box.put('token', data['token']);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to login. Please try again!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.amberAccent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  buildCustomText("Log in /", " Sign Up", 18, 28),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.amber),
                  foregroundColor: MaterialStateProperty.all(Colors.black),
                  fixedSize: MaterialStateProperty.all(const Size(120, 30)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                onPressed: () => login(context),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCustomText(
    String logIn,
    String signUp,
    double logInSize,
    double signUpSize,
  ) =>
      Text.rich(
        TextSpan(
          text: logIn,
          children: [
            TextSpan(
              text: signUp,
              style: TextStyle(
                fontSize: logInSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          style: TextStyle(
            fontSize: signUpSize,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
}
