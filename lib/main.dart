import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController txt = TextEditingController();
  String userInput = "";
  String chatGPTResponse = "Pending";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const Drawer(
          child: Text('This is a Drawer'),
        ),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: const Text(
            'Simple chatGpt Api',
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: txt,
                  decoration: const InputDecoration(
                      hintText: "Enter prompt to ChatGPT"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        submitButtonPressed();
                      });
                    },
                    child: const Text("Submit")),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      color: Colors.red,
                      height: 500,
                      width: 500,
                      child: Center(
                        child: Text(
                          chatGPTResponse,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> postRequestToChatGPT() async {
    Uri url = Uri.https("api.openai.com", "/v1/chat/completions");

    Map<String, dynamic> body = {
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "user", "content": userInput}
      ],
      "temperature": 0.7
    };

    var response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer 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", //put your actual auth key here after "Bearer"
        },
        body: json.encode(body));

    if (response.statusCode == 200) {
      print("Success!");
    } else {
      print("Error! ${response.statusCode}");
    }

    return json.decode(response.body)["choices"][0]["message"]["content"];
    //return response.body;
  }

  void submitButtonPressed() async {
    setState(() {
      userInput = txt.text;
    });
    chatGPTResponse = await postRequestToChatGPT();
    setState(() {});
  }
}


/*
Additions: 

Make response container scrollable - Shohag
Add an appbar at the top with a drawer that shows the responses - Mithu
Create a list to save responses and display in a listview (Just create the listview, don't need to display it, will be displayed in second requirement) - Shakil

*/