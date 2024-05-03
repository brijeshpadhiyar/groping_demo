import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groping_demo/helper/image_picker.dart';
import 'package:groping_demo/model/data_model.dart';
import 'package:groping_demo/repository/data_repo.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final DataModel employee;
  const ProfileScreen({super.key, required this.employee});

  @override
  ConsumerState<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends ConsumerState<ProfileScreen> {
  final TextEditingController _nameCont = TextEditingController();
  final TextEditingController _emailCont = TextEditingController();

  bool _isUpdate = false;
  File? _image;

  @override
  void initState() {
    _nameCont.text = widget.employee.name;
    _emailCont.text = widget.employee.email;
    super.initState();
  }

  @override
  void dispose() {
    _nameCont.dispose();
    _emailCont.dispose();
    super.dispose();
  }

  _tosterMessage() {
    Fluttertoast.showToast(
        msg: "Profile Updated",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    void homeNavigator() {
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Update profile"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  _image = await imagePicker();
                  if (_image != null) {
                    _isUpdate = true;
                  }
                  setState(() {});
                },
                child: _image != null
                    ? CircleAvatar(radius: 50, backgroundImage: FileImage(_image!))
                    : const CircleAvatar(
                        radius: 50,
                        backgroundImage: CachedNetworkImageProvider(
                            "https://images.unsplash.com/flagged/photo-1570612861542-284f4c12e75f?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                      ),
              ),
              const SizedBox(height: 20),
              Text(
                _nameCont.text,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Container(
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextFormField(
                  controller: _nameCont,
                  onChanged: (value) {
                    setState(() {
                      _isUpdate = true;
                    });
                  },
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextFormField(
                  controller: _emailCont,
                  onChanged: (value) {
                    setState(() {
                      _isUpdate = true;
                    });
                  },
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () {
                  if (_isUpdate) {
                    DataModel updateEmployee = DataModel(
                        id: widget.employee.id,
                        name: _nameCont.text,
                        email: _emailCont.text,
                        profilePic: _image != null ? _image!.path : "",
                        hireDt: widget.employee.hireDt);
                    ref.read(dataRepoProvider).updateEmployeeData(updateEmployee);
                    _tosterMessage();
                    homeNavigator();
                  } else {}
                },
                child: const Text("Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
