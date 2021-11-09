import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/todo.dart';

class TodoElement extends StatefulWidget {
  TodoElement({
    Key? key,
    required this.todo,
    required this.deleteFunctionHandler,
    required this.editFunctionHandler,
    required this.longPressHandler,
  }) : super(key: key);

  Todo todo;
  Function deleteFunctionHandler;
  Function editFunctionHandler;
  Function longPressHandler;

  @override
  _TodoElementState createState() => _TodoElementState();
}

class _TodoElementState extends State<TodoElement> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        widget.longPressHandler(widget.todo);
      },
      child: Dismissible(
        key: UniqueKey(),
        background: Container(
            alignment: AlignmentDirectional.centerStart,
            color: Colors.red,
            child: const Padding(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ))),
        secondaryBackground: Container(
            alignment: AlignmentDirectional.centerEnd,
            color: Colors.green,
            child: const Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                ))),
        onDismissed: (DismissDirection direction) {
          if (direction == DismissDirection.startToEnd) {
            widget.deleteFunctionHandler(widget.todo);
          } else {
            widget.editFunctionHandler(widget.todo);
          }
        },
        child: Card(
          color: widget.todo.completed ? Colors.green[300] : Colors.red[300],
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  widget.todo.title,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(
                  width: 10,
                  height: 30,
                ),
                Text(
                  "Created At : ${DateFormat.yMMMMd().format(DateTime.parse(widget.todo.created))}",
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(widget.todo.completed ? "Done" : "Not Done",
                    style: const TextStyle(fontSize: 25, color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
