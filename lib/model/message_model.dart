import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:krushapp/model/user_model.dart';

import './aviator_model.dart';
part 'message_model.g.dart';

@HiveType(typeId: 1)
class Message {
  @HiveField(0)
  int id;

  @HiveField(1)
  int senderId;

  @HiveField(2)
  String
      time; // Would usually be type DateTime or Firebase Timestamp in production apps

  @HiveField(3)
  String text;
  @HiveField(4)
  bool isLiked;
  @HiveField(5)
  bool unread;

  @HiveField(6)
  String image;

  @HiveField(7)
  bool sending;

  @HiveField(8)
  String type;

  DateTime messageTime;

  Message({
    this.id,
    this.senderId,
    this.time,
    this.text,
    this.isLiked,
    this.unread,
    this.image,
    this.type,
    this.sending,
  }) {
    var format = DateFormat('yyyy-MM-dd HH:mm:ss');
    messageTime = format.parse(time);
  }

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isLiked = json['isLiked'] == 1;
    unread = json['status'] == 0;
    senderId = json['fromUserId'];
    time = json['created_at'];
    text = json['message'];
    image = json['image'];
    type = json['type'];
    var format = DateFormat('yyyy-MM-dd HH:mm:ss');
    messageTime = format.parse(time);
  }
}

//////////////////// This is the none revealed ppl

// ADMIRERS CONTACTS

// YOU - current user
// final User currentUser = User(
//   id: 0,
//   name: 'Current User',
//   imageUrl: 'assets/images/greg.jpg',
// );

// // USERS
// final User thecutegirl = User(
//   id: 1,
//   name: 'thecutegirl',
//   imageUrl: 'assets/images/f_5.jpg',
// );
// final User sweetcrucher = User(
//   id: 2,
//   name: 'sweetcrucher',
//   imageUrl: 'assets/images/f_4.jpg',
// );
// final User workgirl = User(
//   id: 3,
//   name: 'workgirl',
//   imageUrl: 'assets/images/f_3.jpg',
// );
// final User randomgirl = User(
//   id: 4,
//   name: 'randomgirl',
//   imageUrl: 'assets/images/f_1.jpg',
// );
// final User number1crush = User(
//   id: 5,
//   name: 'number1crush',
//   imageUrl: 'assets/images/m_1.jpg',
// );
// final User crusher = User(
//   id: 6,
//   name: 'crusher',
//   imageUrl: 'assets/images/m_2.jpg',
// );
// final User likingyou = User(
//   id: 7,
//   name: 'likingyou',
//   imageUrl: 'assets/images/f_2.jpg',
// );

// List<User> admirers = [
//   workgirl,
//   randomgirl,
//   number1crush,
//   crusher,
//   likingyou,
//   sweetcrucher,
//   thecutegirl
// ];

// ///////////////// This is the Revealed ppl

// // USERS
// final User greg = User(
//   id: 1,
//   name: 'Greg',
//   imageUrl: 'assets/images/greg.jpg',
// );
// final User james = User(
//   id: 2,
//   name: 'James',
//   imageUrl: 'assets/images/james.jpg',
// );
// final User john = User(
//   id: 3,
//   name: 'John',
//   imageUrl: 'assets/images/john.jpg',
// );
// final User olivia = User(
//   id: 4,
//   name: 'Olivia',
//   imageUrl: 'assets/images/olivia.jpg',
// );
// final User sam = User(
//   id: 5,
//   name: 'Sam',
//   imageUrl: 'assets/images/sam.jpg',
// );
// final User sophia = User(
//   id: 6,
//   name: 'Sophia',
//   imageUrl: 'assets/images/sophia.jpg',
// );
// final User steven = User(
//   id: 7,
//   name: 'Steven',
//   imageUrl: 'assets/images/steven.jpg',
// );

// // FAVORITE CONTACTS
// List<User> favorites = [sam, steven, olivia, john, greg];

