import 'package:expense_manager/scoped_models/main.dart';
import 'package:expense_manager/utils/data_cruncher.dart';
import 'package:expense_manager/widgets/categories/category_summary.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ExpenseOverview extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ExpenseOverviewState();
  }
}

var seriesdata;

class _ExpenseOverviewState extends State<ExpenseOverview> {
  final dataCruncher = DataCruncher();
  String timeSummary = "week";

  double budget;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget widget, MainModel model) {
        if (model.finalbudget != "") {
          budget = double.parse(model.finalbudget);
          budget = budget - dataCruncher.getMonthTotal(model.allExpenses);
        }

        var daytotal=dataCruncher.getDayTotal(model.allExpenses);
        print(daytotal);

        List topCategories = dataCruncher.getTopCategories(
            model.allCategories, model.allExpenses, model.userCurrency);

        seriesdata = dataCruncher.generateCategoryChart(
            model.allCategories, model.allExpenses, model.userCurrency);

        return Scaffold(
          body: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(
              FocusNode(),
            ),
            child: SafeArea(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.grey[900],
                    expandedHeight: 280,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        child: SafeArea(
                          bottom: false,
                          top: true,
                          child: Column(
                            children: <Widget>[
                              /*Row(
                                children: <Widget>[
                                  SizedBox(width: 20,),
                                  InkWell(
                                    onTap: () {
                                      print("Clicked");
                                      Navigator.pop(context);
                                    },
                                    child: Icon(Icons.arrow_back)),
                                ],
                              ),*/

                              Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 30),
                                child: Row(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        print("Clicked");
                                        Navigator.pop(context);
                                      },
                                      child: Icon(
                                        Icons.arrow_back,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 14,
                                    ),
                                    Text(
                                      "Expense Overview",
                                      style: TextStyle(
                                        letterSpacing: 2.5,
                                        color: Colors.white,
                                        fontSize: 28.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Total Expenses : ",
                                    style: TextStyle(
                                      letterSpacing: 1.0,
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    "${model.userCurrency}${dataCruncher.getTotal(model.allExpenses).toStringAsFixed(2)}",
                                    style: TextStyle(
                                      letterSpacing: 1.0,
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                               Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Total This Day : ",
                                    style: TextStyle(
                                      letterSpacing: 1.0,
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    "${model.userCurrency}${dataCruncher.getDayTotal(model.allExpenses).toStringAsFixed(2)}",
                                    style: TextStyle(
                                      letterSpacing: 1.0,
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                               Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Total This Week : ",
                                      style: TextStyle(
                                        letterSpacing: 1.5,
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                          "${model.userCurrency}${dataCruncher.getWeekTotal(model.allExpenses).toStringAsFixed(2)}",
                                      style: TextStyle(
                                        letterSpacing: 1.5,
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Total This Month : ",
                                    style: TextStyle(
                                      letterSpacing: 1.0,
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    "${model.userCurrency}${dataCruncher.getMonthTotal(model.allExpenses).toStringAsFixed(2)}",
                                    style: TextStyle(
                                      letterSpacing: 1.0,
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                                    Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    model.finalbudget != ""
                                        ? "Budget left : "
                                        : "",
                                    style: TextStyle(
                                      letterSpacing: 1.5,
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    model.finalbudget != ""
                                        ? "${model.userCurrency}${budget.toStringAsFixed(2)}"
                                        : "",
                                    style: TextStyle(
                                      letterSpacing: 1.5,
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Flexible(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Breakdown by Category',
                                      style: TextStyle(
                                        letterSpacing: 1.5,
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    floating: false,
                    delegate: _SliverAppBarDelegate(
                        child: PreferredSize(
                      preferredSize: Size.fromHeight(270.0),
                      child: Container(
                        color: Colors.grey[900],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    )),
                  ),
                 /* SliverPadding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                  ),*/
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return CategorySummary(topCategories[index].name,
                            topCategories[index].total, model.userCurrency);
                      },
                      childCount: topCategories.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final PreferredSize child;

  _SliverAppBarDelegate({this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _container();
  }

  @override
  double get maxExtent => child.preferredSize.height-30;

  @override
  double get minExtent => child.preferredSize.height-30;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

  Widget _container() {
    return Container(
      height: 350,
      child: charts.PieChart(
        seriesdata,
        animate: true,
        defaultRenderer: new charts.ArcRendererConfig(
          layoutPaintOrder: 1,
          arcRendererDecorators: [
            charts.ArcLabelDecorator(
              showLeaderLines: true,
              labelPosition: charts.ArcLabelPosition.auto,
              leaderLineStyleSpec: charts.ArcLabelLeaderLineStyleSpec(
                  color: charts.Color.white, length: 12, thickness: 1),
              insideLabelStyleSpec: charts.TextStyleSpec(
                color: charts.Color.white,
                fontSize: 10,
              ),
              outsideLabelStyleSpec: charts.TextStyleSpec(
                color: charts.Color.white,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
