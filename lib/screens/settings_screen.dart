import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  bool voiceAlert=true;
  bool vibration=true;
  bool darkMode=false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Settings"),
      ),

      body: ListView(

        children: [

          SwitchListTile(

            title: const Text("Voice Alert"),

            value: voiceAlert,

            onChanged: (value){
              setState(() {
                voiceAlert=value;
              });
            },

          ),

          SwitchListTile(

            title: const Text("Vibration"),

            value: vibration,

            onChanged: (value){
              setState(() {
                vibration=value;
              });
            },

          ),

          SwitchListTile(

            title: const Text("Dark Mode"),

            value: darkMode,

            onChanged: (value){
              setState(() {
                darkMode=value;
              });
            },

          ),

          ListTile(
            leading: Icon(Icons.language),
            title: Text("Language"),
            subtitle: Text("English"),
          ),

          ListTile(
            leading: Icon(Icons.storage),
            title: Text("Storage Used"),
            subtitle: Text("120 MB"),
          ),

        ],

      ),

    );

  }

}