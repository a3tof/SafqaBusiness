class CategoryAttributeModel {
  final int id;
  final String name;
  final int dataType;
  final int unit;
  final bool isRequired;

  const CategoryAttributeModel({
    required this.id,
    required this.name,
    required this.dataType,
    required this.unit,
    required this.isRequired,
  });

  factory CategoryAttributeModel.fromJson(Map<String, dynamic> json) {
    return CategoryAttributeModel(
      id: (json['id'] ?? 0) as int,
      name: (json['name'] ?? '') as String,
      dataType: (json['dataType'] ?? 1) as int,
      unit: (json['unit'] ?? 0) as int,
      isRequired: (json['isRequired'] ?? false) as bool,
    );
  }

  bool get isTextLike => dataType == 1 || dataType == 7;
  bool get isNumber => dataType == 2;
  bool get isBoolean => dataType == 4;
  bool get isDate => dataType == 5;
  bool get isDateTime => dataType == 6;

  String get unitLabel {
    switch (unit) {
      case 1:
        return 'cm';
      case 2:
        return 'm';
      case 3:
        return 'inch';
      case 4:
        return 'g';
      case 5:
        return 'kg';
      case 6:
        return 'lb';
      case 7:
        return 'l';
      case 8:
        return 'ml';
      case 9:
        return 'm²';
      case 10:
        return 'sec';
      case 11:
        return 'min';
      case 12:
        return 'hr';
      default:
        return '';
    }
  }
}
