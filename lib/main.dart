import 'package:expense_manager/pages/get_started.dart';
import 'package:expense_manager/pages/home.dart';
import 'package:expense_manager/pages/login.dart';
import 'package:expense_manager/scoped_models/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:core';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
String deviceTheme = "dark";
bool firstRun;
bool fingeprintenable=false;


final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.grey[700],
    primaryColorLight: Colors.grey[850],
    accentColor: Colors.blue,
    textSelectionHandleColor: Colors.blue);
    

restartApp() {
  main();
}

  getFirstRun() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  firstRun=(pref.getBool("firstRun") ?? false);
  print(firstRun);
}

setfirstruntrue() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.setBool("firstRun", true);
}

setfirstrunfalse() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.setBool("firstRun", false);
}


final LocalAuthentication _localAuthentication = LocalAuthentication();
bool _hasFingerPrintSupport = false;
String _authorizedOrNot = "Not Authorized";
List<BiometricType> _availableBuimetricType = List<BiometricType>();

  Future<void> _getBiometricsSupport() async {
    bool hasFingerPrintSupport = false;
    try {
      hasFingerPrintSupport = await _localAuthentication.canCheckBiometrics;
    } catch (e) {
      print(e);
    }
      _hasFingerPrintSupport = hasFingerPrintSupport;
      print(_hasFingerPrintSupport);
  }

  Future<void> _getAvailableSupport() async {
    
    List<BiometricType> availableBuimetricType = List<BiometricType>();
    try {
      availableBuimetricType =
          await _localAuthentication.getAvailableBiometrics();
    } catch (e) {
      print(e);
    }
      _availableBuimetricType = availableBuimetricType;
      print(_availableBuimetricType);
  }

  Future<void> _authenticateMe() async {
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Authenticate for Testing", 
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } catch (e) {
      print(e);
    }
    _authorizedOrNot = authenticated ? "Authorized" : "Not Authorized";
    if(_authorizedOrNot=="Not Authorized")
    {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
     print(_authorizedOrNot);
  }

  
checksec() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  fingeprintenable=(pref.getBool("EnableFingeprint") ?? false);

  if(fingeprintenable){
     _getBiometricsSupport();
    _getAvailableSupport();
    _authenticateMe();
  }
}

logout() {
    runApp(MyApp(darkTheme));
  }

  void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  setfirstruntrue();
  String theme = (pref.getString("theme") ?? "dark");
  deviceTheme = theme;
  if (theme == "dark") {
    runApp(MyApp(darkTheme));
  }
}

class MyApp extends StatefulWidget {
  final ThemeData theme;
  MyApp(this.theme);
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {

  MainModel model = MainModel();

  @override
  void initState() {
    super.initState();
    checksec();
    getFirstRun();
  }

  @override
  void didUpdateWidget(MyApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    checksec();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense Manager',
        home: _authenticateUser(model.loginUser, model),
        theme: widget.theme,
      ),
    );
  }
}


Widget _authenticateUser(Function loginUser, MainModel model) {
  return StreamBuilder<FirebaseUser>(
    stream: _auth.onAuthStateChanged,
    builder: (BuildContext context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return _buildSplashScreen();
      } else {
        if (snapshot.hasData) {
          dynamic user = snapshot.data;

          loginUser(user.uid, user.email);

          return HomePage();
        }
        return firstRun == true ? Carroussel() : LoginScreen();
      }
    },
  );
}


Widget _buildSplashScreen() {
  return Scaffold(
    body: Center(
      child: Text("Loading..."),
    ),
  );
}
