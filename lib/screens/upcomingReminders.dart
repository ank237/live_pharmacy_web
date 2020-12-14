import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:live_pharmacy/constants/styles.dart';
import 'package:live_pharmacy/models/notesModel.dart';
import 'package:live_pharmacy/models/store.dart';
import 'package:live_pharmacy/provider/notesProvider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class UpcomingReminders extends StatefulWidget {
  @override
  _UpcomingRemindersState createState() => _UpcomingRemindersState();
}

class _UpcomingRemindersState extends State<UpcomingReminders> {
  Future<bool> _onDeletePressed(NotesModel note) {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Are you sure?',
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
          content: Text(
            'Do you want to want to delete this reminder ?',
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('NO'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text('YES'),
              onPressed: () async {
                Navigator.pop(context);
                await notesProvider.deleteReminder(note.docId, note.date);
              },
            )
          ],
        );
      },
    ) ??
        false;
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<NotesProvider>(context, listen: false).fetchReminders();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final notesProvider = Provider.of<NotesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Upcoming Reminders'+' ( '+Stores.dropdownValue+' )'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: notesProvider.isLoading,
        child: Container(
          padding: EdgeInsets.all(20),
          width: size.width,
          child: ListView.builder(
            itemCount: notesProvider.remindersList.length,
            itemBuilder: (context, index) {
              var note = notesProvider.remindersList[index];
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.reminder.day.toString() + '/' + note.reminder.month.toString() + '/' + note.reminder.year.toString(),
                      style: kBlueTextStyle,
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Text(note.note, style: kAppbarButtonTextStyle),
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 50,
                          child: FlatButton(
                            onPressed: () async {
                              await _onDeletePressed(note);
                              Navigator.pushNamed(context, 'notes');
                            },
                            child: Icon(FontAwesomeIcons.trash, color: Colors.white, size: 15),
                            color: kCancelButtonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.all(0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}