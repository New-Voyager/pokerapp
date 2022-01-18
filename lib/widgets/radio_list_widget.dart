import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/widgets/texts.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class RadioListWidget<T> extends StatelessWidget {
  final List<T> values;
  final T defaultValue;
  final void Function(T value) onSelect;
  final int padding;
  final bool border;
  final bool wrap;
  final String label;

  RadioListWidget({
    Key key,
    @required this.values,
    @required this.onSelect,
    this.defaultValue,
    this.label = '',
    this.padding = 3,
    this.wrap = true,
    this.border = false,
  }) : super(key: key);

  Widget _buildItem({
    AppTheme theme,
    T v,
  }) {
    return Consumer<ValueNotifier<T>>(builder: (_, vnCurrValue, __) {
      Color borderColor = theme.primaryColorWithDark();
      if (vnCurrValue.value == v) {
        borderColor = theme.accentColor;
      }
      // color: vnCurrValue.value == v
      //     ? theme.accentColor
      //     : theme.primaryColorWithDark(),
      return InkWell(
        onTap: () {
          vnCurrValue.value = v;
          onSelect(v);
        },
        child: IntrinsicWidth(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: borderColor,
            ),
            padding: EdgeInsets.all(padding.toDouble()),
            height: 32.ph,
            alignment: Alignment.center,
            child: Text(
              (v is GameType) ? '${gameTypeShortStr(v)}' : v.toString(),
              style: TextStyle(
                fontSize: 10.dp,
                color: theme.supportingColor,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black,
                    offset: Offset.zero,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildItems(AppTheme theme) {
    return Wrap(
      children: values
          .map<Widget>(
            (v) => _buildItem(v: v, theme: theme),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    Widget choices = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 5.0,
        vertical: 5.0,
      ),
      decoration: BoxDecoration(
        color: theme.primaryColorWithDark(),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: _buildItems(theme),
    );

    Widget child = choices;
    // if (label != null && label.isNotEmpty) {
    //   child = Row(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     children: [
    //       LabelText(label: label, theme: theme),
    //       SizedBox(width: 20),
    //       choices,
    //     ],
    //   );
    // }
    return ListenableProvider<ValueNotifier<T>>(
      create: (_) => ValueNotifier<T>(defaultValue),
      child: child,
    );
  }
}

class RadioToggleButtonsWidget<T> extends StatelessWidget {
  final List<T> values;
  final List<bool> isSelected = [];

  final int defaultValue;
  final void Function(int value) onSelect;
  final ValueNotifier vnCurrValue = ValueNotifier<int>(0);

  RadioToggleButtonsWidget({
    Key key,
    @required this.values,
    @required this.onSelect,
    this.defaultValue,
  }) : super(key: key) {
    vnCurrValue.value = 0;
    if (this.defaultValue != null) {
      vnCurrValue.value = this.defaultValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    Map<int, Widget> children = Map<int, Widget>();
    int i = 0;
    for (final value in values) {
      children[i] = Text(value.toString(),
          textAlign: TextAlign.center,
          style: AppDecorators.getHeadLine6Style(theme: theme));
      i++;
    }
    return ValueListenableBuilder(
        valueListenable: vnCurrValue,
        builder: (_, __, ___) {
          return CupertinoSlidingSegmentedControl(
              groupValue: vnCurrValue.value,
              children: children,
              thumbColor: theme.accentColor,
              onValueChanged: (value) {
                vnCurrValue.value = value;
                if (this.onSelect != null) {
                  this.onSelect(value);
                }
              });
        });
  }
}
