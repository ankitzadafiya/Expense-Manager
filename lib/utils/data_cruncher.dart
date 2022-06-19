import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:expense_manager/models/CategoryData.dart';
import 'package:expense_manager/models/category.dart';
import 'package:expense_manager/models/expense.dart';

class DataCruncher {
  List<charts.Series<CategoryData, int>> generateCategoryChart(
      List<Category> categories, List<Expense> expenses, String currency) {
    List<Map<String, dynamic>> _categoryData = [];

    categories.forEach(
      (category) {
        _categoryData.add(
          {
            "domainID": Random().nextInt(1000000),
            "id": category.id,
            "name": category.name,
            "count": 0,
            "total": 0,
          },
        );
      },
    );

    expenses.forEach(
      (expense) {
        _categoryData.forEach(
          (category) {
            if (expense.category == category["id"]) {
              category["count"] += 1;
              category["total"] += (double.parse(expense.amount) / 100).round();
            }
          },
        );
      },
    );

    List<CategoryData> data = [];

    int i = 0;
    _categoryData.forEach(
      (category) {
        if (category["count"] != 0) {
          data.add(CategoryData(
              i, category["count"], category["name"], category["total"]));
          i++;
        }
      },
    );

    // FILTER

    data.sort(
      (a, b) {
        return a.total < b.total ? 1 : -1;
      },
    );

    List<CategoryData> output = data.take(6).toList();

    var total = 0;
    var count = 0;
    for (var i =6; i < data.length; i++) {
      total += data[i].total;
      count += data[i].count;
    }

    CategoryData others = CategoryData(7, count, "Other", total);

    output.add(others);

    if (output.length > 0) {
      return [
        charts.Series<CategoryData, int>(
          id: 'Categories',
          domainFn: (CategoryData category, _) => category.id,
          measureFn: (CategoryData category, _) => category.total,
          colorFn: (CategoryData category, _) => category.color,
          data: output,
          labelAccessorFn: (CategoryData row, _) =>
              '${row.name} $currency${row.total.toString()}',
        )
      ];
    } else {
      return null;
    }
  }

  List<CategoryData> getTopCategories(
      List<Category> categories, List<Expense> expenses, String currency) {
    List<Map<String, dynamic>> _categoryData = [];

    categories.forEach(
      (category) {
        _categoryData.add(
          {
            "domainID": Random().nextInt(1000000),
            "id": category.id,
            "name": category.name,
            "count": 0,
            "total": 0,
          },
        );
      },
    );

    expenses.forEach(
      (expense) {
        _categoryData.forEach(
          (category) {
            if (expense.category == category["id"]) {
              category["count"] += 1;
              category["total"] += (double.parse(expense.amount) / 100).round();
            }
          },
        );
      },
    );

    List<CategoryData> data = [];

    int i = 0;
    _categoryData.forEach(
      (category) {
        if (category["count"] != 0) {
          data.add(CategoryData(
              i, category["count"], category["name"], category["total"]));
          i++;
        }
      },
    );

    // FILTER

    data.sort(
      (a, b) {
        return a.total < b.total ? 1 : -1;
      },
    );

    return data;
  }

  double getMonthTotal(expenses) {
    double total = 0;

    expenses.forEach(
      (Expense expense) {
        DateTime expenseDate =
            DateTime.fromMillisecondsSinceEpoch(int.parse(expense.createdAt));
        if (expenseDate.month == DateTime.now().month &&
            expenseDate.year == DateTime.now().year) {
          double price = double.parse(expense.amount) / 100;
          total = total + price;
        }
      },
    );
    return total;
  }

  double getDayTotal(expenses) {
    double total = 0;

    expenses.forEach(
      (Expense expense) {
        DateTime expenseDate =
            DateTime.fromMillisecondsSinceEpoch(int.parse(expense.createdAt));
        if (expenseDate.day == DateTime.now().day) {
          double price = double.parse(expense.amount) / 100;
          total = total + price;
        }
      },
    );
    return total;
  }

  double getWeekTotal(expenses) {
    double total = 0;
    int currentDay = DateTime.now().weekday;
    DateTime startWeek =
        DateTime.now().subtract(Duration(days: currentDay - (currentDay - 1)));
    int start = DateTime(startWeek.year, startWeek.month, startWeek.day)
        .millisecondsSinceEpoch;
    DateTime endWeek = DateTime.now().add(Duration(days: 7 - currentDay));
    int end = DateTime(endWeek.year, endWeek.month, endWeek.day, 23, 59)
        .millisecondsSinceEpoch;
    expenses.forEach(
      (Expense expense) {
        int createdAt = int.parse(expense.createdAt);
        if (createdAt >= start && createdAt <= end) {
          double price = double.parse(expense.amount) / 100;
          total = total + price;
        }
      },
    );
    return total;
  }

  double getTotal(expenses) {
    double total = 0;
    expenses.forEach(
      (Expense expense) {
        double price = double.parse(expense.amount) / 100;
        total = total + price;
      },
    );
    return total;
  }
}
