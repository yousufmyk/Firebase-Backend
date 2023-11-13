import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'package:firebasebackend/ui/auth/loginScreen.dart';
import 'package:firebasebackend/ui/posts/add_posts.dart';
import 'package:firebasebackend/utils/utils.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  final searchfilter = TextEditingController();
  final editControler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Screen'),
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
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: searchfilter,
              decoration: const InputDecoration(
                  hintText: 'Search', border: OutlineInputBorder()),
                  onChanged: (String value){
                    setState(() {
                      
                    });
                  },
            ),
            Expanded(
                child: FirebaseAnimatedList(
              query: ref,
              defaultChild: const Text('loading'),
              itemBuilder: (context, snapshot, animation, index) {
                final title = snapshot.child('Data').value.toString();

                if (searchfilter.text.isEmpty) {
                  return ListTile(
                    title: Text(snapshot.child('Data').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_vert_rounded),
                      itemBuilder: (context) => [
                         PopupMenuItem(
                          value: 1,
                          child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Edit'),
                          onTap: (){
                            Navigator.pop(context);
                            showMyDailog(title,snapshot.child('id').value.toString());
                          },
                        )),
                         PopupMenuItem(
                          value: 1,
                          child: ListTile(
                          leading: Icon(Icons.delete),
                          title: Text('Delete'),
                          onTap: (){
                            Navigator.pop(context);
                            ref.child(snapshot.child('id').value.toString()).remove();
                          },
                        )),
                      ]),
                  );
                } else if (title.toLowerCase().contains(searchfilter.text.toLowerCase().toLowerCase())) {
                  return ListTile(
                      title: Text(snapshot.child('Data').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()));
                } else {
                  return Container();
                }
              },
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPost()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  Future<void> showMyDailog (String title,String id)async {
    editControler.text = title;
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text('Update'),
        content: Container(
          child: TextField(
            controller: editControler,
            decoration: InputDecoration(
              hintText: 'Edit'
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Cancel'),),
          TextButton(onPressed: (){
            Navigator.pop(context);
            ref.child(id).update({
              'Data' : editControler.text.toString()
            }).then((value){
              Utils().sucesstoastMessage('Post Updated');
            }).onError((error, stackTrace) {
              Utils().toastMessage(error.toString());
            });
          }, child: Text('Update'),),
        ],
      );
    });
}
}





// Expanded(
//               child: StreamBuilder(
//             stream: ref.onValue,
//             builder: (context,AsyncSnapshot<DatabaseEvent> snapshot){
//               if (!snapshot.hasData) {
//                 return CircularProgressIndicator();                
//               } else {
//                 Map<dynamic,dynamic> map = snapshot.data!.snapshot.value as dynamic;
//                 List<dynamic> list = [];
//                 list.clear();
//                 list = map.values.toList();
//                 return ListView.builder(
//                   itemCount: list.length,
//                   itemBuilder: (context,index){
//                     return ListTile(
//                       title: Text(list[index]['Data']),
//                       subtitle: Text(list[index]['id']),
//                     );
//                   });
//               }
//             },
//           )),
//           Expanded(
//               child: FirebaseAnimatedList(
//             query: ref,
//             defaultChild: Text('loading'),
//             itemBuilder: (context, snapshot, animation, index) {
//               return ListTile(
//                 title: Text(snapshot.child('Data').value.toString()),
//                 subtitle: Text(snapshot.child('id').value.toString()),
//               );
//             },
//           ))