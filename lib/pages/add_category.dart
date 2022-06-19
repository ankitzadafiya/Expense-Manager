import 'package:expense_manager/scoped_models/main.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:math';

import 'package:scoped_model/scoped_model.dart';

class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  @override
  void initState() {
    super.initState();
  }

  bool ispressed = false;
  var setcolor;
  var savecodepoint;
  var iconData;
  var selecticonid;
  var title;
  var iconpoint;

  final random = new Random();
  var num;
  String name;
  String id;
  IconData icon;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _catData = {
    "id": null,
    "name": null,
    "iconCode": null,
  };

  _generate() {
    num = random.nextDouble();
    id = num.toString();
    print(id);
  }

  Widget _showIconGrid() {
    var ls = [
      MdiIcons.billiards,
      MdiIcons.home,
      MdiIcons.car,
      MdiIcons.shopping,
      MdiIcons.usbFlashDrive,
      MdiIcons.certificate,
      MdiIcons.taxi,
      MdiIcons.television,
      MdiIcons.cigar,
      MdiIcons.smoking,
      MdiIcons.heartFlash,
      MdiIcons.carSports,
      MdiIcons.drone,
      MdiIcons.hairDryer,
      MdiIcons.castEducation,
      MdiIcons.fruitGrapes,
      MdiIcons.instagram,
      MdiIcons.security,
      MdiIcons.network,
      MdiIcons.officeBuilding,
      MdiIcons.safetyGoggles,
      MdiIcons.trademark,
      MdiIcons.tea,
      MdiIcons.coffee,
      MdiIcons.googleHome,
      MdiIcons.gasStation,
      MdiIcons.parking,
      MdiIcons.truck,
      MdiIcons.powerCycle,
      MdiIcons.bike,
      MdiIcons.receipt,
      MdiIcons.pizza,
      MdiIcons.handWater,
      MdiIcons.harddisk,
      MdiIcons.dumbbell,
      MdiIcons.yoga,
      MdiIcons.youtubeGaming,
      MdiIcons.youtubeSubscription,
      MdiIcons.cat,
      MdiIcons.electricSwitch,
      MdiIcons.airConditioner,
      MdiIcons.cameraGopro,
      MdiIcons.weatherSunset
    ];

    return GridView.count(
      crossAxisCount: 7,
      mainAxisSpacing: 12.5,
      children: List.generate(ls.length, (index) {
        iconData = ls[index];

        return GestureDetector(
          onTap: () {
            print("Clicked");
          },
          child: IconButton(

              //highlightColor: Colors.yellowAccent,

              splashColor: Colors.yellowAccent,
              iconSize: 30.0,
              color: ispressed == true && selecticonid == iconData
                  ? Colors.yellowAccent
                  : Colors.white,
              onPressed: () {
                selecticonid = ls[index];
                iconpoint = ls[index].codePoint;
                print('$selecticonid Clicked');
                print('$iconpoint Clicked');
                setState(() {
                  print("Setstate called");

                  ispressed = !ispressed;

                  print(ispressed);
                });
              },
              icon: Icon(
                iconData,
              )),
        );

        /*return IconButton(
          //highlightColor: Colors.yellowAccent,
          splashColor: Colors.yellowAccent,
          iconSize: 30.0,
            color: ispressed == true && selecticonid == iconData
                ? Colors.yellowAccent
                : Colors.white,
            onPressed: () {
              selecticonid = ls[index];
              print('$selecticonid Clicked');
              setState(() {
                print("Setstate called");
                ispressed = !ispressed;
                print(ispressed);
              });
            },
            icon: Icon(
              iconData,
            ));*/
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, _, MainModel model) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Add New Category"),
          ),
          body: Container(
            padding: EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: TextFormField(
                    validator: (String value) {
                      if (value.length <= 0) {
                        return "Please Enter a Valid Title";
                      }
                    },
                    decoration: InputDecoration(labelText: "Title"),
                    onSaved: (String text) {
                      title = text;
                      _catData['name'] = text;
                    },
                    /*onChanged: (String text) {
                      _catData['name'] = text;
                    },*/
                  ),
                ),
                Container(
                  child: Text(
                    "Pick An Icon : ",
                    style: TextStyle(
                        letterSpacing: 1.5, fontWeight: FontWeight.w400),
                  ),
                  margin: EdgeInsets.all(12.0),
                ),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: _showIconGrid())),
                RaisedButton(
                  child: Text("Create"),
                  onPressed: () async {
                    _generate();

                    if (!_formKey.currentState.validate()) {
                      return "Valid Data Not Found";
                    }
                    _formKey.currentState.save();

                    _catData['id'] = id;
                    _catData['title'] = title;
                    _catData['iconCode'] = iconpoint;

                    /*final Map<String, dynamic> _catData = {
                      "id": "77",
                      "name": "dcxfdfd",
                      "iconCode": MdiIcons.exitRun.codePoint,
                    };*/

                    model.addCategory(
                        id: _catData['id'],
                        name: _catData['name'],
                        iconCode: _catData['iconCode']);

                        Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
