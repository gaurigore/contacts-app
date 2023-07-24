import 'package:contact_app/model/contactModel.dart';

import 'package:contact_app/ui/addContact/newContactScreen.dart';
import 'package:contact_app/ui/editContact/editContactScreen.dart';
import 'package:flutter/material.dart';

import '../db/databaseHelper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Contact> _contacts = [];
  String _order = "ASC";

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts({String? orderBy}) async {
    List<Contact> contactList =
        await DatabaseHelper.instance.queryAllContacts(orderBy: orderBy);
    setState(() {
      _contacts = contactList;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("here is contact");
    print(_contacts);
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Contact Manager'),
                      actions: [
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context, true);
                            bool result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewContactScreen()));
                            if (result) {
                              _loadContacts();
                            }
                          },
                          child: const Text('Add New Contact'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await _loadContacts(orderBy: 'name $_order');
                            setState(() {
                              _order = 'DESC';
                            });
                          },
                          child: const Text('Sort'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await _loadContacts();
                          },
                          child: const Text('Reset'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.more_vert)),
        ],
      ),
      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              title: Text(
                _contacts[index].name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_contacts[index].phone),
                  Text(_contacts[index].email),
                ],
              ),
              trailing: IconButton(
                onPressed: () async {
                  bool result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditContactScreen(
                              contactId: _contacts[index].id!)));
                  if (result) {
                    _loadContacts();
                  }
                },
                icon: Icon(Icons.edit),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/edit_contact',
                    arguments: _contacts[index]);
              },
            ),
          );
        },
      ),
    );
  }

  void _sortContacts() {
    setState(() {
      _contacts.sort((a, b) => a.name.compareTo(b.name));
    });
  }
}
