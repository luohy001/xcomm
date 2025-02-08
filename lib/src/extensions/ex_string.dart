/// 扩展String
extension ExString on String? {
  /// 是否为空或null
  bool get isEmptyOrNull => _isEmptyOrNull();

  /// 是否不为空或null
  bool get isNotEmptyOrNull => !_isEmptyOrNull();

  bool _isEmptyOrNull() {
    if (this == null) {
      return true;
    }
    return this!.isEmpty;
  }

  /// 转为int类型
  int? toInt({int defValue = 0}) {
    if (this == null) {
      return null;
    }
    return int.tryParse(this!) ?? defValue;
  }

  /// 转为double类型
  double? toDouble({double defValue = 0}) {
    if (this == null) {
      return null;
    }
    return double.tryParse(this!) ?? defValue;
  }

  /// 转为num类型
  num? toNumber({num defValue = 0}) {
    if (this == null) {
      return null;
    }
    return num.tryParse(this!) ?? defValue;
  }
}
