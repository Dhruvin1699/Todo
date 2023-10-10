/// HOme screen  code
// import 'package:flutter/material.dart';
// import 'package:todoappdemo/Presentation/Screens/edit.dart';
// import 'package:todoappdemo/Presentation/Screens/tas.dart';
// import 'package:todoappdemo/databse.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: TodoAppHomeScreen(),
//     );
//   }
// }
//
// class TodoAppHomeScreen extends StatefulWidget {
//
//   @override
//   _TodoAppHomeScreenState createState() => _TodoAppHomeScreenState();
// }
//
// class _TodoAppHomeScreenState extends State<TodoAppHomeScreen> {
//   String? _selectedOption;
//   // String _selectedOption = 'Default';// Variable to store the selected dropdown option
//   TextEditingController _textFieldController =
//   TextEditingController(); // Controller for the text field
//   List<TaskModel> _tempTasks = [];
//   DatabaseHelper _dbHelper = DatabaseHelper();
//   List<TaskModel> _tasks = [];
//   List<String> _dropdownItems = [];
//
//   void _navigateToTaskScreen() async {
//     String? selectedItem = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => Task(onItemAdded: _updateDropdownItems)),
//     );
//
//     if (selectedItem != null) {
//       _loadTasks(); // Refresh tasks when returning from the Task screen
//     }
//   }
//
//   void _updateDropdownItems(String newItem) {
//     setState(() {
//       _dropdownItems.add(newItem);
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _loadTasks();
//   }
//
//
//   Future<void> _loadTasks() async {
//     List<TaskModel> tasks = await _dbHelper.getTasks();
//     List<String> categories = await _dbHelper.getCategories(); // Load categories from the database
//
//     setState(() {
//       _tasks = tasks;
//       _dropdownItems = categories;
//       _dropdownItems.insert(0, 'All'); // Add 'All' as the first item in the list
//       _selectedOption = 'All'; // Set default selected option to 'All'
//     });
//   }
//   Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
//     bool confirmDelete = false;
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Confirm Deletion"),
//           content: Text("Are you sure you want to delete this task?"),
//           actions: <Widget>[
//             TextButton(
//               child: Text("Cancel"),
//               onPressed: () {
//                 Navigator.of(context).pop(false); // Return false to indicate cancellation
//               },
//             ),
//             TextButton(
//               child: Text("Yes"),
//               onPressed: () {
//                 confirmDelete = true;
//                 Navigator.of(context).pop(true); // Return true to confirm deletion
//               },
//             ),
//           ],
//         );
//       },
//     );
//     return confirmDelete;
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.only(bottom: 80.0),
//         child: FloatingActionButton(
//           onPressed: () {
//             _navigateToTaskScreen();
//           },
//           child: Icon(Icons.add, color: Colors.black),
//           backgroundColor: Colors.grey,
//         ),
//       ),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         titleSpacing: 0,
//         leading: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Container(
//             width: 30, // Set the width of the container
//             height: 20, // Set the height of the container
//             child: Image.asset(
//               'images/accept_check_checklist_circle_mark_ok_yes_icon_123225.png', //
//             ),
//           ),
//         ),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 1.0),
//               child: Text(
//                 'Custom Title',
//                 style: TextStyle(color: Colors.black),
//               ),
//             ), // Your custom title
//
//             DropdownButtonHideUnderline(
//               // Hide the underline
//               child: DropdownButton<String>(
//                 // Dropdown menu
//                 value: _selectedOption, // Selected option value
//                 icon: Icon(Icons.arrow_drop_down), // Custom dropdown icon
//                 items: _dropdownItems
//                     .map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 })
//                     .toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedOption = newValue!; // Update the selected option
//                   });
//                   // Handle dropdown menu selection
//                 },
//               ),
//             ),
//
//           ],
//         ),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.search, color: Colors.black), // Search icon
//             onPressed: () {
//               // Implement your search functionality here
//             },
//           ),
//           PopupMenuButton<String>(
//             color: Colors.black,
//
//             onSelected: (String choice) {
//               // Handle choice selection
//
//             },
//             itemBuilder: (BuildContext context) {
//               return <PopupMenuEntry<String>>[
//                 PopupMenuItem<String>(
//                   value: 'Option 1',
//                   child: Text('Option 1'),
//                 ),
//                 PopupMenuItem<String>(
//                   value: 'Option 2',
//                   child: Text('Option 2'),
//                 ),
//                 PopupMenuItem<String>(
//                   value: 'Option 3',
//                   child: Text('Option 3'),
//                 ),
//               ];
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: <Widget>[
//           // Other body content goes here
//
//           // Text field at the bottom
//           Expanded(child:
//
//
//           ListView.builder(
//             itemCount: _tasks.length,
//             itemBuilder: (context, index) {
//               TaskModel task = _tasks[index];
//               if (_selectedOption == 'All' || task.selectedItem == _selectedOption) {
//                 return Dismissible(
//                   key: UniqueKey(),
//                   onDismissed: (direction) async {
//                     bool confirmDelete = await _showDeleteConfirmationDialog(context);
//                     if (confirmDelete) {
//                       await _dbHelper.deleteTask(task.id);
//                       _loadTasks();
//                     }else{
//                       setState(() {
//                         _tasks = List.from(_tempTasks);
//                       });
//                     }
//                   },
//                   background: Container(
//                     color: Colors.red,
//                     alignment: Alignment.centerRight,
//                     padding: EdgeInsets.only(right: 16.0),
//                     child: Icon(Icons.delete, color: Colors.white),
//                   ),
//                   secondaryBackground: Container(
//                     color: Colors.green,
//                     alignment: Alignment.centerLeft,
//                     padding: EdgeInsets.only(left: 16.0),
//                     child: Icon(Icons.check, color: Colors.white),
//                   ),
//                   child: GestureDetector(
//                     onTap: () async {
//                       TaskModel updatedTask = await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => Task(onItemAdded: (String ) {  },)
//                         ),
//                       );
//
//                       if (updatedTask != null) {
//                         _loadTasks();
//                       }
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                         padding: const EdgeInsets.all(16.0),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey),
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   task.task,
//                                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
//                                 ),
//                                 Text(
//                                   task.date,
//                                   style: TextStyle(fontSize: 14, color: Colors.grey),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 10),
//                             Text(
//                               task.selectedItem,
//                               style: TextStyle(fontSize: 16, color: Colors.blue),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               } else {
//                 return Container(); // Return an empty container for tasks that don't match the selected option
//               }
//             },
//           ),
//           ),
//           //       Expanded(
//           //         child: ListView.builder(
//           //           itemCount: _tasks.length,
//           //           itemBuilder: (context, index) {
//           //             TaskModel task = _tasks[index];
//           //             if (_selectedOption == 'All' || task.selectedItem == _selectedOption) {
//           //               return Dismissible(
//           //                 key: UniqueKey(),
//           //                 onDismissed: (direction) async {
//           //                   // ...
//           //                 },
//           //                 // ...
//           //                 child: GestureDetector(
//           //                   onTap: () async {
//           //                     setState(() {
//           //                       _editingIndex = index; // Start editing this task
//           //                     });
//           //                     _textFieldController.text = task.task; // Populate the text field with the task text
//           //                   },
//           //                   child: _editingIndex == index // Check if this task is being edited
//           //                       ? Padding(
//           //                     padding: const EdgeInsets.all(8.0),
//           //                     child: Container(
//           //                       padding: const EdgeInsets.all(16.0),
//           //                       decoration: BoxDecoration(
//           //                         border: Border.all(color: Colors.grey),
//           //                         borderRadius: BorderRadius.circular(8.0),
//           //                       ),
//           //                       child: Column(
//           //                         crossAxisAlignment: CrossAxisAlignment.start,
//           //                         children: [
//           //                           // Editable task text field
//           //                           TextField(
//           //                             controller: _textFieldController,
//           //                             decoration: InputDecoration(
//           //                               hintText: 'Edit your task', // Hint text
//           //                               focusedBorder: UnderlineInputBorder(
//           //                                 borderSide: BorderSide(color: Colors.green),
//           //                               ),
//           //                             ),
//           //                           ),
//           //                           SizedBox(height: 10),
//           //                           // Save button for edited task
//           //                           ElevatedButton(
//           //                             onPressed: () {
//           //                               // Implement save functionality here
//           //                               // You can access the edited task text from _textFieldController.text
//           //                               setState(() {
//           //                                 _editingIndex = -1; // Stop editing
//           //                               });
//           //                             },
//           //                             child: Text('Save'),
//           //                           ),
//           //                         ],
//           //                       ),
//           //                     ),
//           //                   )
//           //                       : Padding(
//           //                     padding: const EdgeInsets.all(8.0),
//           //                     child: Container(
//           //                       // ... (same code as before for non-edited tasks)
//           //                     ),
//           //                   ),
//           //                 ),
//           //               );
//           //             } else {
//           //               return Container();
//           //             }
//           //           },
//           //         ),
//           //       ),
//
//           Container(
//             height: 60,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey), // Border line color
//               borderRadius: BorderRadius.circular(8),
//             ),
//             margin: EdgeInsets.all(16),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 controller: _textFieldController,
//
//                 decoration: InputDecoration(
//                   hintText: 'Enter your text', // Hint text
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors
//                         .green), // Underline decoration without boxes
//                   ),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
// }

