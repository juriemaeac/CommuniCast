import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:wesafe/constants.dart';
import 'package:wesafe/providers/user_provider.dart';
import 'package:wesafe/resources/firestore_methods.dart';
import 'package:wesafe/utils/colors.dart';
import 'package:wesafe/utils/utils.dart';
import 'package:wesafe/widgets/indicators.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import "package:http/http.dart" as http;
import "dart:convert" as convert;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;
import 'package:wesafe/models/post.dart' as model;

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _indicatorController = TextEditingController();
  // String? title = 'test title';
  // String? description;
  String? locationAddress;
  //String? indicator = 'CODE BLUE';
  String? _selectedIndicator;
  String countrySet = 'PH';
  late double lat = 0;
  late double long = 0;
  late LatLng currentCenter = LatLng(lat, long);
  MapController mapController = MapController();
  final String apiKey = "nNpeA6MVcnH0q5w6LfXTP2uNR58WIcKI";
  DateTime timestamp = DateTime.now();

  final List<Marker> markers = List.empty(growable: true);
  List<String> _indicators = [
    'CODE RED',
    'CODE AMBER',
    'CODE BLUE',
    'CODE GREEN',
    'CODE BLACK',
  ];

  double currentZoom = 16.0;

  void _zoom() {
    currentZoom = currentZoom + 1.0;
    print('Zoom: $currentZoom');
    mapController.move(currentCenter, currentZoom);
  }

  void _unzoom() {
    currentZoom = currentZoom - 1.0;
    print('Zoom: $currentZoom');
    mapController.move(currentCenter, currentZoom);
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        _titleController.text,
        _descriptionController.text,
        _file!,
        uid,
        username,
        profImage,
        _locationController.text,
        lat,
        long,
        _selectedIndicator!,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Posted!',
        );
        clearImage();
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String completeAddress =
        '${placemark.street}, ${placemark.locality}, ${placemark.country}, ${placemark.postalCode}';
    print('LATITUDE: ${position.latitude}, LONGITUDE: ${position.longitude}');
    print('completeAddress: $completeAddress');
    _locationController.text = completeAddress;
    setState(() {
      locationAddress = completeAddress;
      lat = position.latitude;
      long = position.longitude;
      currentCenter = LatLng(lat, long);
      print('LOCATIONADDRESS: $locationAddress || LAT: $lat || LONG: $long');
    });
  }

  SuperTooltip? tooltip;

  getMarkers() async {
    print("\n\n==============\n");
    print("FETCHING DATA!!!!!!!!!!");
    await FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        Map data = (result.data() as Map);
        print("\n\n==============\n");
        var docLat = data['latitude'];
        var docLon = data['longitude'];
        var docTitle = data['title'];
        var docIndicator = data['indicator'];
        print("\n==============\n");
        print("Fetched Data: ");
        print(docTitle);
        print(docIndicator);
        print(docLat);
        print(docLon);
        print("\n==============\n");
        String title = docTitle.toString();
        String indicator = docIndicator.toString();
        var icon = 61242;
        Color color = Colors.white;
        bool dark = false;
        if (indicator == 'CODE RED') {
          icon = 57912;
          color = Colors.red;
        } else if (indicator == 'CODE AMBER') {
          icon = 983712;
          color = Colors.amber;
        } else if (indicator == 'CODE BLUE') {
          icon = 983744;
          color = Colors.blue;
        } else if (indicator == 'CODE GREEN') {
          icon = 983699;
          color = Colors.green;
        } else if (indicator == 'CODE BLACK') {
          icon = 62784;
          color = Colors.black;
          dark = true;
        }
        Future<bool> _willPopCallback() async {
          // If the tooltip is open we don't pop the page on a backbutton press
          // but close the ToolTip
          if (tooltip!.isOpen) {
            tooltip!.close();
            return false;
          }
          return true;
        }

        void onTap() {
          if (tooltip != null && tooltip!.isOpen) {
            tooltip!.close();
            return;
          }

          var renderBox = context.findRenderObject() as RenderBox;
          final overlay =
              Overlay.of(context)!.context.findRenderObject() as RenderBox?;

          var targetGlobalCenter = renderBox.localToGlobal(
              renderBox.size.center(Offset.zero),
              ancestor: overlay);

          // We create the tooltip on the first use
          tooltip = SuperTooltip(
            popupDirection: TooltipDirection.up,
            closeButtonColor: Colors.white,
            closeButtonSize: 15,
            showCloseButton: ShowCloseButton.inside,
            borderWidth: 0,
            backgroundColor: color,
            shadowColor: Colors.transparent,
            borderColor: color,
            arrowLength: 0,
            content: Material(
              child: Container(
                width: 200,
                height: 30,
                decoration: BoxDecoration(
                  color: color,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(IconData(icon, fontFamily: 'MaterialIcons'),
                        size: 30.0, color: Colors.white),
                    SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$title',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        Text('Type: $indicator',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );

          tooltip!.show(context);
        }

        var marker = Marker(
          width: 160.0,
          height: 55.0,
          point: LatLng(docLat, docLon),
          builder: (BuildContext context) => Column(
            children: [
              WillPopScope(
                onWillPop: _willPopCallback,
                child: GestureDetector(
                  onTap: onTap,
                  child: Icon(
                    Icons.location_history_rounded,
                    color: color,
                    size: 40,
                  ),
                  // Container(
                  //     width: 50.0,
                  //     height: 50.0,
                  //     decoration: new BoxDecoration(
                  //       shape: BoxShape.circle,
                  //       color: color,
                  //     )),
                ),
              )
            ],
          ),
        );
        markers.add(marker);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    getMarkers();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _descriptionController.dispose();
  //   _titleController.dispose();
  //   _locationController.dispose();
  //   _indicatorController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    //get posts from firestore
    FirebaseFirestore.instance.collection('posts').snapshots();

    //set initial marker latitude and longitude
    //working
    final initialMarker = Marker(
      width: 100.0,
      height: 55.0,
      point: LatLng(lat, long),
      builder: (BuildContext context) => Container(
        width: 100,
        child: Column(
          children: const [
            Icon(Icons.location_on, size: 40.0, color: Colors.red),
            Text('Current Location',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
    markers.add(initialMarker);

    return lat == 0 || long == 0
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : _file == null
            ? Scaffold(
                // appBar: AppBar(
                //   title: const Text('Flutter Map'),
                // ),
                body: Center(
                  child: Container(
                    child: Stack(
                      children: [
                        FlutterMap(
                            mapController: mapController,
                            options: MapOptions(
                                center: currentCenter, zoom: currentZoom),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    "https://api.tomtom.com/map/1/tile/basic/main/"
                                    "{z}/{x}/{y}.png?key={apiKey}",
                                additionalOptions: {"apiKey": apiKey},
                              ),
                              MarkerLayer(markers: markers)
                            ]),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 40),
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.menu),
                                  color: Colors.white,
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.search),
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            padding: const EdgeInsets.all(5),
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AddReportBtn(),
                                const Indicator(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            //after taking a pic
            : Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    onPressed: clearImage,
                  ),
                  title: const Text(
                    'Post to',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  centerTitle: false,
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        postImage(
                          userProvider.getUser.uid,
                          userProvider.getUser.username,
                          userProvider.getUser.photoUrl,
                        );
                      },
                      child: const Text(
                        "Post",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    )
                  ],
                ),
                // POST FORM
                body: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      isLoading
                          ? const LinearProgressIndicator()
                          : const Padding(padding: EdgeInsets.only(top: 0.0)),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: double.infinity,
                        child: AspectRatio(
                          aspectRatio: 487 / 451,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              fit: BoxFit.cover,
                              alignment: FractionalOffset.topCenter,
                              image: MemoryImage(_file!),
                            )),
                          ),
                        ),
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            userProvider.getUser.photoUrl,
                          ),
                        ),
                        title: Container(
                          width: MediaQuery.of(context).size.width - 100,
                          child: TextField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(15)
                            ],
                            controller: _titleController,
                            style: AppTextStyles.body,
                            decoration: const InputDecoration(
                                hintText: "Report Title",
                                hintStyle: AppTextStyles.body,
                                border: InputBorder.none),
                            //maxLines: 2,
                          ),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.description,
                          color: Colors.grey,
                          size: 20,
                        ),
                        title: Container(
                          width: MediaQuery.of(context).size.width - 100,
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            controller: _descriptionController,
                            style: AppTextStyles.body,
                            decoration: const InputDecoration(
                                hintText: "Write a caption...",
                                hintStyle: AppTextStyles.body,
                                border: InputBorder.none),
                            //maxLines: 8,
                          ),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.drag_indicator,
                          color: Colors.grey,
                          size: 20,
                        ),
                        title: Container(
                          width: MediaQuery.of(context).size.width - 100,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              hint: Text(
                                'Select Report Indicator',
                                style: AppTextStyles.body,
                              ),
                              items: _indicators
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item,
                                            style: AppTextStyles.body),
                                      ))
                                  .toList(),
                              value: _selectedIndicator,
                              onChanged: (value) {
                                setState(() {
                                  _selectedIndicator = value as String;
                                });
                              },
                              buttonHeight: 40,
                              buttonWidth: 340,
                              itemHeight: 40,
                            ),
                          ),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.location_on,
                          size: 20,
                          color: Colors.grey,
                        ),
                        title: Container(
                          width: MediaQuery.of(context).size.width - 100,
                          child: TextField(
                            enabled: false,
                            controller: _locationController,
                            style: AppTextStyles.body,
                            decoration: const InputDecoration(
                              hintText: "Where was the photo taken?...",
                              hintStyle: AppTextStyles.body,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              );
  }

  //widget for button
  AddReportBtn() {
    return ElevatedButton(
      onPressed: () {
        _selectImage(context);
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0)),
        // backgroundColor:
        //     MaterialStateProperty.all<Color>(Colors.blueAccent),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Add Report',
          ),
        ],
      ),
    );
  }
}
