import 'package:flutter/material.dart';
import 'package:onesq/note-detail.dart';
import 'package:onesq/note-model.dart';
import 'package:onesq/sql-database.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  SqlDb sqlDb = SqlDb();
  List<Note> notes = [];

  @override
  void initState() {
    loadNotes();
    super.initState();
  }

  loadNotes()async{
    var response = await sqlDb.readData("SELECT * FROM notes");
    setState(() {
      notes = response.map((map)=>Note.fromMap(map)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Note list', style: TextStyle(color: Colors.white),),
      ),
      body: ListView.builder(
          itemCount: notes.length,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context , index){
            return ListTile(
              title: Text(notes[index].title??'No title'),
              subtitle: Text(notes[index].subtitle??'No subtitle'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>NoteDetail(note: notes[index],))).then((v){
                  loadNotes();
                });
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>NoteDetail())).then((v){
              loadNotes();
            });
          }),
    );
  }
}
