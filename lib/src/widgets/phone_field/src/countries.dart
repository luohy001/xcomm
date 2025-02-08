const List<Country> countries = [
  Country(
    name: "Malaysia",
    nameTranslations: {
      "zh": "马来西亚",
      "en": "Malaysia",
    },
    flag: "🇲🇾",
    code: "MY",
    dialCode: "60",
    minLength: 9,
    maxLength: 10,
  ),
  Country(
    name: "Singapore",
    nameTranslations: {
      "zh": "新加坡",
      "en": "Singapore",
    },
    flag: "🇸🇬",
    code: "SG",
    dialCode: "65",
    minLength: 8,
    maxLength: 8,
  ),
];

class Country {
  final String name;
  final Map<String, String> nameTranslations;
  final String flag;
  final String code;
  final String dialCode;
  final String regionCode;
  final int minLength;
  final int maxLength;

  const Country({
    required this.name,
    required this.flag,
    required this.code,
    required this.dialCode,
    required this.nameTranslations,
    required this.minLength,
    required this.maxLength,
    this.regionCode = "",
  });

  String get fullCountryCode {
    return dialCode + regionCode;
  }

  String get displayCC {
    if (regionCode != "") {
      return "$dialCode $regionCode";
    }
    return dialCode;
  }

  String localizedName(String languageCode) {
    return nameTranslations[languageCode] ?? name;
  }
}
