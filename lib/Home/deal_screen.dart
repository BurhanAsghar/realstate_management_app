import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class DealScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deal List'),
      ),
      body: DealsList(),
    );
  }
}

class DealsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('properties').where('isSold', isEqualTo: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        else
        {
          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
            // No properties to display, show a message
            return Center(child: Text('No properties are marked as sold.'));
          }
          else
          {
            final propertyDocs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: propertyDocs.length,
              itemBuilder: (context, index) {
                final propertyData = propertyDocs[index].data() as Map<String, dynamic>;
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(propertyData['name']),
                    subtitle: Text(propertyData['address']),
                    onTap: () {
                      // Navigate to a property details screen with propertyData
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PropertyDetailsScreen(propertyData: propertyData),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        }



      },
    );
  }
}


class PropertyDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> propertyData;

  PropertyDetailsScreen({required this.propertyData});

  @override
  Widget build(BuildContext context) {
    // Build a detailed view of the property using propertyData
    return Scaffold(
      appBar: AppBar(
        title: Text('Property Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${propertyData['name']}'),
            Text('Address: ${propertyData['address']}'),
            Text('Phone Number: ${propertyData['phonenumber']}'),

            // Add more property details as needed
          ],
        ),
      ),
    );
  }
}

