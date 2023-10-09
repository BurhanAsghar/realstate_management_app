/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class PropertyListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Property List'),
      ),
      body: PropertyList(),
    );
  }
}

class PropertyList extends StatelessWidget {
  /*void _markPropertyAsSold(DocumentReference propertyRef) {
    propertyRef.update({'status': 'sold'})
        .then((_) => print('Property marked as sold'))
        .catchError((error) => print('Error marking property as sold: $error'));
  }*/

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('properties').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
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
              trailing:  SizedBox(
                  width: 100,
                  child: Row(

            ),
            ),
            ),
            );
          },
        );
      },
    );
  }
}

children: [
// Press this button to edit a single product
IconButton(
icon: const Icon(Icons.edit),
onPressed: () =>
_update(documentSnapshot)),
This icon button is used to delete a single product
IconButton(
icon: const Icon(Icons.delete),
onPressed: () =>
_deleteProduct(documentSnapshot.id)),
],*/


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Property List'),
      ),
      body: PropertyList(),
    );
  }
}

class PropertyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('properties').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final propertyDocs = snapshot.data!.docs;
        return ListView.builder(
          itemCount: propertyDocs.length,
          itemBuilder: (context, index) {
            final propertyData = propertyDocs[index].data() as Map<String, dynamic>;
            final documentId = propertyDocs[index].id; // Get the document ID

            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(propertyData['name']),
                subtitle: Text(propertyData['address']),
                onTap: () {
                  // Navigate to property details screen when tapping the property
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PropertyDetailsScreen(propertyData: propertyData, documentId: documentId),
                    ),
                  );
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Navigate to edit screen for the selected property
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PropertyEditScreen(propertyData: propertyData, documentId: documentId),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Show a confirmation dialog and delete the property if confirmed
                        _showDeleteConfirmationDialog(context, documentId);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Function to show a confirmation dialog for deleting a property
  void _showDeleteConfirmationDialog(BuildContext context, String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this property?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Delete the property from Firestore
                FirebaseFirestore.instance.collection('properties').doc(documentId).delete();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class PropertyDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> propertyData;
  final String documentId;

  PropertyDetailsScreen({required this.propertyData, required this.documentId});

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
            Text('Price: ${propertyData['price']}'),
            Text('Phone Number: ${propertyData['description']}'),
            Text('Status: ${propertyData['isSold'] == null ? 'Not Sold' : 'Sold'}'),






            // Add more property details as needed

            ElevatedButton(
              onPressed: () {
                // Navigate to the edit screen with the document ID
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PropertyEditScreen(propertyData: propertyData, documentId: documentId),
                  ),
                );
              },
              child: Text('Edit Property'),
            ),
          ],
        ),
      ),
    );
  }
}

class PropertyEditScreen extends StatefulWidget {
  final Map<String, dynamic> propertyData;
  final String documentId;

  PropertyEditScreen({required this.propertyData, required this.documentId});

  @override
  _PropertyEditScreenState createState() => _PropertyEditScreenState();
}

class _PropertyEditScreenState extends State<PropertyEditScreen> {
  final _formKey = GlobalKey<FormState>();
  // Define controllers for the fields
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phonenumberController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSold = false;
  // Add controllers for other fields as needed

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the existing data
    _nameController.text = widget.propertyData['name'];
    _addressController.text = widget.propertyData['address'];
    _phonenumberController.text = widget.propertyData['phonenumber'];
    _priceController.text = widget.propertyData['price'];
    _descriptionController.text = widget.propertyData['description'];
    _isSold = widget.propertyData['isSold'];


    // Initialize other controllers with existing data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Property'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                keyboardType: TextInputType.text,
                // Validation logic for name
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  if (RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]').hasMatch(value ?? '')) {
                    return 'Numbers and special characters are not accepted.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                // Validation logic for address
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phonenumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
                keyboardType: TextInputType.number, // Allow only numeric input
                // Validation logic for phone number
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  // Check if the input contains only digits
                  if (RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return null; // Valid input
                  } else {
                    return 'Only numbers are allowed';
                  }
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: ' Description'),
                // Validation logic for phone number
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                keyboardType: TextInputType.number, // Allow only numeric input
                // Validation logic for price
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  // Check if the input contains only digits
                  if (RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return null; // Valid input
                  } else {
                    return 'Only numbers are allowed';
                  }
                },
              ),
              Row(
                children: [
                  Checkbox(
                    value: _isSold,
                    onChanged: (newValue) {
                      setState(() {
                        _isSold = newValue ?? false;
                      });
                    },
                  ),
                  Text('Sold'),
                ],
              ),

              // Add form fields for other properties

              ElevatedButton(
                onPressed: () {
                  // Validate the form
                  if (_formKey.currentState!.validate()) {
                    // Perform update operation and save data to Firestore
                    _updateProperty();
                  }
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateProperty() async {
    try {
      // Update the property data in Firestore
      await FirebaseFirestore.instance.collection('properties').doc(widget.documentId).update({
        'name': _nameController.text,
        'phonenumber': _phonenumberController.text,
        'address': _addressController.text,
        'price': _priceController.text,
        'description': _descriptionController.text,
        'isSold': _isSold,


        // Update other fields as needed
      });

      // Show a success message and navigate back to property details
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Property updated successfully'),
        backgroundColor: Colors.green,
      ));

      // Navigate back to property details
      Navigator.pop(context);
    } catch (error) {
      // Handle any errors that occur during the update
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error updating property: $error'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
