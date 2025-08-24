import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _userToDO = '';
  List<String> todoList = [];
  int? editingIndex;
  TextEditingController _editController = TextEditingController();

@override
void initState() {
  super.initState();
  _loadTodoList();
}
void _menuOpen() {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (BuildContext context) {
    return Scaffold(
     appBar: AppBar(title: Text('Меню'),),
     body: Row(
       children: [
         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
           child: ElevatedButton(
             onPressed: () {
               Navigator.pop(context);
               Navigator.pushNamedAndRemoveUntil(
                   context, '/', (route) => false);
             },
             child: Text('На главную'),
           ),
         ),


       ],
     )
    );
    })
  );
}

//редактирование
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  // Загрузка списка из SharedPreferences
  void _loadTodoList() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? storedList = prefs.getStringList('todoList');
    if (storedList != null) {
      setState(() {
        todoList = storedList;
      });
    } else {
      // Можно задать начальные задачи, если нужно
      setState(() {
        todoList = [];
      });
    }
  }
  // Сохранение списка в SharedPreferences
  void _saveTodoList() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('todoList', todoList);
  }
  // Добавление задачи
  void _addTask(String task) {
    setState(() {
      todoList.add(task);
    });
    _saveTodoList();
  }
  // Удаление задачи по индексу
  void _removeTask(int index) {
    setState(() {
      todoList.removeAt(index);
    });
    _saveTodoList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Список дел'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: _menuOpen,
              icon: Icon(Icons.menu_outlined))
        ],
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(todoList[index]),
            onDismissed: (direction) {
              setState(() {
                todoList.removeAt(index);
              });
              _saveTodoList();
            },
            child: Card(
              child: ListTile(
                title: (editingIndex == index)
                    ? TextField(
                  controller: _editController,
                  autofocus: true,
                  onSubmitted: (value) {
                    setState(() {
                      todoList[index] = value;
                      editingIndex = null;
                    });
                    _saveTodoList();
                  },
                )
                    : Text(todoList[index]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.green),
                      onPressed: () {
                        TextEditingController _dialogController = TextEditingController(text: todoList[index]);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Редактировать задачу'),
                              content: TextField(
                                controller: _dialogController,
                                autofocus: true,
                                decoration: InputDecoration(hintText: 'Введите новую задачу'),
                              ),
                              actions: [
                                TextButton(
                                  child: Text('Отмена'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                ElevatedButton(
                                  child: Text('Сохранить'),
                                  onPressed: () {
                                    setState(() {
                                      todoList[index] = _dialogController.text;
                                    });
                                    _saveTodoList();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon:
                      Icon(Icons.delete_sweep, color: Colors.deepOrangeAccent),
                      onPressed: () {
                        _removeTask(index);
                        if (editingIndex == index) {
                          editingIndex = null;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Добавить новую задачу'),
                content: TextField(
                  onChanged: (String value) {
                    _userToDO = value;
                  },
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      if (_userToDO.trim().isNotEmpty) {
                        _addTask(_userToDO.trim());
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text('Добавить'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add_box, color: Colors.white),
      ),
    );
  }
}