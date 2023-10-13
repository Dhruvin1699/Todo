import 'package:flutter/material.dart';
import 'package:todo1/Presentation/Screens/tas.dart';



import '../../databse.dart'; // Import your TaskModel class
class TaskListScreen extends StatefulWidget {
  final List<TaskModel> tasks;

  TaskListScreen({required this.tasks});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0277BD),
        title: Text('Task List'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back when the back arrow is pressed
          },
        ),
      ),
      body: Container(
       color:Color(	0xFFFAF9F6),
        child: ListView.builder(
          itemCount: widget.tasks.length,
          itemBuilder: (context, index) {
            TaskModel task = widget.tasks[index];
            return ListTile(
              title: Text(task.task,style: TextStyle(color: Colors.black,  fontFamily: 'Poppins',),),
              subtitle: Text(task.date,style: TextStyle(color: Colors.green),),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit,color: Colors.blueGrey,),
                    onPressed: () {
                      // Navigate to Task screen in edit mode
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Task(onItemAdded: (String newItem) {}, task: task, isEdit: true),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete,color: Colors.blueGrey),
                    onPressed: () {
                      // Handle delete functionality here
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
