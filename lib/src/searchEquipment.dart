import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchEquipment extends StatefulWidget {
  SearchEquipment({Key key}) : super(key: key);

  @override 
  _SearchEquipmentState createState() => _SearchEquipmentState();
}

class _SearchEquipmentState extends State<SearchEquipment> {

  String dropdownValue;
  String dropdownType;
  String dropdownYear;
  String dropdownLocation;
  DateTime selectedDate = DateTime.now();

  final List<String> types = <String>['Small', 'Medium', 'Large'];
  final List<String> oldYears = <String>['2015', '2016', '2017'];
  final List<String> location = <String>['Jakarta', 'Bandung', 'Bali'];
  final List<String> transport = <String>['true', 'false'];

  // final List<DocumentSnapshot> snapshot = Stream Firestore.instance.collection('Earth Works').snapshots();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context, 
      initialDate: selectedDate, 
      firstDate: DateTime(2015), 
      lastDate: DateTime(2030),
    );
    if(picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('categoryHE').snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) return LinearProgressIndicator();
        return _chooseCategory(context, snapshot.data.documents, 'Category');
      },
    );
  }

  Widget _buildBodySub(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('categoryHE').document('0').collection('subCategoryHE').snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) return LinearProgressIndicator();
        return _chooseCategory(context, snapshot.data.documents, 'SubCategory');
      },
    );
  }

  Widget _chooseCategory(BuildContext context, List<DocumentSnapshot> snapshot, String title) {
    // final initialValue = Record.fromSnapshot(snapshot[0]);
    return Container(
        child: DropdownButton<String>(
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
          hint: Text(title),
          // disabledHint: Text('Material Production'),
        
        ),
        margin: EdgeInsets.fromLTRB(5, 2, 5, 2),
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

  Widget _searchDateButton() {
      return InkWell(
        onTap: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
          // printCategoryDocument();
          _selectDate(context);
        },
        child: Container(
          // width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15),
          margin: EdgeInsets.fromLTRB(5, 2, 5, 2),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            // gradient: LinearGradient(
            //   begin: Alignment.centerLeft,
            //   end: Alignment.centerRight,
              
            // ),
          ),
          child: Text(
            '${selectedDate.toLocal()}'.split(' ')[0],
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      );
  }

  Widget _dateButton() {
    return Container(
        child: RaisedButton(
          onPressed: () => _selectDate(context),
          child: Text('${selectedDate.toLocal()}'.split(' ')[0]),
        ),
        
      
    );
  }

  Widget _dateContainer(String title) {
    return Container(
      // margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
      child: _searchDateButton(),
    );
  }

  Widget _chooseType() {  
    return Container(
      child: DropdownButton(
        hint: Text('Type'),
        items: types.map((String valueType) {
          return DropdownMenuItem<String>(
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
      margin: EdgeInsets.fromLTRB(5, 2, 5, 2),
    );
  }

  Widget _chooseYear() {  
    return Container(
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
      margin: EdgeInsets.fromLTRB(5, 2, 5, 2),
    );
  }

  Widget _chooseDropdown(String title, List<String> listMenu) {
    return Container(
      child: DropdownButton(
        hint: Text(title),
        items: listMenu.map((String value) {
          return DropdownMenuItem(
            child: Text(value),
            value: value,
          );
        }).toList(), 
        onChanged: (String newValue) {
          setState(() {
            dropdownLocation = newValue;
          });
        },
        value: dropdownLocation,
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
      margin: EdgeInsets.fromLTRB(5, 2, 5, 2),
    );
  }

  Widget _searchButton() {
      return InkWell(
        onTap: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
          // printCategoryDocument();
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
            'Search',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      );
  }
  

  @override 
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // _buildTitle('Category'),
          _buildBody(context),
          // _buildTitle('Sub Category'),
          _buildBodySub(context),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _chooseType(),
                ),
                Expanded(
                  child: _chooseYear(),
                ),
                
              ],
            ),
          ),
          
          // _buildTitle('Location'),
          _chooseDropdown('Location', location),
          // _buildTitle('Transport'),
          _chooseDropdown('Transport', transport),
          _buildTitle('Start Date'),
          _searchDateButton(),
          
          
          _buildTitle('End Date'),
          _searchDateButton(),
          SizedBox(height: 130),
          _searchButton(),
          
          
          

        ],
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