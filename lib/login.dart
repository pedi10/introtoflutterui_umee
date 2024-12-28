// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_workshop/dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Conterollers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Remember Me Boolean
  bool isRememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('/login_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            logoImage(),
            const SizedBox(height: 20),
            loginCard(),
          ],
        ),
      ),
    );
  }

  /// --- MAIN WIDGETS --- ///

  // Logo Image
  Widget logoImage() {
    return Image.asset('/logo.png', height: 50);
  }

  // Login Card
  Widget loginCard() {
    return Card(
      color: Colors.white,
      elevation: 3,
      child: Container(
        //width: 400,
        width: (MediaQuery.of(context).size.width < 800)
            ? MediaQuery.of(context).size.width * 0.8
            : MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            welcomeTexts(),
            const SizedBox(height: 40),
            textFields(),
            const SizedBox(height: 10),
            rememberMeRow(),
            const SizedBox(height: 30),
            loginButton(),
            const SizedBox(height: 10),
            newAccButton(),
          ],
        ),
      ),
    );
  }

  /// --- LOGIN CARD WIDGETS --- ///

  // Welcome Texts
  Widget welcomeTexts() {
    return Column(
      children: [
        Text(
          'Welcome Back',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          'Sign in to access to your account',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  // Text Fields
  Widget textFields() {
    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: "Email",
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: "Password",
            filled: true,
            fillColor: Colors.grey[200],
          ),
          obscureText: true,
        ),
      ],
    );
  }

  // Remember Me and Forgot Password
  Widget rememberMeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
                value: isRememberMe,
                onChanged: (bool? value) {
                  setState(() {
                    isRememberMe = value!;
                  });
                }),
            Text('Remember Me'),
          ],
        ),
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Forgot Password Button Pressed!'),
                backgroundColor: Colors.blue,
              ),
            );
          },
          child: Text('Forgot Password?'),
        ),
      ],
    );
  }

  // Login Button
  Widget loginButton() {
    return Container(
      height: 40,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff0553B1),
        ),
        onPressed: () {
          loginLogic();
        },
        child: Text('Login', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  // New Account Button
  Widget newAccButton() {
    return TextButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('New Account Button Pressed!'),
            backgroundColor: Colors.blue,
          ),
        );
      },
      child: Text('Create New Account'),
    );
  }

  /// --- LOGICS --- ///

  // Login Logic
  void loginLogic() {
    String email = emailController.text;
    String password = passwordController.text;

    if (email == 'admin' && password == 'root') {
      // Succesfful Feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login Successful!'),
          backgroundColor: Colors.green,
        ),
      );
      // Navigate to the Dashboard Page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    } else {
      // Failed Feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login Failed!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
