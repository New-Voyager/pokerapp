import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/gradient_text.dart';
import 'package:pokerapp/widgets/buttons.dart';

class CustomAppBar extends AppBar {
  final titleText;
  final subTitleText;
  final context;
  final actionsList;
  final bool showBackButton;
  final Function onBackHandle;
  final AppTheme theme;
  CustomAppBar({
    Key key,
    this.titleText,
    this.subTitleText,
    this.context,
    this.actionsList,
    this.showBackButton,
    this.onBackHandle,
    @required this.theme,
  }) : super(
          key: key,
          backgroundColor: Colors.transparent,
          elevation: 0,
          // leadingWidth: 50.pw,
          leading: (showBackButton ?? true)
              ? BackArrowWidget(
                  onBackHandle: onBackHandle,
                )
              : SizedBox.shrink(),
          title: Container(
            height: 90.ph,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GradientText(
                  titleText ?? "",
                  style: AppDecorators.getAppBarStyle(theme: theme),
                  // textAlign: TextAlign.center,
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFFFFF), Color(0xFFCCCCCC)],
                    stops: [0.2, 1],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                Visibility(
                  visible: subTitleText != null,
                  child: Text(
                    subTitleText ?? "",
                    style: AppDecorators.getHeadLine4Style(theme: theme),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          centerTitle: true,
          actions: actionsList ?? [],
        );
}

class BackArrowWidget extends StatelessWidget {
  final Function onBackHandle;

  const BackArrowWidget({Key key, this.onBackHandle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    // return Container(
    //   alignment: Alignment.centerLeft,
    //   padding: EdgeInsets.only(left: 16.pw),
    //   child: InkWell(
    //       child: SvgPicture.asset(
    //         'assets/images/backarrow.svg',
    //         color: theme.secondaryColor,
    //         width: 32.pw,
    //         height: 32.pw,
    //         fit: BoxFit.contain,
    //       ),
    //       borderRadius: BorderRadius.circular(32.pw),
    //       onTap: () {
    //         if (onBackHandle != null) {
    //           onBackHandle();
    //         } else {
    //           Navigator.of(context).pop();
    //         }
    //       }),
    // );

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(left: 8.pw),
          child: ThemedCircleImageButton(
            onTap: () {
              if (onBackHandle != null) {
                onBackHandle();
              } else {
                Navigator.of(context).pop();
              }
            },
            style: theme.orangeButton,
            icon: Icons.arrow_back,
            // svgAsset: 'assets/images/backarrow.svg',
          ),
        ),
      ],
    );
  }
}
