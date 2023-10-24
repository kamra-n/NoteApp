import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditNoteScreen extends StatefulWidget {
  final note;
  const EditNoteScreen({super.key, this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  //back button

  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  bool isUpdating = false;

  Future<void> _updateNotes() async {
    try {
      setState(() {
        isUpdating = true;
        Navigator.pop(context);
      });
      CollectionReference notes =
          FirebaseFirestore.instance.collection('Notes');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String userid = prefs.getString('uid')!;
      await notes.doc('${widget.note.id}').update({
        'id': userid,
        'note': noteController.text,
        'title': titleController.text
      });
      // ignore: use_build_context_synchronously
      setState(() {
        isUpdating = false;
        Fluttertoast.showToast(
            msg: "Note Updated Successfully.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    } catch (e) {
      print('error in upated note $e');
      setState(() {
        isUpdating = false;
      });
      Navigator.pop(context);
    }
  }

  Future<void> _backButtonDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff252525),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                  child: Icon(
                Icons.info,
                color: Colors.grey,
                size: 35,
              )),
              SizedBox(
                height: 20,
              ),
              Text(
                'Are your sure you want\ndiscard your changes ?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => const ViewNote()));
                  print('move to new Screen');
                },
                child: const Text(
                  'Discard',
                  style: TextStyle(color: Colors.white),
                )),
            const SizedBox(
              width: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  Navigator.pop(context);
                  // print('leeo');
                },
                child: const Text(
                  'Keep',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        );
      },
    );
  }

  Future<void> _saveButtonDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff252525),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                  child: Icon(
                Icons.info,
                color: Colors.grey,
                size: 35,
              )),
              SizedBox(
                height: 20,
              ),
              Text(
                'Save changes ?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Discard',
                  style: TextStyle(color: Colors.white),
                )),
            const SizedBox(
              width: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  _updateNotes();
                },
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    titleController.text = widget.note['title']!;
    noteController.text = widget.note['note']!;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
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
                          _backButtonDialog();
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
                          _saveButtonDialog();
                        },
                        icon: const Icon(
                          Icons.save,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: isUpdating
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 60,
                            width: double.infinity,
                            child: TextFormField(
                              controller: titleController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Title',
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                  )),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                                child: TextFormField(
                              controller: noteController,
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
                            )),
                          ),
                        ],
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
