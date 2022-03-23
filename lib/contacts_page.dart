// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hive_learn/contacts.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final List<Contact> _contacts = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(_contacts[index].name.substring(0, 2).toUpperCase()),
            ),
            title: Text(_contacts[index].name),
            subtitle: Text(_contacts[index].phoneNumnber),
            onLongPress: () async {
              Contact? contact = await showDialog(
                  context: context,
                  builder: (context) {
                    return ContactsDialog(contact: _contacts[index], isEditing: true,);
                  });
              setState(() {
                if (contact != null) {
                  _contacts.removeAt(index);
                  _contacts.insert(index, contact);
                }
              });
            },
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _contacts.removeAt(index);
                });
              },
              icon: Icon(
                Icons.delete,
                size: 20,
                color: Colors.red,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Contact? contact = await showDialog(
              context: context,
              builder: (context) {
                return ContactsDialog();
              });
          setState(() {
            if (contact != null) _contacts.add(contact);
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ContactsDialog extends StatefulWidget {
  final Contact? contact;
  final bool isEditing;

  ContactsDialog({this.contact, this.isEditing = false});

  @override
  State<ContactsDialog> createState() => _ContactsDialogState();
}

class _ContactsDialogState extends State<ContactsDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? name;
  String? phoneNumber;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = widget.contact?.name;
    phoneNumber = widget.contact?.phoneNumnber;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add a contact'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNameField(),
            SizedBox(
              height: 10,
            ),
            _buildNumberField(),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      actions: _buildButtons(context),
    );
  }

  List<Widget> _buildButtons(BuildContext context) {
    return [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          var isValid = _formKey.currentState!.validate();
          if (isValid) {
            var contact = Contact()
              ..name = name!
              ..phoneNumnber = phoneNumber!;
            Navigator.pop(context, contact);
          }
        },
        child: Text(widget.isEditing ? 'Save' : 'Add'),
      ),
    ];
  }

  TextFormField _buildNumberField() {
    return TextFormField(
            initialValue: phoneNumber,
            onChanged: (newValue) {
              phoneNumber = newValue;
            },
            validator: (value) {
              if (value == null ||
                  int.tryParse(value) == null ||
                  value.length < 11 ||
                  value.length > 11) {
                return 'Invalid phone number!';
              }
              return null;
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                isDense: true,
                contentPadding: EdgeInsets.all(8),
                hintText: 'Phone number'),
          );
  }

  TextFormField _buildNameField() {
    return TextFormField(
            initialValue: name,
            onChanged: (newValue) {
              name = newValue;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Name field cannnot be empty';
              }
              return null;
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                isDense: true,
                contentPadding: EdgeInsets.all(8),
                hintText: 'Name'),
          );
  }
}
