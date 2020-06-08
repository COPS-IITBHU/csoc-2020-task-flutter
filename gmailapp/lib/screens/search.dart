import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gmailapp/models/helpers.dart';
import 'package:gmailapp/models/mail.dart';
import './detail_view.dart';
import 'dart:async';


class DataSearch extends SearchDelegate<String> {


  List<Mail> mailList  = [];
  var sugg =[];
  Map<String,int> getIndex ={};
  var sub = [] ;
  int count;
  DbHelper databaseHelper = DbHelper();
  void updateListView1() {
    final Future<Database> dbFuture = databaseHelper.initializeDb();
    dbFuture.then((db) {
      Future<List<Mail>> mailListFuture = databaseHelper.getMailList();
      mailListFuture.then((newList) {
        
          this.mailList = newList;
          this.count = newList.length;
          for(int i=0;i<count;i++)
          {
            sub.add(mailList[i].sub);
            getIndex[mailList[i].sub]= i;
          }
          sugg.clear();
          for(int i=0;i<3;i++)
          {
             sugg.add(sub[i]);
          }
      });
    });
  }
  
 
  @override
  List<Widget> buildActions(BuildContext context) {
    
    return [
      IconButton(
        icon: Icon(Icons.clear),
        color: Colors.purple,
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
      sub.clear();
     // sugg.clear();
      getIndex.clear();
      updateListView1();
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
          color: Colors.purple,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  buildResults(BuildContext context)   {

    return null ;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    
   var  list = query.isEmpty
        ? sugg
        : sub.where((element) => element.startsWith(query)).toList();

        

     if(list.length==0)
     {
         return Scaffold( 
              
              body : Image.asset('assets/no_result.gif'),
             );
     }
     

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: ()  async {
           showToast(context);
           await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return  MailDetail(mailList.elementAt(getIndex[list[index]]));
        }));
        }, 
        leading: Icon(Icons.contact_mail),
        title: RichText(
          text: TextSpan(
              text: list[index].substring(0, query.length),
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
              children: [
                TextSpan(
                  text: list[index].substring(query.length),
                  style: TextStyle(color: Colors.black, fontSize: 20),
                )
              ]),
        ),
      ),
      itemCount: list.length,
    );
  
  

   }
  static void showToast(BuildContext context) {

    OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
        builder: (context) => ToastWidget()
    );
    Overlay.of(context).insert(overlayEntry);
    Timer(Duration(seconds: 3), () =>  overlayEntry.remove());

   }
  }

  class ToastWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : Center(child: Image.asset('assets/gmailsearch.gif',fit: BoxFit.fill,)),
    );
  }
}