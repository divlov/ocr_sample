import 'package:flutter/material.dart';

class ErrorBox extends StatelessWidget {

  final bool noDataFound;

  const ErrorBox(this.noDataFound,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[800]!)),
      margin:
      EdgeInsets.only(top: 20, left: 40,right: 40),
      padding: EdgeInsets.all(10),
      constraints:
      noDataFound ? null : BoxConstraints(maxHeight: 0),
      height: noDataFound ? 50 : 0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (noDataFound)
            Icon(
              Icons.error,
              color: Colors.grey[800],
            ),
          SizedBox(width: 5),
          Flexible(
              child: Text('No data found',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800]))),
        ],
      ),
    );
  }
}
