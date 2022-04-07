import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? title;
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  String uid = '';

  @override
  void initState() {
    super.initState();
    getuid();
  }

  getuid() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      uid = user!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/todobg.jpeg"),
                fit: BoxFit.cover,
                colorFilter:
                    ColorFilter.mode(Colors.black45, BlendMode.luminosity)),
          ),
        ),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: const Icon(Icons.menu, color: Color(0xfff324d9a)),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    color: Color(0xFFF324D9A),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Color(0xFFF324D9A),
                  ),
                ),
                const SizedBox(
                  width: 5,
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GetUserName(uid),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(" MY TASKS",
                        style: TextStyle(
                            color: Color(0xFFF324D9A),
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 20,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("Users")
                            .doc(uid)
                            .collection("MyTasks")
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else {
                            final docs = snapshot.data!.docs;
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext context, index) {
                                  var isChecked = docs[index]['isChecked'];
                                  var time = DateTime.now();
                                  return Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Edit Todo'),
                                                content: TextFormField(
                                                  controller: titleController..text=docs[index]['title'],
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText: "Edit todo"
                                                      ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xFFF324D9A),
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('Users')
                                                          .doc(uid)
                                                          .collection("MyTasks")
                                                          .doc(docs[index]
                                                              ['time'])
                                                          .update({
                                                        'title': titleController
                                                            .text,
                                                      });
                                                      titleController.clear();
                                                      Navigator.pop(context);
                                                      setState(() {});
                                                    },
                                                    child: const Text(
                                                      "Submit",
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xFFF324D9A),
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      child: ListTile(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                                leading: Checkbox(
                                                  // side: ,
                                                  
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(3)
                                                  ),

                                        checkColor: Colors.white,
                                        activeColor: Color(0xfff324d9a),
                                        value: isChecked,
                                        onChanged: (bool? value) async {
                                            isChecked = value!;
                                         await FirebaseFirestore.instance
                                              .collection('Users')
                                              .doc(uid)
                                              .collection("MyTasks")
                                              .doc(docs[index]['time'])
                                              .update({
                                            'isChecked': isChecked,
                                          });
                                          setState(() {});
                                        }),
                                        tileColor: Colors.white54,
                                        trailing: IconButton(
                                            onPressed: () async {
                                              await FirebaseFirestore.instance
                                                  .collection('Users')
                                                  .doc(uid)
                                                  .collection('MyTasks')
                                                  .doc(docs[index]['time'])
                                                  .delete();
                                            },
                                            icon: const Icon(Icons.delete,
                                                color: Color(0xfff324d9a))),
                                        title: Text(
                                          docs[index]['title'],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        subtitle: Text(
                                            DateFormat.yMd()
                                                .add_jm()
                                                .format(time),
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white54)),
                                      ),
                                    ),
                                  );
                                });
                          }
                        }),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xFFF324D9A),
              onPressed: () {
                        titleController.clear();
                var time = DateTime.now();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Add Todo'),
                        content: TextField(
                          controller: titleController,
                          decoration:
                              const InputDecoration(hintText: "Enter todo"),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                  color: Color(0xFFF324D9A),
                                  fontWeight: FontWeight.w400),
                            ),
                            onPressed: () {
                              setState(() {
                                Navigator.pop(context);
                              });
                            },
                          ),
                          TextButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(uid)
                                  .collection("MyTasks")
                                  .doc(time.toString())
                                  .set({
                                'title': titleController.text,
                                'time': time.toString(),
                                'isChecked':false
                              });
                              titleController.clear();
                              Navigator.pop(context);
                              setState(() {});
                            },
                            child: const Text(
                              "Submit",
                              style: TextStyle(
                                  color: Color(0xFFF324D9A),
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      );
                    });
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ))
      ],
    ));
  }
}

class GetUserName extends StatelessWidget {
  final String documentId;

  const GetUserName(this.documentId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text("What's up,  ${data["Username"].split(' ')[0]}!",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 29,
              ));
        }
        return const Text("loading");
      },
    );
  }
}
