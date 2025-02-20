import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          SizedBox(
            height: double.infinity,
            width: 250,
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(248, 248, 247, 1.0),
                          border: Border(
                            right: BorderSide(color: Colors.grey, width: 0.2),
                          )
                        ),
                      ),

                      Column(
                        children: [

                          Padding(
                            padding: const EdgeInsets.only(left: 7, top: 7),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Image.asset("lib/assets/logo2.png", width: 30, height: 30,)),
                          ),

                      SizedBox(height: 21,),

                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_, __, ___) => HomePage(),
                              transitionDuration: Duration(seconds: 0),));
                          },
                          child: Row(children: [
                            Icon(FluentIcons.home_16_regular, color: Color.fromRGBO(145, 145, 142, 1.0),),
                            SizedBox(width: 8,),
                            Text("Home", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color.fromRGBO(95, 94, 91, 1.0)),)
                          ]),
                        ),
                      ),

                      SizedBox(height: 11,),

                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(children: [
                          Icon(FluentIcons.search_16_regular, color: Color.fromRGBO(145, 145, 142, 1.0),),
                          SizedBox(width: 8,),
                          Text("Search", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color.fromRGBO(95, 94, 91, 1.0)),)
                        ]),
                      ),

                      SizedBox(height: 11,),

                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(children: [
                          Icon(FluentIcons.alert_16_regular, color: Color.fromRGBO(145, 145, 142, 1.0),),
                          SizedBox(width: 8,),
                          Text("Notifications", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color.fromRGBO(95, 94, 91, 1.0)),)
                        ]),
                      ),

                      SizedBox(height: 11,),

                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(children: [
                          Icon(FluentIcons.mail_inbox_16_regular, color: Color.fromRGBO(145, 145, 142, 1.0),),
                          SizedBox(width: 8,),
                          Text("Chat", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color.fromRGBO(95, 94, 91, 1.0)),)
                        ]),
                      ),

                      SizedBox(height: 11,),

                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(children: [
                          Icon(FluentIcons.broad_activity_feed_16_regular, color: Color.fromRGBO(145, 145, 142, 1.0),),
                          SizedBox(width: 8,),
                          Text("Feeds", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color.fromRGBO(95, 94, 91, 1.0)),)
                        ]),
                      ),

                      SizedBox(height: 11,),

                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(children: [
                          Icon(FluentIcons.apps_list_20_regular, color: Color.fromRGBO(145, 145, 142, 1.0), size: 24,),
                          SizedBox(width: 8,),
                          Text("Lists", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color.fromRGBO(95, 94, 91, 1.0)),)
                        ]),
                      ),

                      SizedBox(height: 11,),

                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(children: [
                          Icon(FluentIcons.person_16_regular, color: Color.fromRGBO(145, 145, 142, 1.0), size: 24,),
                          SizedBox(width: 8,),
                          Text("Profile", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color.fromRGBO(95, 94, 91, 1.0)),)
                        ]),
                      ),

                      SizedBox(height: 11,),

                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(children: [
                          Icon(FluentIcons.settings_16_regular, color: Color.fromRGBO(145, 145, 142, 1.0), size: 24,),
                          SizedBox(width: 8,),
                          Text("Settings", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color.fromRGBO(95, 94, 91, 1.0)),)
                        ]),
                      ),

                      SizedBox(height: 25,),

                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(children: [
                          Icon(FluentIcons.note_edit_20_regular, color: Color.fromRGBO(145, 145, 142, 1.0), size: 24,),
                          SizedBox(width: 8,),
                          Text("New Post", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color.fromRGBO(95, 94, 91, 1.0)),)
                        ]),
                      ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const Expanded(
            child: Column(),
          ),
        ],
      ),
    );
  }
}