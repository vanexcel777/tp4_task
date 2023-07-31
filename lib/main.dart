import 'package:flutter/material.dart';
import 'db_test.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final dogDatabase = DogDatabase();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dog App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dog Application '),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  // Insert a new dog
                  final dog = Dog(id: 1, name: 'Fido', age: 3);
                  await dogDatabase.insertDog(dog);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Dog inserted')),
                  );
                },
                child: Text('Insert Dog'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Get all dogs
                  final dogs = await dogDatabase.getAllDogs();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Dogs'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                            dogs.map((dog) => Text(dog.toString())).toList(),
                      ),
                    ),
                  );
                },
                child: Text('Get All Dogs'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Get a dog
                  final id = 1;
                  final dog = await dogDatabase.getDog(id);
                  if (dog != null) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Dog'),
                        content: Text(dog.toString()),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Dog not found')),
                    );
                  }
                },
                child: Text('Get Dog'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Update a dog
                  final id = 1;
                  final dog = await dogDatabase.getDog(id);
                  if (dog != null) {
                    final updatedDog = Dog(id: dog.id, name: 'Rufus', age: 5);
                    await dogDatabase.updateDog(updatedDog);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Dog updated')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Dog not found')),
                    );
                  }
                },
                child: Text('Update Dog'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Delete a dog
                  final id = 1;
                  final dog = await dogDatabase.getDog(id);
                  if (dog != null) {
                    await dogDatabase.deleteDog(id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Dog deleted')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Dog not found')),
                    );
                  }
                },
                child: Text('Delete Dog'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
