import 'package:charts_application/constants/dimensions.dart';
import 'package:charts_application/pages/appointments/user_appointments_page.dart';
import 'package:charts_application/pages/map/map_page.dart';
import 'package:charts_application/pages/posts/posts_page.dart';
import 'package:charts_application/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:persistent_bottom_nav_bar_plus/persistent_bottom_nav_bar_plus.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      const MapPageGetX(),
      const FavoritePostsPage(),
      const UserAppointmentsPage(),
      const ProfilePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
     
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.map),
        title: "Map".tr,
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
       PersistentBottomNavBarItem(
        icon: const Icon(Icons.feed_outlined),
        title: "Posts".tr,
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.date_range),
        title: "Appointments".tr,
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon:  Icon(
          Icons.person,
          size: Dimensions.iconSize16(context),
          ),
        title: "Profile".tr,
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white, 
      navBarStyle: NavBarStyle.style6, 
    );
  }
}
