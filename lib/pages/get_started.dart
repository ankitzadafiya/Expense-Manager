import 'package:expense_manager/main.dart';
import 'package:expense_manager/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Carroussel extends StatefulWidget {
  @override
  _CarrousselState createState() => _CarrousselState();
}

class _CarrousselState extends State<Carroussel> {
  final PageController controller = new PageController();

  String text = 'NEXT';
  String page1Title = "Personalization";
  String page1Description = "Manage your money at your own finger tips !";

  String page2Title = "Detailed Analysis";
  String page2Description = "Analyze your where, how and what of spending !";

  String page3Title = "Security";
  String page3Description = "Fingerprint Authentication makes it more secure !";

  String page4Title = "Instant Cloud Syncing";
  String page4Description = "Access Your Data from anywhere at anytime !";

  int currentPageValue = 0;

  Widget buildScreen(String assetname, String title, String description) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Material(
            type: MaterialType.transparency,
            child: Padding(
              padding: const EdgeInsets.only(top: 32.0, left: 25.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: (){
                    setfirstrunfalse();
                    getFirstRun();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
                      return MyApp(darkTheme);
                    }));
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
              ),
            ),
          ),
          buildscreenImage(assetname, title, description),
        ],
      ),
    );
  }

  buildscreenImage(String passassetName, String title, String description) {
    final String assetName = passassetName;
    final Widget svg = new SvgPicture.asset(
      assetName,
      fit: BoxFit.contain,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Material(
          type: MaterialType.transparency,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 4.5,
                  fontFamily: 'Montserrat-ExtraBold.',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 50.0),
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            constraints: BoxConstraints.loose(Size.infinite),
            height: 260.0,
            width: 300.0,
            child: svg),
        SizedBox(
          height: 30.0,
        ),
        Material(
          type: MaterialType.transparency,
          child: Padding(
            padding: EdgeInsets.only(
                left: 25.0, right: 15.0, top: 15.0, bottom: 15.0),
            child: Row(
              textDirection: TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    description,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontSize: 20.0,
                      letterSpacing: 3.5,
                      fontFamily: 'Montserrat-Thin',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: isActive ? 15 : 10,
      width: isActive ? 15 : 10,
      decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }

  Widget buildText(String text) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () async {
              currentPageValue += 1;
              controller.nextPage(
                  curve: Curves.easeOut,
                  duration: Duration(milliseconds: 1000));
              if (text == 'GO') {
                 setfirstrunfalse();
                    getFirstRun();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
                      return MyApp(darkTheme);
                    }));
              }
            },
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 3.5,
                  fontFamily: 'Montserrat-Thin',
                  fontWeight: FontWeight.w300),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> introWidgetsList = <Widget>[
      buildScreen('assets/vector/undraw_Mobile_application_mr4r.svg',
          page1Title, page1Description),
      buildScreen('assets/vector/white_undraw_financial_data_es63.svg',
          page2Title, page2Description),
      buildScreen('assets/vector/undraw_Security_on_ff2u.svg', page3Title,
          page3Description),
      buildScreen('assets/vector/white_undraw_cloud_sync_2aph.svg', page4Title,
          page4Description),
    ];

    return Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          PageView.builder(
            physics: ClampingScrollPhysics(),
            itemCount: introWidgetsList.length,
            onPageChanged: (int page) {
              getChangedPageAndMoveBar(page);
            },
            controller: controller,
            itemBuilder: (context, index) {
              return introWidgetsList[index];
            },
          ),
          Stack(
            // alignment: AlignmentDirectional.topStart,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      //mainAxisSize: MainAxisSize.min,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        for (int i = 0; i < introWidgetsList.length; i++)
                          if (i == currentPageValue) ...[circleBar(true)] else
                            circleBar(false),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(right: 25.0, bottom: 26.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Visibility(
                      visible: currentPageValue == 0 ||
                              !(currentPageValue == introWidgetsList.length - 1)
                          ? true
                          : false,
                      child: buildText('NEXT'),
                      replacement: buildText('GO'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    SharedPreferences pref = await SharedPreferences.getInstance();
    firstRun = await pref.setBool("firstRun", false);
  }
}
