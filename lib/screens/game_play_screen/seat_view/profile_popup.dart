import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/resources/animation_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';

class ProfilePopup extends StatefulWidget {
  final Seat seat;
  ProfilePopup({Key key, this.seat}) : super(key: key);

  @override
  _ProfilePopupState createState() => _ProfilePopupState();
}

class _ProfilePopupState extends State<ProfilePopup> {
  bool _isMicOn = true;
  bool _isChatOn = true;
  String _animationID;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        getStickers(),
      ],

      //getCloseButton(),
      //   Row(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       /*
      //         * member avatar
      //         * */
      //       //   SizedBox(width: 10),
      //       //    getUserDetails(),
      //       //    Spacer(),
      //       //    communication(),
      //       //   SizedBox(width: 15),
      //     ],
      //   ),
      //   /*
      //     * stickers
      //     **/
      //   //  SizedBox(height: 10),
      //   getStickers(),
      //   /*
      //     * confirm button
      //     * * */
      //   //  getConfirmButton()
      // ],
    );
  }

  Widget getUserDetails() => Row(
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

  Widget getConfirmButton() => Center(
        child: InkWell(
          onTap: () => Navigator.pop(
            context,
            {
              "isMicOn": _isMicOn,
              "isChatOn": _isChatOn,
              "animationID": _animationID,
            },
          ),
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

  Widget getStickers() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...AnimationAssets.animationObjects
                .map(
                  (animationObject) => GestureDetector(
                    onTap: () {
                      Navigator.pop(
                        context,
                        {
                          "isMicOn": _isMicOn,
                          "isChatOn": _isChatOn,
                          "animationID": animationObject.id,
                        },
                      );
                      // setState(
                      //   () => _animationID = animationObject.id,
                      // );
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration:
                          BoxDecoration(color: Colors.transparent, boxShadow: [
                          
                        BoxShadow(
                          color: AppColors.appAccentColor,
                          spreadRadius: 0.1,
                          blurRadius: 0.1,
                        ),
                      ]),
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(5),
                      child: SvgPicture.asset(
                        animationObject.assetSvg,
                        height: 50,
                        width: 50,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      );

  Widget communication() => Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isChatOn = !_isChatOn;
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
                _isChatOn ? Icons.comment : Icons.change_history_outlined,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                _isMicOn = !_isMicOn;
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
                _isMicOn ? Icons.mic : Icons.mic_off,
                color: Colors.white,
              ),
            ),
          )
        ],
      );

  Widget getCloseButton() => Align(
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
