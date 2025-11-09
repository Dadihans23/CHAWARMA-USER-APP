import 'package:flutter/material.dart';
import '../models/APIData.dart'; // adapte le chemin si besoin

class TransactionProvider extends ChangeNotifier {
  TransactionModel? _transaction;

  TransactionModel? get transaction => _transaction;

  void setTransaction(TransactionModel transactionData) {
    _transaction = transactionData;
    notifyListeners();
  }
}
