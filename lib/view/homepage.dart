import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:video_call_app/view/callpage.dart';

const appId = "c69b983919194da99783562c34a7adaf";
const token =
    "007eJxTYEjlPBtweN2Uiz0KlWWnapvufzrIfaSpXDYnq0j0zqWPJ68qMCSbWSZZWhhbGgKhSUqipaW5hbGpmVGysUmieWJKYtrb9bPTGwIZGWpLdzEyMkAgiM/OUJJaXJKZl87AAABmwSOM";

// HomePage widget
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _channelController = TextEditingController();
  String _channelName = '';
  ClientRoleType _role = ClientRoleType.clientRoleBroadcaster;

  void _navigateToVideoCallPage() {
    if (_channelName.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoCallPage(
            channel: _channelName,
            role: _role,
          ),
        ),
      ).then((_) {
        // Clear the text field and reset the controller when returning from VideoCallPage
        _channelController.clear();
      });;
    } else {
      // Show an error message if the channel name is empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter a channel name'),
      ));
    }
  }

  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agora Video Call')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the column content
          children: [
            Center(
              // Center the Lottie animation
              child: LottieBuilder.asset(
                'assets/animations/Animation - 1738251890096.json', // Path to your Lottie file
                width: 250, // Adjust width as needed
                height: 250, // Adjust height as needed
              ),
            ),
            SizedBox(height: 30), // Add spacing between Lottie and TextField
            TextField(
              controller: _channelController,
              decoration: InputDecoration(
                labelText: 'Enter Channel Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // Circular border
                  borderSide:
                      BorderSide(color: Colors.amber, width: 2), // Amber border
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _channelName = value;
                });
              },
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Radio<ClientRoleType>(
                  activeColor: Colors.amber,
                  value: ClientRoleType.clientRoleBroadcaster,
                  groupValue: _role,
                  onChanged: (ClientRoleType? value) {
                    setState(() {
                      _role = value!;
                    });
                  },
                ),
                Text('Host'),
                Radio<ClientRoleType>(
                  activeColor: Colors.amber,
                  value: ClientRoleType.clientRoleAudience,
                  groupValue: _role,
                  onChanged: (ClientRoleType? value) {
                    setState(() {
                      _role = value!;
                    });
                  },
                ),
                Text('Audience'),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.amber.shade300, // Set button color to amber
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Circular button
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: 50, vertical: 15), // Add padding to the button
              ),
              onPressed: _navigateToVideoCallPage,
              child: Text('Join Call', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
