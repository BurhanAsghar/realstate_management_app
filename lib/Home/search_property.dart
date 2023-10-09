import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:realstate_management_app/Home/property_list_screen.dart';

class SearchProperty extends StatefulWidget {
  @override
  _SearchPropertyState createState() => _SearchPropertyState();
}

class _SearchPropertyState extends State<SearchProperty> {
  String _searchName = '';
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final CollectionReference _propertyCollection =
    FirebaseFirestore.instance.collection('properties');

    return Scaffold(
      appBar: AppBar(
        title: Text('Property Search'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _searchName = _searchController.text;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _propertyCollection
                    .where('name', isEqualTo: _searchName)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No properties found.'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var property = snapshot.data!.docs[index];
                        return ListTile(
                          title: Text(property['name']),
                          subtitle: Text(property['address']),
                          onTap: () {
                            // Navigate to the PropertyDetailsScreen and pass property data
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PropertyDetailsScreen(
                                  propertyData: property.data() as Map<String, dynamic>,
                                  documentId: '', // You can pass an empty string or any suitable default value here
                                ),
                              ),
                            );
                          },

                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
