import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

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

void showToast(message, Color color) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 2,
    backgroundColor: color,
    textColor: Color(0xFF345995),
    fontSize: 16.0,
  );
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
              backgroundColor: Colors.black87,
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
                  icon: Icon(
                    Icons.fiber_new,
                    color: Colors.white,
                    size: 30,
                  ),
                  selectedIcon: Icon(
                    Icons.fiber_new,
                    color: Colors.white,
                    size: 40,
                  ),
                  label: Text(
                    'New',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.system_update_alt,
                    color: Colors.white,
                    size: 30,
                  ),
                  selectedIcon: Icon(
                    Icons.system_update_alt,
                    color: Colors.white,
                    size: 40,
                  ),
                  label: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                    size: 30,
                  ),
                  selectedIcon: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 40,
                  ),
                  label: Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.card_giftcard,
                    color: Colors.white,
                    size: 30,
                  ),
                  selectedIcon: Icon(
                    Icons.card_giftcard,
                    color: Colors.white,
                    size: 40,
                  ),
                  label: Text(
                    'Discounts',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.add_shopping_cart,
                    color: Colors.white,
                    size: 30,
                  ),
                  selectedIcon: Icon(
                    Icons.add_shopping_cart,
                    color: Colors.white,
                    size: 40,
                  ),
                  label: Text(
                    'Orders',
                    style: TextStyle(color: Colors.white),
                  ),
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
                        )),
                    Text("Owner Console",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 30,
                          fontFamily: 'Roboto',
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Text(task,
                        style: TextStyle(
                          fontWeight: FontWeight.w200,
                          fontSize: 28,
                          fontFamily: 'Roboto',
                        )),
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
    // ignore: deprecated_member_use
    File pick = await ImagePicker.pickImage(source: ImageSource.gallery);
    path1 = basename(pick.path);
    setState(() {
      String fileName = basename(pick.path);
      print(' Attatchment- ${pick.path}');
      imageFile = pick;
      final StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      final StorageUploadTask task = firebaseStorageRef.putFile(pick);
      print(task.isSuccessful.toString());
    });

    String platformResponse;

    try {
      // ignore: deprecated_member_use
      await ImagePicker.pickImage(source: ImageSource.gallery);
      platformResponse = 'success';
      showToast('Image was successfully uploaded', Colors.white);
    } catch (error) {
      platformResponse = error.toString();
      showToast(error.toString(), Colors.white);
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.black)),
                color: Colors.black87,
                onPressed: () {
                  final StorageReference firebaseStorageRef =
                      FirebaseStorage.instance.ref().child(path1);
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
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              )),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Colors.black)),
                    color: Colors.black87,
                    onPressed: () {
                      _openImagePicker();
                    },
                    child: Text(
                      'Upload Image',
                      style: TextStyle(color: Colors.white),
                    ),
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
    // ignore: deprecated_member_use
    var pick = await ImagePicker.pickImage(source: ImageSource.gallery);
    path1 = basename(pick.path);
    setState(() {
      print(' Attatchment- ${pick.path}');
      imageFile = pick;
      String fileName = basename(pick.path);

      final StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      final StorageUploadTask task = firebaseStorageRef.putFile(pick);
      print(task.isSuccessful.toString());
    });

    String platformResponse;

    try {
      // ignore: deprecated_member_use
      await ImagePicker.pickImage(source: ImageSource.gallery);
      platformResponse = 'success';
      showToast('Image was successfully uploaded', Colors.white);
    } catch (error) {
      showToast(error.toString(), Colors.white);
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
                  return 'Please Select Category';
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.black)),
                color: Colors.black87,
                onPressed: () {
                  final StorageReference firebaseStorageRef =
                      FirebaseStorage.instance.ref().child(path1);
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
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              )),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Colors.black)),
                    color: Colors.black87,
                    onPressed: () {
                      _openImagePicker();
                    },
                    child: Text(
                      'Upload Image',
                      style: TextStyle(color: Colors.white),
                    ),
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

int i = 0;

List<Container> currOrdersCard = [];
List<Container> pastOrdersCard = [];
String t;

class _OrdersState extends State<Orders> {
  void getOrderList() {
    DatabaseReference usersref =
        FirebaseDatabase.instance.reference().child('Orders');
    usersref.once().then((DataSnapshot snap) {
      // ignore: non_constant_identifier_names
      var KEYS = snap.value.keys;
      // ignore: non_constant_identifier_names

      for (var key in KEYS) {
        currOrdersCard.clear();
        pastOrdersCard.clear();
        getOrders(key);

        print("number read $key");
      }
    });
  }

  String address;
  void getAddress(String number) {
    DatabaseReference addressref =
        FirebaseDatabase.instance.reference().child('Users').child(number);
    addressref.once().then((DataSnapshot snap) {
      // ignore: non_constant_identifier_names

      // ignore: non_constant_identifier_names
      var DATA = snap.value;
      address = DATA['Addressline1'] + DATA['Addressline2'];
      print(address);
    });
  }

