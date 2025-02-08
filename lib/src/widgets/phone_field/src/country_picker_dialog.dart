import 'package:flutter/material.dart';
import 'package:xcomm/src/widgets/no_water_ripples_are_displayed.dart';
import 'countries.dart';
import 'helpers.dart';

class PickerDialogStyle {
  final Color? backgroundColor;

  final TextStyle? countryCodeStyle;

  final TextStyle? countryNameStyle;

  final Widget? listTileDivider;

  final EdgeInsets? listTilePadding;

  final EdgeInsets? padding;

  final Color? searchFieldCursorColor;

  final InputDecoration? searchFieldInputDecoration;

  final EdgeInsets? searchFieldPadding;

  final double? width;

  PickerDialogStyle({
    this.backgroundColor,
    this.countryCodeStyle,
    this.countryNameStyle,
    this.listTileDivider,
    this.listTilePadding,
    this.padding,
    this.searchFieldCursorColor,
    this.searchFieldInputDecoration,
    this.searchFieldPadding,
    this.width,
  });
}

class CountryPickerDialog extends StatefulWidget {
  final List<Country> countryList;
  final Country selectedCountry;
  final ValueChanged<Country> onCountryChanged;
  final String searchText;
  final List<Country> filteredCountries;
  final PickerDialogStyle? style;
  final String languageCode;

  const CountryPickerDialog({
    super.key,
    required this.searchText,
    required this.languageCode,
    required this.countryList,
    required this.onCountryChanged,
    required this.selectedCountry,
    required this.filteredCountries,
    this.style,
  });

  @override
  State<CountryPickerDialog> createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<CountryPickerDialog> {
  late List<Country> _filteredCountries;
  late Country _selectedCountry;

  @override
  void initState() {
    _selectedCountry = widget.selectedCountry;
    _filteredCountries = widget.filteredCountries.toList()
      ..sort(
        (a, b) => a
            .localizedName(widget.languageCode)
            .compareTo(b.localizedName(widget.languageCode)),
      );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 600),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          top: false,
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_filteredCountries.length > 10)
                  Padding(
                    padding: widget.style?.searchFieldPadding ??
                        const EdgeInsets.all(0),
                    child: TextField(
                      cursorColor: widget.style?.searchFieldCursorColor,
                      decoration: widget.style?.searchFieldInputDecoration ??
                          InputDecoration(
                            suffixIcon: const Icon(Icons.search),
                            labelText: widget.searchText,
                          ),
                      onChanged: (value) {
                        _filteredCountries =
                            widget.countryList.stringSearch(value)
                              ..sort(
                                (a, b) => a
                                    .localizedName(widget.languageCode)
                                    .compareTo(
                                        b.localizedName(widget.languageCode)),
                              );
                        if (mounted) setState(() {});
                      },
                    ),
                  ),
                const SizedBox(height: 20),
                Expanded(
                  child: NoWaterRipplesAreDisplayed(
                    child: SingleChildScrollView(
                      child: Column(
                        children: _filteredCountries
                            .map((item) => ListTile(
                                  leading: Container(
                                    width: 32,
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'assets/flags/${item.code.toLowerCase()}.png',
                                      package: 'xcomm',
                                    ),
                                  ),
                                  contentPadding: widget.style?.listTilePadding,
                                  title: Text(
                                    item.localizedName(widget.languageCode),
                                    style: widget.style?.countryNameStyle ??
                                        const TextStyle(
                                            fontWeight: FontWeight.w700),
                                  ),
                                  trailing: Text(
                                    '+${item.dialCode}',
                                    style: widget.style?.countryCodeStyle ??
                                        const TextStyle(
                                            fontWeight: FontWeight.w700),
                                  ),
                                  onTap: () {
                                    _selectedCountry = item;
                                    widget.onCountryChanged(_selectedCountry);
                                    Navigator.of(context).pop();
                                  },
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
