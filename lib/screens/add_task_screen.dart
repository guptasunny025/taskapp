// ignore_for_file: use_build_context_synchronously, sort_child_properties_last, unnecessary_null_comparison, prefer_if_null_operators

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../httpException.dart';
import '../provider/auth.dart';
import 'login_screen.dart';

class AddTaskScreen extends StatefulWidget {
  final String taskid, taskname, taskdesc, docid, taskdate;
  final bool isedit;
  const AddTaskScreen(
      {super.key,
      required this.taskid,
      required this.taskname,
      required this.taskdesc,
      required this.docid,
      required this.isedit,
      required this.taskdate});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  var _isLoading = false;
  final _descController = TextEditingController();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  Future<void> _submit() async {
    String dateoftask = _dobController.text.trim();
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    } else if (dateoftask.isEmpty) {
      toast('please choose date');
    } else {
      setState(() {
        _isLoading = true;
      });
      try {
        widget.isedit == true
            ? await Provider.of<Auth>(context, listen: false).edittask(
                _nameController.text,
                _descController.text,
                dateoftask,
                widget.docid,
                widget.taskid)
            : await Provider.of<Auth>(context, listen: false).addtask(
                _nameController.text, _descController.text, dateoftask);
      } on HttpException catch (error) {
        toast(error.message.toString());
      } catch (error) {
        toast(error.toString());
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  selectDate(BuildContext context, DateTime initialDateTime,
      {required DateTime lastDate}) async {
    Completer completer = Completer();
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2024))
        .then((temp) {
      if (temp == null) return null;
      completer.complete(temp);
      setState(() {});
    });
    return completer.future;
  }

  getdata() {
    _nameController.text = widget.taskname;
    _descController.text = widget.taskdesc;
    _dobController.text = widget.taskdate;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isedit == true) {
      getdata();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(
              left: deviceSize.width / 4 / 4 / 2,
              right: deviceSize.width / 4 / 4 / 2),
          color: const Color(0xFF46539E),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Container(
                    margin: EdgeInsets.only(top: deviceSize.height / 4 / 4 / 4),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: const Color(0xFF5086C6),
                              size: deviceSize.height / 4 / 4 * .7,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Text(
                           widget.isedit==true? 'Update new task': 'Add new task',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: deviceSize.height / 4 / 4 / 2 * .8),
                          ),
                          const FaIcon(
                            FontAwesomeIcons.sliders,
                            color: Color(0xFF5086C6),
                          )
                        ])),
                Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: deviceSize.height / 4 / 4 / 2),
                    width: double.infinity,
                    padding: const EdgeInsets.all(1),
                    child: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 81, 94, 171),
                      radius: deviceSize.height / 4 / 4 * .8,
                      child: const FaIcon(
                        FontAwesomeIcons.listCheck,
                        color: Color(0xFF5086C6),
                      ),
                    )),
                SizedBox(height: deviceSize.height / 4 / 4 / 2),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                      left: deviceSize.width / 4 / 4 / 4,
                      right: deviceSize.width / 4 / 4 / 4),
                  child: TextFormField(
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      controller: _nameController,
                      validator: (value) =>
                          value!.isEmpty ? 'Pḷease enter task name' : null,
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w300),
                        hintText: 'Task name',
                        //  border: InputBorder.none,
                      )),
                ),
                SizedBox(height: deviceSize.height / 4 / 4 / 2),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                      left: deviceSize.width / 4 / 4 / 4,
                      right: deviceSize.width / 4 / 4 / 4),
                  child: TextFormField(
                      controller: _descController,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      validator: (value) =>
                          value!.isEmpty ? 'Pḷease enter desc' : null,
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w300),
                        hintText: 'Description',
                        //  border: InputBorder.none,
                      )),
                ),
                GestureDetector(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                        left: deviceSize.width / 4 / 4 / 4,
                        right: deviceSize.width / 4 / 4 / 4,
                        top: deviceSize.height / 4 / 4 / 2),
                    child: TextFormField(
                        controller: _dobController,
                        enabled: false,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        // validator: (value) =>
                        //     value!.isEmpty ? 'Pḷease enter date' : null,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w300),
                          hintText: 'Date',
                          //  border: InputBorder.none,
                        )),
                  ),
                  onTap: () async {
                    DateTime orderDate = await selectDate(
                        context, DateTime.now(),
                        lastDate: DateTime.now());
                    final df = new DateFormat('dd-MM-yyyy');
                    setState(() {
                      _dobController.text = df.format(orderDate);
                    });
                  },
                ),
                Container(
                    width: double.infinity,
                    height: deviceSize.height / 4 / 4,
                    margin: EdgeInsets.only(
                      top: deviceSize.height / 4 / 4 * .8,
                      left: deviceSize.width / 4 / 4 / 4,
                      right: deviceSize.width / 4 / 4 / 4,
                    ),
                    child: _isLoading == true
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : OutlinedButton(
                            onPressed: () async {
                              await _submit();
                              if (Provider.of<Auth>(context, listen: false)
                                      .isSucess ==
                                  true) {
                                Navigator.pop(context);
                              } else {
                                if (_formKey.currentState!.validate() &&
                                    _dobController.text.isNotEmpty) {
                                  toast(
                                      'somthing happened please try after sometime');
                                }
                              }
                            },
                            child: Text(
                             widget.isedit==true? 'Update task' :'Add Task',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: deviceSize.height / 4 / 4 / 3),
                            )),
                    decoration: BoxDecoration(
                        color: const Color(0xff2EB9EF),
                        borderRadius: BorderRadius.circular(5))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
