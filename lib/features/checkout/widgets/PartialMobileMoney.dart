import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/providers/theme_provider.dart';
import 'package:flutter_restaurant/features/checkout/providers/checkout_provider.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;


import 'dart:convert';

import 'package:flutter_restaurant/features/checkout/providers/API_data.dart';
import 'package:flutter_restaurant/features/checkout/models/APIData.dart';
import 'package:flutter_restaurant/features/checkout/screens/redirectPaymentPage.dart';


import 'package:url_launcher/url_launcher.dart';


class PartialMobileMoneyWidget extends StatelessWidget {
  final bool isPartialPay;
  final double totalPrice;
  const PartialMobileMoneyWidget({super.key, required this.isPartialPay, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final CheckoutProvider checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    final TransactionProvider transaction = Provider.of<TransactionProvider>(context , listen: false);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(
        width: 500,
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Align(alignment: Alignment.topRight, child: InkWell(
            onTap: ()=> context.pop(),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.clear, size: 24),
            ),
          )),


          Image.asset(Images.note, width: 35, height: 35),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Text(
            getTranslated('note', context)!, textAlign: TextAlign.center,
            style: rubikBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: themeProvider.darkTheme ? Theme.of(context).primaryColor : ColorResources.homePageSectionTitleColor),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
            child: Row(children: [

              Expanded(
                child: RichText(textAlign : TextAlign.center, text: TextSpan(children: [
                 TextSpan(
                  text: 'Voulez-vous payer avec du mobile money ? Si oui, appuyez sur OUI pour proceder au portail de paiement.',
                  style: rubikSemiBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: themeProvider.darkTheme
                        ? Theme.of(context).primaryColor
                        : ColorResources.homePageSectionTitleColor,
                  ),
                ), 

                  const TextSpan(text: ' '),
                ])),
              ),


            ]),
          ),


          const SizedBox(height: Dimensions.paddingSizeDefault),

          Image.asset(Images.partialPay, height: 35, width: 35),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Row(children: [
              Expanded(child: CustomButtonWidget(
                btnTxt: getTranslated('no', context),
                backgroundColor: Theme.of(context).disabledColor,
                onTap: (){
                  checkoutProvider.savePaymentMethod(index: null, method: null);
                if(checkoutProvider.partialAmount != null){
                  checkoutProvider.changePartialPayment();
                }
                context.pop();
                },
              )),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(child: CustomButtonWidget(btnTxt: getTranslated('yes_pay', context), onTap: () async {

                  final transaction = Provider.of<TransactionProvider>(context, listen: false).transaction;
                  print('voilaaaa') ;
                  checkoutProvider.setPaymentIndex(0);
                  if (transaction != null) {
                    final response = await sendTransactionToCinetPay(transaction);
                    if (response.statusCode == 200 || response.statusCode == 201) {
                      final responseBody = jsonDecode(response.body);
                      final paymentUrl = responseBody['data']['payment_url'];
                      if (paymentUrl != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RedirectToPaymentPage(
                              paymentUrl: paymentUrl,
                              transactionId: transaction.transactionId,
                              siteId: transaction.siteId,
                              apiKey: transaction.apikey,
                            ),
                          ),
                        );
                      }
                    } else {
                      print("Erreur lors de la création de la transaction.");
                    }
                  } else {
                    print("Aucune transaction trouvée dans le provider.");
                  }

                // context.pop();
              })),
            ]),
          ),
        ]),
      ),
    );
  }




  Future<http.Response> sendTransactionToCinetPay(TransactionModel transaction) async {
  final url = Uri.parse('https://api-checkout.cinetpay.com/v2/payment'); // adapte l’URL si besoin
                        
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode(transaction.toJson()),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    print('Succès: ${response.body}');
  } else {
    print('Erreur: ${response.statusCode} - ${response.body}');
  }

  return response;
}


Future<void> openPaymentUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    print('Impossible d’ouvrir le lien $url');
  }
}
}


