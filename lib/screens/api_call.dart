import 'dart:convert';
import 'package:http/http.dart' as http;

//Auth token we will use to generate a meeting and connect to it
const token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiIwNTRiNzVkMS01ZDZjLTQ4MTMtOWZhNi03NWJiZmMzMmE0NmUiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTY5NTU2MjcyNCwiZXhwIjoxNjk2MTY3NTI0fQ.dAAMVZSnpwt0aku9BWbo7Yhu9VRmN2vdk9R48rwjIWg';

// API call to create meeting
Future<String> createMeeting() async {
  final http.Response httpResponse = await http.post(
    Uri.parse('https://api.videosdk.live/v2/rooms'),
    headers: {'Authorization': token},
  );

//Destructuring the roomId from the response
  return json.decode(httpResponse.body)['roomId'];
}