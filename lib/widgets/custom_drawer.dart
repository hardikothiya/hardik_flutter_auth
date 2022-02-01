import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hardik_flutter_auth/screens/home_page.dart';
import 'package:hardik_flutter_auth/screens/login_screen.dart';
import 'package:hardik_flutter_auth/screens/profile_screen.dart';

class CustomDrawer extends StatelessWidget {
  _buildDrawerOption(Icon icon, String title, Function() onTap) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: const TextStyle(fontSize: 18),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    var currentUser;
    return Drawer(
      child: Column(
        children: [
          Stack(
            children: [
              Image(
                image: AssetImage(currentUser.backgroundImageUrl),
                width: double.infinity,
                fit: BoxFit.cover,
                height: 200,
              ),
              Positioned(
                bottom: 20,
                left: 20,
                child: Row(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(currentUser.profileImageUrl),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 3),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      currentUser.name,
                      style: const TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          ),
          _buildDrawerOption(
            const Icon(Icons.dashboard),
            'Home',
            () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => HomeScreen())),
          ),
          _buildDrawerOption(const Icon(Icons.chat), 'Chat', () {}),
          _buildDrawerOption(const Icon(Icons.location_on), 'Location', () {}),
          _buildDrawerOption(
              const Icon(Icons.account_circle),
              'Profile',
              () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ProfileScreen()))),
          _buildDrawerOption(const Icon(Icons.settings), 'Setting', () {}),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: _buildDrawerOption(
                const Icon(Icons.directions_run),
                'Logout',
                () => Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginScreen())),
              ),
            ),
          )
        ],
      ),
    );
  }
}
