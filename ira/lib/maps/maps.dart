import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ira/maps/addReport.dart';
import 'package:ira/maps/indicators.dart';
import 'package:latlong2/latlong.dart';
import "package:http/http.dart" as http;
import "dart:convert" as convert;

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final String apiKey = "nNpeA6MVcnH0q5w6LfXTP2uNR58WIcKI";
  @override
  Widget build(BuildContext context) {
    final locationPoint = new LatLng(52.376372, 4.908066);
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Flutter Map'),
        // ),
        body: Center(
      child: Container(
        child: Stack(
          children: [
            FlutterMap(
                options: new MapOptions(center: locationPoint, zoom: 13.0),
                // options: MapOptions(
                //   center: LatLng(51.5, -0.09),
                //   zoom: 13.0,
                // ),
                children: [
                  TileLayer(
                    urlTemplate: "https://api.tomtom.com/map/1/tile/basic/main/"
                        "{z}/{x}/{y}.png?key={apiKey}",
                    additionalOptions: {"apiKey": apiKey},
                  ),
                  MarkerLayer(markers: [
                    Marker(
                        point: locationPoint, //LatLng(51.5, -0.09),
                        builder: (context) => Icon(Icons.location_on,
                            color: Colors.red, size: 40.0))
                  ])
                ]),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
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
    ));
  }

  //widget for button
  Widget AddReportBtn() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AddReport();
        }));
        // _showModal();
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

  //show container for whole screen
  void _showModal() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.black.withOpacity(0.3),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      'Add Report',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      'Please select the type of report',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              Text(
                                'Add',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              Text(
                                'Add',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
