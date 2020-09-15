import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  Detail({Key key, this.title}) : super(key: key );

  final String title;

  @override 
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {

  Widget _builBody() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, i) {
        return Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(2),
          child: Column(
            children: <Widget>[
              _buildImage('images/Excavators.jpg'),
              _buildTitle('Bulldozer'),
              _buildDescription(),
              _addButton(),
              
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      padding: EdgeInsets.all(2),
      margin: EdgeInsets.all(2),
      child: Text(title)
    );
  }

  Widget _buildImage(String title) {
    return Container(
        child: Image(
          image: AssetImage(title),
          fit: BoxFit.cover,
          height: 200,
          width: 350,
        ), 
        margin: EdgeInsets.fromLTRB(8, 10, 8, 0),
        // height: 240,
        padding: EdgeInsets.all(2),
      
      );
  }

  Widget _buildDescription() {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
      padding: EdgeInsets.all(2),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:<Widget>[
          Container(
            // margin: EdgeInsets.all(2),
            // padding: EdgeInsets.all(2),
            child: Column(
              children: <Widget>[
                Text('Weight'),
                Text('20T'),
              ],
            ),
          ),
          Container(
            // margin: EdgeInsets.all(2),
            // padding: EdgeInsets.all(2),
            child: Column(
              children: <Widget>[
                Text('Year'),
                Text('2017')
              ],
            ),
          ),
          Container(
            // margin: EdgeInsets.all(2),
            // padding: EdgeInsets.all(2),
            child: Column(
              children: <Widget>[
                Text('Price'),
                Text('160')
              ]
            ),
          ),
        ]
      ),
    );
    
  }

  Widget _addButton() {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
      padding: EdgeInsets.all(2),
      child: Row(
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              color: Colors.orange,
              textColor: Colors.white,
              onPressed: () {
                print('Button Pressed');
              },
              child: Text('Add to Cart'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ]
      ),
      
    );
  }
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: _builBody(),
      backgroundColor: Colors.orange[100],
    );
  }
}