import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoappdemo/Presentation/Screens/homescreen.dart';
import 'package:todoappdemo/databse.dart';



void main() => runApp(Task(onItemAdded: (String ) {  },));

class Task extends StatefulWidget {
  final Function(String) onItemAdded;
   final TaskModel? task;
   bool isEdit;
  Task({required this.onItemAdded,this.task,this.isEdit=false});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {

  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  // bool showSaveButton = false;
  // bool showFloatingButton = true;
  String _selectedItem = 'Default';
   List<String> _dropdownItems = ['item1, item 2'];
  bool get isEditing => widget.task != null;// Flag to indicate whether editing an existing task
  TaskModel? _editingTask;
  String get _screenTitle => widget.isEdit ? 'Edit Task' : 'New Task';
  @override

  void initState() {
    super.initState();
    if (widget.task != null) {
      // If task is not null, set the flag and initialize editing task
      // isEditing = true;
       _editingTask = widget.task;
      _taskController.text = _editingTask!.task;
      _dateController.text = _editingTask!.date;
      _selectedItem = _editingTask!.selectedItem;
       // showSaveButton = true;
       // showFloatingButton = false;
    }
    _loadCategories();
  }
  void _loadCategories() async {
    // Fetch categories from the database
    List<String> categories = await DatabaseHelper.instance.getCategories();

    // If no categories are available, insert default categories
    if (categories.isEmpty) {
      await DatabaseHelper.instance.insertDefaultCategories();
      categories = await DatabaseHelper.instance.getCategories();
    }


    setState(() {
      _dropdownItems = categories;
    });
  }

  void _onSaveButtonPressed() async {
    String task = _taskController.text;
    String date = _dateController.text;

    if (task.isNotEmpty && date.isNotEmpty) {
      TaskModel updatedTask;
      if (widget.task != null) {
        // If task is not null, update the existing task
        updatedTask = TaskModel(
          id: widget.task!.id,
          task: task,
          date: date,
          selectedItem: _selectedItem,
        );
        await DatabaseHelper.instance.updateTask(updatedTask);
      } else {
        // If task is null, insert a new task
        await DatabaseHelper.instance.insertTask(task, date, _selectedItem);
      }

      // Notify the parent widget that an item has been added/updated
      widget.onItemAdded(_selectedItem);

      // Navigate back to the home screen
      Navigator.pop(context,_selectedItem);
    } else {
      print('Task or date is empty. Task not saved.');
    }
  }


  @override


  // void _onFloatingActionButtonPressed() async {
  //   String task = _taskController.text;
  //   String date = _dateController.text;
  //   if (task.isNotEmpty && date.isNotEmpty) {
  //     if (!_dropdownItems.contains(_selectedItem)) {
  //       await DatabaseHelper.instance.insertCategory(_selectedItem);
  //       widget.onItemAdded(_selectedItem);
  //     }
  //     await DatabaseHelper.instance.insertTask(task, date, _selectedItem);
  //
  //     print('Task saved successfully!');
  //     Navigator.pop(context,_selectedItem,); // Navigate back after saving
  //   } else {
  //     print('Task or date is empty. Task not saved.');
  //   }
  // }


  void _onFloatingActionButtonPressed() async {
    String task = _taskController.text;
    String date = _dateController.text;
    if (task.isNotEmpty && date.isNotEmpty) {
      if (!_dropdownItems.contains(_selectedItem)) {
        await DatabaseHelper.instance.insertCategory(_selectedItem);
        widget.onItemAdded(_selectedItem);
      }
      await DatabaseHelper.instance.insertTask(task, date, _selectedItem);
      print('Task saved successfully!');

      // Update _selectedItem before calling Navigator.pop
      setState(() {
        _selectedItem = _selectedItem; // This line might not be necessary, but it ensures the state is updated
      });

      Navigator.pop(context, _selectedItem); // Navigate back after saving
    } else {
      print('Task or date is empty. Task not saved.');
    }
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      floatingActionButton: widget.isEdit
          ?SizedBox.shrink() : FloatingActionButton(
        onPressed: _onFloatingActionButtonPressed,
        backgroundColor: Colors.white,
        child: Icon(Icons.arrow_right,     color:Color(0xFF01579B),),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFF0277BD),
        elevation: 3,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          _screenTitle,
          style: TextStyle(color: Colors.white),
        ),

        actions: <Widget>[
          widget.isEdit
              ? GestureDetector(
            onTap: _onSaveButtonPressed, // Handle save action
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Image.asset(
                'images/icons8-save-button-64.png', // Image asset path
                width: 35, // Set image width
                height: 54, // Set image height
                color: Colors.white, // Set image color
              ),
            ),
          )
              : SizedBox.shrink(),
        ],
      ),
        body: Container(
          height: double.maxFinite,
          width: double.infinity,
          color:Color(	0xFFFAF9F6),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('What Is To be Done?',style: TextStyle(
                      color: Colors.black, fontFamily: 'Poppins',
                    ),),
                  ],
                ),
                TextField(
                  controller: _taskController,
                  style: TextStyle(color: Colors.blueGrey),
                  decoration: InputDecoration(
                    hintText: 'Enter task',
                    hintStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 12, fontFamily: 'Poppins',

                    ),
                    border: UnderlineInputBorder(

                    ),
                  ),
                ),
                SizedBox(height: 20), // Add some space between widgets
                Row(
                  children: [
                    Text('Due Date',style: TextStyle(color: Colors.black, fontFamily: 'Poppins',),),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    // Handle date picker open
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      // Handle picked date and format it
                      String formattedDate = DateFormat('MM-dd-yyyy').format(pickedDate);
                      setState(() {
                        _dateController.text = formattedDate;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _dateController,
                      style: TextStyle(color: Colors.blueGrey),
                      decoration: InputDecoration(
                        hintText: 'Pick a date',
                        hintStyle: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 12, fontFamily: 'Poppins',

                        ),
                        border: UnderlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today,color: Colors.blueGrey,),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30,),

                Row(
                  children: [
                    Text('Add to List',style: TextStyle(color: Colors.black, fontFamily: 'Poppins',),),
                  ],
                ),
                SizedBox(height: 15,),
                CustomDropdown(
                  selectedItem: _selectedItem,
                  items: _dropdownItems, // Pass the categories list
                  onItemSelected: (newValue) {
                    setState(() {
                      _selectedItem = newValue;
                    });
                  },
                  onItemAdded: (newItem) {
                    if (newItem.isNotEmpty && !_dropdownItems.contains(newItem)) {
                      setState(() {
                        _dropdownItems.add(newItem);
                        _selectedItem = newItem;
                      });
                      // widget.updateDropdownItems(newItem);
                    }
                  },
                ),

                SizedBox(height: 20), // Add some space between widgets

              ],
            ),
          ),
        ),

    );
  }
}

