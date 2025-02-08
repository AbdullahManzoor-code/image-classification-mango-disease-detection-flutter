import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:my_tflit_app/Utils/utils.dart';
import 'package:my_tflit_app/widget/HomeAppBar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final search = TextEditingController();
  final ref = FirebaseDatabase.instance.ref('data');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool check() {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    bool guest = false;
    if (user == null) {
      guest = true;
    }
    return guest;
  }

  @override
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4C53A5),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Text(
              AppLocalizations.of(context)!.chat_chats,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                fontFamily: 'Squada',
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: TextFormField(
              // controller: ,
              onChanged: (String val) {
                setState(() {});
              },
              decoration: InputDecoration(
                label: Text(AppLocalizations.of(context)!.post_search),
                hintText: AppLocalizations.of(context)!.chat_search,
                hintStyle: const TextStyle(color: Colors.black26),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.all(8),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black12),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: MediaQuery.of(context).size.height / 1.235,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.chat_convo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Color(0xFF4C53A5),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('users')
                        .doc(_auth.currentUser?.uid)
                        .collection('images')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            'No data found.',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        );
                      }

                      final List<DocumentSnapshot> documents = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          final data = documents[index].data() as Map<String, dynamic>;
                          final username = data['username'] ?? 'Unknown';
                          final email = data['email'] ?? 'No email';
                          final result = data['Result'] ?? 'No result';
                          final suggestion = data['suggestion'] ?? 'No suggestion';
                          final imagePath = data['imagepath'] ?? '';

                          File? imageFile;
                          if (imagePath.isNotEmpty) {
                            imageFile = File(imagePath);
                          }

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: ListTile(
                              leading: imageFile != null && imageFile.existsSync()
                                  ? Image.file(
                                      imageFile,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.image, size: 50, color: Colors.grey),
                              title: Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Email: $email'),
                                  Text('Result: $result'),
                                  Text('Suggestion: $suggestion'),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ImagePreviewScreen(
                                      imagePath: imagePath,
                                      username: username,
                                      email: email,
                                      result: result,
                                      suggestion: suggestion,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImagePreviewScreen extends StatelessWidget {
  final String imagePath;
  final String username;
  final String email;
  final String result;
  final String suggestion;

  const ImagePreviewScreen({
    super.key,
    required this.imagePath,
    required this.username,
    required this.email,
    required this.result,
    required this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    File? imageFile;
    if (imagePath.isNotEmpty) {
      imageFile = File(imagePath);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(username),
        backgroundColor: const Color(0xFF4C53A5),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageFile != null && imageFile.existsSync()
                ? Image.file(
                    imageFile,
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.image, size: 100, color: Colors.grey),
            const SizedBox(height: 20),
            Text('Username: $username', style: const TextStyle(fontSize: 18)),
            Text('Email: $email', style: const TextStyle(fontSize: 18)),
            Text('Result: $result', style: const TextStyle(fontSize: 18)),
            Text('Suggestion: $suggestion', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

}
