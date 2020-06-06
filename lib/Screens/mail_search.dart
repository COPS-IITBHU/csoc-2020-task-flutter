import 'dart:async';
import 'package:flutter/material.dart';
import '../Models/maildb.dart';
import '../Utility/database_settings.dart';
import '../Screens/mail_template.dart';
import 'package:sqflite/sqflite.dart';


class SearchList extends StatefulWidget{

  final String str;
  SearchList(this.str);

  @override
  State<StatefulWidget> createState() => SearchListState(this.str);
}

class SearchListState extends State<SearchList>{
  DatabaseHelper databaseHelper= DatabaseHelper();

  String str;
  SearchListState(this.str);

  List<MailDB> searchList;
  int count=0;

  TextEditingController searchController1= TextEditingController();

  @override
  void dispose(){
    searchController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
      if(searchList==null){
      searchList=List<MailDB>();
      searchEmailView(str);
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
                 Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(1,18.0,1,1),
                  child: TextField(
                    controller: searchController1,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Search',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search), 
                        onPressed: () => searchEmailView(searchController1.text)
                        ),
                      prefixIcon: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () => navigateToMain()
                        )
                      ),
                    ),
                  ),
                  Text('SEARCH RESULTS'),
                Expanded(
                  child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: count,
                  itemBuilder: (BuildContext context, int position){
                  return  
                  GestureDetector(
                    onTap: ()=> navigateToDetail(this.searchList[position]),
                    child: Card(
                    color: Colors.white,
                    elevation: 2.0,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.people),
                        ),
                      title: Text(this.searchList[position].subject, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(subbody1(this.searchList[position].mail)),
                      trailing: Text(this.searchList[position].date, style: TextStyle(fontWeight: FontWeight.w100, fontSize: 10.0)),
                    )
                  )
                  );
                  }
                  )
                )
          ]
        )
      )
    );
  }

   String subbody1(String val){
    if (val.length<=30)
    return val;
    else
    return val.substring(0,28)+"..";
  }

  void navigateToMain(){
    Navigator.pop(context,true);   
  } 

  void navigateToDetail(MailDB detail){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return EmailShow(detail);
    }));
  }

  void searchEmailView(String str1){
    final Future<Database> db= databaseHelper.initializeDatabase();
    db.then((database){
      Future<List<MailDB>> mailListFuture = databaseHelper.getSearchList(str1);
      mailListFuture.then((searchList){
        setState(() {
          this.searchList=searchList;
          this.count=searchList.length;
          if (this.count==0){
            alertmessage('Status', 'No email matches search value');
          }
        });
      });
    });
  }

  void alertmessage(String title, String message){

    AlertDialog alertDialog= AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_)=> alertDialog);
  }
}


                  
                  
                
                
                  
            
          
        
    
  

    
  