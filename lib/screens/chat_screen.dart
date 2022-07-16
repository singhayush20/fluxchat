import 'package:flutter/material.dart';
import 'package:fluxchat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'Chat String';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final FirebaseAuth? _auth = FirebaseAuth.instance;
  String messageText = '';
  void getCurrentUser() async {
    //Check if there is any current signed in user
    if (_auth != null) {
      final user = await _auth!.currentUser;

      if (user != null) {
        //currently signed in user
        loggedInUser = user;
        print(loggedInUser?.email);
      }
    }
  }

  // void getMessages() async {
  //   final messages = await _firestore.collection('messages').get();
  //   for (var message in messages.docs) {
  //     print(message.data()); //gives the key value pair
  //   }
  // }

  void messageStream() async {
    print('entered messageStream()');
    //We will listen to the stream of messages coming from the fire store
    //returns a list of futures.
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
    //by subscribing to this stream we will listen to the changes to the particular
    //collection. When a new message is added to this collection, we will be notified
    //of the change.
    print('leaving messageStream()');
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                //Implement logout functionality
                _auth!.signOut();
                Navigator.pop(context);
                // messageStream();
              }),
        ],
        title: Text('Flux Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller:
                          messageTextController, //to clear the text field when send is pressed
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      FocusScope.of(context)
                          .unfocus(); //close the keyboard which might be open
                      //Implement send functionality.
                      //Send to fire store
                      //messageText+loggedInUser.email
                      //The collection and field names must be
                      //exactly same as used in fire store.
                      if (messageText.trim() != '') {
                        _firestore.collection('messages').add(
                          {
                            'text': messageText,
                            'sender': loggedInUser!.email,
                            'createdAt': Timestamp.now(),
                          },
                        );
                      }
                      messageTextController.clear();
                      messageText = '';
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<
            QuerySnapshot> /*Eventually this type of data
            will be available*/
        (
      builder: (context,
          snapshot /*This is a Flutter Async Snapshot which
                  contains a query snapshot from firebase*/
          ) {
        if (!snapshot.hasData) //if data is available
        {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = //using dynamic data type
            snapshot /*This is an async snapshot from flutter*/ .data!
                .docs; //accessing the data in our async snapshot
        //when we specify the type of StreamBuilder <>, data gets updated
        // to actual query snapshot, therefore can access the docs.
        //use a for loop to build widgets
        List<MessageBubble> messageWidgets = [];
        for (var message
            in messages) // message is a document snapshot from firebase
        {
          final messageText = message.get('text');
          final messageSender = message.get('sender');
          final currentUser = loggedInUser?.email;
          if (currentUser == messageSender) {
            //message from the logged in user

          }
          final messagewidget = MessageBubble(
              sender: messageSender,
              text: messageText,
              isMe: currentUser == messageSender);
          messageWidgets.add(messagewidget);
        }
        /*Wrap in extended so that the list view takes
                only the available space and do not push the other widgets
                of the screen
                 */
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageWidgets,
            reverse: true,
          ),
        );
      }, //provide logic what StreamBuilder should do i.e., what action to take
      //the type is the AsyncSnapshot represents the most recent interaction with the stream
      stream: _firestore
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .snapshots(), //where the data comes from
    );
  }
}

class MessageBubble extends StatelessWidget {
  String? sender = '';
  String? text = '';
  bool? isMe;
  MessageBubble({this.sender, this.text, this.isMe});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
          crossAxisAlignment:
              isMe ?? false ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              sender ?? ' ',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.black54,
              ),
            ),
            Material(
              elevation: 5,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isMe ?? false ? 30.0 : 0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
                topRight: Radius.circular(isMe ?? false ? 0 : 30.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  '$text',
                  style: TextStyle(
                    color: isMe ?? false ? Colors.white : Colors.black54,
                  ),
                ),
              ),
              color: isMe ?? false ? Colors.lightBlueAccent : Colors.white,
            ),
          ]),
    );
  }
}
