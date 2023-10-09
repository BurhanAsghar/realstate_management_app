import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorScreen());
}

class CalculatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int first = 0;
  int second = 0;
  String res = "";
  String text = "";
  String opp = "";

  @override
  void initState() {
    super.initState();
    clearState();
  }

  void clearState() {
    setState(() {
      text = "";
      opp = "";
      res = "";
      first = 0;
      second = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.bottomRight,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 60.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.deepOrange,
                  ),
                ),
              ),
            ),
            buildButtonRow(["7", "8", "9", "+"]),
            buildButtonRow(["4", "5", "6", "-"]),
            buildButtonRow(["1", "2", "3", "x"]),
            buildButtonRow(["C", "0", "=", "/"]),
          ],
        ),
      ),
    );
  }

  Widget buildButtonRow(List<String> buttons) {
    List<Widget> rowButtons = buttons.map((btnText) {
      return customOutlineButton(btnText);
    }).toList();

    return Row(children: rowButtons);
  }

  Widget customOutlineButton(String val) {
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.all(25.0),
          primary: Colors.deepOrange, // Text color
        ),
        onPressed: () => btnClicked(val),
        child: Text(
          val,
          style: TextStyle(fontSize: 35.0),
        ),
      ),
    );
  }

  void btnClicked(String btnText) {
    if (btnText == "C") {
      clearState();
    } else if (btnText == "+" ||
        btnText == "-" ||
        btnText == "x" ||
        btnText == "/") {
      if (text.isNotEmpty) {
        first = int.parse(text);
        opp = btnText;
        res = "";
      }
    } else if (btnText == "=") {
      if (opp.isNotEmpty && text.isNotEmpty) {
        second = int.parse(text);
        if (opp == "+") {
          res = (first + second).toString();
        }
        if (opp == "-") {
          res = (first - second).toString();
        }
        if (opp == "x") {
          res = (first * second).toString();
        }
        if (opp == "/") {
          if (second != 0) {
            res = (first ~/ second).toString();
          } else {
            res = "Cannot divide by zero";
          }
        }
        opp = "";
        first = int.parse(res);
      }
    } else {
      res = int.parse(text + btnText).toString();
    }

    setState(() {
      text = res;
    });
  }
}
