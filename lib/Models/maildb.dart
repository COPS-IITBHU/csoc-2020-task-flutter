class MailDB{

  int _id;
  String _subject;
  String _mail;
  String _sender;
  String _recepient;
  String _date;

  MailDB(this._sender, this._recepient, this._subject, this._date, [this._mail]);
  MailDB.withId(this._id, this._sender, this._recepient, this._subject, this._date, [this._mail]);

  int get id=> _id;
  String get sender=> _sender;
  String get recepient=> _recepient;
  String get subject=> _subject;
  String get mail=> _mail;
  String get date=> _date;

  set sender(String newSender){
    this._sender=newSender;
  }

  set recepient(String newRecepient){
    this._recepient=newRecepient;
  }

  set subject(String newSubject){
    this._subject=newSubject;
  }

  set mail(String newMail){
    this._mail=newMail;
  }

  set date(String newDate){
    this._date=newDate;
  }

  Map<String, dynamic> toMap(){
    var map=Map<String, dynamic>();
    if(id!=null){
      map['id']=_id;
    }
    map['sender']=_sender;
    map['recepient']=_recepient;
    map['subject']=_subject;
    map['mail']=_mail;
    map['date']=_date;

    return map;
  }

  MailDB.fromMapObject(Map<String, dynamic> map){
    this._id=map['id'];
    this._sender=map['sender'];
    this._recepient=map['recepient'];
    this._subject=map['subject'];
    this._mail=map['mail'];
    this._date=map['date'];
  }
}