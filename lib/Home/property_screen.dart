import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'property_list_screen.dart'; // Import the PropertyListScreen widget
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase

  runApp(MaterialApp(
    home: PropertyScreen(),
  ));
}

class PropertyScreen extends StatefulWidget {
  const PropertyScreen({Key? key}) : super(key: key);

  @override
  _PropertyScreenState createState() => _PropertyScreenState();
}

class _PropertyScreenState extends State<PropertyScreen> {
  final _formKey = GlobalKey<FormState>(); // Define _formKey here
  String _addressType = '';
  final _nameController = TextEditingController();
  final _phonenumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _priceController = TextEditingController();
  final _areaController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSold = false;
  String _message = '';

  // Firestore reference
  final CollectionReference _propertyCollection =
  FirebaseFirestore.instance.collection('properties');

  // Validation functions for each field
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    if (RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]').hasMatch(value ?? '')) {
      return 'Numbers and special characters are not accepted.';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }

    // Check if the input contains only digits
    if (RegExp(r'^[0-9]+$').hasMatch(value)) {
      return null; // Valid input
    } else {
      return 'Only numbers are allowed';
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    // Add additional email validation logic if needed
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an address';
    }
    return null;
  }

  String? _validateArea(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an area';
    }
    // Add additional validation logic for area if needed
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a price';
    }
    // Add additional validation logic for price if needed
    // Check if the input contains only digits
    if (RegExp(r'^[0-9]+$').hasMatch(value)) {
      return null; // Valid input
    } else {
      return 'Only numbers are allowed';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('PropertyScreen'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // Assign _formKey to the Form widget
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateName, // Apply validation
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _phonenumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validatePhoneNumber, // Apply validation
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateEmail, // Apply validation
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateAddress, // Apply validation
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: _addressType.isNotEmpty ? _addressType : null, // Set value based on _addressType
                  onChanged: (newValue) {
                    setState(() {
                      _addressType = newValue!;
                    });
                  },
                  items: <String>['','Apart', 'For Rent', 'For Sale', 'For Purchase']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Address Type',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _areaController,
                  decoration: InputDecoration(
                    labelText: 'Area',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateArea, // Apply validation
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  // Validation logic for description
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,

                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validatePrice, // Apply validation
                ),
                SizedBox(height: 16.0),
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
                SizedBox(height: 16.0),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Form is valid, submit the data

                        try {
                          // Save the property data to Firestore using _propertyCollection
                          await _propertyCollection.add({
                            'userId': userId, // Associate the property with the user ID
                            'name': _nameController.text,
                            'phonenumber': _phonenumberController.text,
                            'email': _emailController.text,
                            'address': _addressController.text,
                            'addressType': _addressType,
                            'price': _priceController.text,
                            'area': _areaController.text,
                            'description': _descriptionController.text,
                            'isSold': _isSold,
                          });

                          // Display a confirmation message
                          setState(() {
                            _message = 'Property data saved successfully!';
                          });
                        } catch (error) {
                          // Handle any errors that occur during data saving
                          setState(() {
                            _message = 'Error saving property data: $error';
                          });
                        }

                        // Navigate to the new screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PropertyListScreen(),
                          ),
                        );
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(_message, style: TextStyle(color: Colors.green)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
