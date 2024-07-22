import 'package:flutter/material.dart';

typedef OnSearchCallback = void Function(String);

class SearchBarTeam extends StatelessWidget {
  final OnSearchCallback onSearch;

  const SearchBarTeam({Key? key, required this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 20.0, vertical: 15.0), // Adjust padding as needed
      child: SizedBox(
        height: 45,
        child: TextFormField(
          onChanged: onSearch,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
            fillColor: Colors.white,
            filled: true,
            label: const Text('Search'),
            hintStyle:
                const TextStyle(color: Color.fromARGB(255, 172, 172, 172)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
