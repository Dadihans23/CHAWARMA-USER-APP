// common/widgets/view_cart_button_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';
import 'package:flutter_restaurant/features/cart/screens/cart_screen.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class ViewCartButtonWidget extends StatelessWidget {
  const ViewCartButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusLarge)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Consumer<CartProvider>(
            builder: (context, cartProvider, _) {
              final int itemCount = cartProvider.cartList.length;
              final bool hasItems = itemCount > 0;

              return ElevatedButton(
                onPressed: hasItems
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CartScreen()),
                        );
                      }
                    : null, // Désactivé si panier vide
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_basket, size: 25, color : Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Voir mon panier',
                      style: rubikMedium.copyWith(fontSize: 20),
                    ),
                    if (hasItems) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$itemCount',
                          style: rubikSemiBold.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}





// // common/widgets/bottom_nav_bar_widget.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
// import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';
// import 'package:flutter_restaurant/helper/responsive_helper.dart';
// import 'package:flutter_restaurant/localization/app_localization.dart';
// import 'package:flutter_restaurant/utill/dimensions.dart';
// import 'package:flutter_restaurant/utill/images.dart';
// import 'package:flutter_restaurant/utill/styles.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
// import 'package:flutter_restaurant/common/widgets/custom_pop_scope_widget.dart';
// import 'package:flutter_restaurant/common/widgets/third_party_chat_widget.dart';
// import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
// import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';
// import 'package:flutter_restaurant/features/cart/screens/cart_screen.dart';
// import 'package:flutter_restaurant/features/dashboard/widgets/bottom_nav_item_widget.dart';
// import 'package:flutter_restaurant/features/home/screens/home_screen.dart';
// import 'package:flutter_restaurant/features/menu/screens/menu_screen.dart';
// import 'package:flutter_restaurant/features/order/providers/order_provider.dart';
// import 'package:flutter_restaurant/features/order/screens/order_screen.dart';
// import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
// import 'package:flutter_restaurant/features/wishlist/screens/wishlist_screen.dart';
// import 'package:flutter_restaurant/helper/responsive_helper.dart';
// import 'package:flutter_restaurant/localization/app_localization.dart';
// import 'package:flutter_restaurant/localization/language_constrants.dart';
// import 'package:flutter_restaurant/utill/dimensions.dart';
// import 'package:flutter_restaurant/utill/images.dart';
// import 'package:flutter_restaurant/utill/styles.dart';
// import 'package:provider/provider.dart';


// class BottomNavBarWidget extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onTap;

//   const BottomNavBarWidget({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.sizeOf(context);

//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Container(
//         width: size.width,
//         height: defaultTargetPlatform == TargetPlatform.iOS ? 80 : 65,
//         decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusLarge)),
//           boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
//         ),
//         child: Stack(
//           children: [
//             // FAB central (Panier)
//             Center(
//               heightFactor: 0.2,
//               child: Container(
//                 width: 60, height: 60,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Theme.of(context).cardColor, width: 5),
//                   borderRadius: BorderRadius.circular(30),
//                   boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, offset: const Offset(0, -2))],
//                 ),
//                 child: FloatingActionButton(
//                   shape: const CircleBorder(),
//                   backgroundColor: Theme.of(context).primaryColor,
//                   onPressed: () => onTap(2), // Page du panier
//                   elevation: 0,
//                   child: Consumer<CartProvider>(
//                     builder: (context, cartProvider, _) {
//                       return Stack(
//                         children: [
//                           const CustomAssetImageWidget(Images.order, color: Colors.white, height: 30),
//                           if (cartProvider.cartList.isNotEmpty)
//                             Positioned(
//                               top: -4, right: 0,
//                               child: Container(
//                                 padding: const EdgeInsets.all(5),
//                                 decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
//                                 child: Text(
//                                   '${cartProvider.cartList.length}',
//                                   style: rubikSemiBold.copyWith(
//                                     color: Theme.of(context).primaryColor,
//                                     fontSize: Dimensions.paddingSizeSmall,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),

//             // Les 4 boutons autour
//             Center(
//               child: SizedBox(
//                 width: size.width,
//                 height: 80,
//                 child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//                   _buildNavItem(context, 0, 'home', Images.homeSvg),
//                   _buildNavItem(context, 1, 'favourite', Images.favoriteSvg),
//                   Container(width: size.width * 0.2), // Espace pour le FAB
//                   _buildNavItem(context, 3, 'order', Images.shopSvg),
//                   _buildNavItem(context, 4, 'menu', Images.menuSvg),
//                 ]),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNavItem(BuildContext context, int index, String translationKey, String icon) {
//     return BottomNavItemWidget(
//       title: getTranslated(translationKey, context)!.toCapitalized(),
//       imageIcon: icon,
//       isSelected: currentIndex == index,
//       onTap: () => onTap(index),
//     );
//   }
// }