class CustomDropdown extends StatefulWidget {
  final String selectedItem;
  final List<String> items;
  final Function(String) onItemSelected;
  final Function(String) onItemAdded;

  CustomDropdown({
    required this.selectedItem,
    required this.items,
    required this.onItemSelected,
    required this.onItemAdded,
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  TextEditingController _addItemController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            _showCustomDropdownMenu(context);
          },
          child: Row(
            children: [
              Text(widget.selectedItem,style: TextStyle(color: Colors.blueGrey),),
              SizedBox(width: 5,),
              Icon(Icons.arrow_drop_down,color: Colors.blueGrey,),
            ],
          ),
        ),
        SizedBox(width: 10),
        // Add some space between dropdown button and text field
        GestureDetector(
          onTap: () {
            _showAddItemDialog(context);
          },
          child: Icon(Icons.add,color: Colors.blueGrey,),
        ),
      ],
    );
  }

  void _showCustomDropdownMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay
        .of(context)
        .context
        .findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
            button.size.bottomLeft(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    final List<PopupMenuEntry<String>> popupItems = widget.items.map((
        String item) {
      return PopupMenuItem<String>(

         value: item,
        child: Padding(
          padding: EdgeInsets.only(left: 16.0),
          // Add left padding to create a gap between icon and text
          child: Text(item,style: TextStyle(color: Colors.blueGrey),),
        ),
      );
    }).toList();

    showMenu(
      context: context,
      position: position,
      items: popupItems,
    ).then((newValue) {
      if (newValue != null) {
        widget.onItemSelected(newValue);
      }
    });
  }

  void _showAddItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(

          title: Text('Add New Item',style: TextStyle(    color:Color(0xFF01579B), fontFamily: 'Poppins',),),
          content: TextField(
            controller: _addItemController,

            decoration: InputDecoration(
              hintText: 'Enter new item',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',style: TextStyle(    color:Color(0xFF01579B), fontFamily: 'Poppins',),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add',style: TextStyle(    color:Color(0xFF01579B), fontFamily: 'Poppins',),),
              onPressed: () async {
                String newItem = _addItemController.text;
                if (newItem.isNotEmpty) {
                  // Save the new item to the database
                  await DatabaseHelper.instance.insertCategory(newItem);

                  // Update the dropdown items list
                  widget.onItemAdded(newItem);
                }
                Navigator.of(context).pop();
              },
            ),

          ],
        );
      },
    );
  }


}


