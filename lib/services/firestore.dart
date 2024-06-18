import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  //get collection of notes
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

  //Create: add a new note
  Future<void> addNote(String note) {
    return notes.add({
      'note': note,
      'timestamps': Timestamp.now(),
    });
  }

  //Read: get notes from database
  Stream<QuerySnapshot> getnotesStream() {
    final notesStream =
        notes.orderBy('timestamps', descending: true).snapshots();
    return notesStream;
  }

  //Update: update a note given a doc id
  Future<void> updateNote(String docID, String newNote) {
    return notes.doc(docID).update(
      {
        'note': newNote,
        'timestamp': Timestamp.now(),
      },
    );
  }

  //delete: delete a note given a doc id
  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }
}
