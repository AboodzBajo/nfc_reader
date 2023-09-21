import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ValueNotifier<dynamic> result = ValueNotifier(null);

  initState() {
    // ignore: avoid_print
    print("initState Called");
    _tagRead();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('NFC Reader')),
        body: SafeArea(
          child: FutureBuilder<bool>(
            future: NfcManager.instance.isAvailable(),
            builder: (context, ss) => ss.data != true
                ? Center(child: Text('NfcManager.isAvailable(): ${ss.data}'))
                : Flex(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    direction: Axis.vertical,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.all(4),
                          constraints: BoxConstraints.expand(),
                          decoration: BoxDecoration(border: Border.all()),
                          child: SingleChildScrollView(
                            child: ValueListenableBuilder<dynamic>(
                              valueListenable: result,
                              builder: (context, value, _) =>
                                  Text('${value ?? ''}'),
                            ),
                          ),
                        ),
                      ),
                      Image.asset('assets/images/contactless.png'),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  void _tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var tagValue = String.fromCharCodes(tag.data["ndef"]["cachedMessage"]["records"][0]["payload"]).substring(3);
      result.value = tagValue;
      print(tagValue);
      String url = "https://docs.google.com/forms/d/e/1FAIpQLSePo4vcbVDYyjC0I585RkLTeJAtGoRO11idP0404labEO7u1Q/formResponse?usp=pp_url&entry.960852383="+tagValue+"&submit=Submit";
      final response = await http.get(Uri.parse(url));
      // var responseData = json.decode(response.body);
      // print(res);
      // NfcManager.instance.stopSession();
    });
  }


}