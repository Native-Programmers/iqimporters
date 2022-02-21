import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:qbazar/services/auth_service.dart';
import 'package:qbazar/widgets/custom_appbar.dart';
import 'package:qbazar/widgets/section_title.dart';
import 'package:url_launcher/url_launcher.dart';

TextEditingController name = TextEditingController();
TextEditingController emailaddress = TextEditingController();
TextEditingController mobile = TextEditingController();
TextEditingController city = TextEditingController();
TextEditingController address = TextEditingController();
TextEditingController zip = TextEditingController();
TextEditingController image = TextEditingController();
String _image = '';

var userId = FirebaseAuth.instance.currentUser?.uid;

const String _url = 'https://wa.me/923214527673';

class UnregisteredUser extends StatefulWidget {
  const UnregisteredUser({Key? key}) : super(key: key);

  @override
  _UnregisteredUserState createState() => _UnregisteredUserState();
}

class _UnregisteredUserState extends State<UnregisteredUser> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final authService = Provider.of<AuthService>(context);
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: const CustomAppBar(title: 'User Profile'),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            ExpansionTile(
              title: const Text("User Data"),
              initiallyExpanded: true,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        child: IconButton(
                          icon: const Icon(Icons.person),
                          onPressed: () {
                            if (kIsWeb) {
                              uploadToStorage();
                            }
                            // showModalBottomSheet(
                            //     context: context,
                            //     builder: (context) {
                            //       return Wrap(
                            //         children: [
                            //           InkWell(
                            //             onTap: () {
                            //               captureImage();
                            //             },
                            //             child: const ListTile(
                            //               leading:
                            //                   FaIcon(FontAwesomeIcons.camera),
                            //               title: Text('Camera'),
                            //             ),
                            //           ),
                            //           InkWell(
                            //             onTap: () {
                            //               getImage();
                            //             },
                            //             child: const ListTile(
                            //               leading: FaIcon(FontAwesomeIcons.image),
                            //               title: Text('Gallery'),
                            //             ),
                            //           ),
                            //           InkWell(
                            //             onTap: () {
                            //               Navigator.pop(context);
                            //             },
                            //             child: const ListTile(
                            //               leading: FaIcon(
                            //                   FontAwesomeIcons.windowClose),
                            //               title: Text('Close'),
                            //             ),
                            //           ),
                            //         ],
                            //       );
                            //     });
                          },
                        ),
                        maxRadius: (kIsWeb
                            ? MediaQuery.of(context).size.width / 30
                            : MediaQuery.of(context).size.width / 8),
                      ),
                      const SectionTitle(title: "Add Information"),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Divider(
                              height: 20,
                              color: Colors.transparent,
                            ),
                            //full name
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                focusColor: Colors.lightBlueAccent,
                                hintText: "Full Name",
                                label: Text("Name"),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.black,
                                )),
                              ),
                              controller: name,
                            ),
                            const Divider(
                              height: 20,
                              color: Colors.transparent,
                            ),
                            //email
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              enabled: false,
                              enableInteractiveSelection:
                                  false, // will disable paste operation
                              // focusNode: AlwaysDisabledFocusNode(),
                              decoration: const InputDecoration(
                                focusColor: Colors.lightBlueAccent,
                                hintText: "Enter Email",
                                label: Text("Email"),
                                enabled: false,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.black,
                                )),
                              ),
                              initialValue:
                                  FirebaseAuth.instance.currentUser!.email,
                            ),
                            const Divider(
                              height: 20,
                              color: Colors.transparent,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                controller: mobile,
                                maxLength: 10,
                                decoration: InputDecoration(
                                  prefixIcon: Container(
                                    padding: const EdgeInsets.only(left: 15),
                                    height: 75,
                                    width: 100,
                                    child: Row(
                                      children: [
                                        const Text("+92"),
                                        SizedBox(
                                          width: 35,
                                          height: 35,
                                          child: Image.asset(
                                              'icons/flags/png/pk.png',
                                              package: 'country_icons'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  focusColor: Colors.lightBlueAccent,
                                  hintText: "Phone Number",
                                  label: const Text("Phone Number"),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Colors.black,
                                  )),
                                ),
                              ),
                            ),
                            const Divider(
                              height: 20,
                              color: Colors.transparent,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                focusColor: Colors.lightBlueAccent,
                                hintText: "City",
                                label: Text("City"),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.black,
                                )),
                              ),
                              controller: city,
                            ),
                            const Divider(
                              height: 20,
                              color: Colors.transparent,
                            ),
                            //address
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                focusColor: Colors.lightBlueAccent,
                                hintText: "Delivery Address",
                                label: Text("Address"),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.black,
                                )),
                              ),
                              controller: address,
                            ),
                            const Divider(
                              height: 20,
                              color: Colors.transparent,
                            ),
                            //zip code
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                focusColor: Colors.lightBlueAccent,
                                hintText: "Zip Code",
                                label: Text("City Zip"),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.black,
                                )),
                              ),
                              controller: zip,
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 15,
                        color: Colors.transparent,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                              ),
                              onPressed: () {
                                EasyLoading.show();
                                FirebaseFirestore.instance
                                    .collection("userinfo")
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .set({
                                  'name': name.text,
                                  'pic': image.text,
                                  'email': emailaddress.text,
                                  'mobile': mobile.text,
                                  'city': city.text,
                                  'address': address.text,
                                  'zip': zip.text,
                                }).then((value) => EasyLoading.showSuccess(
                                            "Information Added Successfully")
                                        .onError((error, stackTrace) =>
                                            EasyLoading.showError(
                                                "Unable to add information.")));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('SAVE INFORMATION'),
                                  VerticalDivider(
                                    width: 5,
                                  ),
                                  Icon(Icons.save),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 10,
                        color: Colors.transparent,
                      )
                    ],
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('History'),
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 400,
                  child: FirestoreListView(
                      query: FirebaseFirestore.instance.collection('checkout'),
                      itemBuilder: (context, snapshot) {
                        return ExpansionTile(
                          title: Text('Bill ${snapshot['total']}'),
                          children: [],
                        );
                      }),
                )
              ],
            ),
            ExpansionTile(
              title: const Text('About Us'),
              children: [
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.info),
                  title: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const Text(
                        "Qismat Bazar is an E-commerce app. Where the amount you spend is based on your luck.",
                        style: TextStyle(fontSize: 10),
                      )),
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Contact Us'),
              children: [
                InkWell(
                  onTap: () {
                    (kIsWeb ? _launchInBrowser(_url) : whatsAppOpen());
                  },
                  child: const ListTile(
                    leading: FaIcon(FontAwesomeIcons.whatsapp),
                    title: SizedBox(
                      child: Text("Click to contact"),
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () async {
                    authService.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('LOGOUT'),
                      VerticalDivider(
                        width: 5,
                      ),
                      Icon(Icons.logout),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                ),
              ),
            ),
            const Divider(
              color: Colors.transparent,
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  void uploadImage({required Function(File file) onSelected}) {
    final uploadInput = FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      final file = uploadInput.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        EasyLoading.dismiss();
        onSelected(file);
      });
    });
  }

  //to return the download url of uploaded image
  Future<String> downloadUrl(String name) async {
    return FirebaseStorage.instance
        .refFromURL('gs://qbazar-19c41.appspot.com/user_data')
        .child(name)
        .getDownloadURL();
    //store download url in firestore document
  }

  void uploadToStorage() {
    final date = DateTime.now();
    final path = date.toString();
    EasyLoading.show();
    Future.delayed(const Duration(milliseconds: 500), () {
      EasyLoading.dismiss();
    });
    uploadImage(onSelected: (file) {
      FirebaseStorage.instance
          .refFromURL('gs://qbazar-19c41.appspot.com/user_data')
          .child(path)
          .putBlob(file)
          .then((p0) {
        EasyLoading.dismiss();

        return downloadUrl(path).then((value) {
          EasyLoading.showSuccess('Image Uploaded');
          setState(() {
            image.text = value;
            print(value);
          });
        });
      }).onError((error, stackTrace) {
        EasyLoading.showError('Something went wrong');
        return Future.delayed(const Duration(milliseconds: 500), () {});
      });
    });
  }

  void whatsAppOpen() async {
    await FlutterLaunch.launchWhatsapp(
        phone: "+923124586164",
        message: "I've contacted you regarding Qismat Bazaar.");
  }

  Future<void> _launchInBrowser(String url) async {
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
  }
}
