import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyB9i64prRdk06SVU5CoQODNAnBCggyPHQ0",
            authDomain: "age-empower-7wy650.firebaseapp.com",
            projectId: "age-empower-7wy650",
            storageBucket: "age-empower-7wy650.firebasestorage.app",
            messagingSenderId: "626712733047",
            appId: "1:626712733047:web:cfff939e89adbc42d1ad72"));
  } else {
    await Firebase.initializeApp();
  }
}
