import 'package:flutter/material.dart';
import 'package:wesafe/constants.dart';

class IndicatorWidget extends StatelessWidget {
  String? colorCode;
  String? text;
  Color? color;
  IconData? icon;

  IndicatorWidget(
      {super.key, this.colorCode, this.text, this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              contentPadding: EdgeInsets.all(30.0),
              //title:
              content: Container(
                height: 230,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          colorCode!,
                          style: AppTextStyles.title.copyWith(
                            color: color,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SizedBox(
                            child: Text(
                              text!,
                              style: AppTextStyles.body,
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pop(false); //Will not exit the App
                        },
                        child: Text(
                          'OK',
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
              // actions: <Widget>[
              //   // ignore: deprecated_member_use
              //   TextButton(
              //     child: Text(
              //       'OK',
              //       style: TextStyle(
              //           fontSize: 15,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.blueGrey),
              //     ),
              //     onPressed: () {
              //       Navigator.of(context).pop(false); //Will not exit the App
              //     },
              //   ),
              // ],
            );
          },
        );
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: AppColors.white,
        ),
      ),
    );
  }
}

class Indicator extends StatefulWidget {
  const Indicator({super.key});

  @override
  State<Indicator> createState() => _IndicatorState();
}

class _IndicatorState extends State<Indicator> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IndicatorWidget(
            colorCode: 'Code RED',
            text: 'This is a code red alert. This means that there is a '
                'dangerous situation in your area. Please stay indoors and '
                'avoid going out. If you are outside, please return home '
                'immediately. If you are in a car, please drive to the nearest '
                'safe location. If you are in a building, please stay indoors '
                'and avoid going out. ',
            color: Colors.red,
            icon: Icons.info_outline,
          ),
          IndicatorWidget(
            colorCode: 'Code YELLOW',
            text: 'This is a code yellow alert. This means that there is a '
                'dangerous situation in your area. Please stay indoors and '
                'avoid going out. If you are outside, please return home '
                'immediately. If you are in a car, please drive to the nearest '
                'safe location. If you are in a building, please stay indoors '
                'and avoid going out. ',
            color: Colors.amber,
            icon: Icons.warning_amber_rounded,
          ),
          IndicatorWidget(
            colorCode: 'Code BLUE',
            text: 'This is a code blue alert. This means that there is a '
                'dangerous situation in your area. Please stay indoors and '
                'avoid going out. If you are outside, please return home '
                'immediately. If you are in a car, please drive to the nearest '
                'safe location. If you are in a building, please stay indoors '
                'and avoid going out. ',
            color: Colors.blue,
            icon: Icons.wifi_tethering_error_rounded_rounded,
          ),
          IndicatorWidget(
            colorCode: 'Code GREEN',
            text: 'This is a code green alert. This means that there is a '
                'dangerous situation in your area. Please stay indoors and '
                'avoid going out. If you are outside, please return home '
                'immediately. If you are in a car, please drive to the nearest '
                'safe location. If you are in a building, please stay indoors '
                'and avoid going out. ',
            color: Colors.green,
            icon: Icons.remove_red_eye_outlined,
          ),
          IndicatorWidget(
            colorCode: 'Code BLACK',
            text: 'This is a code black alert. This means that there is a '
                'dangerous situation in your area. Please stay indoors and '
                'avoid going out. If you are outside, please return home '
                'immediately. If you are in a car, please drive to the nearest '
                'safe location. If you are in a building, please stay indoors '
                'and avoid going out. ',
            color: Colors.black,
            icon: Icons.shield_outlined,
          )
        ],
      ),
    );
  }
}
