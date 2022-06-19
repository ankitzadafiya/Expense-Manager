import 'package:expense_manager/main.dart';
import 'package:expense_manager/pages/add_category.dart';
import 'package:expense_manager/scoped_models/main.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<FormState> _resetFormKey = GlobalKey<FormState>();
  String _resetFormData = "";

  bool darkThemeVal;
  bool swicthval = false;
  @override
  void initState() {
    super.initState();
    getData();
    darkThemeVal = true;
  }

  getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    fingeprintenable = (pref.getBool("EnableFingeprint") ?? false);
  }

  saveData(bool fingerprintenable) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("EnableFingeprint", fingerprintenable);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget widget, MainModel model) {
        return GestureDetector(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.grey[900],
                pinned: false,
                floating: false,
                expandedHeight: 150.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 40),
                    child: SafeArea(
                      bottom: false,
                      top: true,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "Settings",
                                style: TextStyle(
                                  letterSpacing: 2.5,
                                  color: Colors.white,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                width: 55.0,
                              ),
                              IconButton(
                                icon: Icon(
                                  MdiIcons.logout,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () async {
                                  await GoogleSignIn().signOut();
                                  await FirebaseAuth.instance.signOut();
                                  model.logoutUser();
                                  restartApp();
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    model.authenticatedUser.email,
                                    style: TextStyle(
                                        letterSpacing: 2.5,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 2.0,
                              ),
                              Icon(
                                Icons.verified_user,
                                size: 17.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    Card(
                      margin: EdgeInsets.symmetric(vertical: 3.0),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          padding: EdgeInsets.only(left: 7),
                          child: Text(
                            "Account Settings",
                            style: TextStyle(
                              letterSpacing: 2.0,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      color: Colors.grey[900],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 3.0),
                      color: Colors.grey[800],
                      child: ListTile(
                        title: Text("Reset Password"),
                        trailing: IconButton(
                          icon: Icon(MdiIcons.restore),
                          onPressed: () async {
                            FirebaseUser user =
                                await FirebaseAuth.instance.currentUser();
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: user.email);
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Password reset sent to registered email address."),
                                backgroundColor: Colors.blue[800],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          padding: EdgeInsets.only(left: 7.0),
                          child: Text(
                            "Preferences",
                            style: TextStyle(
                              letterSpacing: 2.0,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      color: Colors.grey[900],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 3.0),
                      color: Colors.grey[800],
                      child: ListTile(
                        title: Text("Currency"),
                        subtitle: Text(model.userCurrency != null
                            ? model.userCurrency
                            : "Loading preferences"),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: model.userCurrency == null
                              ? null
                              : () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        height: 200,
                                        child: ListView(
                                          children: <Widget>[
                                            RadioListTile(
                                              groupValue: model.userCurrency,
                                              value: "₹",
                                              title: Text("INR (₹)"),
                                              activeColor:
                                                  Theme.of(context).accentColor,
                                              onChanged: (String value) {
                                                model.updateCurrency(value);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            RadioListTile(
                                              groupValue: model.userCurrency,
                                              value: "£",
                                              title: Text("Pounds (£)"),
                                              activeColor:
                                                  Theme.of(context).accentColor,
                                              onChanged: (String value) {
                                                model.updateCurrency(value);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            RadioListTile(
                                              groupValue: model.userCurrency,
                                              value: "\$",
                                              title: Text("Dollars (\$)"),
                                              activeColor:
                                                  Theme.of(context).accentColor,
                                              onChanged: (String value) {
                                                model.updateCurrency(value);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            RadioListTile(
                                              groupValue: model.userCurrency,
                                              value: "€",
                                              title: Text("Euros (€)"),
                                              activeColor:
                                                  Theme.of(context).accentColor,
                                              onChanged: (String value) {
                                                model.updateCurrency(value);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 3.0),
                      color: Colors.grey[800],
                      child: ListTile(
                        title: Text("Add Budget"),
                        trailing: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () async{
                              await showDialog(
                                context: context,
                                builder: (context) => buildBudgetDialog(),
                              );

                              model.addBudget(
                                  budget: _resetFormData, context: context);
                            }),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 3.0),
                      color: Colors.grey[800],
                      child: ListTile(
                        title: Text("Add Category"),
                        trailing: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AddCategory(),
                                ),
                              );
                            }),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 3.0),
                      color: Colors.grey[800],
                      child: ListTile(
                        title: Text("Enable Security"),
                        trailing: Switch(
                          value: fingeprintenable,
                          onChanged: (newval) {
                            setState(() {
                              fingeprintenable = newval;
                              saveData(fingeprintenable);
                              if (fingeprintenable) {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
                      return MyApp(darkTheme);
                    }));
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          padding: EdgeInsets.only(left: 7.0),
                          child: Text(
                            "Manage Your Data",
                            style: TextStyle(
                              letterSpacing: 2.0,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      color: Colors.grey[900],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 3.0),
                      color: Colors.grey[800],
                      child: ListTile(
                        title: Text("Clear All Expenses"),
                        subtitle: model.allExpenses.length == 0
                            ? Text("No expenses found.")
                            : Text("Warning: This action is permanent."),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: model.allExpenses.length == 0
                              ? null
                              : () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Delete All Expenses"),
                                        content: Text(
                                            "Are you sure you want to delete all expenses. Warning this action is irreversible."),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text(
                                              "Delete All",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            onPressed: () {
                                              model.clearExpenses();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("Cancel"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 3.0),
                      color: Colors.grey[800],
                      child: ListTile(
                        title: Text("Backup All Expenses"),
                        subtitle: model.allExpenses.length == 0
                            ? Text("No expenses found.")
                            : Text("Save expenses locally."),
                        trailing: IconButton(
                            icon: Icon(Icons.save),
                            onPressed: model.allExpenses.length == 0
                                ? null
                                : () async {
                                    final PermissionHandler _permissionHandler =
                                        PermissionHandler();
                                    var result = await _permissionHandler
                                        .requestPermissions(
                                            [PermissionGroup.storage]);
                                    switch (result[PermissionGroup.storage]) {
                                      case PermissionStatus.granted:
                                        print('permisson granted');
                                        model.backupExpenses();
                                        Scaffold.of(context)
                                            .showSnackBar(SnackBar(
                                          backgroundColor: Colors.blue[800],
                                          content: Text(
                                              "Backup Taken Successfully."),
                                          action: SnackBarAction(
                                            onPressed: () {
                                              Scaffold.of(context)
                                                  .hideCurrentSnackBar();
                                            },
                                            label: "Dismiss",
                                            textColor: Colors.white,
                                          ),
                                        ));

                                        break;
                                      case PermissionStatus.denied:
                                        print('permisson denied');
                                        break;
                                      case PermissionStatus.restricted:
                                        print('permisson restricted');
                                        break;
                                      case PermissionStatus.unknown:
                                        print('permisson unknown');
                                        break;
                                      default:
                                    }
                                  }),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 3.0),
                      color: Colors.grey[800],
                      child: ListTile(
                        title: Text("Restore All Expenses"),
                        subtitle: model.allExpenses.length == 0
                            ? Text("No expenses found.")
                            : Text("Load expenses from file."),
                        trailing: IconButton(
                          icon: Icon(Icons.restore),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Restore Expenses"),
                                  content: Text(
                                      "Are you sure you want to overwrite all expenses. Warning this action is irreversible."),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        "Restore",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        model.restoreExpense();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  buildSaveButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.grey[900],
      ),
      child: MaterialButton(
        onPressed: () async {
          if (!_resetFormKey.currentState.validate()) {
            return "";
          }
          _resetFormKey.currentState.save();

          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Add Budget"),
                content: Text("Budget Added Successfully."),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Okay"),
                  ),
                ],
              );
            },
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.send,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Add",
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  buildCancelButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.grey[900],
      ),
      child: MaterialButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.cancel,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Cancel",
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  buildBudgetDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: 200,
        width: 500,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              "Add Budget",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Card(
              clipBehavior: Clip.none,
              elevation: 3.0,
              margin: EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Form(
                key: _resetFormKey,
                child: TextFormField(
                  onSaved: (String value) => _resetFormData = value,
                  validator: (String value) {
                    if (value.isEmpty ||
                        !RegExp(r"^\-?\(?\$?\s*\-?\s*\(?(((\d{1,3}((\,\d{3})*|\d*))?(\.\d{1,4})?)|((\d{1,3}((\,\d{3})*|\d*))(\.\d{0,4})?))\)?$")
                            .hasMatch(value)) {
                      return "Please enter a valid Budget";
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 15.0,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    hintText: "Budget",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                    hasFloatingPlaceholder: true,
                    prefix: Text("  "),
                    filled: true,
                    fillColor: Colors.grey[600],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildSaveButton(),
                SizedBox(
                  width: 10,
                ),
                buildCancelButton()
              ],
            )
          ],
        ),
      ),
    );
  }
}
