class EmailTileContents {
  List<String> sender;
  String subject;
  String snippet;
  List<String> attachments;
  String avatarUrl;
  int unreadCount;

  //constructor
  EmailTileContents(
      {this.sender,
      this.subject,
      this.snippet,
      this.attachments,
      this.avatarUrl,
      this.unreadCount,
      });
}
