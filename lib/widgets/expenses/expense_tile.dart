import 'package:cached_network_image/cached_network_image.dart';
import 'package:expense_manager/models/category.dart';
import 'package:expense_manager/models/expense.dart';
import 'package:expense_manager/pages/edit_expense.dart';
import 'package:expense_manager/widgets/expenses/DetailsImage.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final int index;
  final String currency;
  final Function expenseCategory;
  final Function deleteExpense;
  ExpenseTile(this.expense, this.index, this.expenseCategory, this.currency,
      this.deleteExpense);

  _buildModelSheet(BuildContext context, Category category) {
    return Container(
      height: expense.note.split("\n").length >= 3 || expense.note.length > 20
          ? (MediaQuery.of(context).size.height)
          : (MediaQuery.of(context).size.height),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Icon(
            category.iconCode != null
                ? IconData(
                    category.iconCode,
                    fontPackage: 'material_design_icons_flutter',
                    fontFamily: 'Material Design Icons',
                  )
                : MdiIcons.cashRegister,
            color: Theme.of(context).accentColor,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 10.0,
              left: 5.0,
              right: 5.0,
            ),
            child: Text(
              expense.title,
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 6.0,
              vertical: 2.5,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Text(
              currency +
                  (double.parse(expense.amount) / 100).toStringAsFixed(2),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          expense.note != ""
              ? Expanded(
                  flex: 3,
                  child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: ListView(
                        children: <Widget>[
                          Text(
                            expense.note,
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            maxLines: 4,
                          ),
                        ],
                      )),
                )
              : Container(),
          expense.invoiceURl != ""
              ? Expanded(
                  flex: 6,
                  child: Container(
                      padding: EdgeInsets.only(top: 5.0),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return DetailsImage(expense);
                            }));
                          },
                          child: Hero(
                              tag: 'imageHero',
                              child: CachedNetworkImage(
                                imageUrl: expense.invoiceURl,
                              )))),
                )
              : Container(),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.center,
              child: ButtonBar(
                buttonPadding: EdgeInsets.only(bottom: 10.0),
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditExpense(expense),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.edit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final category = expenseCategory(expense.category);
    List<String> date =
        DateTime.fromMillisecondsSinceEpoch(int.parse(expense.createdAt))
            .toIso8601String()
            .substring(0, 10)
            .split("-");

    return Dismissible(
      onDismissed: (direction) {
        deleteExpense(expense.key);
      },
      direction: DismissDirection.endToStart,
      dismissThresholds: {DismissDirection.endToStart: 0.6},
      background: Container(
        color: Colors.red[700],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "Delete",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            )
          ],
        ),
      ),
      confirmDismiss: (DismissDirection direction) async {
        bool shouldDelete = false;
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Are you sure you want to delete this expense?"),
              title: Text("Delete"),
              actions: <Widget>[
                MaterialButton(
                  child: Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    shouldDelete = true;
                    Navigator.of(context).pop();
                  },
                ),
                MaterialButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    shouldDelete = false;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );

        if (shouldDelete) {
          return true;
        } else {
          return false;
        }
      },
      key: Key(expense.key),
      child: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.only(bottom: 2.0),
            elevation: 5.5,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return _buildModelSheet(context, category);
                    });
              },
              splashColor: Colors.blue[100],
              child: ListTile(
                leading: Icon(
                  category.iconCode != null
                      ? IconData(
                          category.iconCode,
                          fontFamily: 'Material Design Icons',
                          fontPackage: 'material_design_icons_flutter',
                        )
                      : MdiIcons.cashRegister,
                  color: Colors.blueAccent,
                ),
                title: Text(
                  expense.title,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(currency +
                      (currency == "€"
                          ? (double.parse(expense.amount) / 100)
                              .toStringAsFixed(2)
                              .replaceAll(".", ",")
                          : (double.parse(expense.amount) / 100)
                              .toStringAsFixed(2))),
                ),
                trailing: Text(currency == "\$"
                    ? "${date[1]}-${date[2]}-${date[0]}"
                    : "${date[2]}-${date[1]}-${date[0]}"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
