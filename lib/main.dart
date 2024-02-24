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

  Future<void> postRequestToChatGPT() async {
  const String url = 'https://api.replicate.com/v1/predictions';
  const String token = 'r8_S1jRu33UXar3TA6msFU1fyV8ngmAcfk1lCkpa';
  final Map<String, dynamic> jsonBody = {
    "version": "02e509c789964a7ea8736978a43525956ef40397be9033abf9fd2badfe68c9e3",
    "input": {"prompt": txt.text}
  };

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
    },
    body: json.encode(jsonBody),
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    if (responseData.containsKey('urls') &&
        responseData['urls'].containsKey('get')) {
      final getUrl = responseData['urls']['get'];

      final getResponse = await http.get(
        Uri.parse(getUrl),
        headers: {'Authorization': 'Token $token'},
      );

      if (getResponse.statusCode == 200) {
        final getResponseData = json.decode(getResponse.body);
        setState(() {
          chatGPTResponse = json.encode(getResponseData);
        });
      } else {
        print('Error! ${getResponse.statusCode}');
      }
    }
  } else {
    print('Error! ${response.statusCode}');
  }
}
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

/*
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(home: HomePage());
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final TextEditingController txt = TextEditingController();
//   String userInput = "";
//   String chatGPTResponse = "Pending";
//   String getGPTResponse = "";

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextField(
//                   controller: txt,
//                   decoration: const InputDecoration(
//                       hintText: "Enter prompt to ChatGPT"),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         _fetchData();
//                       });
//                     },
//                     child: const Text("Submit")),
//               ),
//               Flexible(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                       color: Colors.red,
//                       height: 500,
//                       width: 500,
//                       child: Center(
//                         child: SingleChildScrollView(
//                           scrollDirection: Axis.vertical,
//                           child: Text(
//                             chatGPTResponse,
//                             style: const TextStyle(
//                               fontSize: 20,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       )),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _fetchData() async {
//     String _responseText = '';
//     // final TextEditingController _promptController = TextEditingController();
//     // const String url = 'https://api.replicate.com/v1/predictions';
//     Uri url = Uri.https("api.replicate.com", "/v1/predictions");

//     const String token = 'r8_S1jRu33UXar3TA6msFU1fyV8ngmAcfk1lCkpa';
//     final Map<String, dynamic> jsonBody = {
//       "version":
//           "02e509c789964a7ea8736978a43525956ef40397be9033abf9fd2badfe68c9e3",
//       "input": {"prompt": txt.text}
//     };
// /*
//  {
//   "version": "02e509c789964a7ea8736978a43525956ef40397be9033abf9fd2badfe68c9e3",
//   "input": {
//     "prompt": "make a poem of 20 lines"
//   }
// }
//  */
//     print(jsonBody);
//     final response = await http.post(
//       url,
//       headers: {
//         'Authorization': 'Token $token',
//         'Content-Type': 'application/json',
//       },
//       body: json.encode(jsonBody),
//     );
//     print(response);

//     final responseData = json.decode(response.body);
//     print("The responce is: $responseData");

//     if (responseData.containsKey('urls') &&
//         responseData['urls'].containsKey('get')) {
//       final getUrl = responseData['urls']['get'];

//       final getResponse = await http.get(
//         Uri.parse(getUrl),
//         headers: {'Authorization': 'Token $token'},
//       );

//       final getResponseData = json.decode(getResponse.body);

//       setState(() {
//         _responseText = json.encode(getResponseData);
//       });
//     }
//   }

//   // void submitButtonPressed() async {
//   //   setState(() {
//   //     userInput = txt.text;
//   //   });
//   //   chatGPTResponse = await postRequestToChatGPT();
//   //   setState(() {});
//   // }
// }

// /*
// Additions: 

// Make response container scrollable - Shohag
// Add an appbar at the top with a drawer that shows the responses - Mithu
// Create a list to save responses and display in a listview (Just create the listview, don't need to display it, will be displayed in second requirement) - Shakil

// // Additions: 

// // Make response container scrollable - Shohag
// // Add an appbar at the top with a drawer that shows the responses - Mithu
// // Create a list to save responses and display in a listview (Just create the listview, don't need to display it, will be displayed in second requirement) - Shakil
*/