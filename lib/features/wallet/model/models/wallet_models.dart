// ── Wallet balance ────────────────────────────────────────────────────────────

class WalletBalance {
  final double balance;

  const WalletBalance({required this.balance});

  factory WalletBalance.fromJson(Map<String, dynamic> json) {
    final raw = json['balance'] ?? json['Balance'] ?? 0;
    return WalletBalance(
      balance: (raw is int) ? raw.toDouble() : (raw as num).toDouble(),
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
    return CardModel(
      id: (json['id'] ?? json['Id']) as int,
      cardholderName:
          (json['cardholderName'] ?? json['CardholderName'] ?? '') as String,
      last4: (json['last4'] ?? json['Last4'] ?? '****') as String,
      expiryDate:
          (json['expiryDate'] ?? json['ExpiryDate'] ?? '') as String,
      label: (json['label'] ?? json['Label']) as String?,
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
        ((json['type'] ?? json['Type'] ?? '') as String).toLowerCase();

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

    final rawAmount = json['amount'] ?? json['Amount'] ?? 0;
    final amount =
        (rawAmount is int) ? rawAmount.toDouble() : (rawAmount as num).toDouble();

    return TransactionModel(
      id: (json['id'] ?? json['Id'] ?? 0) as int,
      title: (json['title'] ?? json['Title'] ?? json['type'] ?? 'Transaction')
          as String,
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
        if (label != null && label!.isNotEmpty) 'label': label,
      };
}

class DepositRequest {
  final double amount;
  const DepositRequest({required this.amount});
  Map<String, dynamic> toJson() => {'amount': amount};
}

class WithdrawalRequest {
  final double amount;
  const WithdrawalRequest({required this.amount});
  Map<String, dynamic> toJson() => {'amount': amount};
}
