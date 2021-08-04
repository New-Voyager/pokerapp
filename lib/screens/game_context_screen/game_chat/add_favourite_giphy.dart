import 'package:flutter/material.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/services/app/game_service.dart';

class AddFavouriteGiphy extends StatelessWidget {
  AddFavouriteGiphy({Key key}) : super(key: key);

  final TextEditingController controller = TextEditingController();

  Widget _buildButton(context, text) => InkWell(
        onTap: () async {
          if (controller.text.trim().isNotEmpty)
            await GameService.addPresetText(
              controller.text.trim(),
            );

          Navigator.pop(context);
        },
        child: Container(
          // height: 32.ph,
          // width: 80.pw,
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
              color: AppColorsNew.newGreenButtonColor,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppStylesNew.clubItemInfoTextStyle.copyWith(
              fontSize: 16.0,
              color: AppColorsNew.newGreenButtonColor,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /* main preset message text field */
        Container(
          padding: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextField(
            controller: controller,
            style: TextStyle(
              color: Colors.white,
            ),
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              hintText: 'Your preset message',
              hintStyle: TextStyle(
                color: AppColorsNew.lightGrayTextColor,
              ),
              border: InputBorder.none,
            ),
          ),
        ),

        // sep
        SizedBox(height: 20),

        // button
        _buildButton(context, 'Add'),
      ],
    );
  }
}
