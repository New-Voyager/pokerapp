import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:provider/provider.dart';

import 'buttons.dart';

abstract class GameScreenCustomizationDialog {
  static Future<CustomizationAsset> show(
    BuildContext context, {
    CustomizationAsset currentSelection,
  }) {
    return showDialog<CustomizationAsset>(
      context: context,
      builder: (_) => _CustomizationWidget(
        currentSelection: currentSelection ?? CustomizationAsset('', '', ''),
      ),
    );
  }
}

class CustomizationAsset extends ChangeNotifier {
  String _table;
  String get table => _table;
  set table(String a) {
    this._table = a;
    notifyListeners();
  }

  String _backdrop;
  String get backdrop => _backdrop;
  set backdrop(String a) {
    this._backdrop = a;
    notifyListeners();
  }

  String _cardBack;
  String get cardBack => _cardBack;
  set cardBack(String a) {
    this._cardBack = a;
    notifyListeners();
  }

  CustomizationAsset(
    this._table,
    this._backdrop,
    this._cardBack,
  );
}

class _AssetWidget extends StatelessWidget {
  final String asset;
  final bool isSelected;
  final bool isWide;
  final double width;
  final ValueChanged<String> onChanged;

  const _AssetWidget({
    @required this.asset,
    this.isSelected = false,
    this.isWide = false,
    this.width = 0,
    this.onChanged,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();
    double width = this.width;
    if (width == 0) {
      width = 100;
      if (isWide) {
        width = 200;
      }
    }
    return InkWell(
      onTap: () => onChanged?.call(asset),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: isSelected
            ? AppDecorators.accentBorderDecoration(theme)
            : AppDecorators.accentNoBorderDecoration(theme),
        height: 100.0,
        width: isWide ? 150.0 : 100.0,
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          asset,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _CustomizationSelectionWidget extends StatelessWidget {
  final String heading;
  final String currentSelected;
  final List<String> assets;
  final ValueChanged<String> onChanged;
  final bool isWide;

  _CustomizationSelectionWidget({
    @required this.heading,
    @required this.currentSelected,
    @required this.assets,
    @required this.onChanged,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // heading
        Text(heading),

        // sep
        const SizedBox(height: 8.0),

        // show selectables
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: assets
                .map<Widget>((asset) => _AssetWidget(
                      asset: asset,
                      isSelected: currentSelected == asset,
                      onChanged: onChanged,
                      isWide: isWide,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _CustomizationWidget extends StatelessWidget {
  final CustomizationAsset currentSelection;

  const _CustomizationWidget({
    Key key,
    this.currentSelection,
  }) : super(key: key);

  void _onClose(BuildContext context) {
    Navigator.pop(context);
  }

  void _onConfirm(BuildContext context) {
    Navigator.pop(context, currentSelection);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();

    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: AppDecorators.bgRadialGradient(theme).copyWith(
          border: Border.all(color: theme.accentColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: AnimatedBuilder(
          animation: currentSelection,
          builder: (_, __) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // heading
                Text(
                  'Customize',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                // sep
                const SizedBox(height: 10),

                // back drop
                _CustomizationSelectionWidget(
                  heading: 'Backdrop',
                  currentSelected: currentSelection.backdrop,
                  assets: AppAssets.backdrops,
                  onChanged: (String backdrop) {
                    currentSelection.backdrop = backdrop;
                  },
                ),

                // sep
                const SizedBox(height: 10),

                // table
                _CustomizationSelectionWidget(
                  heading: 'Table',
                  currentSelected: currentSelection.table,
                  assets: AppAssets.tables,
                  onChanged: (String table) {
                    currentSelection.table = table;
                  },
                  isWide: true,
                ),

                // sep
                const SizedBox(height: 10),

                // card back
                _CustomizationSelectionWidget(
                  heading: 'Card Back',
                  currentSelected: currentSelection.cardBack,
                  assets: AppAssets.cards,
                  onChanged: (String cardBack) {
                    currentSelection.cardBack = cardBack;
                  },
                ),

                // sep
                const SizedBox(height: 20),

                // close & confirm buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RoundRectButton(
                      onTap: () => _onClose(context),
                      text: 'Close',
                      theme: theme,
                    ),
                    RoundRectButton(
                      onTap: () => _onConfirm(context),
                      text: 'Confirm',
                      theme: theme,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
