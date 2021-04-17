import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();
  factory ContactHelper() => _instance;
  final String _tableName = "contacts";

  ContactHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initDB();
    }

    return _db;
  }

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, "contact.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newVersion) async {
      await db.execute(
          "CREATE TABLE $_tableName(id INTEGER PRIMARY KEY, name TEXT, email TEXT, phone TEXT, img TEXT)");
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    Database dbContact = await db;

    contact.id = await dbContact.insert(_tableName, contact.toMap());

    return contact;
  }

  Future<Contact> getContact(int id) async {
    Database dbContact = await db;

    List<Map> maps = await dbContact.query(_tableName,
        columns: ["id", "name", "email", "phone", "img"],
        where: "id = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return Contact.fromMap(maps.first);
    }
  }

  Future<int> updateContact(Contact contact) async {
    print(contact);
    Database dbContact = await db;

    return await dbContact.update(_tableName, contact.toMap(),
        where: "id = ?", whereArgs: [contact.id]);
  }

  Future<int> deleteContact(int id) async {
    print(id);
    Database dbContact = await db;

    return await dbContact.delete(_tableName, where: "id = ?", whereArgs: [id]);
  }

  Future<List> getAll() async {
    Database dbContact = await db;

    List listMap = await dbContact.rawQuery("SELECT * FROM $_tableName");

    List<Contact> listContacts = List();

    for (Map m in listMap) {
      listContacts.add(Contact.fromMap(m));
    }

    return listContacts;
  }

  Future<List> searchContact(String search) async {
    Database dbContact = await db;

    List<Map> maps = await dbContact.rawQuery(
        "SELECT * FROM $_tableName WHERE name LIKE '%$search%' OR email LIKE '%$search%' OR phone LIKE '%$search%' ");

    List<Contact> listContacts = List();

    for (Map m in maps) {
      listContacts.add(Contact.fromMap(m));
    }

    return listContacts;
  }

  Future close() async {
    Database dbContact = await db;
    await dbContact.close();
  }
}

class Contact {
  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact();

  Contact.fromMap(Map map) {
    id = map["id"];
    name = map["name"];
    email = map["email"];
    phone = map["phone"];
    img = map["img"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "name": name,
      "email": email,
      "phone": phone,
      "img": img,
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }
}
