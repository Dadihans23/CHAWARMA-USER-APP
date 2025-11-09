// import 'package:flutter/material.dart';
// import 'package:flutter_restaurant/helper/responsive_helper.dart';
// import 'package:flutter_restaurant/utill/dimensions.dart';
// import 'package:flutter_restaurant/utill/styles.dart';
// import 'package:go_router/go_router.dart';

// class CustomAppBarWithBackButton extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final Color? titleColor;
//   final bool centerTitle;
//   final bool isTransparent;
//   final double elevation;
//   final Widget? actionView;

//   const CustomAppBarWithBackButton({
//     super.key,
//     required this.title,
//     this.titleColor,
//     this.centerTitle = true,
//     this.isTransparent = false,
//     this.elevation = 0,
//     this.actionView,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: Text(
//         title,
//         style: rubikSemiBold.copyWith(
//           fontSize: Dimensions.fontSizeLarge,
//           color: titleColor ?? (isTransparent ? Theme.of(context).cardColor : Theme.of(context).textTheme.bodyLarge!.color),
//         ),
//       ),
//       centerTitle: centerTitle,
//       backgroundColor: isTransparent ? Colors.transparent : Theme.of(context).cardColor,
//       elevation: elevation,
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back_ios),
//         color: titleColor ?? (isTransparent ? Theme.of(context).cardColor : Theme.of(context).primaryColor),
//         onPressed: () => context.pop(), // 👈 Retour automatique
//       ),
//       actions: actionView != null
//           ? [
//               Padding(
//                 padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
//                 child: actionView!,
//               )
//             ]
//           : [],
//     );
//   }

//   @override
//   Size get preferredSize => Size(double.maxFinite, ResponsiveHelper.isDesktop(get.context) ? 100 : 50);

// }
