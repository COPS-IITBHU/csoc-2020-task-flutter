import 'package:flutter/material.dart';
import 'package:gmail/Database/EmailDatabase.dart';
import 'package:gmail/Database/EmailModel.dart';
import 'package:sqflite/sqflite.dart';

import 'emaildetail.dart';

class EmailListView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _EmailListState();
  }
  

}
class _EmailListState extends State<EmailListView>{
  static EmailDatabase emaildb=EmailDatabase();
  Future<Database> dataBase=emaildb.database;
  @override
  Widget build(BuildContext context){    
    return FutureBuilder(
      future: dataBase,
      builder: (context, snapshotdb) {
        if(snapshotdb.data==null){
          return Text("Loading",style: TextStyle(color: Colors.white),);
        }
        Future<List<Emails>> emaillist=emaildb.getEmails(snapshotdb.data);
        return FutureBuilder(
          future: emaillist,
          builder: (context, snapshot) {
            if(snapshot.data==null){
              return Text("Loading emails",style: TextStyle(color: Colors.white),);
            }
            return RefreshIndicator(child:SizedBox(height: MediaQuery.of(context).size.height,child:ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context,index){
              var to = snapshot.data[index].to;
              var arrto=to.split('');
            return Dismissible(
              key: Key(snapshot.data[index].id.toString()),
              background: Container(color:Color.fromRGBO(189, 0, 0, 1)),
              onDismissed: (direction) async{
                await emaildb.deleteCustomer(snapshot.data[index].id, snapshotdb.data);
              },
              child:Card(color: Colors.black,child:ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Emaildetail(snapshot.data[index].id)));
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(arrto[0].toUpperCase(),style: TextStyle(fontSize: 25),),
                ),
              title: Text(snapshot.data[index].subject,style: TextStyle(color: Colors.white,fontSize: 20),),
              subtitle:Text(snapshot.data[index].message,style: TextStyle(color: Colors.white,fontSize: 15),) ,
            )),
            );
        },

      ))
      ,onRefresh: () async {
        setState(() {
          
        });
      },
      );
      },
      );
      },
    );
    
  }

}