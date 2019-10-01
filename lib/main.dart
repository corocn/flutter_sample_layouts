import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:provider/provider.dart';

void main() {
//  Provider.debugCheckInvalidValueType = null;

  runApp(
      ChangeNotifierProvider<MyModel>(
        builder: (context) => MyModel(),
        child: MyApp(),
      )
  );
}
class MyModel with ChangeNotifier {
  String _foo;

  String get foo => _foo;

  void set foo(String value) {
    _foo = value;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('MyApp built');
    return
        MaterialApp(
            home: Scaffold(
                appBar: AppBar(),
                body: Column(children: [
                  Text('Hoge'),
                  MyWidget(),
                  OtherWidget()
                ])
            )
        );
  }
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('MyWidget built');
    return Consumer<MyModel>(
      builder: (context, value, child) => Text(value.foo),
    );
  }
}

class OtherWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('OtherWidget built');
    return FlatButton(
      child: Text('Update'),
      onPressed: () {
        final model = Provider.of<MyModel>(context);
        model.foo = DateTime.now().toString();
      },
    );
  }
}