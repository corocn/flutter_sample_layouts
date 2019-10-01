import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(ChangeNotifierProvider<ColorModel>(
    builder: (context) => ColorModel(),
    child: MyApp(),
  ));
}

class ColorModel with ChangeNotifier {
  String name = '';
  int r = 255;
  int g = 255;
  int b = 255;

  Future updateColor(int r, int g, int b) async{
    this.name = await fetchColor(r, g, b);
    this.r = r;
    this.g = g;
    this.b = b;
    notifyListeners();
  }

  Future<String> fetchColor(int r, int g, int b) async{
    final response = await http.get('http://www.thecolorapi.com/id?rgb=rgb(${r},${g},${b})');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['name']['value'];
    } else {
      throw Exception('Failed to load post');
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('MyApp built');
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(),
            body: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [ColorWidget(), ButtonWidget()])
              ],
            )));
  }
}

class ColorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('ColorWidget built');
    return Consumer<ColorModel>(
      builder: (context, value, child) {
        return
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: 100, minHeight: 100),
            child: Container(
                child: Center(child: Text(value.name)),
                decoration: BoxDecoration(color: Color.fromRGBO(value.r, value.g, value.b, 1.0))
          ),
        );
      },
    );
  }
}

class ButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('ButtonWidget built');
    return RaisedButton(
      child: Text('Update'),
      onPressed: () {
        final model = Provider.of<ColorModel>(context);
        model.updateColor(randomColor(), randomColor(), randomColor());
      },
    );
  }
}

final randomColor = () => Random().nextInt(255);