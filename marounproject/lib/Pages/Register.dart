import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:marounproject/Pages/Login.dart';
import 'package:http/http.dart' as http;

class RegisterUI extends StatefulWidget {
  const RegisterUI({Key? key}) : super(key: key);

  @override
  State<RegisterUI> createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  String error = '';
  final _formKey = GlobalKey<FormState>();

  Future<int> register(String name,String email,String password) async {
    const phpEndPoint = "https://maroun99.000webhostapp.com/register.php";

    try {
      final response = await http.post(
        Uri.parse(phpEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'name': name,
          'password': password,
          'email': email,
        }),
      );

      print(response.body);
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
          'Register',
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
              height: MediaQuery.of(context).size.height / 2.4,
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        decoration: const InputDecoration(
                          hintText: 'Name',
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
                            return 'Please enter your Name';
                          }
                          return null;
                        },
                      ),
                    ),
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
                    //Email Input End
                    
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
                            String name = _nameController.text;
                    
                            var response = await register(name, email, password);
                    
                            if(response==200){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder)=>Login()));
                            }
                            else if(response==400){
                              setState(() {
                                error = 'Email Already Used Try Another one';
                              });
                            }else{
                    
                              setState(() {
                                error = 'Try Again Later';
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
            Text("Already have an account?",
                style: TextStyle(color: Colors.white)),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (builder) => Login()));
              },
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
