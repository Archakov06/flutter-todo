import 'package:flutter/material.dart';

void main() => runApp(new MaterialApp(home: App()));

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _App();
  }
}

class _App extends State<App> {
  List<TodoItem> items = List<TodoItem>();

  @override
  void initState() {
    items.add(TodoItem(text: '123'));
    super.initState();
  }

  void addItem(BuildContext context) {
    TextEditingController fieldController = new TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Текст задачи'),
              actions: <Widget>[
                MaterialButton(
                  elevation: 5.0,
                  child: Text('Отмена'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                MaterialButton(
                  color: Colors.blue,
                  elevation: 5.0,
                  child: Text('Добавить'),
                  onPressed: () {
                    setState(() {
                      items.add(TodoItem(text: fieldController.text));
                      Navigator.pop(context);
                    });
                  },
                )
              ],
              content: TextField(controller: fieldController));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text('Список задач')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: () {
          addItem(context);
        },
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (itemContext, index) {
          return Dismissible(
              direction: DismissDirection.endToStart,
              background: Container(
                  color: Colors.red,
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 28.0, 0.0))),
              key: UniqueKey(),
              confirmDismiss: (DismissDirection direction) async {
                return await showDialog(
                    context: itemContext,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text('Удалить запись?'),
                          actions: <Widget>[
                            FlatButton(
                                child: Text('Отмена'),
                                onPressed: () {
                                  Navigator.of(itemContext).pop(false);
                                }),
                            FlatButton(
                                child: Text('Удалить'),
                                onPressed: () {
                                  items.removeAt(index);
                                  Navigator.of(context).pop(true);
                                  Scaffold.of(itemContext).showSnackBar(
                                      SnackBar(
                                          content: Text('Вернуть задачу?',
                                              textAlign: TextAlign.center)));
                                  print(items);
                                },
                                textColor: Colors.red[400],
                                color: Colors.red[50])
                          ]);
                    });
              },
              child: ListTile(
                title: Text(items[index].text),
                trailing: IconButton(
                  color:
                      items[index].completed ? Colors.blue[500] : Colors.grey,
                  icon: Icon(!items[index].completed
                      ? Icons.check_box_outline_blank
                      : Icons.check_box),
                  onPressed: () {
                    setState(() {
                      items[index].completed = !items[index].completed;
                    });
                  },
                ),
              ));
        },
      ),
    );
  }
}

class TodoItem {
  String text;
  bool completed;

  TodoItem({this.text, this.completed = false});
}
