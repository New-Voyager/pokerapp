import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/services/game_play/graphql/game_service.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
import 'package:provider/provider.dart';

class SeatChangeConfirmationPopUp {
  static void dialog({BuildContext context}) => showDialog(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: AppColors.cardBackgroundColor,
          child: _SeatChangeConfirmationPopUpWidget(),
        ),
      );
}

class _SeatChangeConfirmationPopUpWidget extends StatelessWidget {
  void _confirm(BuildContext context) {
    /* call confirmSeatChange mutation */
    final String gameCode = Provider.of<ValueNotifier<GameInfoModel>>(
      context,
      listen: false,
    ).value.gameCode;

    GameService.confirmSeatChange(gameCode);

    Navigator.pop(context);
  }

  void _decline(BuildContext context) => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 20.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'A seat is open. Do you want to change?',
            textAlign: TextAlign.center,
            style: AppStyles.titleTextStyle.copyWith(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Expanded(
                child: CustomTextButton(
                  text: 'Confirm',
                  onTap: () => _confirm(context),
                ),
              ),
              Expanded(
                child: CustomTextButton(
                  text: 'Decline',
                  onTap: () => _decline(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