  void getOrders(String number) {
    DatabaseReference ordersref =
        FirebaseDatabase.instance.reference().child('Orders').child(number);
    ordersref.once().then((DataSnapshot snap) {
      print('database of $number is read');
      // ignore: non_constant_identifier_names
      var KEYS = snap.value.keys;
      // ignore: non_constant_identifier_names
      var DATA = snap.value;

      for (var key in KEYS) {
        getAddress(number);
        print('database of $number has $key');
        List<ListTile> currListTile = [];
        List<ListTile> pastListTile = [];

        currListTile.clear();
        pastListTile.clear();
        //TODO: Change phone number
        if (DATA[key]['Status'] == 'notCompleted' ||
            DATA[key]['Status'] == 'Shipped') {
          print('database of $number has $key with status not complete');
          for (i = 0; i < DATA[key]['orderLength']; i++) {
            print(
                '${DATA[key][i.toString()]['Name']},${DATA[key][i.toString()]['Price']},');
            ListTile t1 = new ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text(
                  '${DATA[key][i.toString()]['Name']},${DATA[key][i.toString()]['Price']},'),
            );
            currListTile.add(t1);
          }
          Container c = new Container(
            margin: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                border: Border()),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: currListTile,
                ),
                Text('Date: ${DATA[key]["DateTime"]}'),
                Text('Shipping Date: ${DATA[key]["ShippedTime"]}'),
                Text('Completed Date: ${DATA[key]["CompletedTime"]}'),
                Text('Total Amount: ${DATA[key]["TotalAmount"]}'),
                Text(
                    'Order Status is ${DATA[key]["Status"]} and User Phone no. is $number and user address is $address'),
                FlatButton(
                  onPressed: () {
                    DATA[key]["ShippedTime"] == "Shipped"
                        ? null
                        : ordersref.child(key).update({
                            "Status": "Shipped",
                            "ShippedTime": DateTime.now().toString()
                          }).then((_) {
                            showToast('successfully updated', Colors.white);
                          }).catchError((onError) {
                            showToast(onError.toString(), Colors.white);
                          });
                    ;
                  },
                  child: Text('Order shipped'),
                ),
                FlatButton(
                  onPressed: () {
                    ordersref.child(key).update({
                      "Status": "Completed",
                      "CompletedTime": DateTime.now().toString()
                    }).then((_) {
                      showToast('successfully updated', Colors.white);
                    }).catchError((onError) {
                      showToast(onError.toString(), Colors.white);
                    });
                    ;
                  },
                  child: Text('Order completed'),
                )
              ],
            ),
          );
          currOrdersCard.add(c);
        } else if (DATA[key]['Status'] == 'Completed') {
          print('Order Length is ${DATA[key]['orderLength'].toString()}');
          for (i = 0; i < DATA[key]['orderLength']; i++) {
            ListTile t1 = new ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text(
                  '${DATA[key][i.toString()]['Name']},${DATA[key][i.toString()]['Price']},'),
            );
            pastListTile.add(t1);
          }
          Container c = new Container(
            margin: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                border: Border()),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: pastListTile,
                ),
                Text('Date: ${DATA[key]["DateTime"]}'),
                Text('Shipping Date: ${DATA[key]["ShippedTime"]}'),
                Text('Completed Date: ${DATA[key]["CompletedTime"]}'),
                Text('Total Amount: ${DATA[key]["TotalAmount"]}'),
                Text('Order Status is ${DATA[key]["Status"]}'),
              ],
            ),
          );
          pastOrdersCard.add(c);
        }
      }
    });
  }

  Order createOrder(List<OrderItem> d) {
    Order temp = new Order(d);
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    getOrderList();
    return Column(
      children: <Widget>[
        Text('Current Orders'),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: currOrdersCard,
        ),
        Text('Past Orders'),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: pastOrdersCard,
        )
      ],
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
                  return 'Please Select Category';
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.black)),
                color: Colors.black87,
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
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
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
  String path1;
  File imageFile;
  String _uploadedFileURL;
  void _openImagePicker() async {
    // ignore: deprecated_member_use
    var pick = await ImagePicker.pickImage(source: ImageSource.gallery);
    path1 = basename(pick.path);
    setState(() {
      print(' Attatchment- ${pick.path}');
      imageFile = pick;
      String fileName = basename(pick.path);

      final StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      final StorageUploadTask task = firebaseStorageRef.putFile(pick);
      print(task.isSuccessful.toString());
    });

    String platformResponse;

    try {
      // ignore: deprecated_member_use
      await ImagePicker.pickImage(source: ImageSource.gallery);
      platformResponse = 'success';
      showToast('Image was successfully uploaded', Colors.white);
    } catch (error) {
      showToast(error.toString(), Colors.white);
    }

    if (!mounted) return;
    print(platformResponse);
  }

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
                  return 'Please Select Category';
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.black)),
                color: Colors.black87,
                onPressed: () {
                  int price1 = int.parse(ageController.text);
                  int price2 = int.parse(age1Controller.text);
                  final StorageReference firebaseStorageRef =
                      FirebaseStorage.instance.ref().child(path1);
                  firebaseStorageRef.getDownloadURL().then((fileURL) {
                    setState(() {
                      _uploadedFileURL = fileURL;
                    });
                  });
                  if (_formKey.currentState.validate()) {
                    dbRef
                        .child('Discounts')
                        .child('Discount ${nameController.text}')
                        .set({
                      "Name": nameController.text,
                      "Category": dropdownValue,
                      "Original Price": price1,
                      "Discounted Price": price2,
                      "ImageUrl": _uploadedFileURL,
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
                child: Text(
                  'Publish Discount',
                  style: TextStyle(color: Colors.white),
                ),
              )),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Colors.black)),
                    color: Colors.black87,
                    onPressed: () {
                      _openImagePicker();
                    },
                    child: Text(
                      'Upload Image',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )),
        ])));
  }
}

class OrderItem {
  String name;
  String price;
  OrderItem(this.name, this.price);
}

class Order {
  List<OrderItem> d = [];
  Order(this.d);
}
