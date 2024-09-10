import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/extensions/media_query.dart';
import 'package:my_app/screens/profile/profiletab.dart';
import 'package:my_app/screens/profile/social/socialmediatab.dart';
import '../../auth/firestore/firestoreService.dart';
import '../../widgets/ThemeController.dart';
import '../../widgets/appColors.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = context.deviceWidth;
    double appBarHeight = deviceWidth * 0.28;
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    Get.lazyPut(() => FirestoreService());
    final ThemeController themeController = Get.find();

    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(appBarHeight),
          child: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            leading: IconButton(
                onPressed: () => Get.offAllNamed('/mainmenu'),
                icon: const Icon(Icons.arrow_back_ios_new_sharp)),
            actions: [
              Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  );
                },
              ),
            ],
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Text(
              'Profile',
              style: GoogleFonts.adamina(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.w700),
            ),
            centerTitle: true,
            backgroundColor: AppColors.defaultColor,
            bottom: const TabBar(
              isScrollable: false,
              indicatorColor: Colors.white,
              indicatorWeight: 5,
              labelColor: Colors.orange,
              unselectedLabelColor: Colors.white,
              tabs: [
                Tab(text: 'App'),
                Tab(text: 'Social Media'),
              ],
            ),
          ),
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                  decoration: const BoxDecoration(
                    color: AppColors.defaultColor,
                  ),
                  child: Image.asset('lib/assets/logo.png')),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Get.toNamed('/settings');
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Change Language'),
                onTap: () {
                  // showLanguageSelection(context);
                },
              ),
              Obx(
                () => ListTile(
                  leading: const Icon(Icons.brightness_6_sharp),
                  title: const Text('Dark Mode'),
                  trailing: Switch(
                    activeTrackColor: Colors.orange,
                    value: themeController.isDarkMode.value,
                    onChanged: (value) {
                      themeController.toggleTheme();
                    },
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Privacy'),
                onTap: () {
                  Get.toNamed('/privacy');
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Log Out'),
                onTap: () {
                  firebaseAuth.signOut();
                  Get.offAllNamed('/homepage');
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ProfileAppTab(),
            const SocialMediaTab(), // Empty tab
          ],
        ),
      ),
    );
  }
}
