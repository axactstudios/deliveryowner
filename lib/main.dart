import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery Owner',
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  String task = 'Register New Product';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 50),
        child: Row(
          children: <Widget>[
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                  if (_selectedIndex == 0) task = 'Register New Product';
                  if (_selectedIndex == 1) task = 'Update Product';
                  if (_selectedIndex == 2) task = 'Delete';
                  if (_selectedIndex == 3) task = 'Discount';
                  if (_selectedIndex == 4) task = 'Orders';
                });
              },
              labelType: NavigationRailLabelType.selected,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.fiber_new),
                  selectedIcon: Icon(Icons.fiber_new),
                  label: Text('New'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.system_update_alt),
                  selectedIcon: Icon(Icons.system_update_alt),
                  label: Text('Update'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.delete_outline),
                  selectedIcon: Icon(Icons.delete),
                  label: Text('Delete'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.card_giftcard),
                  selectedIcon: Icon(Icons.card_giftcard),
                  label: Text('Discounts'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.add_shopping_cart),
                  selectedIcon: Icon(Icons.add_shopping_cart),
                  label: Text('Orders'),
                ),
              ],
            ),
            VerticalDivider(thickness: 1, width: 1),
            // This is the main content.
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Budget Mart",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 30,
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.italic)),
                    Text("Hey, Shivam!!",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 30,
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.italic)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(task,
                        style: TextStyle(
                            fontWeight: FontWeight.w200,
                            fontSize: 30,
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.italic)),
                    if (_selectedIndex == 0)
                      RegisterPet()
                    else if (_selectedIndex == 1)
                      UpdatePet()
                    else if (_selectedIndex == 2)
                      Delete()
                    else if (_selectedIndex == 3)
                      Discount()
                    else if (_selectedIndex == 4)
                      Orders()
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterPet extends StatefulWidget {
  RegisterPet({Key key}) : super(key: key);

  @override
  _RegisterPetState createState() => _RegisterPetState();
}

class _RegisterPetState extends State<RegisterPet> {
  File imageFile;
  String _uploadedFileURL;
  String path1;
  void _openImagePicker() async {
    File pick = await ImagePicker.pickImage(source: ImageSource.gallery);
    path1 = pick.path;
    setState(() {
      print(' Attatchment- ${pick.path}');
      imageFile = pick;
      final StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("hello.jpg");
      final StorageUploadTask task = firebaseStorageRef.putFile(pick);
      print(task.isSuccessful.toString());
    });

    String platformResponse;

    try {
      await ImagePicker.pickImage(source: ImageSource.gallery);
      platformResponse = 'success';
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Your Image Was Successfuly Uploaded.')));
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;
    print(platformResponse);
  }

  final _formKey = GlobalKey<FormState>();
  final listOfCategories = ["Clothes", "Daily needs"];
  String dropdownValue = 'Clothes';
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final dbRef = FirebaseDatabase.instance.reference();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Enter Product Name",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Product Name';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: DropdownButtonFormField(
              value: dropdownValue,
              icon: Icon(Icons.arrow_downward),
              decoration: InputDecoration(
                labelText: "Select Category",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: listOfCategories.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please Select Categpry';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: ageController,
              decoration: InputDecoration(
                labelText: "Enter product price",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter product price';
                }
                return null;
              },
            ),
          ),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: RaisedButton(
                color: Colors.lightBlue,
                onPressed: () {
                  final StorageReference firebaseStorageRef =
                      FirebaseStorage.instance.ref().child("hello.jpg");
                  firebaseStorageRef.getDownloadURL().then((fileURL) {
                    setState(() {
                      _uploadedFileURL = fileURL;
                    });
                  });
                  int price1 = int.parse(ageController.text);
                  if (_formKey.currentState.validate()) {
                    dbRef.child(dropdownValue).child(nameController.text).set({
                      "Name": nameController.text,
                      "Price": price1,
                      "ImageUrl": _uploadedFileURL,
                    }).then((_) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Successfully Added')));
                      ageController.clear();
                      nameController.clear();
                    }).catchError((onError) {
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text(onError)));
                    });
                  }
                },
                child: Text('Submit'),
              )),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.lightBlue,
                    onPressed: () {
                      _openImagePicker();
                    },
                    child: Text('Upload Image'),
                  ),
                ],
              )),
        ])));
  }

  @override
  void dispose() {
    super.dispose();
    ageController.dispose();
    nameController.dispose();
  }
}

class UpdatePet extends StatefulWidget {
  UpdatePet({Key key}) : super(key: key);

  @override
  _UpdatePetState createState() => _UpdatePetState();
}

