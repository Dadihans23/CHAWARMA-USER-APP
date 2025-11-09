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



class OrderHelper {
  static Future<PlaceOrderBody?> buildPlaceOrderBody({
    required BuildContext context,
    required bool kmWiseCharge,
    required bool isCutlery,
    required double orderAmount,
    required List<CartModel?> cartList,
    required OrderType orderType,
    required String? couponCode,
    required TextEditingController noteController,
    required double? deliveryCharge,
  }) async {
    final takeAway = orderType.name.camelCaseToSnakeCase() == 'take_away';
    final checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    final branchProvider = Provider.of<BranchProvider>(context, listen: false);
    final configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;

    DateTime scheduleStartDate = DateTime.now();
    if (checkoutProvider.timeSlots != null && checkoutProvider.timeSlots!.isNotEmpty) {
      DateTime date = checkoutProvider.selectDateSlot == 0 ? DateTime.now() : DateTime.now().add(const Duration(days: 1));
      DateTime startTime = checkoutProvider.timeSlots![checkoutProvider.selectTimeSlot].startTime!;
      scheduleStartDate = DateTime(date.year, date.month, date.day, startTime.hour, startTime.minute+1);
    }

    List<Cart> carts = [];
    for (var cart in cartList) {
      if (cart == null) continue;
      List<int?> addOnIdList = cart.addOnIds!.map((e) => e.id).toList();
      List<int?> addOnQtyList = cart.addOnIds!.map((e) => e.quantity).toList();

      List<OrderVariation> variations = [];

      if(cart.product!.variations != null && cart.variations != null && cart.variations!.isNotEmpty){
        for(int i=0; i<cart.product!.variations!.length; i++) {
          if(cart.variations![i].contains(true)) {
            var variation = OrderVariation(
              name: cart.product!.variations![i].name,
              values: OrderVariationValue(label: []),
            );
            for(int j=0; j<cart.product!.variations![i].variationValues!.length; j++) {
              if(cart.variations![i][j]!) {
                variation.values!.label!.add(cart.product!.variations![i].variationValues![j].level);
              }
            }
            variations.add(variation);
          }
        }
      }

      carts.add(Cart(
        cart.product!.id.toString(), cart.discountedPrice.toString(), [], variations,
        cart.discountAmount, cart.quantity, cart.taxAmount, addOnIdList, addOnQtyList,
      ));
    }

    return PlaceOrderBody(
      cart: carts,
      couponDiscountAmount: Provider.of<CouponProvider>(context, listen: false).discount,
      couponDiscountTitle: couponCode,
      deliveryAddressId: !takeAway ? locationProvider.addressList![checkoutProvider.addressIndex].id : 0,
      orderAmount: double.parse(orderAmount.toStringAsFixed(2)),
      orderNote: noteController.text,
      orderType: orderType.name.camelCaseToSnakeCase(),
      paymentMethod: checkoutProvider.selectedOfflineValue != null
          ? 'offline_payment' : checkoutProvider.selectedPaymentMethod!.getWay!,
      couponCode: couponCode,
      distance: takeAway ? 0 : checkoutProvider.distance,
      branchId: branchProvider.getBranch()?.id,
      deliveryDate: DateFormat('yyyy-MM-dd').format(scheduleStartDate),
      deliveryTime: (checkoutProvider.selectTimeSlot == 0 && checkoutProvider.selectDateSlot == 0) ? 'now' : DateFormat('HH:mm').format(scheduleStartDate),
      isPartial: checkoutProvider.partialAmount == null ? '0' : '1',
      isCutleryRequired: '${isCutlery ? 1 : 0}',
      selectedDeliveryArea: locationProvider.selectedAreaID == -1 || checkoutProvider.orderType == OrderType.takeAway? null  : locationProvider.selectedAreaID,
    );
  }
}
