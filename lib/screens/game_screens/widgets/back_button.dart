import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class CustomAppBar extends AppBar {
  final titleText;
  final subTitleText;
  final context;
  final actionsList;
  final bool showBackButton;
  final AppTheme theme;
  CustomAppBar({
    Key key,
    this.titleText,
    this.subTitleText,
    this.context,
    this.actionsList,
    this.showBackButton,
    @required this.theme,
  }) : super(
          key: key,
          backgroundColor: Colors.transparent,
          elevation: 0,
          // leadingWidth: 50.pw,
          leading:
              (showBackButton ?? true) ? BackArrowWidget() : SizedBox.shrink(),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                titleText ?? "",
                style: AppDecorators.getAppBarStyle(theme: theme),
                textAlign: TextAlign.center,
              ),
              Visibility(
                visible: subTitleText != null,
                child: Text(
                  subTitleText ?? "",
                  style: AppDecorators.getHeadLine3Style(theme: theme),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          centerTitle: true,
          actions: actionsList ?? [],
        );
}

class BackArrowWidget extends StatelessWidget {
  const BackArrowWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    return Transform.scale(
      scale: 1.2,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 16.pw),
        child: InkWell(
          child: SvgPicture.asset(
            'assets/images/backarrow.svg',
            color: theme.secondaryColor,
            width: 32.pw,
            height: 32.pw,
            fit: BoxFit.contain,
          ),
          borderRadius: BorderRadius.circular(32.pw),
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
