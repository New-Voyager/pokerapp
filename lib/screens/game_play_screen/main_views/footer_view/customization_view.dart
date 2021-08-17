import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/game_circle_button.dart';

class HoleCardCustomizationView extends StatefulWidget {
  HoleCardCustomizationView();

  @override
  _HoleCardCustomizationViewState createState() => _HoleCardCustomizationViewState();
}

class _HoleCardCustomizationViewState extends State<HoleCardCustomizationView> {
  @override
  Widget build(BuildContext context) {
    log('CommunicationView:  ::build::');
    final theme = AppTheme.getTheme(context);
    List<Widget> children = [];
    children.add(GameCircleButton(
                          onClickHandler: () {},
                          child: Icon(
                            Icons.edit,
                            size: 24,
                            color: theme.primaryColorWithDark()
                          ),
                        ));
    return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: children,
                );
  }
}
