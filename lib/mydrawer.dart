import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.redAccent,
      child: Column(
        children: <Widget>[
          // DrawerHeader(child: Text("Custom Header")),
          ListTile(
            tileColor: Colors.white,
            title: Image.network(
                "https://akm-img-a-in.tosshub.com/lingo/gnt/resources/img/logo.png",
                height: 40.0,
                alignment: Alignment.bottomLeft),
            // trailing: Icon(Icons.contacts),
            onTap: () {},
            selected: false,
          ),
          ListTile(
            title: Text(
              "About",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            // trailing: Icon(Icons.contacts),
            onTap: () {},
            selected: false,
          ),
          Divider(
            color: Colors.white,
          ),
          ListTile(
            title: Text("Contacts",
                style: TextStyle(color: Colors.white, fontSize: 16)),
            // trailing: Icon(Icons.contacts),
            onTap: () {},
            selected: false,
          ),
        ],
      ),
    );
  }
}
