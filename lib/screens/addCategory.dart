import 'package:flutter/material.dart';
import 'package:spend/database/MyDB.dart';

class Category extends StatefulWidget {
  final int id;
  Category({super.key,required this.id});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  Mydb db = Mydb.instance;

  TextEditingController categoryName = TextEditingController();
  TextEditingController amount = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    late final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(38),
          child: Center(
            child: Column(
              children: [
                TextFormField(
                  controller: categoryName,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: "Enter Category",
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: scheme.primary),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  validator: (value) {
                    if (categoryName.text.isEmpty) {
                      return "Please Enter Category";
                    }
                  },
                ),
                SizedBox(height: 10),

                TextFormField(
                  controller: amount,
                  keyboardType:TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter Amount in \u20B9",
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: scheme.primary),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  validator: (value) {
                    if (amount.text.isEmpty) {
                      return "Please Enter Amount";
                    }
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      insertExpense();
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.primary,
                    foregroundColor: Colors.white,
                    fixedSize: Size(150, 50),
                  ),
                  child: Text("Add"),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  insertExpense() async {

    Map<String,dynamic> row={
      Mydb.columnCategory:categoryName.text.toString(),
      Mydb.columnAmount:amount.text.toString(),
      Mydb.userId:widget.id
    };
    int result= await db.insertExpense(row);

    if(result>0){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Expense Added.")));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error")));
    }

    categoryName.clear();
    amount.clear();
    //Navigator.pop(context);

  }
}
