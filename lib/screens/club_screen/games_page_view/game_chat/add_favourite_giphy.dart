import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/services/app/game_service.dart';

class AddFavouriteGiphy extends StatelessWidget {
  AddFavouriteGiphy({Key key}) : super(key: key);
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: AppColors.cardBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.contentColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                controller: controller,
                style: TextStyle(
                  color: AppColors.lightGrayColor,
                ),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: '',
                  hintStyle: TextStyle(
                    color: AppColors.lightGrayColor,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                if (controller.text.trim() != '') {
                  await GameService.addFavoutireGiphy(controller.text.trim());
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.contentColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Add",
                  style: AppStyles.footerResultTextStyle2,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
