import 'dart:convert'as convert;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/place_order_body.dart';
import 'package:flutter_restaurant/common/models/cart_model.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/features/checkout/domain/enum/delivery_type_enum.dart';
import 'package:flutter_restaurant/features/checkout/providers/checkout_provider.dart';
import 'package:flutter_restaurant/features/checkout/widgets/address_change_widget.dart';
import 'package:flutter_restaurant/features/checkout/widgets/payment_method_bottom_sheet_widget.dart';
import 'package:flutter_restaurant/helper/checkout_helper.dart';
import 'package:flutter_restaurant/helper/date_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/branch/providers/branch_provider.dart';
import 'package:flutter_restaurant/features/coupon/providers/coupon_provider.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/features/order/providers/order_provider.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;



// Future<void> handlePlaceOrder({
//   required BuildContext context,
//   required bool kmWiseCharge,
//   required bool isCutlery,
//   required double? deliveryCharge,
//   required double orderAmount,
//   required List<CartModel?> cartList,
//   required OrderType orderType,
//   String? couponCode,
//   required TextEditingController noteController,
//   required Function callBack,
//   required ScrollController scrollController,
//   required GlobalKey dropdownKey,
// }) async {
//   final BranchProvider branchProvider = Provider.of<BranchProvider>(context, listen: false);
//   final takeAway = orderType.name.camelCaseToSnakeCase() == 'take_away';
//   final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
//   final ConfigModel configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;
//   final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
//   final LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);
//   final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
//   final CheckoutProvider checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);
//   final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);

//   if (!takeAway && (locationProvider.addressList == null || locationProvider.addressList!.isEmpty || checkoutProvider.addressIndex < 0)) return;

//   if (checkoutProvider.selectedPaymentMethod != null || checkoutProvider.selectedOfflineValue != null) {
//     bool isAvailable = true;
//     DateTime scheduleStartDate = DateTime.now();
//     DateTime scheduleEndDate = DateTime.now();

//     if (checkoutProvider.timeSlots == null || checkoutProvider.timeSlots!.isEmpty) {
//       isAvailable = false;
//     } else {
//       DateTime date = checkoutProvider.selectDateSlot == 0 ? DateTime.now() : DateTime.now().add(const Duration(days: 1));
//       DateTime startTime = checkoutProvider.timeSlots![checkoutProvider.selectTimeSlot].startTime!;
//       DateTime endTime = checkoutProvider.timeSlots![checkoutProvider.selectTimeSlot].endTime!;
//       scheduleStartDate = DateTime(date.year, date.month, date.day, startTime.hour, startTime.minute + 1);
//       scheduleEndDate = DateTime(date.year, date.month, date.day, endTime.hour, endTime.minute + 1);

//       for (CartModel? cart in cartList) {
//         if (!DateConverterHelper.isAvailable(cart!.product!.availableTimeStarts!, cart.product!.availableTimeEnds!, time: scheduleStartDate)
//             && !DateConverterHelper.isAvailable(cart.product!.availableTimeStarts!, cart.product!.availableTimeEnds!, time: scheduleEndDate)) {
//           isAvailable = false;
//           break;
//         }
//       }
//     }

//     if (orderAmount < configModel.minimumOrderValue!) {
//       showCustomSnackBarHelper('Minimum order amount is ${configModel.minimumOrderValue}');
//     } else if (checkoutProvider.timeSlots == null || checkoutProvider.timeSlots!.isEmpty) {
//       showCustomSnackBarHelper(getTranslated('select_a_time', context));
//     } else if (!isAvailable) {
//       showCustomSnackBarHelper(getTranslated('one_or_more_products_are_not_available_for_this_selected_time', context));
//     } else if (!takeAway && kmWiseCharge && checkoutProvider.distance == -1) {
//       showCustomSnackBarHelper(getTranslated('delivery_fee_not_set_yet', context));
//     } else if (splashProvider.deliveryInfoModel?.deliveryChargeSetup?.deliveryChargeType == 'area' && locationProvider.selectedAreaID == -1 && checkoutProvider.orderType != OrderType.takeAway) {
//       await scrollController.animateTo(0, duration: const Duration(milliseconds: 100), curve: Curves.ease);
//       _openDropdown(dropdownKey);
//     } else {
//       List<Cart> carts = cartList.map((cart) {
//         List<int?> addOnIdList = [];
//         List<int?> addOnQtyList = [];
//         List<OrderVariation> variations = [];

//         for (var addOn in cart!.addOnIds!) {
//           addOnIdList.add(addOn.id);
//           addOnQtyList.add(addOn.quantity);
//         }

//         if (cart.product!.variations != null && cart.variations != null && cart.variations!.isNotEmpty) {
//           for (int i = 0; i < cart.product!.variations!.length; i++) {
//             if (cart.variations![i].contains(true)) {
//               variations.add(OrderVariation(
//                 name: cart.product!.variations![i].name,
//                 values: OrderVariationValue(label: []),
//               ));

