import 'package:flutter/material.dart';
import 'api_call.dart';
import 'meeting_screen.dart';
class JoinScreen extends StatefulWidget {
  final String meetingId;

  JoinScreen({Key? key, required this.meetingId}) : super(key: key);

  @override
  _JoinScreenState createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final _meetingIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Automatically join the meeting when the screen is initialized
    _joinMeeting(widget.meetingId);
  }

  void _joinMeeting(String meetingId) async {
    if (meetingId.isNotEmpty && isValidMeetingId(meetingId)) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MeetingScreen(
            meetingId: meetingId,
            token: token,
          ),
        ),
      );
    }
  }


  void onJoinButtonPressed(BuildContext context) {
    String meetingId = _meetingIdController.text;
    _joinMeeting(meetingId);
  }

  @override
  Widget build(BuildContext context) {
    // Check if a meeting ID was passed from the previous screen
    final String? passedMeetingId = ModalRoute.of(context)?.settings.arguments as String?;

    // If a meeting ID was passed, automatically join it
    if (passedMeetingId != null && isValidMeetingId(passedMeetingId)) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MeetingScreen(
            meetingId: passedMeetingId,
            token: token,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting Room'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => onJoinButtonPressed(context),
              child: const Text('Join Meeting'),
            ),
            if (passedMeetingId == null)
              Container(
                margin: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Meeting Id',
                    border: OutlineInputBorder(),
                  ),
                  controller: _meetingIdController,
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool isValidMeetingId(String meetingId) {
    var re = RegExp("\\w{4}\\-\\w{4}\\-\\w{4}");
    return re.hasMatch(meetingId);
  }
}
