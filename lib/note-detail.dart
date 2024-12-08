import 'package:flutter/material.dart';
import 'package:onesq/note-model.dart';
import 'package:onesq/sql-database.dart';

class NoteDetail extends StatefulWidget {
  final Note? note;
  const NoteDetail({super.key, this.note});

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  SqlDb sqlDb =SqlDb();
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  @override
  void initState() {
    if(widget.note !=null){
      titleController.text = widget.note!.title ?? '';
      subtitleController.text = widget.note!.subtitle ?? '';
      descController.text = widget.note!.description ?? '';
    }
    super.initState();
  }

  saveNote()async{
    if(titleController.text.isNotEmpty && subtitleController.text.isNotEmpty&& descController.text.isNotEmpty){
      if(widget.note ==null){
        await sqlDb.insertData("INSERT INTO notes (title,subtitle,description) VALUES ('${titleController.text}','${subtitleController.text}','${descController.text}')");
      }else{
        await sqlDb.updateData("UPDATE notes SET title = '${titleController.text}', subtitle = '${subtitleController.text}', description = '${descController.text}' WHERE id = ${widget.note!.id}");
      }
    }
    Navigator.pop(context);
  }

  deleteNote()async{
    if(widget.note !=null){
      await sqlDb.deleteData("DELETE FROM notes WHERE id = ${widget.note!.id}");
    }
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Note Detail',style: TextStyle(color: Colors.white),),
        actions: [
          if(widget.note !=null)
          IconButton(onPressed:deleteNote , icon: Icon(Icons.delete,color: Colors.red,))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'title'
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: subtitleController,
                decoration: InputDecoration(
                    hintText: 'subtitle'
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: descController,
                decoration: InputDecoration(
                    hintText: 'description'
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                  onPressed:saveNote ,
                  child: Text('Submit'))
            ],
          ),
        ),
      ),
    );
  }
}
