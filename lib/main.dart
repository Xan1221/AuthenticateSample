import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser myUser;

  //consumer key for twitter. To change when final version of app is ready. Also, don't forget to change on firebase
  static final TwitterLogin twitterLogin = new TwitterLogin(
    consumerKey: '14FcGw9eggKKEtsunxNamPtdH',
    consumerSecret: 'buq4Dgt8mhIFlVK01Com2jnonbRfIEV8FJp6u7KDMUMoInAJ9j'
  );

  //Initial text for testing purposes
  String message = "Welcome to flutter";

  //login with twitter.
  Future<FirebaseUser> loginWithTwitter() async {
    String newMessage;

    //authorization for the user
    final TwitterLoginResult result = await twitterLogin.authorize();

    //switch cases with authorization. This then feeds into firebase
    switch (result.status) {
      case (TwitterLoginStatus.loggedIn):
        final session = result.session;

        //credentials for user
        final AuthCredential credential = TwitterAuthProvider.getCredential(
            authToken: session.token, authTokenSecret: session.secret);

        AuthResult auth = await _auth.signInWithCredential(credential);
        //firebase user data in here
        FirebaseUser firebaseUser = auth.user;
        //Zee point for writing your database code for user data.

        return firebaseUser;
        break;

        //cancel by user does not work in the library

//      case (TwitterLoginStatus.cancelledByUser):
//        //Information sent to user for test
//        newMessage = 'Login cancelled by user.';
//        changeState(newMessage);
//        return null;
//        break;

      case TwitterLoginStatus.error:
        //Error inforamtion for the user
        newMessage = 'Login error: ${result.errorMessage}';
        changeState(newMessage);
        return null;
        break;
    }
    return null;
  }

  //method to change sign in status
  void changeState(String quote) {
    setState(() {
      message = quote;
    });
  }

  //Actual login to test functionality
  void logIn() {
    loginWithTwitter().then((response) {
      if (response != null) {
        myUser = response;
        changeState(myUser.displayName);
      }
    });
  }

  //Widget used to test authentication feature
  @override
  Widget build(BuildContext context) {
    const padding = 25.0;

    return MaterialApp(
      title: 'Button Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Twitter login"),
        ),
        backgroundColor: Color.fromARGB(0xFF, 0xF0, 0xF0, 0xF0),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(message),
                TwitterSignInButton(onPressed: () {
                  logIn();
                }),
                SizedBox(height: padding),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Heading extends StatelessWidget {
  final String text;

  Heading(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}