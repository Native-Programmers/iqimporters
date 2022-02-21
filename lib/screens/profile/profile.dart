import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qbazar/screens/orders/order_history.dart';
import 'package:qbazar/services/auth_service.dart';
import 'package:qbazar/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

TextEditingController name = TextEditingController();
TextEditingController emailaddress = TextEditingController();
TextEditingController mobile = TextEditingController();
TextEditingController city = TextEditingController();
TextEditingController address = TextEditingController();
TextEditingController zip = TextEditingController();
String _image = '';

var userId = FirebaseAuth.instance.currentUser?.uid;
const String _url = 'https://wa.me/923214527673';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const ProfileScreen());
  }

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  //for mobile image picker
  Future<void> getImage() async {
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final path = image.path;
    }
    uploadToStorage();
  }

  //for mobile camera
  Future<void> captureImage() async {
    // Capture a photo
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    uploadToStorage();
  }

  //to upload image to firebase storage using web
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
            _image = value;
            FirebaseFirestore.instance
                .collection("userinfo")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({
              "pic": _image,
            });
          });
        });
      }).onError((error, stackTrace) {
        EasyLoading.showError('Something went wrong');
        return Future.delayed(const Duration(milliseconds: 500), () {});
      });
    });
  }
//un-comment while building web application

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final authService = Provider.of<AuthService>(context);

    CollectionReference users =
        FirebaseFirestore.instance.collection('userinfo');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(FirebaseAuth.instance.currentUser?.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Container(
              color: Colors.white, child: const Text("Something went wrong"));
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          //When user is not registered
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
                        padding: const EdgeInsets.symmetric(horizontal: 100.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                if (kIsWeb) {
                                  uploadToStorage();
                                }
                              },
                              child: (_image.isEmpty
                                  ? CircleAvatar(
                                      child: const Icon(Icons.person),
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

                                      maxRadius: (kIsWeb
                                          ? MediaQuery.of(context).size.width /
                                              30
                                          : MediaQuery.of(context).size.width /
                                              8),
                                    )
                                  : SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(1000),
                                        child: Image.network(_image),
                                      ),
                                    )),
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
                                        ),
                                      ),
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
                                    initialValue: FirebaseAuth
                                        .instance.currentUser!.email,
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
                                          padding:
                                              const EdgeInsets.only(left: 15),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                    ),
                                    onPressed: () {
                                      EasyLoading.show();
                                      FirebaseFirestore.instance
                                          .collection("userinfo")
                                          .doc(FirebaseAuth
                                              .instance.currentUser?.uid)
                                          .set({
                                        'name': name.text,
                                        'pic': _image,
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
                  InkWell(
                    onTap: () {
                      Get.toNamed('/order-history');
                    },
                    child: const ListTile(
                      leading: Icon(Icons.history),
                      title: Text('ORDER HISTORY'),
                    ),
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

        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data!.exists) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          try {
            name.text = (data['name'] ?? "Please add username");
            emailaddress.text =
                (data['email'] ?? FirebaseAuth.instance.currentUser?.email);
            mobile.text = (data['mobile'] ?? "Add Mobile");
            city.text = (data['city'] ?? "Add City");
            address.text = (data['address'] ?? "Add Address");
            zip.text = (data['zip'] ?? "Add Zip Code");
            _image = (data['pic']);
          } catch (e) {
            print("Error" + e.toString());
          }
          //This will be displayed if the user is already has entered their data.

          return Scaffold(
            appBar: const CustomAppBar(title: 'User Profile'),
            body: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ListView(
                  children: [
                    ExpansionTile(
                      initiallyExpanded: true,
                      title: const Text("User Data"),
                      children: [
                        Padding(
                          padding: (kIsWeb && (width > height)
                              ? const EdgeInsets.symmetric(horizontal: 100.0)
                              : const EdgeInsets.all(0)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              (_image.isEmpty
                                  ? CircleAvatar(
                                      maxRadius: (kIsWeb
                                          ? MediaQuery.of(context).size.width /
                                              30
                                          : MediaQuery.of(context).size.width /
                                              8),
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
                                      ))
                                  : InkWell(
                                      onTap: () {
                                        if (kIsWeb) {
                                          uploadToStorage();
                                        }
                                      },
                                      child: Container(
                                          width: 190.0,
                                          height: 190.0,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(_image),
                                              ))),
                                    )),
                              const SectionTitle(title: "User Information"),
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
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                          color: Colors.black,
                                        )),
                                      ),
                                      initialValue: FirebaseAuth
                                          .instance.currentUser!.email,
                                    ),
                                    const Divider(
                                      height: 20,
                                      color: Colors.transparent,
                                    ),
                                    //mobile
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
                                            padding:
                                                const EdgeInsets.only(left: 15),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.green,
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          EasyLoading.show();
                                          FirebaseFirestore.instance
                                              .collection("userinfo")
                                              .doc(FirebaseAuth
                                                  .instance.currentUser?.uid)
                                              .update({
                                                'name': name.text,
                                                'mobile': mobile.text,
                                                'city': city.text,
                                                'address': address.text,
                                                'zip': zip.text,
                                                'pic': _image,
                                              })
                                              .then((value) =>
                                                  EasyLoading.showSuccess(
                                                      'Data Updated'))
                                              .onError((error, stackTrace) =>
                                                  EasyLoading.showError(
                                                      'Unable to upload data'));
                                        } else {
                                          EasyLoading.showInfo(
                                              'Please fill all fields');
                                        }
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
                                height: 15,
                                color: Colors.transparent,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed('/order-history');
                      },
                      child: const ListTile(
                        leading: Icon(Icons.history),
                        title: Text('ORDER HISTORY'),
                      ),
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
            ),
          );
        }

        return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
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
