// redirect_to_payment_page.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_restaurant/features/order/providers/order_provider.dart';
import 'package:flutter_restaurant/features/checkout/providers/OrderHelper.dart';


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
import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';

import 'package:flutter_restaurant/features/checkout/providers/testOrder2.dart';



import 'dart:math';
import 'dart:ui';
import 'dart:convert' as convert;

// class RedirectToPaymentPage extends StatefulWidget {
//   final String paymentUrl;
//   final String transactionId;
//   final String siteId;
//   final String apiKey;

//   const RedirectToPaymentPage({
//     super.key,
//     required this.paymentUrl,
//     required this.transactionId,
//     required this.siteId,
//     required this.apiKey,
//   });

//   @override
//   State<RedirectToPaymentPage> createState() => _RedirectToPaymentPageState();
// }

// class _RedirectToPaymentPageState extends State<RedirectToPaymentPage> with WidgetsBindingObserver {
//   bool _hasReturnedFromBrowser = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     Future.delayed(const Duration(seconds: 2), () => _launchPayment());
//   }

//   Future<void> _launchPayment() async {
//     final uri = Uri.parse(widget.paymentUrl);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Impossible d’ouvrir le lien.')));
//     }
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed && !_hasReturnedFromBrowser) {
//       _hasReturnedFromBrowser = true;
//       _checkPaymentStatus();
//     }
//   }

//   Future<void> _checkPaymentStatus() async {
//     final url = Uri.parse('https://api-checkout.cinetpay.com/v2/payment/check');
//     final body = {
//       "transaction_id": widget.transactionId,
//       "site_id": widget.siteId,
//       "apikey": widget.apiKey,
//     };

//     try {
//       final response = await http.post(url,
//           headers: {"Content-Type": "application/json"}, body: jsonEncode(body));
//       final data = jsonDecode(response.body);

//       final status = data['data']['status'];
//       if (status == "ACCEPTED") {
//         if (!mounted) return;
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const PaymentSuccessPage()),
//         );
//       } else {
//         if (!mounted) return;
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const PaymentFailedPage()),
//         );
//       }
//     } catch (e) {
//       print('Erreur de vérification : $e');
//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const PaymentFailedPage()),
//         );
//       }
//     }
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(child: CircularProgressIndicator()),
//     );
//   }
// }
// // payment_success_page.dart
// class PaymentSuccessPage extends StatelessWidget {
//   const PaymentSuccessPage({super.key});

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       body: Center(
//         child: Text("wooo"),
//       )
//     );

//   }
// }


// // payment_failed_page.dart
// class PaymentFailedPage extends StatelessWidget {
//   const PaymentFailedPage({super.key});

//   @override
//   Widget build(BuildContext context) {


//     return 
//     WillPopScope(
//       onWillPop: () async {
        
//         Navigator.of(context).popUntil((route) => route.settings.name == RouterHelper.checkoutScreen);

//         return false;
//       },
//       child: Scaffold(
//          body: Center(
//         child: Text('❌ Paiement échoué', style: TextStyle(fontSize: 24, color: Colors.red)),
//       ),
//       ),
//     );
//   }
// }




import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_restaurant/features/order/providers/order_provider.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_restaurant/common/models/place_order_body.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';

class RedirectToPaymentPage extends StatefulWidget {
  final String paymentUrl;
  final String transactionId;
  final String siteId;
  final String apiKey;

  const RedirectToPaymentPage({
    super.key,
    required this.paymentUrl,
    required this.transactionId,
    required this.siteId,
    required this.apiKey,
  });

  @override
  State<RedirectToPaymentPage> createState() => _RedirectToPaymentPageState();
}

class _RedirectToPaymentPageState extends State<RedirectToPaymentPage> with WidgetsBindingObserver {
  bool _hasReturnedFromBrowser = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(const Duration(seconds: 2), () => _launchPayment());
  }

  Future<void> _launchPayment() async {
    final uri = Uri.parse(widget.paymentUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        showCustomSnackBarHelper(
          getTranslated('cannot_open_payment_url', context) ?? 'Impossible d’ouvrir le lien de paiement.',
        );
      }
    }
  }

  Future<void> _checkPaymentStatus() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final url = Uri.parse('https://api-checkout.cinetpay.com/v2/payment/check');
    final body = {
      'transaction_id': widget.transactionId,
      'site_id': widget.siteId,
      'apikey': widget.apiKey,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 30));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = data['data']['status'];

        if (status == 'ACCEPTED') {
          // Récupérer PlaceOrderBody
          final placeOrderData = orderProvider.getPlaceOrder();
          if (placeOrderData != null) {
            final placeOrderBody = PlaceOrderBody.fromJson(
              convert.jsonDecode(convert.utf8.decode(convert.base64Decode(placeOrderData))),
            );
            // Enregistrer la commande
            orderProvider.placeOrder(
              placeOrderBody,
              (bool isSuccess, String message, String orderID, int addressID) {
                if (isSuccess) {
                  RouterHelper.getOrderSuccessScreen(orderID, 'success');
                } else {
                  showCustomSnackBarHelper(message,);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const PaymentFailedPage()),
                  );
                }
              },
            );
          } else {
            showCustomSnackBarHelper(
              getTranslated('order_data_not_found', context) ?? 'Données de la commande non trouvées.',
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PaymentFailedPage()),
            );
          }
        } else {
          showCustomSnackBarHelper(
            getTranslated('payment_failed', context) ?? 'Le paiement a échoué.',
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const PaymentFailedPage()),
          );
        }
      } else {
        showCustomSnackBarHelper(
         'Erreur lors de la vérification du paiement.',
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PaymentFailedPage()),
        );
      }
    } catch (e) {
      print('Erreur de vérification : $e');
      if (mounted) {
        showCustomSnackBarHelper(
          getTranslated('network_error', context) ?? 'Erreur réseau. Veuillez réessayer.',
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PaymentFailedPage()),
        );
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_hasReturnedFromBrowser) {
      _hasReturnedFromBrowser = true;
      _checkPaymentStatus();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Text(
             'Redirection vers le paiement...',
            ),
          ],
        ),
      ),
    );
  }
}





class PaymentFailedPage extends StatelessWidget {
  const PaymentFailedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popUntil((route) => route.settings.name == RouterHelper.checkoutScreen);
        return false;
      },
      child: Scaffold(
        body: Center(
          child: Text("echec"),
      ),
    )
    ) ;
  } 
  
}





class PaymentSuccessPage extends StatelessWidget {
  final String orderID;

  const PaymentSuccessPage({super.key, required this.orderID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("bravooo"),
    )
    );
  }
}