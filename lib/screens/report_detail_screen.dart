import 'package:flutter/material.dart';

class ReportDetailScreen extends StatelessWidget {
  const ReportDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            Card(
              child: ListTile(
                leading: Icon(Icons.warning,color: Colors.red),
                title: Text("Severity"),
                subtitle: Text("High"),
              ),
            ),

            Card(
              child: ListTile(
                leading: Icon(Icons.location_on,color: Colors.green),
                title: Text("Location"),
                subtitle: Text("Live location saved with report"),
              ),
            ),

            Card(
              child: ListTile(
                leading: Icon(Icons.speed,color: Colors.orange),
                title: Text("G-Force"),
                subtitle: Text("2.8 G"),
              ),
            ),

            Card(
              child: ListTile(
                leading: Icon(Icons.timer),
                title: Text("Date & Time"),
                subtitle: Text(DateTime.now().toString()),
              ),
            ),

            const SizedBox(height:20),

            Container(
              height:250,
              width:double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Icon(
                  Icons.image,
                  size:100,
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.share),
                label: Text("Share Report"),
                onPressed: () {},
              ),
            )

          ],
        ),
      ),
    );
  }
}