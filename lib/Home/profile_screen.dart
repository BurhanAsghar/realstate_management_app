import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();

  final CollectionReference _profileCollection =
  FirebaseFirestore.instance.collection('Profile');

  @override
  void initState() {
    super.initState();
    // Load profile data when the screen is first opened
    _loadProfileData();
  }

  void _loadProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    if (userId != null) {
      try {
        final querySnapshot = await _profileCollection.doc(userId).get();
        if (querySnapshot.exists) {
          final profileData = querySnapshot.data() as Map<String, dynamic>;
          setState(() {
            _companyController.text = profileData['Company'] ?? '';
            _nameController.text = profileData['Name'] ?? '';
            _phoneController.text = profileData['Phone No'] ?? '';
            _cityController.text = profileData['City'] ?? '';
            _addressController.text = profileData['Address'] ?? '';
          });
        }
      } catch (error) {
        // Handle any errors here
        print('Error loading profile data: $error');
      }
    }
  }

  void _saveOrUpdateProfile() async {
    if (_formKey.currentState!.validate()) {
      final company = _companyController.text;
      final name = _nameController.text;
      final phone = _phoneController.text;
      final city = _cityController.text;
      final address = _addressController.text;

      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid;

      try {
        final querySnapshot = await _profileCollection.doc(userId).get();
        if (querySnapshot.exists) {
          await _profileCollection.doc(userId).update({
            'UserID': userId, // Include the user's ID here
            'Company': company,
            'Name': name,
            'Phone No': phone,
            'City': city,
            'Address': address,
          });
        } else {
          await _profileCollection.doc(userId).set({
            'UserID': userId, // Include the user's ID here
            'Company': company,
            'Name': name,
            'Phone No': phone,
            'City': city,
            'Address': address,
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile saved successfully!'),
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving profile: $error'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _companyController,
                decoration: InputDecoration(labelText: 'Company/Office Name*'),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a company name.';
                  }
                  if (RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]').hasMatch(value ?? '')) {
                    return 'Numbers and special characters are not accepted.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name*'),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your name.';
                  }
                  if (RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]').hasMatch(value ?? '')) {
                    return 'Numbers and special characters are not accepted.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone No*'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a phone number.';
                  }
                  // Add additional phone number validation logic if needed
                  return null;
                },
              ),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'City*'),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your city.';
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
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveOrUpdateProfile,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
