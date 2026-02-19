import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spend/colors.dart';
import 'package:spend/screens/addCategory.dart';

import '../database/MyDB.dart';
import 'login.dart';

class Dashboard extends StatefulWidget {
  final String username;
  final int id;

  Dashboard({super.key, required this.id, required this.username});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Mydb db = Mydb.instance;
  List<Map<String, dynamic>> Data = [];

  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    // TODO: implement initState
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    late final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${widget.username}"),
        backgroundColor: scheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool("isLoggedIn", false);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => login()),);
            },
          ),
        ],


      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: Data.length,
                  itemBuilder: (contex, index) {
                    var item = Data[index];
                    return SizedBox(
                      height: 120,

                      child: Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item[Mydb.columnCategory],
                                    style: TextStyle(
                                      color: scheme.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "₹ ${item[Mydb.columnAmount]}",
                                    style: TextStyle(
                                      color: scheme.onSurface,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: () {
                                  showEditDialog(item);
                                },
                                icon: Icon(Icons.edit),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("\u26A0\uFE0F Delete",style: TextStyle(color: Colors.red),),
                                        content: const Text("Are you sure you want to delete?"),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context, false);
                                            },
                                            child: const Text("Cancel"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context, true);
                                            },style: ElevatedButton.styleFrom(backgroundColor: Colors.red,foregroundColor: Colors.white),
                                            child: const Text("OK"),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirm == true) {
                                    Map<String, dynamic> row = {
                                      Mydb.userId: widget.id,
                                      Mydb.columnCategory: item[Mydb.columnCategory],
                                    };

                                    int result = await db.deleteData(row);

                                    if (result > 0) {
                                      await fetch();

                                    }
                                  }
                                },
                              ),

                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Category(id: widget.id)),
          );
          fetch();
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  fetch() async {
    final allRows = await db.fetchData(widget.id);
    Data = allRows;
    setState(() {
      Data = allRows;
    });
  }

  showEditDialog(item) {
    TextEditingController amountC = TextEditingController();
    final _dialogFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            item[Mydb.columnCategory],
            style: TextStyle(
              color: lightColorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Form(
            key: _dialogFormKey,
            child: SizedBox(
              height: 110,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Edit Amount", style: TextStyle(fontSize: 15)),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: amountC,
                    decoration: InputDecoration(
                      hintText: "Enter Amount",
                      border: OutlineInputBorder(),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter Amount";
                        }

                        final number = num.tryParse(value);
                        if (number == null) {
                          return "Enter valid number";
                        }

                        if (number <= 0) {
                          return "Amount must be greater than 0";
                        }

                        return null;
                      },

                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if(_dialogFormKey.currentState!.validate()){
                  Map<String,dynamic> value={
                    Mydb.userId:widget.id,
                    Mydb.columnCategory:item[Mydb.columnCategory],
                    Mydb.columnAmount:amountC.text.toString()
                  };
                  int result=await db.editAmount(value);
                  if(result>0){
                    Navigator.pop(context);
                    fetch();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: lightColorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: Text("Edit"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                // backgroundColor: lightColorScheme.primary,
                // foregroundColor: Colors.white,
              ),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
