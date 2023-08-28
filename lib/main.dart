import 'package:flutter/material.dart';
import 'package:gifs_finder_project/ui/home_page.dart';

void main() {
  runApp(
      MaterialApp(
        home: const HomePage(),
        theme: ThemeData(hintColor: Colors.white),
      )
  );
}

