import 'package:intl/intl.dart';

enum AuctionStatus { upcoming, active, endingSoon, finished, canceled, sold }

class HistoryItem {
  final int id;
  final int auctionId;
  final String lotNumber;
  final String title;
  final AuctionStatus status;
  final int bidsCount;
  final String? timeLeft;
  final DateTime? endDate;
  final double price;
  final String? imageUrl;
  final String? mileage;

  const HistoryItem({
    required this.id,
    required this.auctionId,
    required this.lotNumber,
    required this.title,
    required this.status,
    required this.bidsCount,
    required this.timeLeft,
    required this.endDate,
    required this.price,
    required this.imageUrl,
    required this.mileage,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    final rawId = _asInt(json['id'] ?? json['Id']);
    final rawAuctionId = _asInt(json['auctionId'] ?? json['AuctionId']);
    final rawLotId = _asInt(json['lotId'] ?? json['LotId']);
    final status = _parseStatus(
      json['status'] ??
          json['Status'] ??
          json['auctionStatus'] ??
          json['AuctionStatus'],
    );

    final startingPrice = _asDouble(
      json['startingPrice'] ?? json['StartingPrice'],
    );
    final currentPrice = _asDouble(
      json['currentPrice'] ?? json['CurrentPrice'],
    );
    final finalPrice = _asDouble(json['finalPrice'] ?? json['FinalPrice']);
    final fallbackPrice = _asDouble(
      json['price'] ??
          json['Price'] ??
          json['amount'] ??
          json['Amount'] ??
          json['winningBid'] ??
          json['WinningBid'],
    );

    return HistoryItem(
      id: rawId ?? rawLotId ?? rawAuctionId ?? 0,
      // The Get-History response uses 'id' as the auction id (same value that
      // Auction/View/{id} and Auction/Delete/{id} expect).
      // 'auctionId' is kept as an alias but 'id' is the primary source.
      auctionId: rawAuctionId ?? rawId ?? rawLotId ?? 0,
      lotNumber:
          _firstNonEmptyString([
            json['lotNumber'],
            json['LotNumber'],
            json['lotNo'],
            json['LotNo'],
            json['auctionNumber'],
            json['AuctionNumber'],
            json['tag'],
            json['Tag'],
          ]) ??
          '#${_asInt(json['id'] ?? json['Id']) ?? 0}',
      title:
          _firstNonEmptyString([
            json['title'],
            json['Title'],
            json['name'],
            json['Name'],
            json['itemTitle'],
            json['ItemTitle'],
            json['productName'],
            json['ProductName'],
            json['vehicleName'],
            json['VehicleName'],
          ]) ??
          'Auction',
      status: status,
      bidsCount:
          _asInt(
            json['bidsCount'] ??
                json['BidsCount'] ??
                json['bidCount'] ??
                json['BidCount'] ??
                json['bids'] ??
                json['Bids'],
          ) ??
          0,
      timeLeft: _firstNonEmptyString([
        json['timeLeft'],
        json['TimeLeft'],
        json['timeRemaining'],
        json['TimeRemaining'],
        json['remainingTime'],
        json['RemainingTime'],
        json['duration'],
        json['Duration'],
      ]),
      endDate: _parseDate(
        json['endDate'] ??
            json['EndDate'] ??
            json['auctionEndDate'] ??
            json['AuctionEndDate'] ??
            json['finishedAt'] ??
            json['FinishedAt'] ??
            json['createdAt'] ??
            json['CreatedAt'],
      ),
      price: _selectPrice(
        status: status,
        startingPrice: startingPrice,
        currentPrice: currentPrice,
        finalPrice: finalPrice,
        fallbackPrice: fallbackPrice,
      ),
      imageUrl: _extractImageUrl(json),
      mileage: _formatMileage(
        json['mileage'] ??
            json['Mileage'] ??
            json['kilometers'] ??
            json['Kilometers'] ??
            json['distance'] ??
            json['Distance'],
      ),
    );
  }
}

class HistoryPage {
  final List<HistoryItem> items;
  final int totalCount;
  final int page;
  final int pageSize;

  const HistoryPage({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
  });

  bool get hasMore => page * pageSize < totalCount;