// EXAMPLE CHATS ON HOME SCREEN
// List<Message> chats = [
//   Message(
//     sender: workgirl,
//     time: '5:30 PM',
//     text: 'Hey, how\'s it going? What did you do today?',
//     isLiked: false,
//     unread: true,
//   ),
//   Message(
//     sender: randomgirl,
//     time: '4:30 PM',
//     text: 'Hey, how\'s it going? What did you do today?',
//     isLiked: false,
//     unread: true,
//   ),
//   Message(
//     sender: number1crush,
//     time: '3:30 PM',
//     text: 'Hey, how\'s it going? What did you do today?',
//     isLiked: false,
//     unread: false,
//   ),
//   Message(
//     sender: crusher,
//     time: '2:30 PM',
//     text: 'Hey, how\'s it going? What did you do today?',
//     isLiked: false,
//     unread: true,
//   ),
//   Message(
//     sender: likingyou,
//     time: '1:30 PM',
//     text: 'Hey, how\'s it going? What did you do today?',
//     isLiked: false,
//     unread: false,
//   ),
//   Message(
//     sender: sweetcrucher,
//     time: '12:30 PM',
//     text: 'Hey, how\'s it going? What did you do today?',
//     isLiked: false,
//     unread: false,
//   ),
//   Message(
//     sender: thecutegirl,
//     time: '11:30 AM',
//     text: 'Hey, how\'s it going? What did you do today?',
//     isLiked: false,
//     unread: false,
//   ),
// ];

// // EXAMPLE MESSAGES IN CHAT SCREEN
// List<Message> messages = [
//   Message(
//     sender: randomgirl,
//     time: '5:30 PM',
//     text: 'Hey, how\'s it going? What did you do today?',
//     isLiked: true,
//     unread: true,
//   ),
//   Message(
//     sender: currentUser,
//     time: '4:30 PM',
//     text: 'Just walked my doge. She was super duper cute. The best pupper!!',
//     isLiked: false,
//     unread: true,
//   ),
//   Message(
//     sender: crusher,
//     time: '3:45 PM',
//     text: 'How\'s the doggo?',
//     isLiked: false,
//     unread: true,
//   ),
//   Message(
//     sender: likingyou,
//     time: '3:15 PM',
//     text: 'All the food',
//     isLiked: true,
//     unread: true,
//   ),
//   Message(
//     sender: sweetcrucher,
//     time: '2:30 PM',
//     text: 'Nice! What kind of food did you eat?',
//     isLiked: false,
//     unread: true,
//   ),
//   Message(
//     sender: thecutegirl,
//     time: '2:00 PM',
//     text: 'I ate so much food today.',
//     isLiked: false,
//     unread: true,
//   ),
// ];

// List for aviator name --------

final Aviator aviator1 = Aviator(
    id: 1,
    name: 'avatar1',
    imageUrl: 'assets/images/avatar1.png',
    isSelected: false);
final Aviator aviator2 = Aviator(
    id: 2,
    name: 'avatar2',
    imageUrl: 'assets/images/avatar2.png',
    isSelected: false);
final Aviator aviator3 = Aviator(
    id: 3,
    name: 'avatar3',
    imageUrl: 'assets/images/avatar3.png',
    isSelected: false);
final Aviator aviator4 = Aviator(
    id: 4,
    name: 'avatar4',
    imageUrl: 'assets/images/avatar4.png',
    isSelected: false);
final Aviator aviator5 = Aviator(
    id: 5,
    name: 'avatar5',
    imageUrl: 'assets/images/avatar5.png',
    isSelected: false);
final Aviator aviator6 = Aviator(
    id: 6,
    name: 'avatar6',
    imageUrl: 'assets/images/avatar6.png',
    isSelected: false);
final Aviator aviator7 = Aviator(
    id: 7,
    name: 'avatar7',
    imageUrl: 'assets/images/avatar7.png',
    isSelected: false);
final Aviator aviator8 = Aviator(
    id: 8,
    name: 'avatar8',
    imageUrl: 'assets/images/avatar8.png',
    isSelected: false);
List<Aviator> aviators = [
  aviator1,
  aviator2,
  aviator3,
  aviator4,
  aviator5,
  aviator6,
  aviator7,
  aviator8
];
