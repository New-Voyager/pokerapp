import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';

class BackButtonWidget extends StatelessWidget {
  final titleText;
  const BackButtonWidget({Key key, this.titleText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.appAccentColor,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          AppDimensionsNew.getHorizontalSpace(16),
          Text(
            titleText ?? "",
            style: AppStyles.titleBarTextStyle.copyWith(fontSize: 18),
          )
        ],
      ),
    );
  }
}
