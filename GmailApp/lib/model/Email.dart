class Email {
  int _id;
  String _sender;
  String _reciever;
  String _subject;
  String _compose;
  String _date;
  int _star;
  String _color;

  Email(this._sender, this._reciever, this._subject, this._compose, this._date,
      this._star, this._color);

  Email.withId(this._id, this._sender, this._reciever, this._compose,
      this._subject, this._date, this._star, this._color);

  int get id => _id;
  String get sender => _sender;
  String get reciever => _reciever;
  String get subject => _subject;
  String get compose => _compose;
  String get date => _date;
  int get star => _star;
  String get color => _color;

  set sender(String newSender) {
    this._sender = newSender;
  }

  set reciever(String newReciever) {
    this._reciever = newReciever;
  }

  set subject(String newSubject) {
    if (newSubject.length <= 255) {
      this._subject = newSubject;
    }
  }

  set compose(String newCompose) {
    if (newCompose.length <= 255) {
      this._compose = newCompose;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  set star(int newStar) {
    if (newStar >= 1 && newStar <= 2) {
      this._star = newStar;
    }
  }

  set color(String newColor) {
    this._color = newColor;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = _id;
    }
    map['sender'] = _sender;
    map['reciever'] = _reciever;
    map['subject'] = _subject;
    map['compose'] = _compose;
    map['date'] = _date;
    map['star'] = _star;
    map['color'] = _color;

    return map;
  }

  Email.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._sender = map['sender'];
    this._reciever = map['reciever'];
    this._subject = map['subject'];
    this._compose = map['compose'];
    this._date = map['date'];
    this._star = map['star'];
    this._color = map['color'];
  }
}
