// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:todoappdemo/Presentation/Screens/tas.dart';
// import 'package:todoappdemo/databse.dart';
//
// class TaskPage extends StatefulWidget {
//   final TaskModel task;
//
//   TaskPage({required this.task});
//
//   @override
//   _TaskPageState createState() => _TaskPageState();
// }
//
// class _TaskPageState extends State<TaskPage> {
//   final TextEditingController _taskController = TextEditingController();
//   final TextEditingController _dateController = TextEditingController();
//
//   final List<String> _dropdownItems = ['Default', 'Item 2', 'Item 3'];
//   String _selectedItem = 'Default';
//   @override
//   void initState() {
//     super.initState();
//     // Set the initial values in the text controllers and dropdown
//     _taskController.text = widget.task.task;
//     _dateController.text = widget.task.date;
//     _selectedItem = widget.task.selectedItem;
//   }
//
//   void _onSaveButtonPressed() async {
//     // Create a TaskModel object with updated data
//     TaskModel updatedTask = TaskModel(
//       id: widget.task.id,
//       task: _taskController.text,
//       date: _dateController.text,
//       selectedItem: _selectedItem,
//     );
//
//     // Update the task in the database
//     await updatedTask.updateTask();
//
//     // Navigate back to the previous screen with the updated task
//     Navigator.pop(context, updatedTask);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Task'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.save),
//             onPressed: _onSaveButtonPressed,
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _taskController,
//               decoration: InputDecoration(labelText: 'Task'),
//             ),
//             GestureDetector(
//               onTap: () async {
//                 // Handle date picker open
//                 DateTime? pickedDate = await showDatePicker(
//                   context: context,
//                   initialDate: DateTime.now(),
//                   firstDate: DateTime(1900),
//                   lastDate: DateTime(2100),
//                 );
//
//                 if (pickedDate != null) {
//                   // Handle picked date and format it
//                   String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
//                   setState(() {
//                     _dateController.text = formattedDate;
//                   });
//                 }
//               },
//               child: AbsorbPointer(
//                 child: TextField(
//                   controller: _dateController,
//                   decoration: InputDecoration(
//                     hintText: 'Pick a date',
//                     border: UnderlineInputBorder(),
//                     suffixIcon: Icon(Icons.calendar_today),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20,),
//             Row(
//               children: [
//                 CustomDropdown(
//                   selectedItem: _selectedItem,
//                   items: _dropdownItems,
//                   onItemSelected: (newValue) {
//                     setState(() {
//                       _selectedItem = newValue;
//                     });
//                   },
//                   onItemAdded: (newItem) {
//                     if (newItem.isNotEmpty && !_dropdownItems.contains(newItem)) {
//                       setState(() {
//                         _dropdownItems.add(newItem);
//                         _selectedItem = newItem;
//                       });
//                     }
//                   },
//                 ),
//               ],
//             ),
//             // DropdownButton to select an item
//             // ... (your DropdownButton code goes here)
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:todoappdemo/Presentation/Screens/tas.dart';
// // import 'package:todoappdemo/databse.dart';
// //
// // class TaskPage extends StatefulWidget {
// //   final TaskModel task;
// //
// //   TaskPage({required this.task});
// //
// //   @override
// //   _TaskPageState createState() => _TaskPageState();
// // }
// //
// // class _TaskPageState extends State<TaskPage> {
// //   final TextEditingController _taskController = TextEditingController();
// //   final TextEditingController _dateController = TextEditingController();
// //
// //   final List<String> _dropdownItems = ['Default', 'Item 2', 'Item 3'];
// //   String _selectedItem = 'Default';
// //   @override
// //   void initState() {
// //     super.initState();
// //     // Set the initial values in the text controllers and dropdown
// //     _taskController.text = widget.task.task;
// //     _dateController.text = widget.task.date;
// //     _selectedItem = widget.task.selectedItem;
// //   }
// //
// //   void _onSaveButtonPressed() async {
// //     // Create a TaskModel object with updated data
// //     TaskModel updatedTask = TaskModel(
// //       id: widget.task.id,
// //       task: _taskController.text,
// //       date: _dateController.text,
// //       selectedItem: _selectedItem,
// //     );
// //
// //     // Update the task in the database
// //     await updatedTask.updateTask();
// //
// //     // Navigate back to the previous screen with the updated task
// //     Navigator.pop(context, updatedTask);
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Edit Task'),
// //         actions: [
// //           IconButton(
// //             icon: Icon(Icons.save),
// //             onPressed: _onSaveButtonPressed,
// //           ),
// //         ],
// //       ),
// //       body: Padding(
// //         padding: EdgeInsets.all(8.0),
// //         child: Column(
// //           children: [
// //             TextField(
// //               controller: _taskController,
// //               decoration: InputDecoration(labelText: 'Task'),
// //             ),
// //             GestureDetector(
// //               onTap: () async {
// //                 // Handle date picker open
// //                 DateTime? pickedDate = await showDatePicker(
// //                   context: context,
// //                   initialDate: DateTime.now(),
// //                   firstDate: DateTime(1900),
// //                   lastDate: DateTime(2100),
// //                 );
// //
// //                 if (pickedDate != null) {
// //                   // Handle picked date and format it
// //                   String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
// //                   setState(() {
// //                     _dateController.text = formattedDate;
// //                   });
// //                 }
// //               },
// //               child: AbsorbPointer(
// //                 child: TextField(
// //                   controller: _dateController,
// //                   decoration: InputDecoration(
// //                     hintText: 'Pick a date',
// //                     border: UnderlineInputBorder(),
// //                     suffixIcon: Icon(Icons.calendar_today),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             SizedBox(height: 20,),
// //             Row(
// //               children: [
// //                 CustomDropdown(
// //                   selectedItem: _selectedItem,
// //                   items: _dropdownItems,
// //                   onItemSelected: (newValue) {
// //                     setState(() {
// //                       _selectedItem = newValue;
// //                     });
// //                   },
// //                   onItemAdded: (newItem) {
// //                     if (newItem.isNotEmpty && !_dropdownItems.contains(newItem)) {
// //                       setState(() {
// //                         _dropdownItems.add(newItem);
// //                         _selectedItem = newItem;
// //                       });
// //                     }
// //                   },
// //                 ),
// //               ],
// //             ),
// //             // DropdownButton to select an item
// //             // ... (your DropdownButton code goes here)
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
