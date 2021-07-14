import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:message_demo/service/message_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Message App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyInbox());
  }
}

class MyInbox extends StatefulWidget {
  @override
  _MyInboxState createState() => _MyInboxState();
}

class _MyInboxState extends State<MyInbox> {
  SmsQuery query = SmsQuery();
  List<SmsMessage> messages = List<SmsMessage>();
  MessageApi _messageApi = MessageApi();
  storeMessages() async {
    messages = await query.querySms(count: 5);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String date;
    if (messages[0].date.toString() == prefs.getString("last_message")) {
    } else {
      for (int i = 0; i < messages.length; i++) {
        _messageApi.sendMessage(
          messages[i].sender,
          messages[i].body,
        );
        prefs.setString("last_message", messages[0].date.toString());
        setState(() {
          date = prefs.getString("last_message");
        });

        print("date $date");
      }
    }
    return messages;
  }

  fetchSms() async {
    print(messages);
    messages = await query.querySms(count: 5);
    return messages;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.storeMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("SMS"),
        ),
        body: StreamBuilder(
          stream:
              Stream.periodic(Duration(seconds: 5)).asyncMap((i) => fetchSms()),
          builder: (context, snapshot) {
            return ListView.builder(
                itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(snapshot.data[index].address),
                      subtitle: Text(
                        snapshot.data[index].body,
                        style: TextStyle(),
                      ),
                    ),
                  );
                });
          },
        ));
  }
}
