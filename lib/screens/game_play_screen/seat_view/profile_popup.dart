import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/seat.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';

class ProfilePopup extends StatefulWidget {
  final Seat seat;
  ProfilePopup({Key key, this.seat}) : super(key: key);

  @override
  _ProfilePopupState createState() => _ProfilePopupState();
}

class _ProfilePopupState extends State<ProfilePopup> {
  bool isMicOn = true;
  bool isChatOn = true;
  int selectedItem;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.stickerDialogColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      padding: EdgeInsets.all(5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          getCloseButton(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*
              * member avatar
              * */
              SizedBox(width: 10),
              getUserDetails(),
              Spacer(),
              communication(),
              SizedBox(width: 15),
            ],
          ),
          /*
          * stickers
          **/
          SizedBox(
            height: 10,
          ),
          getStickers(),
          /*
          * confirm button
          * * */
          getConfirmButton()
        ],
      ),
    );
  }

  Widget getUserDetails() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          (List.generate(3, (index) => 'assets/images/${index + 1}.png')
                ..shuffle())
              .first,
          height: 50.0,
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          widget.seat.player.name,
          style: AppStyles.stickerDialogText,
        )
      ],
    );
  }

  Widget getConfirmButton() {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.pop(
            context,
            {
              "isMicOn": isMicOn,
              "isChatOn": isChatOn,
              "selectedItem": selectedItem
            },
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          margin: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: AppColors.stickerDialogActionColor),
          child: Text(
            "Confirm",
            style: AppStyles.stickerDialogActionText,
          ),
        ),
      ),
    );
  }

  Widget getStickers() {
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            ...[1, 2, 3, 4, 5, 6, 7, 8].map(
              (e) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedItem = e;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: selectedItem == e
                          ? AppColors.stickerDialogActionColor
                          : Colors.grey,
                      width: 2,
                    ),
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  child: Icon(
                    Icons.ac_unit,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget communication() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isChatOn = !isChatOn;
            });
          },
          child: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.stickerDialogBorderColor,
                width: 2,
              ),
            ),
            child: Icon(
              isChatOn ? Icons.comment : Icons.change_history_outlined,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            setState(() {
              isMicOn = !isMicOn;
            });
          },
          child: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.stickerDialogBorderColor,
                width: 2,
              ),
            ),
            child: Icon(
              isMicOn ? Icons.mic : Icons.mic_off,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  Widget getCloseButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: CircleAvatar(
          backgroundColor: AppColors.stickerDialogActionColor,
          radius: 11,
          child: Icon(
            Icons.close_outlined,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
    );
  }
}
