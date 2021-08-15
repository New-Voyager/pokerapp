import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class RadioListWidget extends StatelessWidget {
  final List<int> values;
  final int defaultValue;
  final void Function(int value) onSelect;

  RadioListWidget({
    @required this.values,
    @required this.onSelect,
    this.defaultValue,
  });

  Widget _buildItem({
    AppTheme theme,
    int v,
  }) =>
      Consumer<ValueNotifier<int>>(
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
            height: 32.ph,
            width: 32.pw,
            alignment: Alignment.center,
            child: Text(
              v == -1 ? '∞' : v.toString(),
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
      child: Row(
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
    return ListenableProvider<ValueNotifier<int>>(
      create: (_) => ValueNotifier<int>(defaultValue),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 15.0,
        ),
        decoration: BoxDecoration(
          color: theme.secondaryColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: _buildItems(theme),
      ),
    );
  }
}
