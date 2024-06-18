import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //firestore
  final FirestoreServices firestoreService = FirestoreServices();
  //text controller
  final TextEditingController textcontroller = TextEditingController();
//open a dialog box to add a note
  void openNoteBox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(controller: textcontroller),
        actions: [
          //button to save
          ElevatedButton(
            onPressed: () {
              //add a new note
              if (docID == null) {
                firestoreService.addNote(textcontroller.text);
              }
              //update an existing note
              else {
                firestoreService.updateNote(docID, textcontroller.text);
              }
              //clear the text contoller
              textcontroller.clear();
              //close the box
              Navigator.pop(context);
            },
            child: const Text('add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        centerTitle: true,
        title: const Text('notes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getnotesStream(),
        builder: (context, snapshot) {
          //if the snapshot has data, get all docs
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            //display as a list
            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                //get each individual doc
                DocumentSnapshot document = notesList[index];
                String docID = document.id;

                // get a note from each doc
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteText = data['note'];

                //display as a list tile
                return ListTile(
                    title: Text(noteText),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => openNoteBox(docID: docID),
                          icon: const Icon(Icons.settings),
                        ),
                        IconButton(
                          onPressed: () => firestoreService.deleteNote(docID),
                          icon: Icon(Icons.delete),
                        )
                      ],
                    ));
              },
            );
          }
          //if there is no data
          else {
            return const Text('No notes...');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: Icon(Icons.add),
      ),
    );
  }
}
