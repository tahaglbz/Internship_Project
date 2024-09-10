// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

Future<String?> ShowEditUsernameBottomSheet(BuildContext context) {
  final TextEditingController usernameController = TextEditingController();

  return showModalBottomSheet<String>(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'New Username',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(usernameController.text);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      );
    },
  );
}
