import 'package:flutter/material.dart';
import 'package:todolist_hive/ui/widgets/groups/groups_widget.dart';

import '../widgets/form/group_form_widget.dart';
import '../widgets/form/task_form_widget.dart';
import '../widgets/tasks_widget.dart';


abstract class MainNavigationRouteNames{
  static const groups='groups';
  static const groupsform='groups/form';
  static const tasks='tasks';
  static const tasksform='tasks/form';

}

class MainNavigation {
  final String initialRoute=MainNavigationRouteNames.groups;
  final routes = <String, Widget Function(BuildContext context)>{
    MainNavigationRouteNames.groups: (context) =>
        const GroupsWidget(),
    MainNavigationRouteNames.groupsform:(context)=> const GroupFormWidget(),
    //MainNavigationRouteNames.tasks:(context)=>const TasksWidget(),
    //MainNavigationRouteNames.tasksform:(context)=>const TaskFromWidget(),

  };
  Route<Object> onGenerateRoute (RouteSettings settings){
    switch(settings.name){
      case MainNavigationRouteNames.tasks:
        final groupKey=settings.arguments as int;
        return MaterialPageRoute(builder: (context){
          return TasksWidget(groupKey: groupKey);
        });

      case MainNavigationRouteNames.tasksform:
        final groupKey=settings.arguments as int;
        return MaterialPageRoute(builder: (context){
          return TaskFromWidget(groupKey: groupKey);
        });
      default:
        const errorNavigationWidget=Text('Navigation error');
        return MaterialPageRoute(builder: (context){
          return errorNavigationWidget;
        });
    }

  }

}