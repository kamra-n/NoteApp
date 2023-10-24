import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddnoteScreen extends StatefulWidget {
  const AddnoteScreen({super.key});

  @override
  State<AddnoteScreen> createState() => _AddnoteScreenState();
}

class _AddnoteScreenState extends State<AddnoteScreen> {
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  bool isadded = false;
  CollectionReference notes = FirebaseFirestore.instance.collection('Notes');
  Future<void> addNote() async {
    try {
      setState(() {
        isadded = true;
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? id = prefs.getString('uid');
      await notes.add({
        'title': _titleController.text,
        'note': _messageController.text,
        'id': id
      });

      _titleController.clear();
      _messageController.clear();
      setState(() {
        isadded = false;
        Fluttertoast.showToast(
            msg: "Note Added Successfully.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    } catch (e) {
      print('Error come from add notes catch $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, top: 30.0, right: 20.0, bottom: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: const Color(0xff3B3B3B),
                          borderRadius: BorderRadius.circular(12)),
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_outlined,
                            color: Colors.white,
                          )),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: const Color(0xff3B3B3B),
                          borderRadius: BorderRadius.circular(12)),
                      child: IconButton(
                          onPressed: () {
                            addNote();
                          },
                          icon: const Icon(
                            Icons.save,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: isadded
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            TextFormField(
                              controller: _titleController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Title',
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                  )),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _messageController,
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: const InputDecoration(
                                  hintText: 'Type Something...',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  )),
                            ),
                          ],
                        ))
            ],
          ),
        ),
      ),
    );
  }
}
