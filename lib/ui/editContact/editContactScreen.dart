import 'package:contact_app/db/databaseHelper.dart';
import 'package:contact_app/model/contactModel.dart';
import 'package:flutter/material.dart';

class EditContactScreen extends StatefulWidget {
  final int contactId;

  const EditContactScreen({
    Key? key,
    required this.contactId,
  });

  @override
  State<EditContactScreen> createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _phone = '';

  @override
  void initState() {
    super.initState();
    getContact(widget.contactId);
  }

  void getContact(int id) async {
    Contact? contact = await DatabaseHelper.instance.queryContactById(id);
    if (contact != null) {
      setState(() {
        _name = contact.name;
        _email = contact.email;
        _phone = contact.phone;
      });
    }
  }

  void _updateContact() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Contact newContact = Contact(
          id: widget.contactId, name: _name, email: _email, phone: _phone);

      DatabaseHelper.instance
          .updateContact(newContact, widget.contactId)
          .then((results) {
        if (results < 1) {
          Navigator.pop(context, false);
        } else {
          Navigator.pop(context, true);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_name.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Contact'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                initialValue: _email,
                decoration: InputDecoration(labelText: 'Email Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email address';
                  } else if (!value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                initialValue: _phone,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  } else if (value.length != 10) {
                    return 'Please enter a valid 10-digit phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phone = value!;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _updateContact,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
