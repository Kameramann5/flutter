import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text('Список дел'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // чтобы колонка занимала минимально возможное пространство
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Начальный экран', style: TextStyle(color: Colors.white)),
              SizedBox(height: 20), // добавим отступ между элементами
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/todo');
                },
                child: Text('Перейти в список дел'),
              ),
            ],
          ),
        ),
    );
  }
}