import 'package:flutter/material.dart';
import 'package:todo_list/todo.dart';
import 'package:todo_list/todo_element.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(title: "TODO List", home: TODOContainer()));
}

class TODOContainer extends StatefulWidget {
  const TODOContainer({Key? key}) : super(key: key);

  @override
  State<TODOContainer> createState() => _TODOContainerState();
}

class _TODOContainerState extends State<TODOContainer> {
  List<Todo> Todos = [];
  late SharedPreferences prefs;

  Future<void> updateTodos(List<Todo> newTodos) async {
    setState(() {
      Todos = newTodos;
    });
    await prefs.setStringList(
        "todos", newTodos.map((todo) => todo.encode()).toList());
  }

  Todo decodeTodo(String encoded) {
    List<String> tododata = encoded.split("***|***");
    return Todo(tododata[0], tododata[1], tododata[2] == "true");
  }

  void deleteFunctionHandler(Todo todo) {
    Todos.remove(todo);

    updateTodos(Todos);
  }

  void editFunctionHandler(Todo todo) {
    var newTitle = todo.title;
    int index = Todos.indexOf(todo);
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Edit Todo'),
              content: TextFormField(
                initialValue: todo.title,
                onChanged: (newValue) {
                  newTitle = newValue;
                },
              ),
              actions: <Widget>[
                ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text("Save"),
                    onPressed: () {
                      Todo newTodo = todo;
                      newTodo.title = newTitle;

                      Todos.removeAt(index);
                      Todos.insert(index, newTodo);
                      updateTodos(Todos);
                      // Navigator.of(context).pop(false);
                      Navigator.pop(context);
                    }),
                ElevatedButton.icon(
                    icon: const Icon(Icons.cancel),
                    label: const Text("Close"),
                    onPressed: () {
                      updateTodos(Todos);
                      Navigator.pop(context);
                    })
              ],
            ));
  }

  void addTodoHandler() async {
    String todoTitle = "";
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Add Todo'),
              content: TextFormField(
                initialValue: "",
                onChanged: (newValue) {
                  todoTitle = newValue;
                },
              ),
              actions: <Widget>[
                ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text("Save"),
                    onPressed: () {
                      Todos.add(
                          Todo(todoTitle, DateTime.now().toString(), false));
                      updateTodos(Todos);
                      // Navigator.of(context).pop(false);
                      Navigator.pop(context);
                    }),
                ElevatedButton.icon(
                    icon: const Icon(Icons.cancel),
                    label: const Text("Close"),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            ));
  }

  void longPressHandler(Todo todo) {
    int index = Todos.indexOf(todo);
    Todos.remove(todo);
    todo.toggleCompletedStatus();
    Todos.insert(index, todo);
    updateTodos(Todos);
  }

  Future<void> initTodo() async {
    prefs = await SharedPreferences.getInstance();
    bool checkValue = prefs.containsKey("todos");

    if (checkValue) {
      setState(() {
        Todos =
            prefs.getStringList("todos")!.map((e) => decodeTodo(e)).toList();
      });
    } else {
      updateTodos([
        Todo("Swipe From Left To Delete A Todo", "2021-11-09 12:03:55.376",
            false),
        Todo(
            "Swipe From Right To Edit A Todo", "2021-11-09 12:04:11.538", true),
        Todo("Double Tap To Change Todo Status", "2021-11-09 12:04:34.850",
            false),
        Todo("Lon Press To Reorder", "2021-11-09 12:04:34.850", true),
      ]);
    }
  }

  @override
  void initState() {
    initTodo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
          title: const Text("TODO List"),
          backgroundColor: Colors.grey[850],
          centerTitle: true,
          elevation: 0),
      body: ReorderableListView(
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final Todo newTodo = Todos.removeAt(oldIndex);
            Todos.insert(newIndex, newTodo);
            updateTodos(Todos);
          });
        },
        children: Todos.isEmpty
            ? [
                ListTile(
                    key: UniqueKey(),
                    title: const Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text(
                        "No Todos To Show",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ))
              ]
            : Todos.map((Todo todo) => ListTile(
                  key: ValueKey(todo),
                  title: TodoElement(
                      todo: todo,
                      deleteFunctionHandler: deleteFunctionHandler,
                      editFunctionHandler: editFunctionHandler,
                      longPressHandler: longPressHandler),
                )).toList(),
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          addTodoHandler();
        },
        icon: const Icon(Icons.add),
        color: Colors.blue,
      ),
    );
  }
}