/// Task screen
///
/// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:todoappdemo/Presentation/Screens/homescreen.dart';
// import 'package:todoappdemo/databse.dart';
//
//
//
// void main() => runApp(Task(onItemAdded: (String ) {  },));
//
// class Task extends StatefulWidget {
//   final Function(String) onItemAdded;
//    final TaskModel? task;
//   Task({required this.onItemAdded,this.task});
//
//   @override
//   State<Task> createState() => _TaskState();
// }
//
// class _TaskState extends State<Task> {
//
//   final TextEditingController _taskController = TextEditingController();
//   final TextEditingController _dateController = TextEditingController();
//
//   String _selectedItem = 'Default';
//    List<String> _dropdownItems = ['item1, item 2'];
//   bool _isEditing = false; // Flag to indicate whether editing an existing task
//   TaskModel? _editingTask;
//   @override
//   // void initState() {
//   //   super.initState();
//   //   _loadCategories();
//   // }
//   void initState() {
//     super.initState();
//     if (widget.task != null) {
//       // If task is not null, set the flag and initialize editing task
//       _isEditing = true;
//       _editingTask = widget.task;
//       _taskController.text = _editingTask!.task;
//       _dateController.text = _editingTask!.date;
//       _selectedItem = _editingTask!.selectedItem;
//     }
//     _loadCategories();
//   }
//   void _loadCategories() async {
//     // Fetch categories from the database
//     List<String> categories = await DatabaseHelper.instance.getCategories();
//
//     // If no categories are available, insert default categories
//     if (categories.isEmpty) {
//       await DatabaseHelper.instance.insertDefaultCategories();
//       categories = await DatabaseHelper.instance.getCategories();
//     }
//
//     // Set three default items
//     // categories.addAll(['Item 1', 'Item 2', 'Item 3']);
//
//     setState(() {
//       _dropdownItems = categories;
//     });
//   }
//
//
//   @override
//
//
//
//
//   void _onFloatingActionButtonPressed() async {
//     String task = _taskController.text;
//     String date = _dateController.text;
//
//     if (task.isNotEmpty && date.isNotEmpty) {
//       if (!_dropdownItems.contains(_selectedItem)) {
//         await DatabaseHelper.instance.insertCategory(_selectedItem);
//         // Invoke the callback to notify HomeScreen about the new item
//         widget.onItemAdded(_selectedItem);
//       }
//
//       await DatabaseHelper.instance.insertTask(task, date, _selectedItem);
//       print('Task saved successfully!');
//       Navigator.pop(context,_selectedItem);
//     } else {
//       print('Task or date is empty. Task not saved.');
//     }
//   }
//   // void _onEditButtonPressed() async {
//   //   String task = _taskController.text;
//   //   String date = _dateController.text;
//   //
//   //   if (task.isNotEmpty && date.isNotEmpty) {
//   //     if (!_dropdownItems.contains(_selectedItem)) {
//   //       await DatabaseHelper.instance.insertCategory(_selectedItem);
//   //       widget.onItemAdded(_selectedItem);
//   //     }
//   //
//   //     // Check if editing an existing task
//   //     if (_isEditing && _editingTask != null) {
//   //       // Update the existing task in the database
//   //       await DatabaseHelper.instance.updateTask(
//   //         _editingTask!.id,
//   //         task,
//   //         date,
//   //         _selectedItem,
//   //       );
//   //     } else {
//   //       // Insert a new task into the database
//   //       await DatabaseHelper.instance.insertTask(task, date, _selectedItem);
//   //     }
//   //
//   //     // Notify the parent widget about the updated task
//   //     widget.onItemAdded(_selectedItem);
//   //
//   //     // Navigate back to the previous screen
//   //     Navigator.pop(context,_selectedItem);
//   //   } else {
//   //     print('Task or date is empty. Task not saved.');
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return
//        Scaffold(
//         floatingActionButton: FloatingActionButton(
//           onPressed: _onFloatingActionButtonPressed,
// backgroundColor: Colors.white,
//
//           child: Icon(Icons.arrow_right,color: Colors.black,),
//         ),
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 3,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back,color: Colors.black),
//             onPressed: () {
//               // Handle back button press
//             },
//           ),
//           title: Text('New Task',style: TextStyle(color: Colors.black),),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Text('What Is To be Done?'),
//                 ],
//               ),
//               TextField(
//                 controller: _taskController,
//                 decoration: InputDecoration(
//                   hintText: 'Enter task',
//                   border: UnderlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 20), // Add some space between widgets
//               Row(
//                 children: [
//                   Text('Due Date'),
//                 ],
//               ),
//               GestureDetector(
//                 onTap: () async {
//                   // Handle date picker open
//                   DateTime? pickedDate = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(1900),
//                     lastDate: DateTime(2100),
//                   );
//
//                   if (pickedDate != null) {
//                     // Handle picked date and format it
//                     String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
//                     setState(() {
//                       _dateController.text = formattedDate;
//                     });
//                   }
//                 },
//                 child: AbsorbPointer(
//                   child: TextField(
//                     controller: _dateController,
//                     decoration: InputDecoration(
//                       hintText: 'Pick a date',
//                       border: UnderlineInputBorder(),
//                       suffixIcon: Icon(Icons.calendar_today),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 30,),
//
//               Row(
//                 children: [
//                   Text('Add to List'),
//                 ],
//               ),
//               SizedBox(height: 15,),
//               CustomDropdown(
//                 selectedItem: _selectedItem,
//                 items: _dropdownItems, // Pass the categories list
//                 onItemSelected: (newValue) {
//                   setState(() {
//                     _selectedItem = newValue;
//                   });
//                 },
//                 onItemAdded: (newItem) {
//                   if (newItem.isNotEmpty && !_dropdownItems.contains(newItem)) {
//                     setState(() {
//                       _dropdownItems.add(newItem);
//                       _selectedItem = newItem;
//                     });
//                     // widget.updateDropdownItems(newItem);
//                   }
//                 },
//               ),
//
//               SizedBox(height: 20), // Add some space between widgets
//
//             ],
//           ),
//         ),
//
//     );
//   }
// }
//
// class CustomDropdown extends StatefulWidget {
//   final String selectedItem;
//   final List<String> items;
//   final Function(String) onItemSelected;
//   final Function(String) onItemAdded;
//
//   CustomDropdown({
//     required this.selectedItem,
//     required this.items,
//     required this.onItemSelected,
//     required this.onItemAdded,
//   });
//
//   @override
//   _CustomDropdownState createState() => _CustomDropdownState();
// }
//
// class _CustomDropdownState extends State<CustomDropdown> {
//   TextEditingController _addItemController = TextEditingController();
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         GestureDetector(
//           onTap: () {
//             _showCustomDropdownMenu(context);
//           },
//           child: Row(
//             children: [
//               Text(widget.selectedItem),
//               SizedBox(width: 300,),
//               Icon(Icons.arrow_drop_down),
//             ],
//           ),
//         ),
//         SizedBox(width: 10),
//         // Add some space between dropdown button and text field
//         GestureDetector(
//           onTap: () {
//             _showAddItemDialog(context);
//           },
//           child: Icon(Icons.add),
//         ),
//       ],
//     );
//   }
//
//   void _showCustomDropdownMenu(BuildContext context) {
//     final RenderBox button = context.findRenderObject() as RenderBox;
//     final RenderBox overlay = Overlay
//         .of(context)
//         .context
//         .findRenderObject() as RenderBox;
//     final RelativeRect position = RelativeRect.fromRect(
//       Rect.fromPoints(
//         button.localToGlobal(Offset.zero, ancestor: overlay),
//         button.localToGlobal(
//             button.size.bottomLeft(Offset.zero), ancestor: overlay),
//       ),
//       Offset.zero & overlay.size,
//     );
//
//     final List<PopupMenuEntry<String>> popupItems = widget.items.map((
//         String item) {
//       return PopupMenuItem<String>(
//         value: item,
//         child: Padding(
//           padding: EdgeInsets.only(left: 16.0),
//           // Add left padding to create a gap between icon and text
//           child: Text(item),
//         ),
//       );
//     }).toList();
//
//     showMenu(
//       context: context,
//       position: position,
//       items: popupItems,
//     ).then((newValue) {
//       if (newValue != null) {
//         widget.onItemSelected(newValue);
//       }
//     });
//   }
//
//   void _showAddItemDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Add New Item'),
//           content: TextField(
//             controller: _addItemController,
//             decoration: InputDecoration(
//               hintText: 'Enter new item',
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Add'),
//               onPressed: () async {
//                 String newItem = _addItemController.text;
//                 if (newItem.isNotEmpty) {
//                   // Save the new item to the database
//                   await DatabaseHelper.instance.insertCategory(newItem);
//
//                   // Update the dropdown items list
//                   widget.onItemAdded(newItem);
//                 }
//                 Navigator.of(context).pop();
//               },
//             ),
//
//           ],
//         );
//       },
//     );
//   }
//
//
// }