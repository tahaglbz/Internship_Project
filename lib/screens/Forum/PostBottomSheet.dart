// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:my_app/extensions/media_query.dart';
// import '../../widgets/ForumBottomNav.dart';
// import '../../widgets/appColors.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as path;
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class Forum extends StatefulWidget {
//   const Forum({super.key});

//   @override
//   State<Forum> createState() => _ForumState();
// }

// class _ForumState extends State<Forum> {
//   int _selectedIndex = 4;

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     switch (_selectedIndex) {
//       case 0:
//         Get.offAllNamed('/mainmenu');
//         break;
//       case 1:
//         _showPostBottomSheet(context); // Open the bottom sheet
//         break;
//       case 2:
//         Get.offAllNamed('/profile');
//         break;
//     }
//   }

//   void _showPostBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
//       ),
//       builder: (context) {
//         final TextEditingController _textController = TextEditingController();
//         final ImagePicker _picker = ImagePicker();
//         XFile? _selectedImage;

//         // Get the bottom padding to account for the keyboard
//         final bottomInset = MediaQuery.of(context).viewInsets.bottom;

//         return Padding(
//           padding: EdgeInsets.only(
//             left: 16.0,
//             right: 16.0,
//             top: 16.0,
//             bottom: bottomInset + 16.0, // Add padding for the keyboard
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text('Create a Post', style: TextStyle(fontSize: 20)),
//                 const SizedBox(height: 10),
//                 TextField(
//                   controller: _textController,
//                   decoration: const InputDecoration(
//                     labelText: 'Post Text',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.photo),
//                   label: const Text('Select Image'),
//                   onPressed: () async {
//                     try {
//                       _selectedImage =
//                           await _picker.pickImage(source: ImageSource.gallery);
//                       if (_selectedImage != null) {
//                         print('Selected image path: ${_selectedImage!.path}');
//                       } else {
//                         print('No image selected.');
//                       }
//                     } catch (e) {
//                       Get.snackbar('Error', 'Failed to pick image: $e');
//                     }
//                   },
//                 ),
//                 const SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: () async {
//                     if (_selectedImage != null &&
//                         _textController.text.isNotEmpty) {
//                       try {
//                         await _createPost(
//                             _selectedImage!, _textController.text);
//                         Get.back(); // Close BottomSheet
//                       } catch (e) {
//                         Get.snackbar('Error', 'Failed to create post: $e');
//                       }
//                     } else {
//                       Get.snackbar('Error',
//                           'Please select an image and enter some text.');
//                     }
//                   },
//                   child: const Text('Post'),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _createPost(XFile image, String postText) async {
//     try {
//       // Resmi Firebase Storage'a yükle
//       String fileName = path.basename(image.path);
//       File imageFile = File(image.path);
//       FirebaseStorage storage = FirebaseStorage.instance;
//       Reference ref = storage.ref().child('posts/$fileName');

//       UploadTask uploadTask = ref.putFile(imageFile);
//       TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

//       // Resmin URL'ini al
//       String downloadUrl = await taskSnapshot.ref.getDownloadURL();

//       // Postu Firestore'a kaydet
//       FirebaseFirestore firestore = FirebaseFirestore.instance;
//       await firestore.collection('posts').add({
//         'text': postText,
//         'imageUrl': downloadUrl,
//         'createdAt': FieldValue.serverTimestamp(),
//       });

//       Get.snackbar('Success', 'Post created successfully.');
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to create post: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double deviceWidth = context.deviceWidth;
//     double appBarHeight = deviceWidth * 0.28;

//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(appBarHeight),
//         child: AppBar(
//           iconTheme: const IconThemeData(color: Colors.white),
//           automaticallyImplyLeading: false,
//           leading: IconButton(
//             onPressed: () => Get.offAllNamed('/mainmenu'),
//             icon: const Icon(Icons.arrow_back_ios_new_sharp),
//           ),
//           elevation: 0,
//           title: Image.asset('lib/assets/logo.png'),
//           centerTitle: true,
//           backgroundColor: AppColors.defaultColor,
//         ),
//       ),
//       bottomNavigationBar: ForumBottom(
//         selectedIndex: _selectedIndex,
//         onItemTapped: _onItemTapped,
//       ),
//     );
//   }
// }