class _UpdatePetState extends State<UpdatePet> {
  File imageFile;
  String _uploadedFileURL;
  String path1;
  void _openImagePicker() async {
    File pick = await ImagePicker.pickImage(source: ImageSource.gallery);
    path1 = pick.path;
    setState(() {
      print(' Attatchment- ${pick.path}');
      imageFile = pick;
      final StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("hello.jpg");
      final StorageUploadTask task = firebaseStorageRef.putFile(pick);
      print(task.isSuccessful.toString());
    });

    String platformResponse;

    try {
      await ImagePicker.pickImage(source: ImageSource.gallery);
      platformResponse = 'success';
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Your Image Was Successfuly Uploaded.')));
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;
    print(platformResponse);
  }

  final _formKey = GlobalKey<FormState>();
  final listOfCategories = ["Clothes", "Daily needs"];
  String dropdownValue = 'Clothes';
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final dbRef = FirebaseDatabase.instance.reference();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Enter Product Name",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Product Name';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: DropdownButtonFormField(
              value: dropdownValue,
              icon: Icon(Icons.arrow_downward),
              decoration: InputDecoration(
                labelText: "Select Category",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: listOfCategories.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please Select Categpry';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: ageController,
              decoration: InputDecoration(
                labelText: "Enter product price",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter product price';
                }
                return null;
              },
            ),
          ),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: RaisedButton(
                color: Colors.lightBlue,
                onPressed: () {
                  final StorageReference firebaseStorageRef =
                      FirebaseStorage.instance.ref().child("hello.jpg");
                  firebaseStorageRef.getDownloadURL().then((fileURL) {
                    setState(() {
                      _uploadedFileURL = fileURL;
                    });
                  });
                  int price1 = int.parse(ageController.text);
                  if (_formKey.currentState.validate()) {
                    dbRef
                        .child(dropdownValue)
                        .child(nameController.text)
                        .update({
                      "Name": nameController.text,
                      "Price": price1,
                      "ImageUrl": _uploadedFileURL,
                    }).then((_) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Successfully Added')));
                      ageController.clear();
                      nameController.clear();
                    }).catchError((onError) {
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text(onError)));
                    });
                  }
                },
                child: Text('Submit'),
              )),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.lightBlue,
                    onPressed: () {
                      _openImagePicker();
                    },
                    child: Text('Upload Image'),
                  ),
                ],
              )),
        ])));
  }

  @override
  void dispose() {
    super.dispose();
    ageController.dispose();
    nameController.dispose();
  }
}

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Incoming orders will appear here'),
      ),
    );
  }
}

class Delete extends StatefulWidget {
  Delete({Key key}) : super(key: key);

  @override
  _DeleteState createState() => _DeleteState();
}

class _DeleteState extends State<Delete> {
  String platformResponse;
  final nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final listOfCategories = ["Clothes", "Daily needs"];
  String dropdownValue = 'Clothes';
  final dbRef = FirebaseDatabase.instance.reference();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: DropdownButtonFormField(
              value: dropdownValue,
              icon: Icon(Icons.arrow_downward),
              decoration: InputDecoration(
                labelText: "Select Category",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: listOfCategories.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please Select Categpry';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Enter Product Name",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Product Name';
                }
                return null;
              },
            ),
          ),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: RaisedButton(
                color: Colors.lightBlue,
                onPressed: () {
                  if (_formKey.currentState.validate())
                    dbRef
                        .child(dropdownValue)
                        .child(nameController.text)
                        .remove()
                        .then((_) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Deleted Successfully')));
                      nameController.clear();
                    }).catchError((onError) {
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text(onError)));
                    });
                },
                child: Text('Delete'),
              )),
        ])));
  }
}

class Discount extends StatefulWidget {
  Discount({Key key}) : super(key: key);

  @override
  _DiscountState createState() => _DiscountState();
}

class _DiscountState extends State<Discount> {
  final _formKey = GlobalKey<FormState>();
  final listOfCategories = ["Clothes", "Daily needs"];
  String dropdownValue = 'Clothes';
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final age1Controller = TextEditingController();
  final dbRef = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Enter Product Name",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Product Name';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: DropdownButtonFormField(
              value: dropdownValue,
              icon: Icon(Icons.arrow_downward),
              decoration: InputDecoration(
                labelText: "Select Category",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: listOfCategories.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please Select Categpry';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: ageController,
              decoration: InputDecoration(
                labelText: "Enter original price",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter product price';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: age1Controller,
              decoration: InputDecoration(
                labelText: "Enter discounted price",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter product price';
                }
                return null;
              },
            ),
          ),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: RaisedButton(
                color: Colors.lightBlue,
                onPressed: () {
                  int price1 = int.parse(ageController.text);
                  int price2 = int.parse(age1Controller.text);
                  if (_formKey.currentState.validate()) {
                    dbRef
                        .child('Discounts')
                        .child('Discount ${nameController.text}')
                        .set({
                      "Name": nameController.text,
                      "Category": dropdownValue,
                      "Original Price": price1,
                      "Discounted Price": price2,
                    }).then((_) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Successfully Added')));
                      ageController.clear();
                      age1Controller.clear();
                      nameController.clear();
                    }).catchError((onError) {
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text(onError)));
                    });
                  }
                },
                child: Text('Publish Discount'),
              )),
        ])));
  }
}
