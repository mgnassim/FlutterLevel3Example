import 'package:flutter/material.dart';

import 'Reminder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          headline1: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          headline2: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
        ),
      ),
      home: RemindersSection(),
    );
  }
}

class TitleSection extends StatelessWidget {
  const TitleSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Reminders', style: Theme.of(context).textTheme.headline1),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text('See below for all your reminders',
              style: Theme.of(context).textTheme.headline2),
        ),
      ]),
    );
  }
}

class RemindersSection extends StatefulWidget {
  const RemindersSection({Key? key}) : super(key: key);

  @override
  State<RemindersSection> createState() => _RemindersSectionState();
}

class _RemindersSectionState extends State<RemindersSection> {
  List<Reminder> reminders = [];

  var _addedReminder;
  var userInput;
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('FlutterLevel3Example'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleSection(),
            Expanded(
              child: ListView.builder(
                  itemCount: reminders.length,
                  itemBuilder: (context, index) {
                    final reminder = reminders[index];
                    return Dismissible(
                      // Each Dismissible must contain a Key. Keys allow Flutter to
                      // uniquely identify widgets.
                      key: UniqueKey(),
                      // Provide a function that tells the app
                      // what to do after an item has been swiped away.
                      onDismissed: (direction) {
                        // Remove the item from the data source.
                        setState(() {
                          reminders.remove(reminder);
                        });
                      },

                      background: Container(color: Colors.transparent),
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 100,
                            child: Material(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              elevation: 4.0,
                              shadowColor: Colors.black,
                              child: ListTile(
                                title: Text(reminder.reminderText),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          )),
                    );
                  }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _pushSaved();
            });
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ));
  }

  void _pushSaved() {
    Navigator.of(context).push(
      // Add lines from here...
      MaterialPageRoute<void>(
        builder: (context) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('FlutterLevel3Example'),
              ),
              body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                      child: Text('Add your reminder',
                          style: Theme.of(context).textTheme.headline1),
                    ),
                    Flexible(
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextField(
                              controller: myController,
                              decoration: const InputDecoration(
                                  hintText: 'Reminder name',
                                  border: UnderlineInputBorder()),
                            ))),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FractionallySizedBox(
                        widthFactor: 1,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                userInput = myController.text;
                                if (userInput.toString().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Reminder can not be empty.')));
                                } else {
                                  reminders
                                      .add(Reminder(reminderText: userInput));
                                  myController.clear();
                                  Navigator.pop(context);
                                }
                              });
                            },
                            child: const Text('ADD REMINDER')),
                      ),
                    )
                  ]));
        },
      ), // ...to here.
    );
  }
}
