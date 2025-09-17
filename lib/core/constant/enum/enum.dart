// // ignore_for_file: constant_identifier_names

// import 'package:flutter/material.dart';

 
// enum VisitRequestStatus {
//   pending,
//   approved,
//   rejected,
//   expired,
//   deactivated;

//   static VisitRequestStatus? fromInt(int? value) {
//     switch (value) {
//       case 1:
//         return VisitRequestStatus.pending;
//       case 2:
//         return VisitRequestStatus.approved;
//       case 3:
//         return VisitRequestStatus.rejected;
//       case 4:
//         return VisitRequestStatus.expired;
//       case 5:
//         return VisitRequestStatus.deactivated;
//       default:
//         return null;
//     }
//   }

//   String localizedLabel(BuildContext context) {
//     final s = S.of(context);
//     switch (this) {
//       case VisitRequestStatus.pending:
//         return s.Pending;
//       case VisitRequestStatus.approved:
//         return s.approved;
//       case VisitRequestStatus.rejected:
//         return s.rejected;
//       case VisitRequestStatus.expired:
//         return s.expired;
//       case VisitRequestStatus.deactivated:
//         return s.deactivated;
//     }
//   }
// }

// enum EntityType {
//   compund,
//   square,
//   floor,
//   building,
//   customer,
//   apartment,
//   advertisement,
//   service,
//   categoryService,
//   serviceRequest,
//   visitRequest,
//   complaint;

//   static EntityType? fromInt(int? value) {
//     switch (value) {
//       case 1:
//         return EntityType.compund;
//       case 2:
//         return EntityType.square;
//       case 3:
//         return EntityType.floor;
//       case 4:
//         return EntityType.building;
//       case 5:
//         return EntityType.customer;
//       case 6:
//         return EntityType.apartment;
//       case 7:
//         return EntityType.advertisement;
//       case 8:
//         return EntityType.service;
//       case 9:
//         return EntityType.categoryService;
//       case 10:
//         return EntityType.serviceRequest;
//       case 11:
//         return EntityType.visitRequest;
//       case 12:
//         return EntityType.complaint;
//       default:
//         return null;
//     }
//   }

//   int toInt() {
//     switch (this) {
//       case EntityType.compund:
//         return 1;
//       case EntityType.square:
//         return 2;
//       case EntityType.floor:
//         return 3;
//       case EntityType.building:
//         return 4;
//       case EntityType.customer:
//         return 5;
//       case EntityType.apartment:
//         return 6;
//       case EntityType.advertisement:
//         return 7;
//       case EntityType.service:
//         return 8;
//       case EntityType.categoryService:
//         return 9;
//       case EntityType.serviceRequest:
//         return 10;
//       case EntityType.visitRequest:
//         return 11;
//       case EntityType.complaint:
//         return 12;
//     }
//   }
// }
