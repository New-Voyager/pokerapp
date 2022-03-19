import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:provider/provider.dart';

const List<String> _emojis = [
  '😊',
  '😀',
  '😁',
  '😅',
  '😂',
  '😇',
  '😍',
  '😜',
  '🤔',
  '🙄',
  '😴',
  '🤐',
  '😔',
  '😑',
  '😧',
  '😥',
  '😩',
  '😡',
  '👻',
  '🤠',
  '😎',
  '🤡',
  '💋',
  '👏',
  '🤞',
  '🖕',
  '👍',
  '👎',
  '🙏',
];

class EmojiStickerPicker extends StatelessWidget {
  final Function onEmojiSelected;
  final Function onStickerSelected;

  EmojiStickerPicker({
    @required void this.onEmojiSelected(String _),
    void this.onStickerSelected(String _),
  });

  Tab _buildEmojiTab() {
    return Tab(
      icon: Text(
        '😂',
        style: TextStyle(
          fontSize: 25.0,
        ),
      ),
    );
  }

  Tab _buildStickerTab() {
    return Tab(
      icon: Text(
        '😂',
        style: TextStyle(
          fontSize: 25.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appTheme = context.read<AppTheme>();
    return Container(
      color: Colors.black,
      width: size.width,
      height: size.height * 0.25,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            // tabs
            TabBar(
              indicatorColor: appTheme.accentColor,
              tabs: [
                // emoji tab
                _buildEmojiTab(),

                // sticker tab
                _buildStickerTab(),
              ],
            ),

            // main body
            Expanded(
              child: TabBarView(
                children: [
                  // emoji body
                  _EmojisWidget(
                    key: const Key('emoji widget'),
                    onEmojiSelected: onEmojiSelected,
                  ),

                  // sticker body
                  _StickersWidget(
                    key: const Key('sticker widget'),
                    onStickerSelected: onStickerSelected,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmojisWidget extends StatelessWidget {
  final Function onEmojiSelected;

  const _EmojisWidget({
    Key key,
    @required void this.onEmojiSelected(String _),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _buildSingleEmojiChild(String emoji) => InkWell(
          onTap: () {
            onEmojiSelected(emoji);
          },
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              emoji,
              style: TextStyle(
                fontSize: 25.0,
              ),
            ),
          ),
        );

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Wrap(
        alignment: WrapAlignment.center,
        children:
            _emojis.map((emoji) => _buildSingleEmojiChild(emoji)).toList(),
      ),
    );
  }
}

class _StickersWidget extends StatelessWidget {
  final Function onStickerSelected;

  const _StickersWidget({
    Key key,
    @required void this.onStickerSelected(String _),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [],
      ),
    );
  }
}