//               for (int j = 0; j < cart.product!.variations![i].variationValues!.length; j++) {
//                 if (cart.variations![i][j]!) {
//                   variations.last.values!.label!.add(cart.product!.variations![i].variationValues![j].level);
//                 }
//               }
//             }
//           }
//         }

//         return Cart(
//           cart.product!.id.toString(), cart.discountedPrice.toString(), [], variations,
//           cart.discountAmount, cart.quantity, cart.taxAmount, addOnIdList, addOnQtyList,
//         );
//       }).toList();

//       PlaceOrderBody placeOrderBody = PlaceOrderBody(
//         cart: carts,
//         couponDiscountAmount: Provider.of<CouponProvider>(context, listen: false).discount,
//         couponDiscountTitle: couponCode,
//         deliveryAddressId: !takeAway ? locationProvider.addressList![checkoutProvider.addressIndex].id : 0,
//         orderAmount: double.parse(orderAmount.toStringAsFixed(2)),
//         orderNote: noteController.text,
//         orderType: orderType.name.camelCaseToSnakeCase(),
//         paymentMethod:"cash_on_delivery" ,
//         couponCode: couponCode,
//         distance: takeAway ? 0 : checkoutProvider.distance,
//         branchId: branchProvider.getBranch()?.id,
//         deliveryDate: DateFormat('yyyy-MM-dd').format(scheduleStartDate),
//         paymentInfo: checkoutProvider.selectedOfflineValue != null ? OfflinePaymentInfo(
//           methodFields: CheckOutHelper.getOfflineMethodJson(checkoutProvider.selectedOfflineMethod?.methodFields),
//           methodInformation: checkoutProvider.selectedOfflineValue,
//           paymentName: checkoutProvider.selectedOfflineMethod?.methodName,
//           paymentNote: checkoutProvider.selectedOfflineMethod?.paymentNote,
//         ) : null,
//         deliveryTime: (checkoutProvider.selectTimeSlot == 0 && checkoutProvider.selectDateSlot == 0) ? 'now' : DateFormat('HH:mm').format(scheduleStartDate),
//         isPartial: checkoutProvider.partialAmount == null ? '0' : '1',
//         isCutleryRequired: '${isCutlery ? 1 : 0}',
//         selectedDeliveryArea: locationProvider.selectedAreaID == -1 || checkoutProvider.orderType == OrderType.takeAway ? null : locationProvider.selectedAreaID,
//       );

//       if (placeOrderBody.paymentMethod == 'wallet_payment' || placeOrderBody.paymentMethod == 'cash_on_delivery' || placeOrderBody.paymentMethod == 'offline_payment') {
//         orderProvider.placeOrder(placeOrderBody, callBack);
//       } else {
//         final hostname = html.window.location.hostname;
//         final protocol = html.window.location.protocol;
//         final port = html.window.location.port;
//         final placeOrder = convert.base64Url.encode(convert.utf8.encode(convert.jsonEncode(placeOrderBody.toJson())));

//         String url = "customer_id=${authProvider.getGuestId() ?? profileProvider.userInfoModel!.id}&&is_guest=${authProvider.getGuestId() != null ? '1' : '0'}"
//             "&&callback=${AppConstants.baseUrl}${RouterHelper.orderSuccessScreen}&&order_amount=${(orderAmount + (deliveryCharge ?? 0)).toStringAsFixed(2)}";

//         String tokenUrl = convert.base64Encode(convert.utf8.encode(url));
//         String selectedUrl = '${AppConstants.baseUrl}/payment-mobile?token=$tokenUrl&&payment_method=${checkoutProvider.selectedPaymentMethod?.getWay}&&payment_platform=app&&is_partial=${checkoutProvider.partialAmount == null ? '0' : '1'}';

//         orderProvider.clearPlaceOrder().then((_) => orderProvider.setPlaceOrder(placeOrder).then((value) {
//           Navigator.pop(context);
//           RouterHelper.getPaymentRoute(selectedUrl, fromCheckout: true);
//         }));
//       }
//     }
//   }
// }


// void _openDropdown(GlobalKey key) {
//   final dropdownContext = key.currentContext;
//   if (dropdownContext != null) {
//     GestureDetector? detector;
//     void searchGestureDetector(BuildContext context) {
//       context.visitChildElements((element) {
//         if (element.widget is GestureDetector) {
//           detector = element.widget as GestureDetector?;
//         } else {
//           searchGestureDetector(element);
//         }
//       });
//     }
//     searchGestureDetector(dropdownContext);
//     detector?.onTap?.call();
//   }
// }

import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/cart_model.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/features/checkout/domain/enum/delivery_type_enum.dart';
import 'package:flutter_restaurant/features/checkout/providers/checkout_provider.dart';
import 'package:flutter_restaurant/features/order/providers/order_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/helper/checkout_helper.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/date_converter_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/common/models/place_order_body.dart';
import 'package:provider/provider.dart';
