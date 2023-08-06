import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_court/modal/user.dart';
import 'package:food_court/views/homepage.dart';

class AdminUser extends StatefulWidget {
  const AdminUser({Key? key}) : super(key: key);

  @override
  State<AdminUser> createState() => _AdminUserState();
}

class _AdminUserState extends State<AdminUser> {
  TextEditingController searchTextEditingController = TextEditingController();
  bool shouldSearch = false;
  bool flitterThePage = false;
  String searchItem = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        backgroundColor:  Colors.orange[900],
        actions: const [],
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                bottom: 10,
                left: 10,
              ),
              child: Row(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width - 160,
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[400]!),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5))),
                        child: TextField(
                          controller: searchTextEditingController,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon:
                                    Icon(Icons.clear, color: Colors.orange[900]),
                                onPressed: clearTheTextFormField,
                              ),
                              border: InputBorder.none,
                              hintText: 'Name'),
                          onChanged: (String val) {
                            setState(() {
                              if (val.isNotEmpty) {
                                shouldSearch = true;
                              } else {
                                shouldSearch = false;
                              }
                            });
                            searchItem = val;
                          },
                        ),
                      ),
                      Container(
                        height: 45,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            color: Colors.orange[900],
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5))),
                        child: const Icon(
                          Icons.search_sharp,
                          size: 30,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 75),
              child: displayAllUsers()),
        ],
      ),
    );
  }

  displayAllUsers() {
    return StreamBuilder(
      stream: shouldSearch
          ? FirebaseFirestore.instance
              .collection('users')
              .where(searchTextEditingController.text,
                  isGreaterThanOrEqualTo: searchItem)
              .snapshots()
          : FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            shouldSearch == true) {
          return const Center(child: CircularProgressIndicator());
        }
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Center(child: CircularProgressIndicator());
          default:
        }
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              UserModel user = UserModel().fromSnapshot(snapshot.data!.docs[index]);

              return ListTile(
                title: buildUsername(user.name!),
                leading: Container(
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(30)),
                  child: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person_outline_outlined,
                      color: Colors.black,
                      size: 33,
                    ),
                  ),
                ),
                subtitle: Wrap(
                  children: [
                    Icon(
                      Icons.person_outline_outlined,
                      size: 11,
                      color: Colors.blue[800],
                    ),
                    Text(
                      user.email!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue.shade800,
                      ),
                    )
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.admin_panel_settings, color: Colors.orange[900], size: 19,),
                  onPressed: () {
                    showDialog(context: context,
                        builder: (context) {
                      return AlertDialog(
                        title: Text('Are You Sure?'),
                        actions: [

                          Row(
                            children: [

                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  FirebaseFirestore.instance.collection('users').doc(userModel!.id).update({
                                    'roles': 'seller'
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue[800],
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                                  child:
                                      const Text(
                                    'Yes',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 19),
                                  )

                                ),
                              ),

                              const SizedBox(width: 20,),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red[800],
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                                  child:  const Text(
                                    'Cancel',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 19),
                                  )

                                ),
                              ),
                            ],
                          )
                        ],
                      );
                        }
                    );
                  },
                ),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildUsername(
    String username,
  ) {
    return Row(children: <Widget>[
      Text(username.toString(), style: TextStyle(color: Colors.blue[800])),
      const SizedBox(
        width: 6,
      ),
    ]);
  }

  clearTheTextFormField() {
    searchTextEditingController.clear();
    setState(() {
      if (searchTextEditingController.text.isNotEmpty) {
        shouldSearch = true;
        setState(() {});
      } else {
        shouldSearch = false;
        setState(() {});
      }
    });
  }
}
