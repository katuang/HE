import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heavy_equipment/src/model.dart';

class AddItem extends StatefulWidget {

  @override 
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {

  File _image;
  String dropdownValue;
  String dropdownSubValue;
  String chooseValue;
  String dropdownType;
  String dropdownYear;
  String singleDocumentId = '0';
  final List<String> types = <String>['Small', 'Medium', 'Large'];
  final List<String> oldYears = <String>['2015', '2016', '2017'];
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool changeCategory = false;
  

  Stream<QuerySnapshot> categoryStream = Firestore.instance.collection('categoryHE').snapshots();
  CollectionReference categoryCollection = Firestore.instance.collection('categoryHE');

  // Future<List<dynamic>> _getCategoryDocument(String changeChooseValue) async {
  //   // await _firebaseAuth.signInWithEmailAndPassword(email: 'katuang29@gmail.com', password: 'trojanassasin');
  //   List<dynamic> tempDocument = [];
  //   QuerySnapshot categoryDocument = await Firestore.instance.collection('categoryHE').where('name', isEqualTo: changeChooseValue).getDocuments();
  //   List<DocumentSnapshot> documentList = categoryDocument.documents;
  //   documentList.forEach((DocumentSnapshot singleDocument) { 
  //   tempDocument.add(singleDocument.documentID);
    
  //   });
  //   // List<dynamic> temporaryDocument = documentList.map((DocumentSnapshot singleDocument) => singleDocument['name']).toList();
  //   return tempDocument;
  // }

  _getCategoryDocumentId(String changeChooseValue) async {
    // await _firebaseAuth.signInWithEmailAndPassword(email: 'katuang29@gmail.com', password: 'trojanassasin');
    // List<dynamic> tempDocument = [];
    QuerySnapshot categoryDocument = await Firestore.instance.collection('categoryHE').where('name', isEqualTo: changeChooseValue).getDocuments();
    List<DocumentSnapshot> documentList = categoryDocument.documents;
    documentList.forEach((DocumentSnapshot singleDocument) { 
    // tempDocument.add(singleDocument.documentID);
    chooseValue = singleDocument.documentID;
    
    });
    // List<dynamic> temporaryDocument = documentList.map((DocumentSnapshot singleDocument) => singleDocument['name']).toList();
    return chooseValue;
  }

  void printCategoryDocument() async {
    // var printItem = await _getCategoryDocument(dropdownValue);
    var printItem = await ModelHE.getProduct('0', '1');
    await ModelHE.addProduct();
    print(printItem);
    // print(dropdownValue);
    // print(chooseValue);
  }
  

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print('Image path $_image');
    });
  }

  Future _uploadPic(BuildContext context) async {
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String imageURL = await taskSnapshot.ref.getDownloadURL();
    print('url image $imageURL');
    setState(() {
      print('Picture upload');
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    });
  }

  Widget _imageContainer() {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 2, 5, 2),
      height: 250,
      decoration: BoxDecoration(
        // border: Border.all(),
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: FileImage(_image),
          fit: BoxFit.cover,
        ),
      ),
      
    );
  }

  Widget _noImageContainer() {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 2, 5, 2),
      height: 250,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          _image != null ? _imageContainer() : _noImageContainer(), 
          InkWell(
            onTap: () {
              _getImage();
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              margin: EdgeInsets.fromLTRB(5, 2, 5, 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.blueGrey,
              ),
              child: Text(
                'Choose Image',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          // RaisedButton(
          //   child: Text('Upload Image'),
          //   onPressed: () {
          //     _uploadPic(context);
          //   },
          // ),
          // RaisedButton(,
          //   onPressed: () {
          //     printCategoryDocument();
          //   },
          //   child: Text('Test Firestore'),
          // ),
        ],
      
    );
  }

  Widget _buildBodyCategory(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: categoryStream,
      builder: (context, snapshot) {
        if(!snapshot.hasData) return LinearProgressIndicator();
        return _chooseCategory(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildBodySubCategory(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('categoryHE').document(singleDocumentId).collection('subCategoryHE').snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) return LinearProgressIndicator();
        return _chooseSubCategory(context, snapshot.data.documents);
      },
    );
  }

  Widget _chooseCategory(BuildContext context, List<DocumentSnapshot> snapshot) {
    // final initialValue = Record.fromSnapshot(snapshot[0]);
    return Container(
        child: DropdownButton<String>(
          hint: Text('Choose Category'),
          value: dropdownValue,
          icon: Icon(Icons.keyboard_arrow_down),
          iconSize: 24,
          elevation: 6,
          style: TextStyle(color: Colors.blueGrey),
          underline: Container(
            height: 1,
            color: Colors.blueGrey,
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
              // _getCategoryDocumentId(newValue);
              singleDocumentId = _getCategoryDocumentId(newValue);
              
            });
          },
          // selectedItemBuilder: (BuildContext context) {
          //   return snapshot.map<Widget>((DocumentSnapshot item) {
          //     return Text(item.data['category']);
          //   }).toList();
          // },
          items: snapshot.map((DocumentSnapshot value) {
            final record = Record.fromSnapshot(value);
            return DropdownMenuItem<String>(
              value: record.name,
              child: Text(record.name),
              );
          }).toList(),
          isExpanded: true,
          // hint: Text(title),
          // disabledHint: Text('Material Production'),
        
        ),
        margin: EdgeInsets.fromLTRB(5, 2, 5, 2),
      );  
  }

  Widget _chooseSubCategory(BuildContext context, List<DocumentSnapshot> snapshot) {
    // final initialValue = Record.fromSnapshot(snapshot[0]);
    return Container(
        child: DropdownButton<String>(
          hint: Text('Choose SubCategory'),
          value: dropdownSubValue,
          icon: Icon(Icons.keyboard_arrow_down),
          iconSize: 24,
          elevation: 6,
          style: TextStyle(color: Colors.blueGrey),
          underline: Container(
            height: 1,
            color: Colors.blueGrey,
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownSubValue = newValue;
            });
          },
          // selectedItemBuilder: (BuildContext context) {
          //   return snapshot.map<Widget>((DocumentSnapshot item) {
          //     return Text(item.data['category']);
          //   }).toList();
          // },
          items: snapshot.map((DocumentSnapshot value) {
            final record = Record.fromSnapshot(value);
            return DropdownMenuItem<String>(
              value: record.name,
              child: Text(record.name),
              );
          }).toList(),
          isExpanded: true,
          // hint: Text(title),
          // disabledHint: Text('Material Production'),
        
        ),
        margin: EdgeInsets.fromLTRB(5, 2, 5, 2),
      );  
  }

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Text(title),
          SizedBox(height: 10),
          TextField(
            obscureText: isPassword,
            decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                  fillColor: Color(0xfff3f3f4),
                  filled: true,
                  hintText: title,
              ),
          ),
        ],
      ),
    );
  }

  Widget _chooseType() {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 2, 5, 2),
      child: DropdownButton(
        hint: Text('Type'),
        items: types.map((String valueType) {
          return DropdownMenuItem<String> (
            value: valueType,
            child: Text(valueType),
          );
        }).toList(), 
        onChanged: (String newValue) {
          setState(() {
            dropdownType = newValue;
          });
        },
        value: dropdownType,
        icon: Icon(Icons.keyboard_arrow_down),
        iconSize: 24,
        elevation: 6,
        style: TextStyle(color: Colors.blueGrey),
        underline: Container(
          height: 2,
          color: Colors.blueGrey,
        ),
        isExpanded: true,
      ),
    );
  }

  Widget _chooseYear() {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 2, 5, 2),
      child: DropdownButton(
        hint: Text('Year'),
        items: oldYears.map((String valueType) {
          return DropdownMenuItem<String>(
            value: valueType,
            child: Text(valueType),
            );
        }).toList(), 
        onChanged: (String newValue) {
          setState(() {
            dropdownYear = newValue;
          });
        },
        value: dropdownYear,
        icon: Icon(Icons.keyboard_arrow_down),
        iconSize: 24,
        elevation: 6,
        style: TextStyle(color: Colors.blueGrey),
        underline: Container(
          height: 2,
          color: Colors.blueGrey,
        ),
        isExpanded: true,
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Container(
        child: Text(
          title,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        // padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
        margin: EdgeInsets.fromLTRB(5, 5, 10, 2),
      );
    
  }

  Widget _addButton() {
    return InkWell(
      onTap: () {
        // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
        printCategoryDocument();
      },
      child: Container(
        // width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        margin: EdgeInsets.fromLTRB(5, 2, 5, 2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xfffbb448), Color(0xfff7892b)],
          ),
        ),
        child: Text(
          'Add',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
      ),
      body: ListView(
        children: <Widget>[
          _buildBodyCategory(context),
          _buildBodySubCategory(context),
          _entryField('Name'),
          _entryField('Location'),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // _buildTitle('Type'),
                      _chooseType(),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // _buildTitle('Year'),
                      _chooseYear(),
                    ],
                  ),
                ),
                
              ],
            ),
          ),
          _buildBody(),
          // SizedBox(height: 20),
          _addButton(),
        ]
      ),
    );
  }
}

class Record {
    final String name;
    final DocumentReference reference;

    Record.fromMap(Map<String, dynamic> map, {this.reference}) : assert(map['name'] != null), name = map['name'];
    Record.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data, reference: snapshot.reference);

    @override
    String toString() => "Record<$name>";
}