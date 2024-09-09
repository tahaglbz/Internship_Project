import 'package:flutter/material.dart';

Future<String?> ShowEditUsernameBottomSheet(BuildContext context) {
  final TextEditingController _usernameController = TextEditingController();

  return showModalBottomSheet<String>(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'New Username',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(_usernameController.text);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      );
    },
  );
}
