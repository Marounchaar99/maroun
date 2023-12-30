import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:marounproject/encrypt.dart';

class RentUI extends StatefulWidget {
  final Map<String, dynamic> car;

  const RentUI({super.key, required this.car});

  @override
  State<RentUI> createState() => _RentUIState();
}

class _RentUIState extends State<RentUI> {
  late DateTime startDate;
  late DateTime endDate;
  bool validate = false;
  int numberOfDays = 0;
  int totalPrice = 0;

  Future<void> _selectStartDate(BuildContext context) async {
    DateTime? pickedStartDate = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (pickedStartDate != null && pickedStartDate != startDate) {
      setState(() {
        startDate = pickedStartDate;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    DateTime? pickedEndDate = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: startDate,
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (pickedEndDate != null && pickedEndDate != endDate) {
      setState(() {
        endDate = pickedEndDate;
        Duration difference = endDate.difference(startDate);
        numberOfDays = difference.inDays;
        totalPrice = numberOfDays * int.parse(widget.car['rentingPrice']);
        validate = true;
      });
    }
  }

  Future<void> rent(
      String start, String end, int total, int Cid) async {
    const url = 'https://maroun99.000webhostapp.com/rent.php';
    String key = await encryptedData.getString('key');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'start': start,
          'end': end,
          'Uid': key,
          'Cid': Cid,
          'total': total,
        }),
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print(response.body);
      } else {
        print('Failed to rent. Error code: ${response.statusCode}');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    startDate = DateTime.now();
    endDate = DateTime.now().add(Duration(days: 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.car['model']} ${widget.car['name']}',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.black,
          ),
          width: MediaQuery.of(context).size.width * 80 / 100,
          height: MediaQuery.of(context).size.height * 50 / 100,
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => _selectStartDate(context),
                      child: Text(
                        'Select Start Date',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => _selectEndDate(context),
                      child: Text(
                        'Select End Date',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Start Date: ${DateFormat('MMM dd, yyyy').format(startDate)}',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'End Date: ${DateFormat('MMM dd, yyyy').format(endDate)}',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  Text(
                    'Total Price:\$ $totalPrice',
                    style: TextStyle(color: Colors.white),
                  ),
                  !validate
                      ? Text(
                          'You Must Select The Dates Before Renting',
                          style: TextStyle(color: Colors.red),
                        )
                      : Center(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (validate) {
                      var response = rent(startDate.toString(), endDate.toString(), totalPrice, int.parse(widget.car['id']));
                    } else {

                    }
                  },
                  child: Text(
                    'Rent',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
