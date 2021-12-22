
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list_v2/add_task_bar.dart';
import 'package:to_do_list_v2/controllers/task_controller.dart';
import 'package:to_do_list_v2/models/tasks.dart';
import 'package:to_do_list_v2/services/notification_services.dart';
import 'package:to_do_list_v2/services/theme_services.dart';
import 'package:to_do_list_v2/ui/task_tile.dart';
import 'package:to_do_list_v2/ui/theme.dart';
import 'package:to_do_list_v2/widget/button.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  var notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    setState(() {
      print('Im here');
    });

  }



  @override
  Widget build(BuildContext context) {
    print('build method called');
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _AppBar(),
      body: Container(
        color: Get.isDarkMode ? Color(0xFF212121) : Colors.white ,
        child: Column(
          children: [
           _AddTask(),
           _AddDateBar(),
            SizedBox(height: 12,),
            _showTasks(),
          ],
        ),
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (context, index) {
              print(_taskController.taskList.length);

                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                        child: FadeInAnimation(
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    _showBottomSheet(context, _taskController.taskList[index]);
                                  },
                                  child: TaskTile(_taskController.taskList[index]),
                                ),
                              ],),
                        ),
                    ),
                );
            });
      }),
    );
  }

  _showBottomSheet(BuildContext context, Task task){
    Get.bottomSheet(
        Container(
          padding: const EdgeInsets.only(top: 4),
          height: task.isCompleted==1?
          MediaQuery.of(context).size.height*0.24:
          MediaQuery.of(context).size.height*0.32,
          color: Get.isDarkMode?Colors.black54 : Colors.white54 ,
        )
    );
  }
  _AddDateBar(){
    return Container(
      margin: const EdgeInsets.only(top: 16, left: 16),
      child: DatePicker(
        DateTime.now(),
        width: 60,
        height: 80,
        initialSelectedDate: DateTime.now(),
        selectedTextColor: Colors.white,
        selectionColor: Color(0xFF4e5ae8),
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date){
          _selectedDate = date;
        },
      ),
    );
  }
  _AddTask(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 16.0, left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  'Today',
                  style: HeadingStyle,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 16,right: 16),
            child: Center(
                child: MyButton(label: "+ Add task", onTap: () async {
                  await Get.to(() => TaskPage());
                  _taskController.getTasks();
                })),
          ),
        ],
      ),
    );
  }
  _AppBar() {
    return AppBar(
      backgroundColor: context.theme.backgroundColor,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          ThemeServices().switchTheme();
          notifyHelper.displayNotification(
            title: 'ToDoo',
            body: Get.isDarkMode
                ? 'Light mode is activated!'
                : 'Dark mode is activated!',
          );
          notifyHelper.scheduledNotification();
        },
        child:
      Icon(
          Get.isDarkMode? Icons.wb_sunny : Icons.brightness_2,
          size: 20.0,
          color: Get.isDarkMode? Colors.white :Colors.black,
        ),
      ),
      actions: [
        Container(
          child: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage("images/user2.png"),
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
      ],
    );
  }
}
