import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Column(children: [
          ScopedModel<MyModel>(
              model: MyModel(),
              child: Column(children: [
                ScopedModelDescendant<MyModel>(
                  builder: (context, child, model) => new Text('${model.foo}'),
                ),
                Text("Another widget that doesn't depend on the CounterModel"),
                WidgetA(),
              ]))
        ]),
      ),
    ));

class MyModel extends Model {
  String _foo;

  String get foo => _foo;

  void set foo(String value) {
    _foo = value;
    notifyListeners();
  }

  static MyModel of(BuildContext context) =>
      ScopedModel.of<MyModel>(context);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MyModel>(
      builder: (context, child, model) => Text(model.foo),
    );
  }
}

class WidgetA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text('BUTTON'),
      onPressed: () {
        final model = ScopedModel.of<MyModel>(context);
        model.foo = DateTime.now().toString();
      },
    );
  }
}