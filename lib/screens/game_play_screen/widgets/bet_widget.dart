import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/game_play_models/provider_models/player_action.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/pulsating_button.dart';
import 'package:pokerapp/services/data/box_type.dart';
import 'package:pokerapp/services/data/hive_datasource_impl.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/numeric_keyboard2.dart';
import 'package:provider/provider.dart';
import 'package:simple_tooltip/simple_tooltip.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class BetWidget extends StatelessWidget {
  final Function onSubmitCallBack;
  final PlayerAction action;
  final int remainingTime;

  BetWidget({
    @required this.action,
    this.onSubmitCallBack,
    this.remainingTime,
  });

  Widget betButton1(ValueNotifier<double> vnVal) {
    return Container(
      width: 60.pw,
      height: 74.ph,
      child: Stack(fit: StackFit.expand, children: [
        PulsatingCircleIconButton(
          onTap: () => onSubmitCallBack?.call(vnVal.value),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DataFormatter.chipsFormat(
                  vnVal.value,
                ),
                style: TextStyle(
                  fontSize: 10.dp,
                  color: Colors.white,
                ),
              ),
              //  SizedBox(height: 5),
              Text(
                "BET",
                style: TextStyle(
                  fontSize: 10.dp,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }

  // TODO: MAKE THIS CLASS A GENERAL ONE SOMEWHERE OUTSIDE IN UTILS
  // WE CAN REUSE THIS CLASS FOR OTHER PLACES AS WELL
  Widget _buildToolTipWith({Widget child}) {
    final userSettingsBox = HiveDatasource.getInstance.getBox(
      BoxType.USER_SETTINGS_BOX,
    );

    final betTooltipCountKey = 'bet_tooltip_count';

    int betTooltipCount =
        userSettingsBox.get(betTooltipCountKey, defaultValue: 0) as int;

    if (betTooltipCount >= 3) {
      // we dont need to show BET tooltip anymore
      return child;
    }

    // else
    // increment the tool tip count
    userSettingsBox.put(betTooltipCountKey, betTooltipCount + 1);

    return SimpleTooltip(
      // ui
      backgroundColor: Colors.white,
      borderColor: AppColorsNew.newTextGreenColor,
      ballonPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),

      // others
      animationDuration: Duration(seconds: 1),
      show: true,
      tooltipDirection: TooltipDirection.right,
      content: Text(
        "Tap or slide-up to confirm bet",
        style: TextStyle(
          color: Colors.black,
          fontSize: 13,
          decoration: TextDecoration.none,
        ),
      ),
      child: child,
    );
  }

  String _getBetChipSvg() {
    String primaryColor = '#168348';
    String accentColor = '#C8923B';

    return """<svg width="124" height="125" viewBox="0 0 124 125" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M13.6747 64.3028C12.8901 63.5182 12.7324 63.1576 12.7324 62.1474C12.7324 60.7622 13.245 59.8816 14.3983 59.2852C16.0297 58.4416 17.908 59.0622 18.6862 60.7021C19.2171 61.8209 19.2171 62.5644 18.686 63.5913C18.1673 64.5944 16.9643 65.245 15.6283 65.245C14.8476 65.245 14.402 65.0301 13.6747 64.3028V64.3028Z" fill="$accentColor"/>
<path d="M37.8125 24.9499C36.5781 24.405 35.9618 23.5646 35.8102 22.2194C35.6965 21.211 35.7925 20.8776 36.4063 20.1481C37.895 18.3789 39.941 18.3717 41.4208 20.1303C42.7681 21.7315 42.0704 24.088 39.9919 24.9565C38.8951 25.4147 38.8654 25.4146 37.8125 24.9499V24.9499Z" fill="$accentColor"/>
<path d="M82.9568 24.1192C81.8949 23.0573 81.7068 21.7493 82.418 20.3739C82.9481 19.3488 84.5632 18.584 85.7342 18.8037C87.6854 19.1698 88.9022 21.6013 88.0037 23.3389C87.3785 24.548 86.5166 25.0614 85.1122 25.0614C84.102 25.0614 83.7414 24.9038 82.9568 24.1192V24.1192Z" fill="$accentColor"/>
<path d="M106.956 64.7709C105.743 64.1508 104.895 62.5478 105.155 61.3655C105.255 60.9071 105.711 60.1583 106.168 59.7016C107.364 58.5058 109.319 58.5058 110.515 59.7016C111.569 60.7549 111.818 61.8537 111.29 63.1163C110.552 64.8844 108.62 65.6217 106.956 64.7709Z" fill="$accentColor"/>
<path d="M83.1738 104.368C82.1931 103.451 81.8017 101.921 82.3009 100.955C82.8994 99.7958 83.7441 99.0673 84.6962 98.8887C86.6718 98.5181 88.3885 100.013 88.3885 102.104C88.3885 103.057 88.2184 103.437 87.4463 104.209C86.6542 105.001 86.3055 105.152 85.2585 105.152C84.2739 105.152 83.8373 104.987 83.1738 104.368Z" fill="$accentColor"/>
<path d="M37.7642 105.024C35.2013 103.909 35.28 100.234 37.8901 99.143C41.6411 97.5757 43.9951 103.244 40.3179 104.989C39.2051 105.517 38.9067 105.521 37.7642 105.024V105.024Z" fill="$accentColor"/>
<path d="M9.28813 79.4106C8.97714 78.9074 7.50172 72.7813 7.14463 70.5105C6.5703 66.8583 6.6524 55.7969 7.2773 52.6357C7.93168 49.3253 9.09204 44.9416 9.39379 44.6398C9.60461 44.429 26.7191 49.9317 27.6071 50.4958C27.8535 50.6524 27.8357 51.1049 27.5334 52.3619C25.9549 58.9275 25.9282 65.1259 27.4526 71.1661C27.7551 72.365 27.9652 73.3788 27.9193 73.419C27.7631 73.5559 9.92667 79.6557 9.68262 79.6557C9.54897 79.6557 9.37145 79.5454 9.28813 79.4106V79.4106ZM18.1551 64.8426C20.0254 63.6172 19.7301 60.0487 17.6702 58.9835C16.4567 58.356 14.3229 58.582 13.4158 59.4342C11.4634 61.2684 12.2966 64.8008 14.844 65.4894C15.7962 65.7468 17.1909 65.4744 18.1551 64.8426V64.8426Z" fill="$primaryColor"/>
<path d="M33.2379 36.5239C32.2483 35.6644 28.9626 32.7807 25.9364 30.1156L20.4341 25.2699L22.7494 22.9276C29.5332 16.0647 37.9998 11.1087 47.2901 8.56255C49.217 8.03444 50.8824 7.60236 50.9911 7.60236C51.2989 7.60236 54.9375 26.4801 54.6741 26.7106C54.5455 26.8232 53.1314 27.323 51.5317 27.8213C46.2093 29.4792 41.5065 32.228 37.3569 36.1065C36.1918 37.1955 35.1932 38.0865 35.1378 38.0865C35.0825 38.0865 34.2275 37.3833 33.2379 36.5239ZM40.3904 25.2284C42.784 23.9906 43.1952 21.2184 41.2602 19.3646C40.5284 18.6634 40.1945 18.5489 38.8816 18.5489C37.4718 18.5489 37.2813 18.6286 36.4056 19.5841C35.6015 20.4616 35.457 20.8216 35.457 21.9473C35.457 23.4512 35.9339 24.2991 37.2214 25.0842C38.2503 25.7116 39.3585 25.762 40.3904 25.2284Z" fill="$primaryColor"/>
<path d="M87.2705 36.5302C83.3507 32.5029 77.9155 29.3301 71.8993 27.5573C69.5846 26.8753 69.4113 26.774 69.4901 26.1498C69.7333 24.2229 72.9408 7.98755 73.1136 7.8086C73.2249 7.69339 74.6674 7.97862 76.3192 8.44244C86.5696 11.3207 94.3712 15.8323 101.388 22.9394L103.718 25.2995L102.219 26.6686C99.2544 29.3772 89.1465 38.0865 88.9678 38.0865C88.8674 38.0865 88.1036 37.3862 87.2705 36.5302V36.5302ZM86.2218 25.3386C86.5294 25.3386 87.2203 24.8994 87.7572 24.3625C88.6891 23.4306 88.7274 23.3159 88.6035 21.8227C88.4902 20.4566 88.3464 20.1421 87.4653 19.3347C86.6441 18.5821 86.2318 18.4104 85.2465 18.4104C81.9724 18.4104 80.3279 22.2718 82.6665 24.4688C83.3832 25.1421 84.7025 25.6365 85.2934 25.4531C85.4964 25.3901 85.9142 25.3386 86.2218 25.3386V25.3386Z" fill="$primaryColor"/>
<path d="M105.134 76.56L96.2447 73.4913L96.9327 70.6845C97.5538 68.1511 97.6211 67.311 97.6236 62.0581C97.6261 56.7995 97.56 55.9658 96.9384 53.4118L96.2504 50.5853L101.873 48.6423C109.051 46.1615 114.709 44.361 114.857 44.5098C115.163 44.8154 116.676 51.3797 117.087 54.1858C117.454 56.6867 117.522 58.6168 117.411 63.443C117.27 69.6034 117.015 71.675 115.828 76.3168C115.151 78.9649 114.844 79.6616 114.36 79.6422C114.174 79.6348 110.023 78.2478 105.134 76.56V76.56ZM110.031 65.093C111.788 64.1844 112.454 61.7893 111.422 60.096C110.87 59.1914 109.356 58.3168 108.342 58.3168C107.316 58.3168 105.886 59.1597 105.298 60.1111C103.41 63.166 106.818 66.7541 110.031 65.093V65.093Z" fill="$primaryColor"/>
<path d="M73.0408 116.29C72.8734 116.019 69.2356 97.3243 69.3351 97.246C69.3736 97.2156 70.5899 96.8548 72.0379 96.4442C77.2743 94.9592 82.6485 91.8933 86.7065 88.0757C87.9315 86.9234 89.0489 86.0228 89.1896 86.0744C89.3304 86.126 92.2084 88.6001 95.5853 91.5723C98.9623 94.5445 102.185 97.377 102.747 97.8669L103.769 98.7575L102.106 100.461C94.758 107.991 86.547 112.888 76.7711 115.57C72.8224 116.653 73.2178 116.576 73.0408 116.29V116.29ZM87.2068 104.976C88.2252 104.341 88.7544 103.277 88.7336 101.907C88.7012 99.7608 87.3637 98.5122 85.0893 98.5046C84.0211 98.5012 83.7355 98.6404 82.803 99.6207C81.9305 100.538 81.7374 100.942 81.7374 101.851C81.7374 103.024 82.2419 104.258 82.9679 104.861C83.9754 105.697 85.9647 105.751 87.2068 104.976V104.976Z" fill="$primaryColor"/>
<path d="M46.8192 115.402C40.2173 113.365 35.2919 111.049 30.563 107.757C28.1894 106.105 23.4969 102.049 21.3487 99.7916L20.4041 98.7991L20.9757 98.3034C21.2901 98.0307 24.5512 95.1576 28.2226 91.9187C31.894 88.6797 34.9724 86.0297 35.0634 86.0297C35.1545 86.0297 36.1844 86.9099 37.3522 87.9858C41.5884 91.8888 46.9814 94.9745 52.139 96.4467C53.5571 96.8514 54.7607 97.221 54.8136 97.268C54.9473 97.3868 51.8724 113.273 51.37 115.059C51.1449 115.859 50.8083 116.504 50.622 116.493C50.4357 116.481 48.7245 115.99 46.8192 115.402V115.402ZM40.9469 105.144C43.7044 103.463 42.7634 98.9396 39.5815 98.5809C38.0274 98.4057 36.7639 98.9931 36 100.246C34.0561 103.434 37.751 107.093 40.9469 105.144Z" fill="$primaryColor"/>
<path d="M57.0446 124.078C37.5403 122.253 20.9152 112.352 10.0709 96.1024C5.36632 89.0529 1.90912 80.0274 0.506946 71.1342C-0.167459 66.8569 -0.169337 57.0411 0.503458 52.8978C2.67307 39.5367 8.62626 27.8028 18.017 18.3784C23.3819 12.9942 27.7012 9.88087 34.5183 6.48428C51.8177 -2.13508 71.8349 -2.16257 89.239 6.40914C96.1125 9.79441 100.633 13.0608 106.144 18.6244C115.821 28.3941 121.586 40.1465 123.622 54.2553C124.266 58.7129 124.057 68.3168 123.222 72.7266C119.066 94.657 104.816 111.982 84.2894 120.059C76.1873 123.248 65.3146 124.851 57.0446 124.078V124.078ZM79.8166 115.454C86.6234 113.268 93.6596 109.209 99.0948 104.332C103.212 100.637 104.43 99.2957 104.211 98.6967C104.107 98.413 102.879 97.1673 101.481 95.9285C96.9494 91.9137 91.2085 86.9072 89.9849 85.9034L88.7909 84.924L86.6593 87.0251C82.6431 90.9841 77.8838 93.8659 72.597 95.5402C68.8243 96.7349 68.4343 96.9505 68.5451 97.7794C68.9233 100.609 72.2937 117.054 72.5245 117.196C72.9307 117.447 75.5745 116.815 79.8166 115.454V115.454ZM51.6351 116.477C52.0426 115.583 55.2908 98.8636 55.2908 97.6606C55.2908 96.7566 55.2549 96.7294 53.4201 96.2418C47.5893 94.6922 42.013 91.5382 37.4241 87.1945L35.0786 84.9742L32.7832 86.9083C28.3639 90.632 19.7121 98.4616 19.5896 98.848C19.4485 99.2931 24.1491 103.93 27.2383 106.393C32.7178 110.763 38.66 113.789 46.4226 116.164C50.3424 117.363 51.2077 117.415 51.6351 116.477V116.477ZM17.65 77.7844C22.1196 76.245 26.3689 74.7871 27.0929 74.5445C28.6499 74.0229 28.6649 73.9412 27.8475 70.4358C26.6677 65.3757 26.6599 58.804 27.828 53.8878C28.6827 50.2904 28.6718 50.237 26.9544 49.5956C24.4238 48.6506 10.5733 44.0728 9.65162 43.8767L8.76873 43.6889L8.07674 45.8795C5.31491 54.6223 5.0287 66.3796 7.35192 75.6559C8.24043 79.2036 8.74406 80.5832 9.15062 80.5832C9.3557 80.5832 13.1804 79.3238 17.65 77.7844H17.65ZM115.402 79.836C115.981 78.5643 117.293 73.0958 117.683 70.3295C118.232 66.425 118.162 57.0522 117.557 53.4003C116.996 50.0204 115.542 44.2829 115.145 43.886C114.97 43.7112 112.56 44.3789 108.293 45.7842C97.465 49.3499 95.4744 50.1001 95.4744 50.6148C95.4744 50.8667 95.8097 52.5061 96.2195 54.2579C96.8704 57.0401 96.9644 58.0215 96.9622 62.0156C96.9601 65.7264 96.8432 67.1106 96.3415 69.3595C95.2722 74.1531 95.2721 74.0507 96.346 74.4065C96.8573 74.5759 101.079 76.0286 105.728 77.6345C110.377 79.2405 114.379 80.561 114.621 80.5689C114.863 80.5768 115.215 80.247 115.402 79.836H115.402ZM37.8722 36.6497C42.3416 32.5732 46.5683 30.146 52.3116 28.3577C54.1026 27.8 55.5679 27.2352 55.5679 27.1024C55.5679 26.0731 51.6385 7.28485 51.3913 7.13206C50.9594 6.86518 48.0709 7.5415 44.0671 8.84696C37.987 10.8294 30.6568 14.9251 25.7766 19.0667C23.2106 21.2443 19.5412 24.9648 19.5412 25.3888C19.5412 25.8194 34.5491 39.014 35.0388 39.014C35.1715 39.014 36.4465 37.9501 37.8722 36.6497V36.6497ZM93.7885 35.0464C99.9786 29.7281 104.079 25.9979 104.264 25.5176C104.565 24.7334 98.1126 18.6961 93.863 15.7855C88.9205 12.4003 82.2118 9.33688 76.5036 7.85865C71.9288 6.67394 72.5456 5.95474 70.8781 14.4188C68.9012 24.4539 68.5039 26.743 68.666 27.1653C68.7429 27.3658 69.8491 27.8263 71.1243 28.1888C74.287 29.0877 77.839 30.6373 80.4096 32.2394C82.6485 33.6349 86.8399 37.0097 87.9362 38.2997C88.2866 38.712 88.744 39.0103 88.9526 38.9624C89.1611 38.9146 91.3373 37.1524 93.7885 35.0464V35.0464Z" fill="$accentColor"/>
</svg>""";
  }

  Widget _buildBetButton(final bool isLargerDisplay, vnBetAmount) {
    final vnOffsetValue = ValueNotifier<double>(.0);

    final colorizeColors = [
      Colors.green,
      Colors.green[400],
      Colors.green[200],
      Colors.green[100],
    ];

    final colorizeTextStyle = TextStyle(
      fontSize: 12.0.dp,
      fontWeight: FontWeight.bold,
    );

    final double s = 40.0.dp;
    final Widget betChipWidget = Container(
      height: s,
      width: s,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // bet coin
          Transform.scale(
            scale: 1.5,
            child: SvgPicture.string(
              _getBetChipSvg(),
              height: s,
              width: s,
            ),
          ),

          // bet text
          IgnorePointer(
            child: AnimatedTextKit(
              // isRepeatingAnimation: true,
              repeatForever: true,
              animatedTexts: [
                ColorizeAnimatedText(
                  'BET',
                  textStyle: colorizeTextStyle,
                  colors: colorizeColors,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final bool isBetByTapActive = HiveDatasource.getInstance
        .getBox(BoxType.USER_SETTINGS_BOX)
        .get('isTapForBetAction?', defaultValue: false);

    final Widget mainWidget = _buildToolTipWith(
      child: IntrinsicWidth(
        child: Container(
          height: 2 * s,
          child: AnimatedBuilder(
            animation: vnOffsetValue,
            builder: (_, __) {
              return Align(
                alignment: Alignment(.5, 1 - vnOffsetValue.value * 2),
                child: betChipWidget,
              );
            },
          ),
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /* drag bet button */
        isBetByTapActive
            // if confirm by tap is active, show a bouncing widget
            ? BouncingWidget(
                scaleFactor: 1.5,
                child: mainWidget,
                onPressed: () {
                  onSubmitCallBack?.call(vnBetAmount.value);
                },
              )
            : GestureDetector(
                // confirm bet ON SLIDE UP TILL THE TOP
                onVerticalDragEnd: (_) {
                  // if we reach 1.0 and leave the chip, CONFIRM BET
                  if (vnOffsetValue.value == 1.0) {
                    return onSubmitCallBack?.call(vnBetAmount.value);
                  }

                  // ELSE on drag release bounce back to start
                  vnOffsetValue.value = 0.0;
                },
                onVerticalDragUpdate: (details) {
                  if (isBetByTapActive) return;
                  vnOffsetValue.value =
                      (vnOffsetValue.value - details.delta.dy / s)
                          .clamp(.0, 1.0);
                },
                child: mainWidget,
              ),
        /* bet amount */
        Transform.translate(
            offset: Offset(0, 10.dp),
            child: ValueListenableBuilder<double>(
              valueListenable: vnBetAmount,
              builder: (_, double betAmount, __) => Text(
                DataFormatter.chipsFormat(betAmount.roundToDouble()),
                style: TextStyle(
                  fontSize: 12.dp,
                  color: Colors.white,
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildBetSeekBar(double width, AppTheme appTheme) => Container(
        width: width / 1.5,
        child: SliderTheme(
          data: SliderThemeData(
            thumbColor: appTheme.accentColor,
            activeTrackColor: appTheme.secondaryColor,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
            inactiveTrackColor: appTheme.secondaryColor.withOpacity(
              0.15,
            ),
            trackHeight: 10.0,
          ),
          child: Consumer<ValueNotifier<double>>(
            builder: (_, vnBetAmount, __) => Slider(
              min: action.minRaiseAmount.toDouble(),
              max: action.maxRaiseAmount.toDouble(),
              value: vnBetAmount.value,
              onChanged: (newBetAmount) {
                vnBetAmount.value = newBetAmount;
              },
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final appTheme = context.read<AppTheme>();

    final int screenSize = context.read<BoardAttributesObject>().screenSize;
    final bool isLargerDisplay = screenSize >= 9;
    log('bet_widget : screenSize : $screenSize');

    return ListenableProvider<ValueNotifier<double>>(
      create: (_) => ValueNotifier<double>(
        action.minRaiseAmount.toDouble(),
      ),
      builder: (BuildContext context, _) {
        final valueNotifierVal = context.read<ValueNotifier<double>>();

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /* bet button */
            _buildBetButton(isLargerDisplay, valueNotifierVal),

            /* progress drag to bet */
            _buildBetSeekBar(width, appTheme),

            /* button row for other bet options */
            Transform.scale(
              alignment: Alignment.topCenter,
              scale: isLargerDisplay ? 1.2 : 1.0,
              child: Container(
                alignment: Alignment.center,
                width: width / 1.5,
                height: 60.ph,
                child: betAmountList(valueNotifierVal),
              ),
            )
          ],
        );
      },
    );
  }

  Widget sleekSlider() {
    return Consumer<ValueNotifier<double>>(
      builder: (_, vnValue, __) => SleekCircularSlider(
        onChange: (value) {
          log('min: ${action.minRaiseAmount} max: ${action.maxRaiseAmount} val: ${vnValue.value}');
          vnValue.value = value.round().toDouble();
        },
        min: action.minRaiseAmount.toDouble(),
        max: action.maxRaiseAmount.toDouble(),
        initialValue: vnValue.value,
        appearance: CircularSliderAppearance(
          size: 300.pw,
          // startAngle: 0,
          // angleRange: 275,
          startAngle: 215,
          angleRange: 110,
          animationEnabled: false,
          infoProperties: InfoProperties(
            mainLabelStyle: TextStyle(
              fontSize: 0,
              color: Colors.white70,
            ),
            modifier: (double value) => '',
          ),
          customColors: CustomSliderColors(
            hideShadow: false,
            trackColor: AppColorsNew.newGreenRadialStartColor,
            dotColor: AppColorsNew.newBorderColor,
            progressBarColors: [
              AppColorsNew.newBorderColor,
              AppColorsNew.newBorderColor,
              AppColorsNew.newBorderColor,
              // Colors.red,
              // Colors.yellow,
              // Colors.green,
            ],
          ),
          customWidths: CustomSliderWidths(
            trackWidth: 12,
            progressBarWidth: 12,
            handlerSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildBetAmountChild({
    bool betButton = false,
    bool isKeyboard = false,
    Option option,
    void onTap(),
  }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: onTap,
                child: Container(
                  padding: isKeyboard
                      ? const EdgeInsets.all(4)
                      : const EdgeInsets.all(8),
                  margin: isKeyboard
                      ? const EdgeInsets.fromLTRB(0, 4, 0, 0)
                      : const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    //color: Colors.red,
                    //  border: Border.all(color: Colors.white, width: 1.0),
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      // begin: Alignment.topRight,
                      // end: Alignment.bottomLeft,
                      colors: [
                        AppColorsNew.newGreenRadialStartColor,
                        AppColorsNew.newGreenRadialStopColor,
                      ],
                      stops: [
                        0.2,
                        0.8,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColorsNew.newGreenButtonColor,
                        offset: Offset(0, 1),
                        blurRadius: 0.5,
                        spreadRadius: 0.5,
                      )
                    ],
                  ),
                  child: isKeyboard
                      ? Icon(
                          Icons.keyboard,
                          color: Colors.white,
                        )
                      : Text(
                          "${option.text}",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              Text(
                isKeyboard ? '' : '${option.amount.toInt().toString()}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(width: 10),
        ],
      );

  Widget betAmountList(ValueNotifier<double> vnValue) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index == 0) {
          // show keyboard
          return _buildBetAmountChild(
            isKeyboard: true,
            onTap: () async {
              double min = action.minRaiseAmount.toDouble();
              double max = action.maxRaiseAmount.toDouble();

              final double res = await NumericKeyboard2.show(
                context,
                title:
                    'Enter your bet/raise amount (${action.minRaiseAmount.toString()} - ${action.maxRaiseAmount.toString()})',
                min: min,
                max: max,
              );

              if (res != null) vnValue.value = res;
            },
          );
        }

        final option = action.options[index - 1];

        return _buildBetAmountChild(
          option: action.options[index - 1],
          onTap: () {
            vnValue.value = option.amount.toDouble();
          },
        );
      },
      itemCount: action.options.length + 1,
    );
  }
}

// class CustomTrackShape extends RoundedRectSliderTrackShape {
//   Rect getPreferredRect({
//     @required RenderBox parentBox,
//     Offset offset = Offset.zero,
//     @required SliderThemeData sliderTheme,
//     bool isEnabled = false,
//     bool isDiscrete = false,
//   }) {
//     final double trackHeight = sliderTheme.trackHeight;
//     final double trackLeft = offset.dx;
//     final double trackTop =
//         offset.dy + (parentBox.size.height - trackHeight) / 2;
//     final double trackWidth = parentBox.size.width;
//     return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
//   }
// }
