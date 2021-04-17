import 'dart:io';

import 'package:contact_app/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;
  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  bool _contactEdited = false;
  Contact _editedContact;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  Future<bool> _requestPop() {
    if (_contactEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Deseja descartar as alterações?"),
              content: Text("Se sim, todas as suas alterações serão perdidas."),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancelar")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text("Sim"))
              ],
            );
          });
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(_editedContact.name ?? "Novo contato"),
            backgroundColor: Colors.deepOrange,
            centerTitle: true,
          ),
          backgroundColor: Colors.deepOrange[100],
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.save),
            backgroundColor: Colors.deepOrange[400],
            onPressed: () {
              if (_editedContact.name != null &&
                  _editedContact.name.isNotEmpty) {
                Navigator.pop(context, _editedContact);
              }
            },
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                GestureDetector(
                  child: Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _editedContact.img != null
                              ? FileImage(File(_editedContact.img))
                              : AssetImage("images/avatar.png"),
                          fit: BoxFit.cover),
                    ),
                  ),
                  onTap: () {
                    ImagePicker.platform
                        .pickImage(source: ImageSource.camera)
                        .then((file) {
                      if (file != null) {
                        setState(() {
                          _editedContact.img = file.path;
                        });
                      }
                    });
                  },
                ),
                Padding(padding: EdgeInsets.only(top: 24.0)),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.deepOrange[400],
                    hintText: 'Nome',
                    hintStyle: TextStyle(
                        fontSize: 14.0,
                        color: Color.fromRGBO(255, 255, 255, 1)),
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrange[600]),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    errorBorder: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.red, width: 0.0),
                    ),
                    focusedErrorBorder: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.red, width: 0.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Color.fromRGBO(197, 197, 197, 1)),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onChanged: (text) {
                    _contactEdited = true;
                    setState(() {
                      _editedContact.name = text;
                    });
                  },
                ),
                Padding(padding: EdgeInsets.only(top: 16.0)),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.deepOrange[400],
                    hintText: 'E-mail',
                    hintStyle: TextStyle(
                        fontSize: 14.0,
                        color: Color.fromRGBO(255, 255, 255, 1)),
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrange[600]),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    errorBorder: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.red, width: 0.0),
                    ),
                    focusedErrorBorder: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.red, width: 0.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Color.fromRGBO(197, 197, 197, 1)),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (text) {
                    _contactEdited = true;
                    setState(() {
                      _editedContact.email = text;
                    });
                  },
                ),
                Padding(padding: EdgeInsets.only(top: 16.0)),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.deepOrange[400],
                    hintText: 'Telefone',
                    hintStyle: TextStyle(
                        fontSize: 14.0,
                        color: Color.fromRGBO(255, 255, 255, 1)),
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrange[600]),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    errorBorder: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.red, width: 0.0),
                    ),
                    focusedErrorBorder: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.red, width: 0.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Color.fromRGBO(197, 197, 197, 1)),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (text) {
                    _contactEdited = true;
                    setState(() {
                      _editedContact.phone = text;
                    });
                  },
                )
              ],
            ),
          ),
        ),
        onWillPop: _requestPop,
      ),
    );
  }
}
