import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
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

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController indicatorController = TextEditingController();
  String? locationAddress;
  String countrySet = 'PH';
  String? indicator = 'CODE BLUE';
  String? title;
  double lat = 14;
  double long = 130;

  final String apiKey = "nNpeA6MVcnH0q5w6LfXTP2uNR58WIcKI";
  DateTime timestamp = DateTime.now();

  final List<Marker> markers = List.empty(growable: true);

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
        _descriptionController.text,
        _file!,
        uid,
        username,
        profImage,
        locationController.text,
        lat,
        long,
        indicatorController.text,
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
    String
        completeAddress = //ctrl + click mo dun sa word na placemark lalabas ung mga areas na pwede mo iaccess, ung <placemark>
        '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.country}, ${placemark.postalCode}';
    print('LATITUDE: ${position.latitude}, LONGITUDE: ${position.longitude}');
    print('completeAddress: $completeAddress');
    locationController.text = completeAddress;
    setState(() {
      locationAddress = completeAddress;
      lat = position.latitude;
      long = position.longitude;
      print('LOCATIONADDRESS: $locationAddress || LAT: $lat || LONG: $long');
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final locationPoint = LatLng(14.5995, 120.9842);

    // setMarker(value, lat, long, countrySet, title, indicator) async {
    //   final Map<String, String> queryParameters = {'key': '$apiKey'};
    //   queryParameters['lat'] = lat;
    //   queryParameters['lon'] = long;
    //   queryParameters['countrySet'] = countrySet;
    //   var response = await http.get(Uri.https(
    //       'api.tomtom.com', '/search/2/search/$value.json', queryParameters));

    //   var icon = 61242; //IconData(61242, fontFamily: 'MaterialIcons')
    //   Color color = Colors.white;

    //   print('============');
    //   print('$value, $lat, $long, $countrySet, $title, $indicator');
    //   if (indicator == 'CODE RED') {
    //     icon = 57912;
    //     color = Colors.red;
    //   } else if (indicator == 'CODE AMBER') {
    //     icon = 983712;
    //     color = Colors.amber;
    //   } else if (indicator == 'CODE BLUE') {
    //     icon = 983744;
    //     color = Colors.red;
    //   } else if (indicator == 'CODE GREEN') {
    //     icon = 983699;
    //     color = Colors.green;
    //   } else if (indicator == 'CODE BLACK') {
    //     icon = 62784;
    //     color = Colors.black;
    //   }

    //   var jsonData = convert.jsonDecode(response.body);
    //   print('$jsonData');
    //   var results = jsonData['results'];
    //   for (var element in results) {
    //     var position = element['position'];
    //     var distance = element['dist'];
    //     var intDistance = (distance.round() / 1000).toInt();
    //     print('$distance');
    //     var marker = new Marker(
    //       width: 230,
    //       height: 80,
    //       point: new LatLng(position['lat'], position['lon']),
    //       builder: (BuildContext context) => Container(
    //         padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
    //         width: 230,
    //         height: 80,
    //         decoration: BoxDecoration(
    //             color: color,
    //             borderRadius: BorderRadius.all(Radius.circular(20.0)),
    //             boxShadow: [
    //               BoxShadow(
    //                 color: Colors.black26,
    //                 blurRadius: 20.0,
    //                 spreadRadius: 10.0,
    //               ),
    //             ]),
    //         child: Row(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //             Icon(IconData(icon, fontFamily: 'MaterialIcons'),
    //                 size: 35.0, color: Colors.white),
    //             SizedBox(width: 10),
    //             Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Text('$title',
    //                     style: TextStyle(
    //                         color: Colors.white,
    //                         fontSize: 18,
    //                         fontWeight: FontWeight.bold)),
    //                 Text('Type: $indicator',
    //                     style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 15,
    //                     )),
    //                 Text('Distance: $intDistance km',
    //                     style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 15,
    //                     )),
    //               ],
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //     markers.add(marker);
    //   }
    // }

    return _file == null
        ? Scaffold(
            // appBar: AppBar(
            //   title: const Text('Flutter Map'),
            // ),
            body: Center(
              child: Container(
                child: Stack(
                  children: [
                    FlutterMap(
                        options:
                            new MapOptions(center: locationPoint, zoom: 13.0),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://api.tomtom.com/map/1/tile/basic/main/"
                                "{z}/{x}/{y}.png?key={apiKey}",
                            additionalOptions: {"apiKey": apiKey},
                          ),
                          MarkerLayer(markers: markers
                              // [
                              //   Marker(
                              //       point: locationPoint, //LatLng(51.5, -0.09),
                              //       builder: (context) => Icon(Icons.location_on,
                              //           color: Colors.red, size: 40.0))
                              // ]
                              )
                        ]),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 40),
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
                              icon: Icon(Icons.menu),
                              color: Colors.white,
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.search),
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.all(20),
                        padding: EdgeInsets.all(5),
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
                            Indicator(),
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
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text(
                'Post to',
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
                    // setMarker(locationAddress, lat, long, countrySet, title,
                    //     indicator);
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
            body: Column(
              children: <Widget>[
                isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0.0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        userProvider.getUser.photoUrl,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            hintText: "Write a caption...",
                            border: InputBorder.none),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45.0,
                      width: 45.0,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                            image: MemoryImage(_file!),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://icons.veryicon.com/png/o/internet--web/55-common-web-icons/person-4.png"),
                    //CachedNetworkImageProvider(widget.currentUser.photoUrl),
                  ),
                  title: Container(
                    width: 250,
                    child: TextField(
                      controller: locationController,
                      decoration: InputDecoration(
                        hintText: "Where was the photo taken?...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 200.0,
                  height: 100.0,
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    child: Text('Use current location'),
                    onPressed: () {
                      _getCurrentLocation();
                    },
                  ),
                ),
              ],
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
          Text(
            'Add Report',
          ),
        ],
      ),
    );
  }
}
