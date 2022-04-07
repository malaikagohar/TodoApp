import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _myFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  createUser() async {
    if (_myFormKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passController.text);
        String uid = userCredential.user!.uid;
        await FirebaseFirestore.instance.collection("Users").doc(uid).set(
          {
            "Username": nameController.text,
            "Email": emailController.text,
            "Password": passController.text,
          },
        );

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Login()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
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
          body: SingleChildScrollView(
            child: Form(
              key: _myFormKey,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),
                    const Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.white, fontSize: 32, letterSpacing: 2),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                        "We aim to provide quality over quantity. Our team is fully trained and experienced to produce best customer support, designs, and top quality products.",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            letterSpacing: 0.5)),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 40, 0, 10),
                      child: TextFormField(
                        controller: nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            fillColor: Colors.black54,
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.grey,
                            ),
                            hintStyle: const TextStyle(color: Colors.grey),
                            labelStyle: const TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Username",
                            labelText: "Username",
                            filled: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Username can't be empty";
                          }

                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: TextFormField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            fillColor: Colors.black54,
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.grey,
                            ),
                            hintStyle: const TextStyle(color: Colors.grey),
                            labelStyle: const TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Email",
                            labelText: "Email",
                            filled: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email can't be empty";
                          }

                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: TextFormField(
                        controller: passController,
                        style: const TextStyle(color: Colors.white),
                        obscureText: true,
                        decoration: InputDecoration(
                            fillColor: Colors.black54,
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            hintStyle: const TextStyle(color: Colors.grey),
                            labelStyle: const TextStyle(color: Colors.grey),
                            hintText: "Password",
                            labelText: "Password",
                            filled: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password can't be empty";
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(
                      height: 25,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: createUser,
                        child: const Text(
                          "REGISTER",
                          style: TextStyle(fontSize: 16),
                        ),
                        style: TextButton.styleFrom(
                            minimumSize: const Size(500, 40),
                            backgroundColor: const Color(0xFFF324D9A)),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Or Enter Via Social Networks",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 60, 0, 80),
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.white)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 10),
                                    Image.asset(
                                      "assets/googleicon.png",
                                      height: 20,
                                    ),
                                    const SizedBox(width: 5),
                                    const Text("Google",
                                        style: TextStyle(color: Colors.white)),
                                    const SizedBox(width: 5),
                                  ],
                                ),
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.transparent)),
                            const VerticalDivider(color: Colors.white),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.facebook),
                              label: const Text("Facebook"),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent,
                              ),
                            )
                          ],
                        ))
                  ],
                ),
              ),
            ),
          ))
    ]);
  }
}
