import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lumina/pages/feed_page.dart';
import 'package:lumina/pages/home_page.dart';

class SideBar extends StatelessWidget {
  final String currentPage;
  
  const SideBar({super.key, this.currentPage = 'home'});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 7, top: 7),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset("lib/assets/logo2.png", width: 30, height: 30,)),
        ),

        SizedBox(height: 21,),

        // Feed button with conditional navigation
        SizedBox(height: 11,),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: InkWell(
            onTap: () {
              // Only navigate if we're not already on FeedPage
              if (currentPage != 'home') {
                // This assumes you've stored the BlueskyService somewhere accessible
                // You might need to adjust this based on your app's structure
              }
            },
            child: Row(children: [
              Icon(
                FluentIcons.broad_activity_feed_16_regular, 
                color: currentPage == 'home' 
                  ? Colors.black 
                  : Color.fromRGBO(145, 145, 142, 1.0),
              ),
              SizedBox(width: 8,),
              Text(
                "Home", 
                style: TextStyle(
                  fontWeight: currentPage == 'home' ? FontWeight.bold : FontWeight.w500, 
                  fontSize: 14, 
                  color: currentPage == 'home' 
                    ? Colors.black 
                    : Color.fromRGBO(95, 94, 91, 1.0)
                ),
              )
            ]),
          ),
        ),
        // Search button
        SizedBox(height: 11),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(children: [
                          Icon(FluentIcons.search_16_regular, color: Color.fromRGBO(145, 145, 142, 1.0),),
                          SizedBox(width: 8,),
                          Text("Search", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color.fromRGBO(95, 94, 91, 1.0)),)
                        ]),
                      ),

                      SizedBox(height: 11,),

                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(children: [
                          Icon(FluentIcons.alert_16_regular, color: Color.fromRGBO(145, 145, 142, 1.0),),
                          SizedBox(width: 8,),
                          Text("Notifications", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color.fromRGBO(95, 94, 91, 1.0)),)
                        ]),
                      ),

                      SizedBox(height: 11,),

                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(children: [
                          Icon(FluentIcons.mail_inbox_16_regular, color: Color.fromRGBO(145, 145, 142, 1.0),),
                          SizedBox(width: 8,),
                          Text("Chat", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color.fromRGBO(95, 94, 91, 1.0)),)
                        ]),
                      ),

                      SizedBox(height: 11,),

                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(children: [
                          Icon(FluentIcons.broad_activity_feed_16_regular, color: Color.fromRGBO(145, 145, 142, 1.0),),
                          SizedBox(width: 8,),
                          Text("Feeds", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color.fromRGBO(95, 94, 91, 1.0)),)
                        ]),
                      ),

                      SizedBox(height: 11,),

                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(children: [
                          Icon(FluentIcons.apps_list_20_regular, color: Color.fromRGBO(145, 145, 142, 1.0), size: 24,),
                          SizedBox(width: 8,),
                          Text("Lists", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color.fromRGBO(95, 94, 91, 1.0)),)
                        ]),
                      ),

                      SizedBox(height: 11,),

                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(children: [
                          Icon(FluentIcons.person_16_regular, color: Color.fromRGBO(145, 145, 142, 1.0), size: 24,),
                          SizedBox(width: 8,),
                          Text("Profile", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color.fromRGBO(95, 94, 91, 1.0)),)
                        ]),
                      ),

                      SizedBox(height: 11,),

                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(children: [
                          Icon(FluentIcons.settings_16_regular, color: Color.fromRGBO(145, 145, 142, 1.0), size: 24,),
                          SizedBox(width: 8,),
                          Text("Settings", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color.fromRGBO(95, 94, 91, 1.0)),)
                        ]),
                      ),

                      SizedBox(height: 40,),

                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () {
                              
                            },
                            child: Container(
                              height: 30,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 224, 222, 217),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(children: [
                                Icon(FluentIcons.note_edit_20_regular, color: Color.fromRGBO(145, 145, 142, 1.0), size: 24,),
                                SizedBox(width: 8,),
                                Text("New Post", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color.fromRGBO(95, 94, 91, 1.0)),)
                              ]),
                            ),
                          ),
                        ),
                      ),
                        ],
                      );
}
}