  factory HistoryPage.fromJson(
    dynamic data, {
    required int page,
    required int pageSize,
  }) {
    final map = data is Map<String, dynamic> ? data : null;
    final items = _extractItems(
      data,
    ).whereType<Map<String, dynamic>>().map(HistoryItem.fromJson).toList();

    final explicitTotal = _extractTotalCount(map);
    final resolvedTotal =
        explicitTotal ??
        ((items.length < pageSize)
            ? ((page - 1) * pageSize) + items.length
            : (page * pageSize) + 1);

    return HistoryPage(
      items: items,
      totalCount: resolvedTotal,
      page: _asInt(map?['page'] ?? map?['Page']) ?? page,
      pageSize: _asInt(map?['pageSize'] ?? map?['PageSize']) ?? pageSize,
    );
  }
}

List<dynamic> _extractItems(dynamic data) {
  if (data is List) return data;
  if (data is! Map<String, dynamic>) return const [];
  if (_looksLikeHistoryItem(data)) return [data];

  final direct = [
    data['items'],
    data['Items'],
    data['data'],
    data['Data'],
    data['results'],
    data['Results'],
    data['history'],
    data['History'],
    data['auctions'],
    data['Auctions'],
    data['records'],
    data['Records'],
    data['result'],
    data['Result'],
    data['payload'],
    data['Payload'],
    data['value'],
    data['Value'],
    data['list'],
    data['List'],
    data['rows'],
    data['Rows'],
  ];

  for (final value in direct) {
    if (value is List) return value;
    if (value is Map<String, dynamic>) {
      if (_looksLikeHistoryItem(value)) return [value];
      final nested = _extractItems(value);
      if (nested.isNotEmpty) return nested;
    }
  }

  return const [];
}

bool _looksLikeHistoryItem(Map<String, dynamic> json) {
  final title = _firstNonEmptyString([
    json['title'],
    json['Title'],
    json['name'],
    json['Name'],
    json['itemTitle'],
    json['ItemTitle'],
  ]);
  final id = _asInt(
    json['id'] ??
        json['Id'] ??
        json['auctionId'] ??
        json['AuctionId'] ??
        json['lotId'] ??
        json['LotId'],
  );
  final status = json['status'] ?? json['Status'] ?? json['auctionStatus'];
  return id != null || title != null || status != null;
}

int? _extractTotalCount(Map<String, dynamic>? map) {
  if (map == null) return null;

  final direct = _asInt(
    map['totalCount'] ??
        map['TotalCount'] ??
        map['count'] ??
        map['Count'] ??
        map['total'] ??
        map['Total'] ??
        map['totalItems'] ??
        map['TotalItems'] ??
        map['itemsCount'] ??
        map['ItemsCount'],
  );
  if (direct != null) return direct;

  final nested = map['data'] ?? map['Data'] ?? map['meta'] ?? map['Meta'];
  if (nested is Map<String, dynamic>) {
    return _extractTotalCount(nested);
  }

  return null;
}

AuctionStatus _parseStatus(dynamic raw) {
  if (raw is num) {
    switch (raw.toInt()) {
      case 1:
        return AuctionStatus.upcoming;
      case 2:
        return AuctionStatus.active;
      case 3:
        return AuctionStatus.endingSoon;
      case 4:
        return AuctionStatus.finished;
      case 5:
        return AuctionStatus.canceled;
      case 6:
        return AuctionStatus.sold;
    }
  }

  final value = raw?.toString().trim().toLowerCase() ?? '';
  if (value.contains('upcoming')) return AuctionStatus.upcoming;
  if (value.contains('active')) return AuctionStatus.active;
  if (value.contains('ending')) return AuctionStatus.endingSoon;
  if (value.contains('cancel')) return AuctionStatus.canceled;
  if (value.contains('sold')) return AuctionStatus.sold;
  return AuctionStatus.finished;
}

double _selectPrice({
  required AuctionStatus status,
  double? startingPrice,
  double? currentPrice,
  double? finalPrice,
  double? fallbackPrice,
}) {
  switch (status) {
    case AuctionStatus.upcoming:
    case AuctionStatus.canceled:
      return startingPrice ?? currentPrice ?? finalPrice ?? fallbackPrice ?? 0;
    case AuctionStatus.active:
    case AuctionStatus.endingSoon:
      return currentPrice ?? startingPrice ?? finalPrice ?? fallbackPrice ?? 0;
    case AuctionStatus.finished:
    case AuctionStatus.sold:
      return finalPrice ?? currentPrice ?? startingPrice ?? fallbackPrice ?? 0;
  }
}

String? _extractImageUrl(Map<String, dynamic> json) {
  final direct = _firstNonEmptyString([
    json['imageUrl'],
    json['ImageUrl'],
    json['image'],
    json['Image'],
    json['headImage'],
    json['HeadImage'],
    json['mainImage'],
    json['MainImage'],
    json['thumbnail'],
    json['Thumbnail'],
    json['coverImage'],
    json['CoverImage'],
  ]);
  if (direct != null) return direct;

  final nestedCandidates = [
    json['item'],
    json['Item'],
    json['product'],
    json['Product'],
    json['vehicle'],
    json['Vehicle'],
  ];

  for (final candidate in nestedCandidates) {
    if (candidate is Map<String, dynamic>) {
      final nested = _extractImageUrl(candidate);
      if (nested != null && nested.isNotEmpty) return nested;
    }
  }

  return null;
}

String? _formatMileage(dynamic raw) {
  if (raw == null) return null;
  if (raw is num) return NumberFormat('#,##0').format(raw);

  final parsed = num.tryParse(raw.toString().replaceAll(',', ''));
  if (parsed != null) return NumberFormat('#,##0').format(parsed);
  return raw.toString();
}

DateTime? _parseDate(dynamic raw) {
  if (raw == null) return null;
  if (raw is DateTime) return raw;
  return DateTime.tryParse(raw.toString());
}

double? _asDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString().replaceAll(',', ''));
}

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

String? _firstNonEmptyString(List<dynamic> values) {
  for (final value in values) {
    if (value == null) continue;
    final text = value.toString().trim();
    if (text.isNotEmpty && text.toLowerCase() != 'null') return text;
  }
  return null;
}
