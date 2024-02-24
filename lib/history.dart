import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  final List<String> historyList;

  HistoryPage({Key? key, required this.historyList}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.blueAccent,
          child: ListView.builder(
            
            itemCount: widget.historyList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(widget.historyList[index]),
                
                
              );
            },
          ),
        ),
      ),
    );
  }

 
}
