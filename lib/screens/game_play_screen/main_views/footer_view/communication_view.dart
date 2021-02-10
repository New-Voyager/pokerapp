import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';

class CommunicationView extends StatelessWidget {
  final Function chatVisibilityChange;
  CommunicationView(this.chatVisibilityChange);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(
              Icons.circle,
              size: 15,
              color: AppColors.positiveColor,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            color: Colors.black,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.mic,
                    size: 35,
                    color: AppColors.appAccentColor,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.volume_up,
                    size: 35,
                    color: AppColors.appAccentColor,
                  ),
                ),
                GestureDetector(
                  onTap: chatVisibilityChange,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.chat,
                      size: 35,
                      color: AppColors.appAccentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
