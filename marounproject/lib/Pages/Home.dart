import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marounproject/Pages/RentUI.dart';
import 'package:marounproject/Pages/rentedCars.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> cars = [];

  Future<void> getCars() async {
    const EndPoint = "https://maroun99.000webhostapp.com/getCars.php";

    try {
      final response = await http.post(
        Uri.parse(EndPoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print(
          "#######################################################################${response.body}");
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> cars =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        setState(() {
          this.cars = cars;
        });
        print(cars);
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (error) {
      print(error);
    }
  }



  @override
  void initState() {
    getCars();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>RentedCarsUI()));
            },
            icon: Icon(Icons.person,color: Colors.white,),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://th.bing.com/th/id/R.758402e11419a6f7bafd220518b93417?rik=wlQ4W9kWT%2frRIQ&pid=ImgRaw&r=0'), // Replace with your image asset
              fit: BoxFit.cover, // Adjust the fit as needed
            ),
          ),
        child: ListView.builder(
          itemCount: cars.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Car Name: ${cars[index]['name']}',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Car Model: ${cars[index]['model']}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Car Year: ${cars[index]['year']}',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Car Renting Price: \$${cars[index]['rentingPrice']}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>RentUI(car: cars[index])));

                        },
                        icon: Icon(
                          Icons.car_rental,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
