import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Profile"),
      ),

      body: ListView(

        padding: const EdgeInsets.all(20),

        children: [

          const CircleAvatar(
            radius: 60,
            child: Icon(
              Icons.person,
              size: 70,
            ),
          ),

          const SizedBox(height:20),

          const Center(
            child: Text(
              "RoadSafe User",
              style: TextStyle(
                  fontSize:24,
                  fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height:30),

          Card(
            child: ListTile(
              leading: Icon(Icons.email),
              title: Text("Email"),
              subtitle: Text("user@email.com"),
            ),
          ),

          Card(
            child: ListTile(
              leading: Icon(Icons.phone),
              title: Text("Phone"),
              subtitle: Text("+91 9876543210"),
            ),
          ),

          Card(
            child: ListTile(
              leading: Icon(Icons.location_city),
              title: Text("City"),
              subtitle: Text("Mangalore"),
            ),
          ),

          Card(
            child: ListTile(
              leading: Icon(Icons.history),
              title: Text("Reports Submitted"),
              trailing: Chip(
                label: Text("18"),
              ),
            ),
          ),

        ],

      ),

    );

  }

}