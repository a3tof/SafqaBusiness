// ── Wallet balance ────────────────────────────────────────────────────────────

class WalletBalance {
  final double balance;

  const WalletBalance({required this.balance});

  factory WalletBalance.fromJson(Map<String, dynamic> json) {
    final raw =
        json['balance'] ??
        json['Balance'] ??
        json['amount'] ??
        json['Amount'] ??
        json['walletBalance'] ??
        json['WalletBalance'] ??
        0;
    return WalletBalance(
      balance: _toDouble(raw),
    );
  }
}

// ── Saved card ────────────────────────────────────────────────────────────────

class CardModel {
  final int id;
  final String cardholderName;

  /// Last 4 digits only — displayed as ".... .... .... {last4}"
  final String last4;
  final String expiryDate;
  final String? label;

  const CardModel({
    required this.id,
    required this.cardholderName,
    required this.last4,
    required this.expiryDate,
    this.label,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    final rawCardNumber =
        (json['cardNumber'] ??
                json['CardNumber'] ??
                json['maskedCardNumber'] ??
                json['MaskedCardNumber'])
            ?.toString();
    return CardModel(
      id: _toInt(
        json['id'] ??
            json['Id'] ??
            json['cardId'] ??
            json['CardId'] ??
            json['savedCardId'] ??
            json['SavedCardId'],
      ),
      cardholderName:
          (json['cardholderName'] ??
                  json['CardholderName'] ??
                  json['holderName'] ??
                  json['HolderName'] ??
                  '')
              .toString(),
      last4: (json['last4'] ??
                  json['Last4'] ??
                  json['lastDigits'] ??
                  json['LastDigits'] ??
                  json['cardLast4'] ??
                  json['CardLast4'])
              ?.toString() ??
          _extractLast4(rawCardNumber),
      expiryDate:
          (json['expiryDate'] ??
                  json['ExpiryDate'] ??
                  json['expireDate'] ??
                  json['ExpireDate'] ??
                  json['expirationDate'] ??
                  json['ExpirationDate'] ??
                  '')
              .toString(),
      label: (json['label'] ??
              json['Label'] ??
              json['cardLabel'] ??
              json['CardLabel'])
          ?.toString(),
    );
  }
}

// ── Transaction ───────────────────────────────────────────────────────────────

enum TransactionType { deposit, withdrawal, auctionDeposit, other }

class TransactionModel {
  final int id;
  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final typeStr =
        (json['type'] ??
                json['Type'] ??
                json['transactionType'] ??
                json['TransactionType'] ??
                '')
            .toString()
            .toLowerCase();

    TransactionType type;
    if (typeStr.contains('withdraw')) {
      type = TransactionType.withdrawal;
    } else if (typeStr.contains('auction')) {
      type = TransactionType.auctionDeposit;
    } else if (typeStr.contains('deposit')) {
      type = TransactionType.deposit;
    } else {
      type = TransactionType.other;
    }

    final rawDate = json['date'] ?? json['Date'] ?? json['createdAt'] ?? '';
    final date =
        rawDate is String && rawDate.isNotEmpty ? DateTime.parse(rawDate) : DateTime.now();

    final rawAmount =
        json['amount'] ??
        json['Amount'] ??
        json['value'] ??
        json['Value'] ??
        json['transactionAmount'] ??
        json['TransactionAmount'] ??
        0;
    final amount = _toDouble(rawAmount);

    return TransactionModel(
      id: _toInt(json['id'] ?? json['Id'] ?? 0),
      title: (json['title'] ??
              json['Title'] ??
              json['description'] ??
              json['Description'] ??
              json['type'] ??
              json['Type'] ??
              'Transaction')
          .toString(),
      amount: amount,
      date: date,
      type: type,
    );
  }
}

// ── Requests ──────────────────────────────────────────────────────────────────

class AddCardRequest {
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String cardholderName;
  final String? label;

  const AddCardRequest({
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.cardholderName,
    this.label,
  });

  Map<String, dynamic> toJson() => {
        'cardNumber': cardNumber,
        'expiryDate': expiryDate,
        'cvv': cvv,
        'cardholderName': cardholderName,
        if (label != null && label!.isNotEmpty) 'cardLabel': label,
      };
}

class DepositRequest {
  final double amount;
  final int savedCardId;

  const DepositRequest({
    required this.amount,
    this.savedCardId = 0,
  });

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'savedCardId': savedCardId,
      };
}

class WithdrawalRequest {
  final double amount;
  final int cardId;

  const WithdrawalRequest({
    required this.amount,
    required this.cardId,
  });

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'cardId': cardId,
      };
}

double _toDouble(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  if (value is double) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String _extractLast4(String? cardNumber) {
  if (cardNumber == null || cardNumber.isEmpty) return '****';
  final digits = cardNumber.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.length < 4) return digits.padLeft(4, '*');
  return digits.substring(digits.length - 4);
}
