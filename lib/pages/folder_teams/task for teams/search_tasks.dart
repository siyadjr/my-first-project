import 'package:flutter/material.dart';

typedef OnSearchCallback = void Function(String);

class SearchTasks extends StatelessWidget {
  final OnSearchCallback onSearch;
  const SearchTasks({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: SizedBox(
        height: 45,
        child: TextFormField(
          onChanged: onSearch,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
            fillColor: Colors.white,
            filled: true,
            labelText: 'Search',
            labelStyle: const TextStyle(
              color: Color.fromARGB(255, 172, 172, 172),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
