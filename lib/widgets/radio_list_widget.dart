import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class RadioListWidget<T> extends StatelessWidget {
  final List<T> values;
  final T defaultValue;
  final void Function(T value) onSelect;
  final int padding;
  final bool wrap;

  RadioListWidget({
    @required this.values,
    @required this.onSelect,
    this.defaultValue,
    this.padding = 5,
    this.wrap = true,
  });

  Widget _buildItem({
    AppTheme theme,
    T v,
  }) =>
      Consumer<ValueNotifier<T>>(
        builder: (_, vnCurrValue, __) => InkWell(
          onTap: () {
            vnCurrValue.value = v;
            onSelect(v);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              color: vnCurrValue.value == v
                  ? theme.accentColor
                  : theme.primaryColorWithDark(),
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: EdgeInsets.all(padding.toDouble()),
            height: 32.ph,
            alignment: Alignment.center,
            child: Text(
              v.toString(),
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

  Widget _buildItems(AppTheme theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Wrap(
        children: values
            .map<Widget>(
              (v) => _buildItem(v: v, theme: theme),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    return ListenableProvider<ValueNotifier<T>>(
      create: (_) => ValueNotifier<T>(defaultValue),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 15.0,
        ),
        decoration: BoxDecoration(
          color: theme.primaryColorWithDark(),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: _buildItems(theme),
      ),
    );
  }
}
