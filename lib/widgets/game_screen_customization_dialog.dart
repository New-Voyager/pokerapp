import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:provider/provider.dart';

abstract class GameScreenCustomizationDialog {
  Future<CustomizationAsset> show(
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

  const _AssetWidget({
    @required this.asset,
    this.isSelected = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();

    return Container(
      decoration: AppDecorators.tileDecoration(theme),
      child: ClipRRect(
        child: Image.asset(
          asset,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _CustomizationSelectionWidget extends StatelessWidget {
  final String heading;
  final String currentSelected;
  final List<String> assets;

  _CustomizationSelectionWidget({
    @required this.heading,
    @required this.currentSelected,
    @required this.assets,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // heading
        Text(heading),

        // show selectables
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: assets
                .map<Widget>((asset) => _AssetWidget(
                      asset: asset,
                      isSelected: currentSelected == asset,
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: AnimatedBuilder(
          animation: currentSelection,
          builder: (_, __) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // heading
                Text(
                  'Game Screen Customization',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                // sep
                const SizedBox(height: 20),

                // back drop
                _CustomizationSelectionWidget(
                  heading: 'Backdrop',
                  currentSelected: currentSelection.backdrop,
                  assets: AppAssets.backdrops,
                ),

                // sep
                const SizedBox(height: 15),

                // table
                _CustomizationSelectionWidget(
                  heading: 'Table',
                  currentSelected: currentSelection.table,
                  assets: AppAssets.tables,
                ),

                // sep
                const SizedBox(height: 15),

                // card back
                _CustomizationSelectionWidget(
                  heading: 'Card Back',
                  currentSelected: currentSelection.cardBack,
                  assets: AppAssets.cards,
                ),

                // close & confirm buttons
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text('Close'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('Confirm'),
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }
}
