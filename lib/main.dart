import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Stand For Sudan Stats'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Map<String, dynamic>> futureData;
  final template = new NumberFormat("#,###", "en_US");

  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(
        'https://standforsudan.ebs-sd.com/StandForSudan/getStandForSudanStatstics');

    if (response.statusCode == 200) {
      Map<String, dynamic> rowJson = json.decode(response.body);
      return rowJson;
    } else {
      throw Exception('Failed to load Data');
    }
  }

  @override
  void initState() {
    futureData = fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Tranasactions: ',
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            Text(
                                template.format(
                                    snapshot.data['numberOfTransaction']),
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ))
                          ]),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Total Amount: ',
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            Text(template.format(snapshot.data['totalAmount']),
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(
                              ' SDG',
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ]),
                    ]);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Center(child: CircularProgressIndicator());
            }));
  }
}
