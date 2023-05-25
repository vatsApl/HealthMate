// -----------------------------------------------------------------
// fix size of dialog button: job application
// height: Dimens.pixel_38,
// width: Dimens.pixel_120,

// applied job dialog:
// height: Dimens.pixel_44,
// width: Dimens.pixel_160,

// logout dialog
// width: Dimens.pixel_110, //cancel button
// height: Dimens.pixel_44,

// mark as paid dialog
// height: Dimens.pixel_38,
// width: Dimens.pixel_120,

// Future<void> parkingDialog() async {
//   return showDialog<void>(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return Dialog(
//         shape:
//         RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
//         child: Padding(
//           padding:
//           const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
//           child: Wrap(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Choose availability',
//                     style: TextStyle(fontSize: 18.0),
//                   ),
//                   const SizedBox(
//                     height: 18.0,
//                   ),
//                   ListView.builder(
//                     itemCount: parkingList.length,
//                     shrinkWrap: true,
//                     itemBuilder: (BuildContext context, int index) {
//                       return GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             selectedParkingIndex = index;
//                           });
//                           // Navigator.pop(context);
//                         },
//                         child: Container(
//                           width: double.infinity,
//                           color: Colors.transparent,
//                           child: Column(
//                             //padding s : 5,5
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   // Text( //previous
//                                   //   parkingList[index].toString(),
//                                   //   style: const TextStyle(
//                                   //     color: kDefaultBlackColor,
//                                   //     fontSize: 16.0,
//                                   //   ),
//                                   //   // textAlign: TextAlign.center,
//                                   // ),
//                                   Flexible(
//                                     child: RadioListTile(
//                                       title: Text(
//                                         parkingList[index].toString(),
//                                         style: const TextStyle(
//                                           color: kDefaultBlackColor,
//                                           fontSize: 16.0,
//                                         ),
//                                       ),
//                                       value: parkingList[index],
//                                       groupValue: selectedParkingItem,
//                                       onChanged: (value) {
//                                         setState(() {
//                                           selectedParkingItem =
//                                               value.toString();
//                                           print(
//                                               'current:$selectedParkingItem');
//                                           print(parkingList
//                                               .indexOf(selectedParkingItem!));
//                                           selectedParkingIndex = parkingList
//                                               .indexOf(selectedParkingItem!);
//                                         });
//                                         Navigator.pop(context);
//                                       },
//                                     ),
//                                   ),
//                                   // Radio(
//                                   //   value: parkingList[index].toString(),
//                                   //   groupValue: selectedParkingItem,
//                                   //   onChanged: (value) {
//                                   //     setState(() {
//                                   //       selectedParkingItem = parkingList[selectedParkingIndex];
//                                   //       print(selectedParkingItem);
//                                   //     });
//                                   //   },
//                                   //   // title: Text(items[index]),
//                                   // ),
//                                 ],
//                               ),
//                               // kDevider
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
