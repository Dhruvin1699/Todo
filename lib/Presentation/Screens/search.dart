 import 'package:flutter/material.dart';

import '../../databse.dart';



 class CustomSearchScreen extends StatefulWidget {
   final List<TaskModel> tasks;

   CustomSearchScreen({required this.tasks});

   @override
   _CustomSearchScreenState createState() => _CustomSearchScreenState();
 }

 class _CustomSearchScreenState extends State<CustomSearchScreen> {
   String _query = '';
   late List<TaskModel> _searchResults;

   @override
   void initState() {
     super.initState();
     _searchResults = widget.tasks;
   }

   void _updateSearchResults(String query) {
     setState(() {
       _query = query;
       _searchResults = widget.tasks
           .where((task) => task.task.toLowerCase().contains(query.toLowerCase()))
           .toList();
     });
   }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text('Search Tasks'),
         elevation: 0, // No shadow
       ),
       body: Container(
         color: Color(0xFFFAF9F6),
         child: Column(
           children: [
             Padding(
               padding: const EdgeInsets.all(16.0),
               child: Container(
                 padding: EdgeInsets.symmetric(horizontal: 10.0),
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(8.0),
                 ),
                 child: TextField(
                   onChanged: _updateSearchResults,
                   decoration: InputDecoration(
                     hintText: 'Search tasks',
                     border: InputBorder.none,
                     icon: Icon(Icons.search, color: Colors.grey),
                   ),
                 ),
               ),
             ),
             Expanded(
               child: _searchResults.isEmpty
                   ? Center(
                 child: Text('No results found for "$_query"'),
               )
                   : ListView.builder(
                 itemCount: _searchResults.length,
                 itemBuilder: (context, index) {
                   TaskModel task = _searchResults[index];
                   return TaskListItem(task: task, searchQuery: _query);
                 },
               ),
             ),
           ],
         ),
       ),
     );
   }
 }


 class TaskListItem extends StatelessWidget {
   final TaskModel task;
   final String searchQuery;
   TaskListItem({required this.task,required this.searchQuery});

   @override
   Widget build(BuildContext context) {
     return ListTile(
       title: Text(task.task),
       // Add more fields or customize the appearance as needed
     );
   }
 }
