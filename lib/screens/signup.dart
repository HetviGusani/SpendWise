import 'package:flutter/material.dart';
import 'package:spend/database/MyDB.dart';
import 'package:spend/screens/login.dart';

import 'dashboard.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  Mydb db = Mydb.instance;

  String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  late RegExp regex = RegExp(pattern);

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late final scheme = Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(38),
          child: Center(
            child: Column(
              children: [
                TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                    hintText: "Enter Name",
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: scheme.primary),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  validator: (value) {
                    if (name.text.isEmpty) {
                      return "Please Enter Your Name";
                    }
                  },
                ),
                SizedBox(height: 10),

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
                  onPressed: () {
                    if(_formKey.currentState!.validate()){
                      insert();
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error : Can't Insert Data")));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.primary,
                    foregroundColor: Colors.white,
                    fixedSize: Size(150, 50),
                  ),
                  child: Text("Sign UP"),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already Signed UP?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => login()),
                        );
                      },
                      child: Text("Login"),
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

  insert() async {
    Map<String, dynamic> row = {
      Mydb.columnname: name.text.toString(),
      Mydb.columnEmail: email.text.toString(),
      Mydb.columnPass:pass.text.toString()
    };
    int id=await db.insertData(row);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data Inserted"),));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => login()),
    );
  }
}
