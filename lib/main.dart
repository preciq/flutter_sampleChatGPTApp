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
                        postRequestToChatGPT();
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
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(
                            chatGPTResponse,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
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
    Uri url = Uri.https("api.replicate.com", "/v1/predictions");
    const authToken = "r8_S1jRu33UXar3TA6msFU1fyV8ngmAcfk1lCkpa";

    Map<String, dynamic> body = {
      "version":
          "02e509c789964a7ea8736978a43525956ef40397be9033abf9fd2badfe68c9e3",
      "input": {
        "prompt":
            txt.text
      }
    };

    var response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Token $authToken", //put your actual auth key here after "Bearer"
        },
        body: json.encode(body));

    if (response.statusCode == 201) {
      print("Success!");
    } else {
      print("Error! ${response.statusCode}");
    }

    final getRequestLink = json.decode(response.body)["urls"]["get"];

    late dynamic responseTwo;
    do {
      responseTwo = await http.get(Uri.parse(getRequestLink), headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Token $authToken", //put your actual auth key here after "Bearer"
      });
      if (responseTwo.statusCode == 200) {
        print("Success!");
      } else {
        print("Error! ${response.statusCode}");
      }
    } while (json.decode(responseTwo.body)["status"] != "succeeded");

    String aiResponse = (json.decode(responseTwo.body)["output"] as List<dynamic>).join('');

    return aiResponse;
  }

  void submitButtonPressed() async {
    setState(() {
      userInput = txt.text;
    });
    chatGPTResponse = await postRequestToChatGPT();
    setState(() {});
   }
}