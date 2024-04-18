import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class ThirdScreen extends StatelessWidget {
  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert Dialog'),
          content: Text('This is an alert dialog.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('This is a SnackBar.'),
        duration: Duration(seconds: 3),
      ),
    );
  }
  void _showToast() {
    Fluttertoast.showToast(
      msg: "This is a Toast.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share'),
              onTap: () => {},
            ),
            ListTile(
              leading: Icon(Icons.link),
              title: Text('Get link'),
              onTap: () => {},
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit name'),
              onTap: () => {},
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Third screen'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _showAlertDialog(context),
              child: Text('Show AlertDialog'),
            ),
            ElevatedButton(
              onPressed: () => _showSnackBar(context),
              child: Text('Show SnackBar'),
            ),
            ElevatedButton(
              onPressed: _showToast,
              child: Text('Show Toast'),
            ),
            ElevatedButton(
              onPressed: () => _showModalBottomSheet(context),
              child: Text('Show ModalBottomSheet'),
            ),
          ],
        ),
      ),
    );
  }
}
