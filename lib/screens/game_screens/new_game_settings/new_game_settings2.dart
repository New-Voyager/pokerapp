import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/widgets/heading_widget.dart';
import 'package:pokerapp/widgets/radio_list_widget.dart';
import 'package:pokerapp/widgets/switch_widget.dart';
import 'package:pokerapp/widgets/text_input_widget.dart';

class NewGameSettings2 extends StatelessWidget {
  final String clubCode;
  NewGameSettings2(this.clubCode);

  Widget _buildLabel(String label) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
        ),
      );

  Widget _buildDecoratedContainer({
    Widget child,
    List<Widget> children,
  }) =>
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 15.0,
        ),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: children != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: children,
              )
            : child,
      );

  Widget _buildSeperator() => Container(
        color: Color(0x33ffffff),
        width: double.infinity,
        height: 1.0,
      );

  Widget _buildRadio({
    @required bool value,
    @required String label,
    @required void Function(bool v) onChange,
  }) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /* switch */
          SwitchWidget(
            label: label,
            value: value,
            onChange: onChange,
          ),

          /* seperator */
          _buildSeperator(),
        ],
      );

  static const sepV20 = const SizedBox(height: 20.0);
  static const sepV8 = const SizedBox(height: 8.0);

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.5,
            colors: [
              const Color(0xff033614),
              const Color(0xff02290F),
              const Color(0xff02290F),
              Colors.black,
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              addAutomaticKeepAlives: true,
              children: [
                /* HEADING */
                HeadingWidget(
                  heading: 'game settings',
                ),

                /* players */
                _buildLabel('Players'),
                sepV8,
                RadioListWidget(
                  values: [2, 4, 6, 8, 9],
                  onSelect: (int value) {},
                ),

                /* big blind & ante */
                sepV20,
                Row(
                  children: [
                    /* big blind */
                    Expanded(
                      child: TextInputWidget(
                        label: 'Big Blind',
                        minValue: 0.0,
                        maxValue: 100,
                        onChange: (value) {},
                      ),
                    ),

                    /* sep */

                    /* ante */
                    Expanded(
                      child: TextInputWidget(
                        label: 'Ante',
                        minValue: 0.0,
                        maxValue: 100,
                        onChange: (value) {},
                      ),
                    ),
                  ],
                ),

                /* buy in */
                sepV20,
                _buildLabel('Buyin'),
                sepV8,
                _buildDecoratedContainer(
                  child: Row(
                    children: [
                      /* min */
                      Expanded(
                        child: TextInputWidget(
                          label: 'min',
                          trailing: 'BB',
                          minValue: 0.0,
                          maxValue: 100,
                          onChange: (value) {},
                        ),
                      ),

                      /* max */
                      Expanded(
                        child: TextInputWidget(
                          label: 'max',
                          trailing: 'BB',
                          minValue: 0.0,
                          maxValue: 100,
                          onChange: (value) {},
                        ),
                      ),
                    ],
                  ),
                ),

                /* tips */
                sepV20,
                _buildLabel('Tips'),
                sepV8,
                _buildDecoratedContainer(
                  child: Row(
                    children: [
                      /* min */
                      Expanded(
                        child: TextInputWidget(
                          trailing: '%',
                          minValue: 0.0,
                          maxValue: 100,
                          onChange: (value) {},
                        ),
                      ),

                      /* max */
                      Expanded(
                        child: TextInputWidget(
                          leading: 'cap',
                          minValue: 0.0,
                          maxValue: 100,
                          onChange: (value) {},
                        ),
                      ),
                    ],
                  ),
                ),

                /* action time */
                sepV20,
                _buildLabel('Action Time (in seconds)'),
                sepV8,
                RadioListWidget(
                  values: [15, 20, 30, 45],
                  onSelect: (int value) {},
                ),

                /* game time */
                sepV20,
                _buildLabel('Game Time (in hours)'),
                sepV8,
                RadioListWidget(
                  values: [1, 2, 5, 10, 15, 24],
                  onSelect: (int value) {},
                ),

                /* sep */
                sepV20,

                /* buy in approval */
                _buildDecoratedContainer(
                  children: [
                    SwitchWidget(
                      label: 'Buyin Approval',
                      onChange: (bool value) {},
                    ),

                    // TODO: show only when approval is enabled
                    // buy in wait time
                    TextInputWidget(
                      label: 'Buyin wait time',
                      minValue: 0.0,
                      maxValue: 100,
                      onChange: (value) {},
                    ),

                    /* seperator */
                    sepV20,
                    _buildSeperator(),

                    /* sep */
                    sepV20,

                    SwitchWidget(
                      label: 'Break allowed',
                      onChange: (bool value) {},
                    ),

                    // TODO: show only when approval is enabled
                    // buy in wait time
                    TextInputWidget(
                      label: 'Max break time',
                      minValue: 0.0,
                      maxValue: 100,
                      onChange: (value) {},
                    ),
                  ],
                ),

                /* sep */
                sepV20,
                _buildDecoratedContainer(
                  children: [
                    /* UTG straddle */
                    _buildRadio(
                      label: 'UTG Straddle',
                      value: false,
                      onChange: (bool b) {},
                    ),

                    /* location check */
                    _buildRadio(
                      label: 'Location Check',
                      value: false,
                      onChange: (bool b) {},
                    ),

                    /* ip check */
                    _buildRadio(
                      label: 'IP Check',
                      value: false,
                      onChange: (bool b) {},
                    ),

                    /* waitlist */
                    _buildRadio(
                      label: 'Waitlist',
                      value: true,
                      onChange: (bool b) {},
                    ),

                    /* allow run it twice */
                    _buildRadio(
                      label: 'Allow run it twice',
                      value: false,
                      onChange: (bool b) {},
                    ),

                    /* shwo player buyin */
                    _buildRadio(
                      label: 'Show player buyin',
                      value: false,
                      onChange: (bool b) {},
                    ),
                  ],
                ),

                /* sep */
                sepV20,
              ],
            ),
          ),
        ),
      );
}
