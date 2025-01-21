import 'package:flutter/material.dart';
import 'appBars.dart';
import 'bottomNavigation.dart';

class CustomColors {
  static const TextHeader = Color(0xFF333333); // Replace with your color
  static const TextHeaderGrey = Color(0xFF666666);
  static const TextSubHeaderGrey = Color(0xFF999999);
  static const GreyBorder = Color(0xFFE0E0E0);
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final int bottomNavigationBarIndex = 0;

  // Sample list of notes
  final List<Map<String, String>> notes = [
    {
      "title": "Grocery List",
      "content": "Milk, Eggs, Bread, Coffee",
    },
    {
      "title": "Meeting Notes",
      "content": "Discuss project updates and deadlines.",
    },
    {
      "title": "Ideas",
      "content": "Brainstorm app features and improvements.",
    },
    {
      "title": "To-Do",
      "content": "Finish Flutter app, write documentation.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: fullAppbar(context), // Custom app bar
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: MediaQuery.of(context).size.width,
        child: CustomScrollView(
          slivers: <Widget>[
            // Header Text
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(left: 10, top: 15, bottom: 10),
                child: const Text(
                  'Your Notes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: CustomColors.TextHeader,
                  ),
                ),
              ),
            ),

            // Notes Grid
            SliverGrid.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: notes.map((note) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: const [
                      BoxShadow(
                        color: CustomColors.GreyBorder,
                        blurRadius: 5.0,
                        spreadRadius: 2.0,
                        offset: Offset(0.0, 2.0),
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: InkWell(
                    onTap: () {
                      // Show note content in a dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(note["title"] ?? "Note"),
                          content: Text(note["content"] ?? "No content."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Close"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note["title"] ?? "",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: CustomColors.TextHeaderGrey,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            note["content"] ?? "",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: CustomColors.TextSubHeaderGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),

      // Floating Action Button for Adding Notes
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open "Add Note" dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Add New Note"),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Content",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add logic to save the new note
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar:
          BottomNavigationBarApp(context, bottomNavigationBarIndex),
    );
  }
}
