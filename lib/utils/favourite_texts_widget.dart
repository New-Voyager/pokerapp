import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_context_screen/game_chat/add_favourite_giphy.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class FavouriteTextWidget extends StatefulWidget {
  final void Function(String) onPresetTextSelect;
  FavouriteTextWidget({
    Key key,
    @required this.onPresetTextSelect,
  }) : super(key: key);

  @override
  _FavouriteTextWidgetState createState() => _FavouriteTextWidgetState();
}

class _FavouriteTextWidgetState extends State<FavouriteTextWidget> {
  List<String> _favouriteTexts = [];

  _fetchFavouriteTexts() async {
    final value = await GameService.getPresetTexts();
    setState(() => _favouriteTexts = value);
  }

  List _cleanTextIfLocal(String text) {
    final List<String> tmp = text.split(GameService.LOCAL_KEY);

    if (tmp.length == 1 || tmp.first.isNotEmpty) {
      return [false, text];
    }

    tmp.removeAt(0);

    return [true, tmp.join('')];
  }

  @override
  void initState() {
    super.initState();
    _fetchFavouriteTexts();
  }

  Widget _buildMessageItem(String text) {
    final ct = _cleanTextIfLocal(text);

    final bool isLocal = ct[0];
    final String cleanedText = ct[1];

    return Stack(
      children: [
        InkWell(
          onTap: () {
            widget.onPresetTextSelect(text);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                color: AppColorsNew.newGreenButtonColor,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              cleanedText,
              textAlign: TextAlign.center,
              style: AppStylesNew.clubItemInfoTextStyle.copyWith(
                fontSize: 15.0,
                color: AppColorsNew.newGreenButtonColor,
              ),
            ),
          ),
        ),
        isLocal
            ? Positioned(
                left: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: InkWell(
                    onTap: () async {
                      await GameService.removePresetText(text);
                      _fetchFavouriteTexts();
                    },
                    child: Icon(
                      Icons.close_rounded,
                      size: 17.0,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = AppTheme.getTheme(context);

    return Container(
      height: size.height * 0.20,
      color: Colors.black,
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(
                right: 60.0,
                bottom: 30,
                top: 10,
              ),
              child: Wrap(
                children: [
                  ..._favouriteTexts
                      .map((text) => _buildMessageItem(
                            text,
                          ))
                      .toList(),
                ],
              ),
            ),
          ),
          (_favouriteTexts.length == 0)
              ? Center(
                  child: CircularProgressIndicator(color: theme.accentColor),
                )
              : Container(),
          Positioned(
            bottom: 16.pw,
            right: 16.pw,
            child: FloatingActionButton.small(
              backgroundColor: theme.accentColor,
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: AppColorsNew.darkGreenShadeColor,
                    content: AddFavouriteGiphy(),
                  ),
                );
                _fetchFavouriteTexts();
              },
              child: Icon(
                Icons.add,
              ),
            ),
          )
        ],
      ),
    );
  }
}
