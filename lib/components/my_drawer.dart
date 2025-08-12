import 'package:chat_apps/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import '../pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  void logout() {
  //get auth service
  final auth = AuthService();
  auth.signOut();
   }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         Column(children: [
           //logo
          DrawerHeader(
            child: Center(
              child: Icon(
                Icons.message,
                color: Theme.of(context).colorScheme.primary,
                size: 40,
              ),
            ),
          ),

        //home list title
          ListTile(
            contentPadding: const EdgeInsets.only(left: 25),
            leading:  Icon(Icons.home, color: Theme.of(context).colorScheme.onBackground),
            title: const Text("H 0 M E"),
            onTap: () {
              //pop the drawer
              Navigator.pop(context);
            },
          ),

         //settings list title
          ListTile(
            contentPadding: const EdgeInsets.only(left: 25),
            leading:  Icon(Icons.settings, color: Theme.of(context).colorScheme.onBackground),
            title: const Text("S E T T I N G S"),
            onTap: () {
              //pop the drawer
              Navigator.pop(context);

              //navigate to settings page
              Navigator.push(
                context,
                 MaterialPageRoute(
                  builder:(context) => const SettingsPage(),
                  ),
              );
            },
          ),

         ],
         ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 25, bottom: 25),
            leading:  Icon(Icons.logout, color: Theme.of(context).colorScheme.onBackground),
            title: const Text("L O G O U T"),
            onTap: logout,
          ),
        ],
      ),
    );
  }
}
