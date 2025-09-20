// import 'package:enjaz/features/profile/widget/1/user_identity_card.dart';
// import 'package:enjaz/features/profile/widget/1/user_meta_chips.dart';
// import 'package:flutter/material.dart';
// import 'package:enjaz/features/profile/data/model/user_model.dart';
// import 'package:enjaz/core/constant/app_padding/app_padding.dart';

// class ProfileOverviewSection extends StatelessWidget {
//   final UserModel user;
//   final ImageProvider? avatarImage;
//   final VoidCallback? onEdit;
//   final VoidCallback? onCall;
//   final VoidCallback? onMessage;

//   const ProfileOverviewSection({
//     super.key,
//     required this.user,
//     this.avatarImage,
//     this.onEdit,
//     this.onCall,
//     this.onMessage,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         UserIdentityCard(user: user, avatarImage: avatarImage, animated: false),
//         const SizedBox(height: AppPaddingSize.padding_16),
//         Align(
//           alignment: Alignment.centerLeft,
//           child: UserMetaChips(user: user),
//         ),
//         const SizedBox(height: AppPaddingSize.padding_16),

//         const SizedBox(height: AppPaddingSize.padding_16),
//       ],
//     );
//   }
// }
