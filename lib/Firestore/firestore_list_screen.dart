import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasebackend/Firestore/add_firestore_data.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebasebackend/ui/auth/loginScreen.dart';
import 'package:firebasebackend/utils/utils.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({super.key});

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  final auth = FirebaseAuth.instance;
  final editControler = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('user').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('user');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fire Store'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                }).catchError((e) {
                  Utils().toastMessage(e.toString());
                  return e;
                });
                ;
              },
              icon: const Icon(Icons.login_rounded))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: fireStore,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return const Text('Error');
                  }

                  return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                //this is to update the data
                                // ref.doc(snapshot.data!.docs[index]['id']
                                //   .toString()).update({
                                //     'title': 'This is yousuf'
                                //   }).then((value){
                                //     Utils().sucesstoastMessage('Updated');
                                //   }).onError((error, stackTrace) {
                                //     Utils().toastMessage(error.toString());
                                //   });

                                //this is to remove the data

                                ref
                                    .doc(
                                      snapshot.data!.docs[index]['id']
                                          .toString(),
                                    )
                                    .delete();
                              },
                              title: Text(
                                snapshot.data!.docs[index]['title'].toString(),
                              ),
                              subtitle: Text(
                                snapshot.data!.docs[index]['id'].toString(),
                              ),
                            );
                          }));
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddFirestoreDataScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDailog(String title, String id) async {
    editControler.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update'),
            content: Container(
              child: TextField(
                controller: editControler,
                decoration: const InputDecoration(hintText: 'Edit'),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Update'),
              ),
            ],
          );
        });
  }
}
