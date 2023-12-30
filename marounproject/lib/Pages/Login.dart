import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:marounproject/Pages/Home.dart';
import 'package:marounproject/Pages/Register.dart';
import 'package:http/http.dart' as http;
import 'package:marounproject/encrypt.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String error = '';
  final _formKey = GlobalKey<FormState>();

  Future<int> login(String email,String password) async {
    const phpEndPoint = "https://maroun99.000webhostapp.com/login.php";

    try {
      final response = await http.post(
        Uri.parse(phpEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        // Successful login
        Map<String, dynamic> userData = json.decode(response.body);
        print(userData);
        await encryptedData.setString('key', userData['id']);
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://th.bing.com/th/id/R.6517f13afad72523ba090c9d425eaeb2?rik=Nbgq%2bdIeLZYBsg&pid=ImgRaw&r=0'), // Replace with your image asset
              fit: BoxFit.cover, // Adjust the fit as needed
            ),
          ),
        child: Center(
          child: Opacity(
            opacity: 0.85,
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width / 1.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.black,
              ),
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
            
            
                    //Email Input Start
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Email';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _passwordController,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                    ),
                    error != ''
                        ? Text(
                            error,
                            style: TextStyle(color: Colors.red),
                          )
                        : Center(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            String email = _emailController.text;
                            String password = _passwordController.text;
            
                            var response = await login(email, password);
                            print(response);
                            if(response == 200){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder)=>Home()));
                            }
                            else if(response == 400){
                              setState(() {
                                error = 'Email Not found Try To Register.';
                              });
                            }
                            else{
                              setState(() {
                                error = 'Try Again Later!';
                              });
                            }
            
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          textStyle: const TextStyle(color: Colors.black),
                        ),
                        child: const Text('Login'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have and account?",
                style: TextStyle(color: Colors.white)),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (builder) => RegisterUI()));
              },
              child: Text(
                'Register',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
