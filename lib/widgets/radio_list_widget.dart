import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RadioListWidget extends StatelessWidget {
  static const Size itemSize = Size(40.0, 40.0);

  final List<int> values;
  final int defaultValue;
  final void Function(int value) onSelect;

  RadioListWidget({
    @required this.values,
    @required this.onSelect,
    this.defaultValue,
  });

  Widget _buildItem({
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
                  ? Color(0xffC48F3A)
                  : Color(0x3340D876),
              borderRadius: BorderRadius.circular(5.0),
            ),
            height: itemSize.height,
            width: itemSize.width,
            alignment: Alignment.center,
            child: Text(
              v.toString(),
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
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

  Widget _buildItems() => Row(
        children: values
            .map<Widget>(
              (v) => _buildItem(v: v),
            )
            .toList(),
      );

  @override
  Widget build(BuildContext _) {
    return ListenableProvider<ValueNotifier<int>>(
      create: (_) => ValueNotifier<int>(defaultValue),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 15.0,
        ),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: _buildItems(),
      ),
    );
  }
}
