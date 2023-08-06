import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_court/modal/productModal.dart';
import 'package:food_court/views/homepage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class CreateMeal extends StatefulWidget{
  @override
  _CreateMealState createState()=>_CreateMealState();
}


class _CreateMealState extends State<CreateMeal>{
  TextEditingController descriptionController =TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  bool nameValidate =false;
  bool descValidate = false;
  bool priceValidate = false;
  String? uploadImage;
  bool imageColor = false;
  dynamic image;
  bool isLoading =false;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:const Text('Create Meal'),
        leading:  const BackButton(),
        backgroundColor:  Colors.orange[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  imageController(),
                  const SizedBox(height: 20,),
               createTextField('Name',nameController,TextInputType.name,1,
               nameValidate),
                  const SizedBox(height: 20,),
                  createTextField('Description', descriptionController,
                      TextInputType.multiline,3,descValidate),
                  const SizedBox(height: 20,),
                  categoryCheckBox(),
                  const SizedBox(height: 20,),
                  createTextField('Price', priceController,
                      TextInputType.number,1,priceValidate),
                  const SizedBox(height: 20,),
                  createButton()

                ],
              ),
            ),
           if(isLoading)
           const Center(
              child: CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
  createButton(){
    return GestureDetector(
      onTap: (){
        if(!isLoading){
          checkForError();
        }
      },
      child: Align(
        alignment: Alignment.center,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width /2,
          decoration: BoxDecoration(
            color: Colors.orange[900],
            borderRadius: BorderRadius.circular(10)
          ),
          child: const Text(
              'Publish',
            style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 17),
          ),
        ),
      ),
    );
  }
  imageController(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Image :',style:
        TextStyle(color: Colors.orange[900],fontWeight: FontWeight.normal,fontSize: 16),),
        GestureDetector(
          onTap: () async {
            if(!isLoading){
              image = await ImagePicker().pickImage(source: ImageSource.gallery);
              if (image == null) return;
              setState(() {
              });
            }
          },
          child: Container(
            height: 150,width: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
               ),
            child:image== null?  Center(
              child: Text('No Image ',style: TextStyle(color: imageColor ?
              Colors.red[900]: Colors.black),),
            ): Image(
              image: FileImage(File(image.path)),
              height: 150,width: 150,fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }
  createTextField(String name,TextEditingController controller,
      TextInputType type,int maxLines,bool validate){
    return Wrap(
      children: [
        Text('$name :',style:
        TextStyle(color: Colors.orange[900],fontWeight: FontWeight.normal,fontSize: 16),),
        TextField(
          enabled: !isLoading,
          controller: controller,
          keyboardType: type,
          maxLines: maxLines,
          decoration: InputDecoration(
            errorText: validate ? 'Field Can\'t Be Empty' : null,
            hintText: name,
            border: const OutlineInputBorder(),
            focusColor: Colors.orange[900],
            focusedBorder: OutlineInputBorder(borderSide:
            BorderSide(width: 1,color: Colors.orange[900]!),gapPadding:0 ),
            errorBorder: OutlineInputBorder(borderSide:
            BorderSide(width: 1,color: Colors.red[900]!),gapPadding: 0)
          ),
        ),

      ],
    );
  }
  String? category;
  bool local = false;
  bool internation = false;
  categoryCheckBox(){

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text( 'Category :',style:
        TextStyle(color: Colors.orange[900],fontWeight: FontWeight.normal,fontSize: 16),),
        Row(
          children: [
            Checkbox(value: local, onChanged: (value){
              setState(() {
                local = true;
                internation = false;
                category = 'Local';
              });
            }),
            const Text('Local'),
            Checkbox(value: internation, onChanged: (value){
              setState(() {
                local = false;
                internation = true;
                category = 'International';
              });
            }),
            const Text('International'),
          ],
        ),
      ],
    );
  }
  checkForError(){
    bool failed = false;
    setState(() {isLoading = true;});
    if(nameController.text.isEmpty ){
      setState(() {
        nameValidate =true;
        isLoading = false;
        failed= true;
        return;
      });
    }
    if(descriptionController.text.isEmpty){
      setState(() {
        descValidate = true;
        isLoading = false;
        failed= true;
        return;
      });
    }
    if( priceController.text.isEmpty){
      setState(() {
        priceValidate = true;
        isLoading = false;
        failed= true;
        return;
      });
    }
    if(category == null ){
      setState(() {
        isLoading = false;
        failed= true;
        return;
      });
    }
    if(image == null){
      setState(() {
        imageColor = true;
        isLoading = false;
        failed= true;
      });
    }
    if(!failed){
     uploadImageToFirebase();
    }
  }
  uploadToFirebase(){
    var uuid = const Uuid();
    String uid = uuid.v4();
      Map<String,dynamic> map ={
      "id":uid,
     "name":nameController.text,
      "rating":0.0,
      "image":uploadImage,
      "price":int.parse(priceController.text),
      "restaurantId":userModel!.restaurantId,
      "restaurant": userModel!.restaurant,
      "description":descriptionController.text,
      "category":category,
      "featured":false,
      "raates":0,
      "userLikes":[]
      };

       FirebaseFirestore.instance.collection('products')
          .doc(uid.toString()).set(map).then((val){
            Navigator.pop(context);
    }).catchError((e){
      isLoading = false;
      print(e);
      print('error 5');
      setState(() {});
      });
}
  uploadImageToFirebase() async {
    String imageString;
    late String imageName;
    File images;
    images = File(image.path);
    String fileName = images.path.split('/').last;
    try {
      imageName = fileName;
      imageString = '${userModel!.restaurant}/$imageName/$imageName.jpeg';

      //upload image to firebase
      final Reference imageStorageReference =
      FirebaseStorage.instance.ref().child(imageString);
      final UploadTask? imageUploadTask = imageStorageReference.putFile(images);

      await imageUploadTask!.whenComplete(() async {
        try {
          dynamic ref = FirebaseStorage.instance.ref().child(imageString);
          uploadImage= await ref.getDownloadURL();
        } catch (e) {
          isLoading = false;
          print('error 1');
          setState(() {});
        }
      }).catchError((e) {
        isLoading = false;

        print('error 2');
        setState(() {});
      });
  } catch (e) {
      isLoading = false;

      print('error 3');
      setState(() {});
    }
    if(isLoading ){

      print('good 1');
      uploadToFirebase();
    }
}
}