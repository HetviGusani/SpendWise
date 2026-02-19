import 'package:shared_preferences/shared_preferences.dart';
import 'package:spend/colors.dart';
import 'package:flutter/material.dart';
import 'package:spend/database/MyDB.dart';
import 'package:spend/screens/signup.dart';

import 'dashboard.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  Mydb db = Mydb.instance;

  SharedPreferences? sharedPreferences;
  bool isPrefsLoaded = false;

  String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late final scheme = Theme.of(context).colorScheme;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  Future<void> initPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
    isPrefsLoaded = true;
    check();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(38),
          child: Center(
            child: Column(
              children: [
                TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    hintText: "Enter E-Mail",
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: scheme.primary),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  validator: (value) {
                    if (email.text.isEmpty) {
                      return "Please Enter Your E-Mail";
                    } else if (!RegExp(pattern).hasMatch(value!)) {
                      return "Enter valid E-Mail";
                    }
                  },
                ),
                SizedBox(height: 10),

                TextFormField(
                  controller: pass,
                  decoration: InputDecoration(
                    hintText: "Enter Password",
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: scheme.primary),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (pass.text.isEmpty) {
                      return "Please Enter Password";
                    }
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      var user = await db.checkLogin(
                        email.text.trim(),
                        pass.text.trim(),
                      );

                      if (user != null) {
                        await sharedPreferences?.setBool("isLoggedIn", true);
                        await sharedPreferences?.setInt(
                          "userId",
                          user[Mydb.columnId],
                        );
                        await sharedPreferences?.setString(
                          "uname",
                          user[Mydb.columnname],
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Dashboard(
                              id: user[Mydb.columnId],
                              username: user[Mydb.columnname],
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Invalid Email or Password")),
                        );
                      }
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.primary,
                    foregroundColor: Colors.white,
                    fixedSize: Size(150, 50),
                  ),
                  child: Text("Login"),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("New User?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Signup()),
                        );
                      },
                      child: Text("Sign Up"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void check() {
    bool isLoggedIn = sharedPreferences?.getBool("isLoggedIn") ?? false;

    if (isLoggedIn) {
      int id = sharedPreferences?.getInt("userId") ?? 0;
      String name = sharedPreferences?.getString("uname") ?? "";

      if (id != 0 && name.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(id: id, username: name),
          ),
        );
      }
    }
  }
}
