import 'package:flutter/material.dart';
import 'package:manager_app/db/model/drawer.dart';
import 'package:manager_app/pages/homescreen_widgets/delete_account.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<DrawerDetails> drawerdata = [
      DrawerDetails(title: 'Privacy and Policy', trailing: ''),
      DrawerDetails(title: 'Version', trailing: '1.0.2'),
      DrawerDetails(title: 'Terms and Conditions', trailing: ''),
      DrawerDetails(title: 'Feedback', trailing: ''),
    ];

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          const DrawerHeader(
            child: Center(
              child: Text(
                'About',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 35),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: drawerdata.length + 1,
              padding: const EdgeInsets.all(8),
              itemBuilder: (BuildContext context, int index) {
                if (index < drawerdata.length) {
                  return ListTile(
                    title: Text(drawerdata[index].title),
                    trailing: Text(drawerdata[index].trailing),
                  );
                } else {
                  return const ListTile(
                    title: DeleteAccount(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    // Implement navigation logic based on the index
    // For example:
    switch (index) {
      case 0:
        // Navigate to Privacy and Policy page
        // Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyPage()));
        break;
      case 1:
        // Navigate to Version page
        // Navigator.push(context, MaterialPageRoute(builder: (context) => VersionPage()));
        break;
      // Add cases for other menu items
    }
  }
}
