import 'package:flutter/material.dart';
import 'package:wesafe/codes.dart';
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
              contentPadding:
                  const EdgeInsets.only(top: 30.0, right: 30, left: 30),
              //title:
              content: Container(
                height: MediaQuery.of(context).size.height * 0.35,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
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
                          Text(
                            text!,
                            style: AppTextStyles.body,
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                      // Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      //   GestureDetector(
                      //     onTap: () {
                      //       Navigator.of(context)
                      //           .pop(false); //Will not exit the App
                      //     },
                      //     child: Text(
                      //       'OK',
                      //       style: AppTextStyles.body.copyWith(
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //   ),
                      // ]),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                // ignore: deprecated_member_use
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(false); //Will not exit the App
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 30.0,
                      bottom: 20,
                    ),
                    child: Text(
                      'OK',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
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
            colorCode: codeRed,
            text: codeRedDesc,
            color: Colors.red,
            icon: Icons.info_outline,
          ),
          IndicatorWidget(
            colorCode: codeYellow,
            text: codeYellowDesc,
            color: Colors.amber,
            icon: Icons.warning_amber_rounded,
          ),
          IndicatorWidget(
            colorCode: codeBlue,
            text: codeBlueDesc,
            color: Colors.blue,
            icon: Icons.wifi_tethering_error_rounded_rounded,
          ),
          IndicatorWidget(
            colorCode: codeGreen,
            text: codeGreenDesc,
            color: Colors.green,
            icon: Icons.remove_red_eye_outlined,
          ),
          IndicatorWidget(
            colorCode: codeBlack,
            text: codeBlackDesc,
            color: Colors.black,
            icon: Icons.shield_outlined,
          )
        ],
      ),
    );
  }
}
