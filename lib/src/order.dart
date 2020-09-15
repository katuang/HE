import 'package:flutter/material.dart';

class Order extends StatefulWidget {

  @override 
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {

  Widget _buildBody() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, i) {
        return Row(
          children: <Widget>[
            _buildImage('images/Excavators.jpg'),
            _buildTitle('Bulldozer'),
          ],
        );
      },
    );
  }

  Widget _buildImage(String title) {
    return Expanded(
        flex: 1,
        child: Image(
        image: AssetImage(title),
        fit: BoxFit.contain,
        ), 
      
      
      );
  }

  Widget _buildTitle(String title) {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(title),
          SizedBox(height: 25,),
          Text('Weight'),
          Text('Price'),
          Text('Year'),
          
        ],

    ),
    // margin: EdgeInsets.all(5),
    );
  }

  @override 
  Widget build(BuildContext context) {
    return Container(
      child: _buildBody(),
    );
  }
}