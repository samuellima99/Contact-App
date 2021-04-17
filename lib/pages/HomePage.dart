import 'dart:io';

import 'package:contact_app/helpers/contact_helper.dart';
import 'package:contact_app/pages/ContactPage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  var searchController = TextEditingController();

  List<Contact> _contacts = List();

  void _getAllContact() {
    helper.getAll().then((list) {
      setState(() {
        _contacts = list;
      });
    });
  }

  void _searchContact() {
    print(searchController.text);
    helper.searchContact(searchController.text).then((list) {
      print(list);
      setState(() {
        _contacts = list;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();

    _getAllContact();
  }

  void changeSearch(String text) {
    if (text.isEmpty) {
      searchController.text = "";
      _getAllContact();
    }
  }

  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contact: contact,
                )));

    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContact();
    }
  }

  void _showOptions(BuildContext context, Contact contact) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextButton(
                        onPressed: () {
                          launch("tel: ${contact.phone}");
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Ligar",
                          style: TextStyle(
                              color: Colors.pink[900], fontSize: 20.0),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showContactPage(contact: contact);
                        },
                        child: Text(
                          "Editar",
                          style: TextStyle(
                              color: Colors.pink[900], fontSize: 20.0),
                        )),
                    TextButton(
                        onPressed: () {
                          helper.deleteContact(contact.id).then((value) {
                            Navigator.pop(context);
                            _getAllContact();
                          });
                        },
                        child: Text(
                          "Remover",
                          style: TextStyle(
                              color: Colors.pink[900], fontSize: 20.0),
                        )),
                  ],
                ),
              );
            },
            onClosing: () {},
          );
        });
  }

  Widget _searchComponent() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Container(
                    margin: EdgeInsets.only(
                        right: 4.0, left: 4.0, top: 16.0, bottom: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Form(
                                key: _formKey,
                                child: TextFormField(
                                    controller: searchController,
                                    validator: (valor) {
                                      if (valor.isEmpty) {
                                        return 'Informe nome, email ou telefone!';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onChanged: changeSearch,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontSize: 18.0),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.deepOrange[400],
                                      hintText: 'Search...',
                                      hintStyle: TextStyle(
                                          fontSize: 14.0,
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1)),
                                      contentPadding: const EdgeInsets.only(
                                          left: 14.0, bottom: 8.0, top: 8.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.deepOrange[600]),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      errorBorder: new OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Colors.red, width: 0.0),
                                      ),
                                      focusedErrorBorder:
                                          new OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Colors.red, width: 0.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Color.fromRGBO(
                                                197, 197, 197, 1)),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    )))),
                        Container(
                          margin: EdgeInsets.only(left: 8.0),
                          width: 60,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            gradient: LinearGradient(
                              colors: [
                                Colors.deepOrange[500],
                                Colors.deepOrange[800],
                              ],
                              begin: FractionalOffset.centerLeft,
                              end: FractionalOffset.centerRight,
                            ),
                          ),
                          child: TextButton(
                            child: Icon(
                              Icons.search,
                              size: 32.0,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _searchContact();
                            },
                          ),
                        ),
                      ],
                    )))
          ],
        )
      ],
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    var contact = _contacts[index];

    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: contact.img != null
                          ? FileImage(File(contact.img))
                          : Image.network(
                              "https://civilis.com.br/assets/3e95807c/assets/images/default-user.png"),
                      fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name ?? "",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contact.email ?? "",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      contact.phone ?? "",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, contact);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Contatos"),
              backgroundColor: Colors.deepOrange,
              centerTitle: true,
            ),
            backgroundColor: Colors.deepOrange[100],
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Colors.deepOrange[400],
              onPressed: () {
                _showContactPage();
              },
            ),
            body: Column(
              children: [
                Container(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    child: _searchComponent()),
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemCount: _contacts.length,
                      itemBuilder: (context, index) {
                        return _contactCard(context, index);
                      }),
                )
              ],
            )));
  }
}
