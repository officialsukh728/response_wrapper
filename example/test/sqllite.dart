import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Form App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserFormScreen(),
    );
  }
}

class UserModel {
  String id;
  String username;
  String email;
  String contact;

  UserModel({this.id, this.username, this.email, this.contact});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'contact': contact,
    };
  }

  UserModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    username = map['username'];
    email = map['email'];
    contact = map['contact'];
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'users.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
      'CREATE TABLE User(id TEXT PRIMARY KEY, username TEXT, email TEXT, contact TEXT)',
    );
  }

  Future<int> saveUser(UserModel user) async {
    var dbClient = await db;
    return await dbClient.insert('User', user.toMap());
  }

  Future<List<UserModel>> getUsers() async {
    var dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient.query('User');
    return result.map((data) => UserModel.fromMap(data)).toList();
  }
}

class UserFormScreen extends StatefulWidget {
  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username;
  String _email;
  String _contact;

  void _saveUser() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      var uuid = Uuid();
      UserModel user = UserModel(
        id: uuid.v4(),
        username: _username,
        email: _email,
        contact: _contact,
      );
      await DatabaseHelper().saveUser(user);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserListScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add User')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter username';
                  }
                  return null;
                },
                onSaved: (value) => _username = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
                onSaved: (value) => _email = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contact Number'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter contact number';
                  }
                  return null;
                },
                onSaved: (value) => _contact = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveUser,
                child: Text('Save User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User List')),
      body: FutureBuilder<List<UserModel>>(
        future: DatabaseHelper().getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data.isEmpty) {
            return Center(child: Text('No users found.'));
          }
          List<UserModel> users = snapshot.data;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(users[index].username),
                subtitle: Text('Email: ${users[index].email}'),
                trailing: Text('Contact: ${users[index].contact}'),
              );
            },
          );
        },
      ),
    );
  }
}
