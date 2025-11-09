class TransactionModel {
  final String apikey;
  final String siteId;
  final String transactionId;
  final int amount;
  final String currency;
  final String description;
  final String notifyUrl;
  final String returnUrl;
  final String channels;

  TransactionModel({
    required this.apikey,
    required this.siteId,
    required this.transactionId,
    required this.amount,
    required this.currency,
    required this.description,
    required this.notifyUrl,
    required this.returnUrl,
    required this.channels,
  });

  Map<String, dynamic> toJson() {
    return {
      "apikey": apikey,
      "site_id": siteId,
      "transaction_id": transactionId,
      "amount": amount,
      "currency": currency,
      "description": description,
      "notify_url": notifyUrl,
      "return_url": returnUrl,
      "channels": channels,
    };
  }
}
