import 'package:flutter/material.dart';
import 'package:food_court/views/admin/adminReports.dart';
import 'package:food_court/views/admin/adminRestaurants.dart';
import 'package:food_court/views/admin/adminUsers.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin HomePage'),
        backgroundColor:  Colors.orange[900],
        leading: const BackButton(),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: names.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Material(
              shadowColor: Colors.grey[100],
              elevation: 5,
              child: GestureDetector(
                onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder:
                        (context)=>nav[index]));
                },
                child: SizedBox(
                  height: 50,
                  child: ListTile(
                    title: Text(names[index],
                      style: TextStyle(color:  Colors.orange[900]),),
                    leading: Icon(icons[index],color:  Colors.orange[900],),

                  ),
                ),
              ),
            ),
          );
        },

      )
    );
  }

  List names = [
    'Restaurants',
    'Users',
    'Report'
  ];

  List icons = [
    Icons.restaurant,
    Icons.people,
    Icons.report
  ];

  List nav = [
    const AdminRestaurants(),
    const AdminUser(),
    const AdminReport()
  ];
}
