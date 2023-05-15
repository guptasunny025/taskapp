// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_app/screens/add_task_screen.dart';
import '../provider/auth.dart';
import 'splash_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isloading = false;
  _showAlertDialog(bool isdelete, String docid) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext dialogContext) {
          final deviceSize = MediaQuery.of(context).size;
          return AlertDialog(
              backgroundColor: Colors.white,
              iconPadding: EdgeInsets.only(
                  top: 0, bottom: deviceSize.height / 4 / 4 / 4),
              title: Text(isdelete == true ? 'Delete task' : 'Log Out',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: deviceSize.height / 4 / 4 / 3,
                      fontWeight: FontWeight.bold)),
              content: Container(
                margin: EdgeInsets.only(
                    left: deviceSize.width / 4 / 4 / 3,
                    right: deviceSize.width / 4 / 4 / 3),
                child: Text(
                    isdelete == true
                        ? 'Are you sure you want to delete task?'
                        : 'Are you sure you want to Log out?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: deviceSize.height / 4 / 4 / 3,
                        fontWeight: FontWeight.w500)),
              ),
              icon: Column(children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                FaIcon(
                  isdelete == true
                      ? FontAwesomeIcons.trashCan
                      : FontAwesomeIcons.rightFromBracket,
                  size: deviceSize.height / 4 / 4,
                )
              ]),
              actions: [
                Column(children: [
                  Container(
                    width: double.infinity,
                    height: deviceSize.height / 4 / 3 * .8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFF4284F3),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4284F3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // <-- Radius
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: deviceSize.height / 4 / 3 * .8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFE9E9E9),
                        border:
                            Border.all(color: Color(0xff900D3E), width: .6)),
                    margin: EdgeInsets.only(
                      top: deviceSize.height / 4 / 4 / 3,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE9E9E9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // <-- Radius
                        ),
                      ),
                      onPressed: () async {
                        if (isdelete == true) {
                          await Provider.of<Auth>(context, listen: false)
                              .deleteProduct(docid)
                              .then((value) => Navigator.pop(context));
                        } else {
                          await Provider.of<Auth>(context, listen: false)
                              .logout();

                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SplashScreen(
                                        auth: false,
                                      )),
                              (Route<dynamic> route) => false);
                        }
                      },
                      child: const Text('Yes',
                          style: TextStyle(
                            color: Colors.black,
                          )),
                    ),
                  )
                ])
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const AddTaskScreen(
                        docid: '',
                        taskdesc: '',
                        taskid: '',
                        taskname: '',
                        isedit: false,
                        taskdate: '',
                      )));
        },
        child: Icon(
          Icons.add,
          size: deviceSize.height / 4 / 4 * .8,
        ),
      ),
      appBar: AppBar(
          leading: Icon(
            Icons.menu,
            color: Colors.white,
            size: deviceSize.height / 4 / 4 * .6,
          ),
          actions: [
            OutlinedButton(
                onPressed: () {
                  _showAlertDialog(false, '');
                },
                child: const Text(
                  "Log Out",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ))
          ]),
      body: SafeArea(
          child: Column(
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
                left: deviceSize.width / 4 / 4 / 2,
                top: deviceSize.height / 4 / 4 / 4),
            child: Text(
              'Welcome : ${Provider.of<Auth>(context, listen: false).username} ',
              style: TextStyle(fontSize: deviceSize.height / 4 / 4 / 3),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
                left: deviceSize.width / 4 / 4,
                top: deviceSize.height / 4 / 4 / 2),
            child: Text(
              'Tasks',
              style: TextStyle(fontSize: deviceSize.height / 4 / 4 / 2 * .9),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('tasks').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return snapshot.data!.docs.isEmpty
                    ? Center(
                        child: Text(
                          'No task found',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: deviceSize.height / 4 / 4 / 3),
                        ),
                      )
                    : snapshot.data!.docs
                            .where((element) =>
                                element['userid'] ==
                                Provider.of<Auth>(context, listen: false)
                                    .userId)
                            .toList()
                            .isEmpty
                        ? Center(
                            child: Text(
                              'No task added yet',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: deviceSize.height / 4 / 4 / 3),
                            ),
                          )
                        : ListView(
                            children: snapshot.data!.docs
                                .where((element) =>
                                    element['userid'] ==
                                    Provider.of<Auth>(context, listen: false)
                                        .userId)
                                .map((document) {
                            final dynamic data = document.data();
                            return GestureDetector(
                              child: Card(
                                color: Colors.white,
                                margin: EdgeInsets.only(
                                    top: deviceSize.height / 4 / 4 / 2,
                                    left: deviceSize.width / 4 / 4 / 2,
                                    right: deviceSize.width / 4 / 4 / 2),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: deviceSize.width / 4 / 4 / 4,
                                      right: 1,
                                      top: deviceSize.height / 4 / 4 / 4 / 2,
                                      bottom:
                                          deviceSize.height / 4 / 4 / 4 / 2),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            Color(0xFF46539E).withOpacity(.9),
                                        radius: deviceSize.height / 4 / 4 * .8,
                                        child: Text(
                                          '${data['taskname'][0]}'
                                              .toUpperCase(),
                                          style: TextStyle(
                                            fontSize:
                                                deviceSize.height / 4 / 4 / 2,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: deviceSize.width / 4 / 4 / 2,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Name: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          deviceSize.height /
                                                              4 /
                                                              4 /
                                                              3),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${data['taskname']}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize:
                                                            deviceSize.height /
                                                                4 /
                                                                4 /
                                                                3),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: deviceSize.height /
                                                  4 /
                                                  4 /
                                                  4 /
                                                  2,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Desc: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          deviceSize.height /
                                                              4 /
                                                              4 /
                                                              3),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${data['taskdesc']}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize:
                                                            deviceSize.height /
                                                                4 /
                                                                4 /
                                                                3),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      data['userid'] !=
                                              Provider.of<Auth>(context,
                                                      listen: false)
                                                  .userId
                                          ? Container()
                                          : Container(
                                              height:
                                                  deviceSize.height / 4 * .7,
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      AddTaskScreen(
                                                                        isedit:
                                                                            true,
                                                                        docid: document
                                                                            .id,
                                                                        taskdesc:
                                                                            data['taskdesc'],
                                                                        taskid:
                                                                            data['taskid'],
                                                                        taskname:
                                                                            data['taskname'],
                                                                        taskdate:
                                                                            data['taskdate'],
                                                                      )));
                                                        },
                                                        icon: const FaIcon(
                                                          FontAwesomeIcons
                                                              .penToSquare,
                                                        )),
                                                    IconButton(
                                                        onPressed: () async {
                                                          _showAlertDialog(true,
                                                              document.id);
                                                        },
                                                        icon: const FaIcon(
                                                          FontAwesomeIcons
                                                              .trashCan,
                                                        )),
                                                  ])),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {},
                            );
                          }).toList());
              },
            ),
          )
        ],
      )),
    );
  }
}
