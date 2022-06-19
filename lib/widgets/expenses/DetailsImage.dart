import 'package:cached_network_image/cached_network_image.dart';
import 'package:expense_manager/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DetailsImage extends StatefulWidget {

  final Expense expense;
  DetailsImage(this.expense);
  @override
  _DetailsImageState createState() => _DetailsImageState();
}

class _DetailsImageState extends State<DetailsImage> {

  @override
  void initState() { 
     SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: CachedNetworkImage(imageUrl: widget.expense.invoiceURl)
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}