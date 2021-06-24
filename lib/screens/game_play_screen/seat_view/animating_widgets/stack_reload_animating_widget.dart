import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';

class StackReloadAnimatingWidget extends StatefulWidget {
  final StackReloadState stackReloadState;
  final Function(int stack) stackTextBuilder;

  StackReloadAnimatingWidget({
    @required this.stackReloadState,
    @required this.stackTextBuilder,
  });

  @override
  _StackReloadAnimatingWidgetState createState() =>
      _StackReloadAnimatingWidgetState();
}

class _StackReloadAnimatingWidgetState
    extends State<StackReloadAnimatingWidget> {
  StackReloadState get srs => widget.stackReloadState;
  Function(int stack) get stackTextBuilder => widget.stackTextBuilder;

  Widget _currentWidget;

  Widget _buildStackText(int value) => Container(
        key: UniqueKey(),
        child: stackTextBuilder(value),
      );

  Widget _buildLoadedAmountText(int value) => Text(
        '+ $value',
        style: TextStyle(
          fontSize: 5.0,
          color: AppColorsNew.yellowAccentColor,
          fontWeight: FontWeight.w900,
        ),
      );

  @override
  void initState() {
    super.initState();

    _currentWidget = _buildStackText(srs.oldStack);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _currentWidget = _buildStackText(srs.newStack));
    });
  }

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.center,
        children: [
          // fade out fade in new stack transition
          AnimatedSwitcher(
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
            child: _currentWidget,
          ),

          // load amount animation
          TweenAnimationBuilder(
            curve: Curves.easeOut,
            tween: Tween<double>(
              begin: 0,
              end: 1,
            ),
            duration: const Duration(milliseconds: 1500),
            child: Transform.scale(
              scale: 4.0,
              child: _buildLoadedAmountText(srs.reloadAmount),
            ),
            builder: (_, v, child) => Opacity(
              opacity: 1 - v,
              child: Transform.translate(
                // TODO: THE OFFSET NEEDS TO BE CHECKED FOR OTHER SEATS
                offset: Offset(50.0, -v * 40),
                child: child,
              ),
            ),
          ),
        ],
      );
}
