library dropdownfield;

import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../generated/l10n.dart';

class DropDownField extends FormField<String> {
  final String? value;
  final Widget? icon;
  final String? hintText;
  final TextStyle hintStyle;
  final String? labelText;
  final TextStyle labelStyle;
  final TextStyle textStyle;
  final bool required;
  @override
  final bool enabled;
  final List<String>? items;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldSetter<String>? setter;
  final ValueChanged<String>? onValueChanged;
  final bool strict;
  final int itemsVisibleInDropdown;
  final TextEditingController? controller;

  DropDownField({
    super.key,
    required BuildContext context, // 'BuildContext' no puede estar en minúscula
    this.controller,
    this.value,
    this.required = false,
    this.icon,
    this.hintText,
    this.hintStyle = const TextStyle(
        fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 18.0),
    this.labelText,
    this.labelStyle = const TextStyle(
        fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 18.0),
    this.inputFormatters,
    this.items,
    this.textStyle = const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: 14.0), // Cambiado el color a negro
    this.setter,
    this.onValueChanged,
    this.itemsVisibleInDropdown = 3,
    this.enabled = true,
    this.strict = true,
  }) : super(
          initialValue: controller?.text ?? (value ?? ''),
          onSaved: setter,
          builder: (FormFieldState<String> field) {
            final DropDownFieldState state = field as DropDownFieldState;
            final ScrollController scrollController = ScrollController();
            final InputDecoration effectiveDecoration = InputDecoration(
                border: InputBorder.none,
                filled: true,
                icon: icon,
                suffixIcon: IconButton(
                    icon: Icon(Icons.arrow_drop_down,
                        size: 30.0,
                        color: Theme.of(context).colorScheme.onSurface,
                        semanticLabel: S.of(context).semanticlabelShowCenters),
                    onPressed: () {
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      state.setState(() {
                        state._showdropdown = !state._showdropdown;
                      });
                    }),
                hintStyle: hintStyle,
                labelStyle: labelStyle,
                hintText: hintText,
                labelText: labelText);

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: state._effectiveController,
                        decoration: effectiveDecoration.copyWith(
                            errorText: field.errorText,
                            fillColor: Theme.of(context).colorScheme.onPrimary,
                            filled: true,
                            contentPadding: EdgeInsets.all(14)),
                        style: textStyle,
                        textAlign: TextAlign.start,
                        autofocus: false,
                        obscureText: false,
                        maxLines: 1,
                        validator: (String? newValue) {
                          if (required &&
                              (newValue == null || newValue.isEmpty)) {
                            return 'This field cannot be empty!';
                          }
                          if (items != null &&
                              strict &&
                              newValue != null &&
                              newValue.isNotEmpty &&
                              !items.contains(newValue)) {
                            return 'Invalid value in this field!';
                          }
                          return null;
                        },
                        onSaved: setter,
                        enabled: enabled,
                        inputFormatters: inputFormatters,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close,
                          semanticLabel: S.of(context).semanticlabelClose),
                      onPressed: () {
                        if (!enabled) return;
                        state.clearValue();
                      },
                    )
                  ],
                ),
                if (state._showdropdown)
                  Container(
                    alignment: Alignment.topCenter,
                    height: itemsVisibleInDropdown * 48.0,
                    width: MediaQuery.of(field.context).size.width,
                    child: ListView(
                      cacheExtent: 0.0,
                      scrollDirection: Axis.vertical,
                      controller: scrollController,
                      padding: EdgeInsets.only(left: 40.0),
                      children: items?.isNotEmpty ?? false
                          ? ListTile.divideTiles(
                                  context: field.context,
                                  tiles: state._getChildren(state._items!))
                              .toList()
                          : [],
                    ),
                  ),
              ],
            );
          },
        );

  @override
  DropDownFieldState createState() => DropDownFieldState();
}

class DropDownFieldState extends FormFieldState<String> {
  TextEditingController? _controller;
  bool _showdropdown = false;
  String _searchText = "";

  @override
  DropDownField get widget => super.widget as DropDownField;
  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  List<String>? get _items => widget.items;

  void clearValue() {
    setState(() {
      _effectiveController!.text = '';
    });
    if (widget.onValueChanged != null) {
      widget.onValueChanged!(''); // Llamamos a onChanged con el valor vacío
    }
  }

  @override
  void didUpdateWidget(DropDownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null) {
        _controller =
            TextEditingController.fromValue(oldWidget.controller!.value);
      }
      if (widget.controller != null) {
        setValue(widget.controller!.text);
        if (oldWidget.controller == null) _controller = null;
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    }
    _effectiveController!.addListener(_handleControllerChanged);
    _searchText = _effectiveController!.text;
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController!.text = widget.initialValue!;
    });
  }

  List<ListTile> _getChildren(List<String> items) {
    List<ListTile> childItems = [];

    String normalizedSearchText = removeDiacritics(_searchText.toUpperCase());

    for (var item in items) {
      String normalizedItem = removeDiacritics(item.toUpperCase());

      if (normalizedSearchText.isNotEmpty) {
        if (normalizedItem.contains(normalizedSearchText)) {
          childItems.add(_getListTile(item));
        }
      } else {
        childItems.add(_getListTile(item));
      }
    }
    return childItems;
  }

  ListTile _getListTile(String text) {
    return ListTile(
      dense: true,
      title: Text(text),
      onTap: () {
        setState(() {
          _effectiveController!.text = text;
          _handleControllerChanged();
          _showdropdown = false;
        });
        if (widget.onValueChanged != null) {
          widget.onValueChanged!(text);
        }
      },
    );
  }

  void _handleControllerChanged() {
    if (_effectiveController!.text != value) {
      didChange(_effectiveController!.text);
    }
    if (_effectiveController!.text.isEmpty) {
      setState(() {
        _searchText = "";
      });
    } else {
      setState(() {
        _searchText = _effectiveController!.text;
        _showdropdown = true;
      });
    }
  }
}
