import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.brown,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<SfSignaturePadState> _signaturePadStateKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Scaffold(
          body: Center(
            child: Container(
              child: Column(children: [
                SfSignaturePad(
                  key: _signaturePadStateKey,
                  backgroundColor: Colors.white,
                  strokeColor: Colors.black,
                  minimumStrokeWidth: 4.0,
                  maximumStrokeWidth: 6.0,
                ),
                const SizedBox(height: 20),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey,
                        onPrimary: Colors.amber,
                      ),
                      onPressed: () async {
                        _signaturePadStateKey.currentState!.clear();
                      },
                      child: Text('Xóa, viết lại'))
                  , const SizedBox(height: 20),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey,
                        onPrimary: Colors.amber,
                      ),
                      onPressed: () async {
                        ui.Image image =
                        await _signaturePadStateKey.currentState!.toImage(pixelRatio: 2.0);
                        final byteData =
                        await image.toByteData(format: ui.ImageByteFormat.png);
                        final Uint8List imageBytes = byteData!.buffer
                            .asUint8List(
                            byteData.offsetInBytes, byteData.lengthInBytes);

                        final String path =
                            (await getApplicationSupportDirectory()).path;
                        final String fileName = '$path/Output.png';
                        final File file = File(fileName);
                        await file.writeAsBytes(imageBytes, flush: true);
                        OpenFile.open(fileName);
                      },
                      child: Text('Lưu vào thư viện'))
              ]),
              height: 400,
              width: 500,
            ),
          ),
        ));
  }
}
