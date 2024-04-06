// Cesar Omar Ramos Nolasco. 2022-0022
import 'package:flutter/material.dart';
import 'package:tarea8/addevent.dart';
import 'package:tarea8/eventlist.dart';
import 'package:tarea8/aboutme.dart';

class TabsControl extends StatelessWidget {
  const TabsControl({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
              bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.add),
              ),
              Tab(icon: Icon(Icons.list)),
              Tab(icon: Icon(Icons.person))
            ],
          )),
          body:
              const TabBarView(children: [AddEvent(), EventList(), AboutMe()]),
        ));
  }
}
