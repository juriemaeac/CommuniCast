// import 'package:flutter/material.dart';
// import 'package:ira/constants.dart';

// class AddReport extends StatefulWidget {
//   const AddReport({super.key});

//   @override
//   State<AddReport> createState() => _AddReportState();
// }

// class _AddReportState extends State<AddReport> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Add Report'),
//         ),
//         body: SafeArea(
//             child: Container(
//           padding: const EdgeInsets.all(30),
//           child: SingleChildScrollView(
//             scrollDirection: Axis.vertical,
//             child: Column(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     color: AppColors.greyAccent,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: TextFormField(
//                     //controller: usernameController,
//                     decoration: const InputDecoration(
//                       fillColor: AppColors.greyAccent,
//                       labelText: 'Enter Date',
//                       labelStyle: AppTextStyles.body,
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.transparent),
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(10.0),
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         borderSide:
//                             BorderSide(color: Colors.transparent, width: 2),
//                       ),
//                     ),
//                     validator: (String? value) {
//                       if (value == null || value.trim().isEmpty) {
//                         return "Required!";
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: AppColors.greyAccent,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: TextFormField(
//                     //controller: usernameController,
//                     decoration: const InputDecoration(
//                       fillColor: AppColors.greyAccent,
//                       labelText: 'Enter Type of Incident',
//                       labelStyle: AppTextStyles.body,
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.transparent),
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(10.0),
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         borderSide:
//                             BorderSide(color: Colors.transparent, width: 2),
//                       ),
//                     ),
//                     validator: (String? value) {
//                       if (value == null || value.trim().isEmpty) {
//                         return "Required!";
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: AppColors.greyAccent,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: TextFormField(
//                     //controller: usernameController,
//                     decoration: const InputDecoration(
//                       fillColor: AppColors.greyAccent,
//                       labelText: 'Enter Location',
//                       labelStyle: AppTextStyles.body,
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.transparent),
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(10.0),
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         borderSide:
//                             BorderSide(color: Colors.transparent, width: 2),
//                       ),
//                     ),
//                     validator: (String? value) {
//                       if (value == null || value.trim().isEmpty) {
//                         return "Required!";
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: AppColors.greyAccent,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: TextFormField(
//                     //controller: usernameController,
//                     decoration: const InputDecoration(
//                       fillColor: AppColors.greyAccent,
//                       labelText: 'Enter Description',
//                       labelStyle: AppTextStyles.body,
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.transparent),
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(10.0),
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         borderSide:
//                             BorderSide(color: Colors.transparent, width: 2),
//                       ),
//                     ),
//                     validator: (String? value) {
//                       if (value == null || value.trim().isEmpty) {
//                         return "Required!";
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: AppColors.greyAccent,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: TextFormField(
//                     //controller: usernameController,
//                     decoration: const InputDecoration(
//                       fillColor: AppColors.greyAccent,
//                       labelText: 'Upload images/videos',
//                       labelStyle: AppTextStyles.body,
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.transparent),
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(10.0),
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         borderSide:
//                             BorderSide(color: Colors.transparent, width: 2),
//                       ),
//                     ),
//                     validator: (String? value) {
//                       if (value == null || value.trim().isEmpty) {
//                         return "Required!";
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 40,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       style: ButtonStyle(
//                         padding: MaterialStateProperty.all(
//                             const EdgeInsets.symmetric(
//                                 vertical: 20.0, horizontal: 60.0)),
//                         // backgroundColor:
//                         //     MaterialStateProperty.all<Color>(Colors.blueAccent),
//                         shape:
//                             MaterialStateProperty.all<RoundedRectangleBorder>(
//                           RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                         ),
//                         shadowColor: MaterialStateProperty.all<Color>(
//                             Colors.transparent),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Done',
//                           ),
//                         ],
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       style: ButtonStyle(
//                         padding: MaterialStateProperty.all(
//                             const EdgeInsets.symmetric(
//                                 vertical: 20.0, horizontal: 60.0)),
//                         backgroundColor: MaterialStateProperty.all<Color>(
//                             AppColors.greyAccent),
//                         shape:
//                             MaterialStateProperty.all<RoundedRectangleBorder>(
//                           RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                         ),
//                         shadowColor: MaterialStateProperty.all<Color>(
//                             Colors.transparent),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Cancel',
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         )));
//   }
// }
