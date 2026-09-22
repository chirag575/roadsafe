import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Detection Reports"),
      ),

      body: ListView.builder(

        itemCount: 10,

        itemBuilder: (context,index){

          return Card(

            margin: const EdgeInsets.all(10),

            child: ListTile(

              leading: const CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(Icons.warning,color: Colors.white),
              ),

              title: Text("Pothole Report ${index+1}"),

              subtitle: const Text(
                  "High Severity\nGPS: Live location saved with report"),

              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: (){
                  Navigator.pushNamed(
                    context,
                    "/reportDetails",
                  );
                },
              ),

            ),

          );

        },

      ),

      floatingActionButton: FloatingActionButton.extended(

        onPressed: (){},

        icon: const Icon(Icons.download),

        label: const Text("Export"),

      ),

    );

  }

}