import 'package:flutter/material.dart';
import 'package:heavy_equipment/src/detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Category extends StatefulWidget {
  Category({Key key, @required this.title}) : super(key: key);

  final String title;
  @override 
  _CategoryState createState() => _CategoryState();

}

class _CategoryState extends State<Category> {

  

  // Widget _buildBody() {
  //   return ListView.builder(
  //     itemCount: 14,
  //     itemBuilder: (context, i) {
  //       return ListTile(
  //         // leading: Icon(Icons.list),
  //         trailing: Icon(Icons.arrow_forward),
  //         title: Text(categories[i]),
  //         onTap: () {
  //           Navigator.push(context, MaterialPageRoute(builder: (context) => Detail()));
  //         },
  //       );
  //     },
  //   );
  // }
  

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection(widget.title).snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 20),
      itemCount: snapshot.length,
      itemBuilder: (context, index) => _buildListItem(context, snapshot[index]),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.category),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.category),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Detail()));
          },
        ),
      ),
    );
  }
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category')
      ),
      body: _buildBody(context),
      
      
    );
  }

}

class Record {
    final String category;
    final DocumentReference reference;

    Record.fromMap(Map<String, dynamic> map, {this.reference}) : assert(map['category'] != null), category = map['category'];
    Record.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data, reference: snapshot.reference);

    @override
    String toString() => "Record<$category>";
}




