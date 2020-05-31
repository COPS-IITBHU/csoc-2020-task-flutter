import 'package:flutter/material.dart';

String myEmail = "me@nowhere.net";

class EmailItem {
  String avatar, description, subject, recName, recEmail, sender;
  int colorIndex;
  DateTime date;
  bool fav, read;
  EmailItem({
    this.avatar,
    this.subject,
    this.recName,
    this.recEmail,
    this.description,
    this.date,
    this.fav,
    this.read = false,
    this.colorIndex,
    this.sender = "",
  });

  void toggleFav() {
    print("a callback");
    this.fav = !this.fav;
  }
}

class EmailData extends ChangeNotifier {
  List<EmailItem> defaultData = <EmailItem>[
    EmailItem(
      avatar: "X",
      description: "Do not open!",
      subject: "Do not open!",
      fav: true,
      date: DateTime.now(),
      recEmail: "anonymous@secret.com",
      recName: "Anonymous",
      read: false,
      colorIndex: 1,
    ),
    EmailItem(
      avatar: "M",
      description:
          "Congratulations! You have won 1 million dollars. Click here to claim.",
      subject: "Win money",
      fav: true,
      date: DateTime.now(),
      recEmail: "notspam@truth.com",
      recName: "Martin",
      read: false,
      colorIndex: 5,
    ),
    EmailItem(
      avatar: "G",
      description: "New app launched!!!",
      subject: "Gmail 17",
      fav: false,
      date: DateTime(2020, 5, 31, 20),
      recEmail: "news@google.com",
      recName: "Google",
      read: false,
      colorIndex: 0,
    ),
    EmailItem(
      avatar: "CD",
      description:
          """Cyberpunk 2077 is an upcoming role-playing video game developed and published by CD Projekt. It is scheduled to be released for Microsoft Windows, PlayStation 4, Stadia, and Xbox One on 17 September 2020. Adapted from the Cyberpunk franchise, it takes place in dystopian Night City, an open world with six distinct regions. Players assume the role of V, a customisable mercenary, in a first-person perspective, acquiring skills in hacking and machinery, an arsenal of ranged weapons, and options for melee combat. Both lethal and non-lethal playthroughs are possible.

      Cyberpunk 2077 is being developed using the REDengine 4 by a team of 500, exceeding the number that worked on the studio's previous game, The Witcher 3: Wild Hunt. CD Projekt launched a new division in Wrocław, Poland and partnered with Digital Scapes, Nvidia, and QLOC to assist with production. Cyberpunk creator Mike Pondsmith is a consultant, and actor Keanu Reeves has a starring role. The soundtrack features original music by Refused, Grimes, Run the Jewels, AAP Rocky, Gazelle Twin, Ilan Rubin, Richard Devine, Nina Kraviz, Deadly Hunta, Rat Boy, and Tina Guo.
      """,
      subject: "Cyberpunk 2077 launched!!!",
      recName: "CD Projekt Red",
      fav: false,
      date: DateTime(2019, 5, 29, 20),
      recEmail: "store@cdprojektred.net",
      read: false,
      colorIndex: 2,
    ),
  ];

  void toggleFav(EmailItem emailItem) {
    emailItem.toggleFav();
    notifyListeners();
  }

  void addEmail(EmailItem emailItem) {
    defaultData.insert(0, emailItem);
    notifyListeners();
  }

  void deleteEmail(EmailItem emailItem) {
    defaultData.remove(emailItem);
    notifyListeners();
  }

  void read(int index) {
    defaultData[index].read = true;
    notifyListeners();
  }
}
