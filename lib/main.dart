import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Llama API Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _responseText = '';
  final TextEditingController _promptController = TextEditingController();

  Future<void> _fetchData() async {
    const String url = 'https://api.replicate.com/v1/predictions';
    const String token = 'r8_S1jRu33UXar3TA6msFU1fyV8ngmAcfk1lCkpa';
    final Map<String, dynamic> jsonBody = {
      "version":
          "02e509c789964a7ea8736978a43525956ef40397be9033abf9fd2badfe68c9e3",
      "input": {"prompt": _promptController.text}
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(jsonBody),
    );

    final responseData = json.decode(response.body);

    if (responseData.containsKey('urls') &&
        responseData['urls'].containsKey('get')) {
      final getUrl = responseData['urls']['get'];

      final getResponse = await http.get(
        Uri.parse(getUrl),
        headers: {'Authorization': 'Token $token'},
      );

      final getResponseData = json.decode(getResponse.body);

      setState(() {
        _responseText = json.encode(getResponseData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Llama API Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                labelText: 'Enter Prompt',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchData,
              child: const Text('Send Request'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    height: 400,
                    width: 400,
                    color: Colors.red,
                    child: Text(
                      _responseText,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*


3.Create a list to save responses and display 
in a listview (Just create the listview, don't need 
to display it, will be displayed in second requirement) - Shakil

*/
