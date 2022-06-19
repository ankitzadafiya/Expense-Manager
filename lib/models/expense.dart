
import 'package:flutter/material.dart';

class Expense {
  String title;
  String category;
  String amount;
  String createdAt;
  String note;
  String invoiceURl;
  String key;

  Expense({
    @required this.title,
    @required this.amount,
    @required this.key,
    @required this.createdAt,
    this.invoiceURl="",
    this.category = "",
    this.note = "",
  });

  Expense.fromJson(this.key, Map data) {
    title = data['title'];
    category = data['category'];
    amount = data['amount'].toString();
    createdAt = data['createdAt'].toString();
    note = data['note'];
    invoiceURl=data['invoiceURl'];
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'category': category,
    'amount': amount,
    'createdAt': createdAt,
    'note': note,
    'invoiceURl':invoiceURl,
    'key': key,
  };

}
