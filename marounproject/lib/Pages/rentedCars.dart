import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RentedCarsUI extends StatefulWidget {
  const RentedCarsUI({Key? key}) : super(key: key);

  @override
  _RentedCarsUIState createState() => _RentedCarsUIState();
}

class _RentedCarsUIState extends State<RentedCarsUI> {
  List<Map<String, dynamic>> rentedCars = [];

  Future<void> getRentedCars() async {
    const EndPoint = "https://maroun99.000webhostapp.com/getRentedCars.php";

    try {
      final response = await http.post(
        Uri.parse(EndPoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'id': '1'}), // Replace with the actual user ID
      );

      if (response.statusCode == 200) {
        List<Map<String, dynamic>> rentedCars =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        setState(() {
          this.rentedCars = rentedCars;
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    getRentedCars();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Rented Cars',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://th.bing.com/th/id/R.758402e11419a6f7bafd220518b93417?rik=wlQ4W9kWT%2frRIQ&pid=ImgRaw&r=0',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: rentedCars.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.black.withOpacity(0.7),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildText(
                        'Car Name: ${rentedCars[index]['name']}',
                        16,
                      ),
                      _buildText(
                        'Car Model: ${rentedCars[index]['model']}',
                        16,
                      ),
                      _buildText(
                        'Start Date: ${rentedCars[index]['start']}',
                        16,
                      ),
                      _buildText(
                        'End Date: ${rentedCars[index]['end']}',
                        16,
                      ),
                      _buildText(
                        'Total Price: \$${rentedCars[index]['TotalPrice']}',
                        20,
                      ),
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

  Widget _buildText(String text, double fontSize) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          shadows: [
            Shadow(
              blurRadius: 2.0,
              color: Colors.black,
              offset: Offset(1.0, 1.0),
            ),
          ],
        ),
      ),
    );
  }
}
