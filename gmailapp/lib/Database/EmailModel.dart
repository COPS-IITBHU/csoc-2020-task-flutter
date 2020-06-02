class Emails {
  int id;
  String to;
  String from;
  String subject;
  String message;

  Emails({this.id, this.to, this.from,this.message,this.subject});
  factory Emails.fromMap(Map<String, dynamic> data) => new Emails(
        id: data["id"],
        to: data["toCol"],
        from: data["fromCol"],
        subject: data["subject"],
        message:data['message']
    );
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'toCol': to,
      'fromCol': from,
      'subject':subject,
      'message':message
    };
  }
  @override
  String toString() {
    return 'Emails{id: $id, to: $to, from: $from,subject: $subject,message:$message}';
  }
}