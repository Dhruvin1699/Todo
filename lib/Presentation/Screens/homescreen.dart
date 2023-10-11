

import 'package:flutter/material.dart';
import 'package:todoappdemo/Presentation/Screens/edit.dart';
import 'package:todoappdemo/Presentation/Screens/tas.dart';
import 'package:todoappdemo/Presentation/Screens/tasklist.dart';
import 'package:todoappdemo/databse.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoAppHomeScreen(),
    );
  }
}

class TodoAppHomeScreen extends StatefulWidget {

  @override
  _TodoAppHomeScreenState createState() => _TodoAppHomeScreenState();
}

class _TodoAppHomeScreenState extends State<TodoAppHomeScreen> {
  String? _selectedOption;
  // String _selectedOption = 'Default';// Variable to store the selected dropdown option
  TextEditingController _textFieldController =
  TextEditingController(); // Controller for the text field
  List<TaskModel> _tempTasks = [];
  DatabaseHelper _dbHelper = DatabaseHelper();
  List<TaskModel> _tasks = [];
   List<String> _dropdownItems = [];



  void _navigateToTaskScreen(TaskModel task) async {
    String? updatedItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Task(onItemAdded: _updateDropdownItems, task: task),
      ),
    );

    if (updatedItem != null) {
      // Update the dropdown items list and reload tasks
      setState(() {
        _loadTasks();
        _selectedOption = updatedItem;
      });
    }
  }
  void _updateDropdownItems(String newItem) {
    setState(() {
      _dropdownItems.add(newItem);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }



  Future<void> _loadTasks() async {
    List<TaskModel> tasks = await _dbHelper.getTasks();
    List<String> categories = await _dbHelper.getCategories(); // Load categories from the database

    setState(() {
      _tasks = tasks;
      _dropdownItems = categories;
      _dropdownItems.insert(0, 'All'); // Add 'All' as the first item in the list
      _selectedOption = 'All'; // Set default selected option to 'All'
    });
  }
  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    bool confirmDelete = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete this task?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false); // Return false to indicate cancellation
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                confirmDelete = true;
                Navigator.of(context).pop(true); // Return true to confirm deletion
              },
            ),
          ],
        );
      },
    );
    return confirmDelete;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 0.0),
        child: FloatingActionButton(
          onPressed: () {
            TaskModel newTask = TaskModel(
              id: 0, // Set an appropriate ID for the new task (or get it from your database logic)
              task: '',
              date: '',
              selectedItem: 'Default', // Set default value for selected item
            );
            _navigateToTaskScreen(newTask);
          },
          child: Icon(Icons.add,     color:Color(0xFF01579B),),
          backgroundColor: Colors.white,
        ),

      ),
     appBar: AppBar(
         backgroundColor: Color(0xFF0277BD),
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          
          child: Container(
            margin: EdgeInsets.all(0),
            width: 30, // Set the width of the container
            height: 20, // Set the height of the container
            child: Image.asset(
              'images/—Pngtree—hand drawn white gray check_7058370.png', //
            ),
          ),
        ),
         title: Row(
     children: [
     Padding(
     padding: const EdgeInsets.only(left: 1.0),
      child: Text(
        _selectedOption ?? 'Custom Title', // Set app bar title to selected dropdown item
        style: TextStyle(color: Colors.white),
      ),
    ),

            DropdownButtonHideUnderline(
              // Hide the underline
              child: DropdownButton<String>(
                // Dropdown menu
                // value: _selectedOption, // Selected option value
                icon: Icon(Icons.arrow_drop_down,color: Colors.white,), // Custom dropdown icon
                items: _dropdownItems
                    .map((String value) {
                  return DropdownMenuItem<String>(
                     value: value,
                      child: Text(value),

                  );
                })
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedOption = newValue!; // Update the selected option
                  });
                  // Handle dropdown menu selection
                },
              ),
            ),

          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: Colors.white), // Search icon
            onPressed: () {
              // Implement your search functionality here
            },
          ),

          PopupMenuButton<String>(
            color: Colors.white, // Set background color of the popup menu
            icon: Icon(
              Icons.more_vert,
              color: Colors.white, // Set icon color to black
            ),
            itemBuilder: (BuildContext context) {
              return [
                'TaskList',
                'Send Feedback',
                'Invite friends to the app',
                'Setting',
              ].map((String option) {
                return PopupMenuItem<String>(
                  value: option,
                  child: Text(
                    option,
                    style: TextStyle(color: Colors.black), // Set text color to black
                  ),
                );
              }).toList();
            },
            onSelected: (String choice) {
              // Handle choice selection
              if (choice == 'TaskList') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskListScreen(tasks:_tasks),
                  ),
                );
              } else if (choice == 'Send Feedback') {
                // Handle 'Send Feedback' option
              } else if (choice == 'Invite friends to the app') {
                // Handle 'Invite friends to the app' option
              } else if (choice == 'Setting') {
                // Handle 'Setting' option
              }
            },
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF0277BD),
        child: Container(
          height: 60,
          margin: EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  // Handle speech recognition here
                },
                icon: Icon(Icons.mic, color: Colors.white),
              ),
              Expanded(
                child: TextField(
                  controller: _textFieldController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter your text',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white60),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
      body: Container(
         color:Color(0xFF01579B),
        child: Column(

          children: <Widget>[
            // Other body content goes here

            // Text field at the bottom
             Expanded(child:


        ListView.builder(
          itemCount: _tasks.length,
          itemBuilder: (context, index) {
            TaskModel task = _tasks[index];
            if (_selectedOption == 'All' || task.selectedItem == _selectedOption) {
              return Dismissible(
                  direction: DismissDirection.startToEnd,
                key: UniqueKey(),
                onDismissed: (direction) async {
                  bool confirmDelete = await _showDeleteConfirmationDialog(context);
                  if (confirmDelete) {
                    await _dbHelper.deleteTask(task.id);
                    _loadTasks();
                  }else{
                    setState(() {
                      _tasks = List.from(_tasks );
                    });
                  }
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.delete, color: Colors.black),
                ),
                secondaryBackground: Container(
                  color: Colors.green,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16.0),
                  child: Icon(Icons.check, color: Colors.black),
                ),
                child: GestureDetector(
                  // onTap: () async {
                  //   TaskModel updatedTask = await Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => Task(onItemAdded: (String ) {  },)
                  //     ),
                  //   );
                  //
                  //   if (updatedTask != null) {
                  //     _loadTasks();
                  //   }
                  // },
                  onTap: () async {
                    if (task.id != 0) {
                      // Existing task, open Task screen for editing
                      TaskModel updatedTask = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Task(
                            onItemAdded: (String newItem) {
                              _loadTasks(); // Reload tasks after editing
                            },
                            task: task,
                            isEdit: true,
                          ),
                        ),
                      );

                      if (updatedTask != null) {
                        _loadTasks(); // Reload tasks after editing
                      }
                    } else {
                      // New task, open Task screen for adding a new task
                      TaskModel newTask = TaskModel(
                        id: 0,
                        task: '',
                        date: '',
                        selectedItem: 'Default',
                      );
                      TaskModel createdTask = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Task(
                            onItemAdded: (String newItem) {
                              _loadTasks(); // Reload tasks after adding a new task
                              _updateDropdownItems(newItem);
                            },
                            task: newTask,
                          ),
                        ),
                      );

                      if (createdTask != null) {
                        _loadTasks(); // Reload tasks after adding a new task
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(

                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(8.0),
                        color: Color(0xFF288D1)

                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                task.task,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              Text(
                                task.date,
                                style: TextStyle(fontSize: 14, color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            task.selectedItem,
                            style: TextStyle(fontSize: 16, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Container(); // Return an empty container for tasks that don't match the selected option
            }
          },
        ),
    ),


            // Container(
            //   height: 60,
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.grey), // Border line color
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   margin: EdgeInsets.all(16),
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: TextField(
            //       controller: _textFieldController,
            //
            //       decoration: InputDecoration(
            //         hintText: 'Enter your text',hintStyle: TextStyle(fontSize: 10,color: Colors.white), // Hint text
            //         enabledBorder: UnderlineInputBorder(
            //           borderSide: BorderSide(color: Colors.white), // Manually set the underline color to white
            //         ),
            //         focusedBorder: UnderlineInputBorder(
            //           borderSide: BorderSide(color: Colors
            //               .white), // Underline decoration without boxes
            //         ),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

}


