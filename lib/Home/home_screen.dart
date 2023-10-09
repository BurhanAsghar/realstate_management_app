import 'package:flutter/material.dart';
import 'package:realstate_management_app/Home/calculator_screen.dart';
import 'package:realstate_management_app/Home/deal_screen.dart';
import 'package:realstate_management_app/Home/profile_screen.dart';
import 'package:realstate_management_app/Home/property_screen.dart';
import 'package:realstate_management_app/Home/task_screen.dart';
import 'package:realstate_management_app/Home/search_property.dart';
import 'package:realstate_management_app/Home/property_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:realstate_management_app/Auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.indigo,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: const Text('Home Screen'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                HomeScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: const Text('Log out'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  title: Text(
                    'Hi Welcome',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    'How Can I Help You?',
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      color: Colors.white54,
                    ),
                  ),
                 /* trailing: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/burhanpic.jpeg'),
                  ),  */
                ),
              ],
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(100),
                ),
              ),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 40,
                mainAxisSpacing: 30,
                children: [
                  itemDashboard(context, 'Search', Icons.search, Colors.deepOrange, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchProperty()),
                    );
                  }),
                  itemDashboard(context, 'Tasks', Icons.add_task_sharp, Colors.deepOrange, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TaskScreen()),
                    );
                  }),
                  itemDashboard(context, 'Properties', Icons.add_business, Colors.deepOrange, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PropertyScreen()),
                    );
                  }),
                  itemDashboard(context, 'Deals', Icons.work, Colors.deepOrange, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DealScreen()),
                    );
                  }),
                  itemDashboard(context, 'PropertyList', Icons.list_alt, Colors.deepOrange, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PropertyListScreen()), // Use the correct class name
                    );
                  }),
                  itemDashboard(context, 'Calculator', Icons.calculate_outlined, Colors.deepOrange, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CalculatorScreen()),
                    );
                  }),
                  // itemDashboard(context, 'properties', Icons.business_sharp, Colors.deepOrange, () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => SearchProperty()),
                  //   );
                  // }),
                  // itemDashboard(context, 'Calculator', Icons.calculate_outlined, Colors.deepOrange, () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => SearchProperty()),
                  //   );
                  // }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

typedef VoidCallback = void Function();

Widget itemDashboard(BuildContext context, String title, IconData iconData, Color background, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Theme.of(context).primaryColor.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconData,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    ),
  );
}
