import 'package:flutter/material.dart';
import 'package:heavy_equipment/src/addItem.dart';
import 'package:heavy_equipment/src/cart.dart';
import 'package:heavy_equipment/src/category.dart';
import 'package:heavy_equipment/src/order.dart';
import 'package:heavy_equipment/src/searchEquipment.dart';
import 'package:heavy_equipment/src/authentication.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {

  HomePage({Key key, this.auth, this.logoutCallback, this.userId}) : super(key: key);

  // final String title;
  final BaseAuth auth;
  final String userId;
  final VoidCallback logoutCallback;
  @override 
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  

  var categories = [
    {
      'title': 'Earth Works',
      'img': 'images/ArticulatedTrucks.jpg',
    },
    {
      'title': 'Material Production',
      'img': 'images/AsphaltPavers.jpg',
    },
    {
      'title': 'Paving Equipment',
      'img': 'images/BackhoeLoaders.jpg',
    },
    {
      'title': 'Lifting Equipment',
      'img': 'images/ColdPlaners.jpg',
    },
    {
      'title': 'Concrete Activity',
      'img': 'images/Compactors.jpg',
    },
    {
      'title': 'Light Equipment',
      'img': 'images/MultiTerrainLoaders.jpg',
    },
    {
      'title': 'Transportation',
      'img': 'images/Dozers.jpg',
    },
    {
      'title': 'Special Equipment',
      'img': 'images/Draglines.jpg',
    },
    {
      'title': 'Erection Equipment',
      'img': 'images/Drills.jpg',
    },
    {
      'title': 'Foundation Equipment',
      'img': 'images/ElectricRopeShovels.jpg',
    },
    {
      'title': 'Pre-Stress Concrete Equipment',
      'img': 'images/Excavators.jpg',
    },
    {
      'title': 'Surveying and Testing',
      'img': 'images/ForestMachines.jpg',
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.8),
      itemCount: 12, 
      itemBuilder: (context, i) {
        return InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Category(title: categories[i]['title'])));
          },
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                buildTitle(categories[i]['title']),
                buildImage(categories[i]['img']),
              ],
            ),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(12),
              color: Colors.orange[200],    
            ),
          ),
        );
      },
    );
  }

  Widget buildTitle(String title) {
    return Container(
        child: Text(
          title,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      );
    
  }

  Widget buildImage(String title) {
    return Expanded(
      child: Image(
        image: AssetImage(title),
        fit: BoxFit.cover,
        ),
      );
  }
  @override 
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      _buildBody(),
      Order(),
      SearchEquipment(),
      
      // Text('Index: 3', style: optionStyle),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Color(0xfffbb448),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Cart()));
            },
            icon: Icon(Icons.shopping_cart),
          ),
          IconButton(
            icon: Icon(Icons.add_circle), 
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddItem()));
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      // backgroundColor: Colors.grey,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            title: Text('Order'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
        ],
        backgroundColor: Color(0xfffbb448),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}