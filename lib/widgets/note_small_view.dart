import 'package:flutter/material.dart';

class NoteSmallView extends StatefulWidget {
  final String noteTitle;
  final String noteText;
  final Color colours;
  const NoteSmallView(
      {super.key,
      required this.noteText,
      required this.colours,
      required this.noteTitle});

  @override
  State<NoteSmallView> createState() => _NoteSmallViewState();
}

class _NoteSmallViewState extends State<NoteSmallView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 100,
          decoration: BoxDecoration(
              color: widget.colours, borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: Text(
              widget.noteTitle.length > 100
                  ? widget.noteTitle.substring(0, 100)
                  : widget.noteTitle,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}
