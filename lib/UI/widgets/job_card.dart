// import 'package:clg_project/constants.dart';
// import 'package:clg_project/models/candidate_models/find_job_response.dart';
// import 'package:clg_project/resourse/images.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// class JobCard extends StatelessWidget {
//   JobModel? jobModel;
//   JobCard({super.key, this.jobModel});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2.0,
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 18.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: Text(
//                     '${jobModel?.jobCategory}',
//                     style: const TextStyle(
//                       fontSize: 12.0,
//                       fontWeight: FontWeight.w500,
//                       color: kDefaultPurpleColor,
//                     ),
//                   ),
//                 ),
//                 RichText(
//                   text: TextSpan(
//                       style: const TextStyle(
//                           fontSize: 16.0, color: kDefaultPurpleColor),
//                       children: <TextSpan>[
//                         const TextSpan(
//                             text: '₹ ', style: TextStyle(fontSize: 12.0)),
//                         TextSpan(
//                           text: '${jobModel?.jobSalary}',
//                         ),
//                         const TextSpan(
//                             text: '/day', style: TextStyle(fontSize: 12.0)),
//                       ]),
//                 )
//               ],
//             ),
//             const SizedBox(
//               height: 10.0,
//             ),
//             Text(
//               "${jobModel?.jobTitle}",
//               style: const TextStyle(
//                   color: kDefaultBlackColor,
//                   fontSize: 16.0,
//                   fontWeight: FontWeight.w500),
//             ),
//             const SizedBox(
//               height: 10.0,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     SvgPicture.asset(
//                       Images.ic_location,
//                       fit: BoxFit.scaleDown,
//                     ), //
//                     const SizedBox(
//                       width: 8.0,
//                     ),
//                     Text(
//                       '${jobModel?.jobLocation}',
//                       style: const TextStyle(
//                         fontSize: 12.0,
//                         color: Color(0xff656565),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SvgPicture.asset(
//                   Images.ic_read_more,
//                   fit: BoxFit.scaleDown,
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 10.0,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     SvgPicture.asset(
//                       Images.ic_clock,
//                       fit: BoxFit.scaleDown,
//                     ),
//                     const SizedBox(
//                       width: 8.0,
//                     ),
//                     Text(
//                       '${jobModel?.jobStartTime} - ${jobModel?.jobEndTime}',
//                       style: const TextStyle(
//                         fontSize: 12.0,
//                         color: Color(0xff656565),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
