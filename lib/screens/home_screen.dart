import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasepractice/constant/app_images.dart';
import 'package:firebasepractice/screens/add_note_screen.dart';
import 'package:firebasepractice/screens/view_note_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../widgets/note_small_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getValuesFromStorage();
  }

  var colors = [
    const Color(0xffFD99FF),
    const Color(0xffFF9E9E),
    const Color(0xff91F48F),
    const Color(0xffFFF599),
    const Color(0xff9EFFFF),
    const Color(0xffB69CFF),
  ];

  CollectionReference notes = FirebaseFirestore.instance.collection('Notes');

  String? id;
  bool isUpdated = false;

  Future<void> getValuesFromStorage() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      id = prefs.getString('uid')!;
    } catch (e) {
      print('error in catch $e');
    }
  }

  Future<void> deleteUser(id) async {
    print('on dismss id $id');
    try {
      setState(() {
        isUpdated = true;
      });
      await notes.doc(id).delete();
      Fluttertoast.showToast(
          msg: "Note Deleted Successfully.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        isUpdated = false;
      });
    } catch (e) {
      print('error while deleting a document $e');
      Fluttertoast.showToast(
          msg: "Error While Deleting Note.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      setState(() {
        isUpdated = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: const Text(
              'Notes',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
            actions: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: const Color(0xff3B3B3B),
                    borderRadius: BorderRadius.circular(12)),
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    )),
              ),
              const SizedBox(
                width: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: const Color(0xff3B3B3B),
                      borderRadius: BorderRadius.circular(12)),
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.info,
                        color: Colors.white,
                      )),
                ),
              )
            ],
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: notes.where('id', isEqualTo: id).snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.data!.docs.isEmpty) {
                return Center(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AppImages.noNotes,
                      fit: BoxFit.contain,
                      width: 350,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      'Create your first note !',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ));
              }

              return ListView.builder(
                itemBuilder: (context, index) {
                  final colorIndex = index % colors.length;
                  DocumentSnapshot document = snapshot.data!.docs[index];
                  return Dismissible(
                    onDismissed: (direction) {
                      deleteUser(document.id);
                    },
                    direction: DismissDirection.endToStart,
                    key: ValueKey<String>(document.id),
                    background: Container(
                      color: Colors.red,
                      height: double.infinity,
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                        child: Center(
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ViewNote(
                                  notes: document,
                                )));
                      },
                      child: isUpdated
                          ? const Center(child: CircularProgressIndicator())
                          : NoteSmallView(
                              noteTitle: document['title'],
                              noteText: document['note'],
                              colours: colors[colorIndex],
                            ),
                    ),
                  );
                },
                itemCount: snapshot.data!.docs.length,
              );
            },
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 80.0, right: 7.0),
            child: FloatingActionButton(
              backgroundColor: Colors.indigo.withOpacity(0.3),
              shape: const CircleBorder(),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AddnoteScreen()));
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          )),
    );
  }
}
