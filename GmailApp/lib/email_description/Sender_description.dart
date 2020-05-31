import 'package:flutter/material.dart';

class Details extends StatelessWidget {
  final String sender;
  final String reciever;
  final String date;
  final int width;
  final int height;
  Details(this.sender, this.reciever, this.date, this.width, this.height);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: height.toDouble(),
      width: width.toDouble(),
      decoration: BoxDecoration(
          color: Colors.blue,
          border: Border.all(),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "From :",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    sender,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "To :",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(left: 45),
                  child: Text(
                    reciever,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Date :",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    date,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
