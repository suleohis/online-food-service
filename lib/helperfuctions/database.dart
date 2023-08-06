
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_court/modal/cart_item.dart';

class DatabaseMethods{
  final FirebaseAuth auth = FirebaseAuth.instance;

  ///This is used to upload user data
  uploadUserInfo(userMap,context)async{
    final User? user =  auth.currentUser;
    await FirebaseFirestore.instance.collection('users')
        .doc(user!.uid).set(userMap).then((value) {
      print('done');
    });
  }

  ///This is used to upload user data
  updateUserInfo(userMap,context)async{
    final User? user =  auth.currentUser;
    await FirebaseFirestore.instance.collection('users')
        .doc(user!.uid).update(userMap).then((value) {
      print('done');

    });
  }
  void addToCart({required String userId, required CartItemModel cartItem}){
    print("THE USER ID IS: $userId");
    print("cart items are: ${cartItem.toString()}");
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      "cart": FieldValue.arrayUnion([cartItem.toMap()])
    });
  }
  void removeFromCart({required String userId, required CartItemModel cartItem}){
    print("THE USER ID IS: $userId");
    print("cart items are: ${cartItem.toString()}");
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      "cart": FieldValue.arrayRemove([cartItem.toMap()])
    });
  }
}