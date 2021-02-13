import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/services/agora/agora.dart';
import 'package:provider/provider.dart';

class CommunicationView extends StatefulWidget {
  final Function chatVisibilityChange;
  CommunicationView(this.chatVisibilityChange);

  @override
  _CommunicationViewState createState() => _CommunicationViewState();
}

class _CommunicationViewState extends State<CommunicationView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ValueNotifier<Agora>>(
      builder: (_, agora, __) {
        print("agora.value.openMicrophone ${agora.value.openMicrophone}");
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
                    GestureDetector(
                      onTap: () {
                        agora.value.switchMicrophone();
                        setState(() {
                          agora.value.openMicrophone =
                              !agora.value.openMicrophone;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          agora.value.openMicrophone
                              ? Icons.mic
                              : Icons.mic_off,
                          size: 35,
                          color: AppColors.appAccentColor,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print("speacker ${agora.value.enableSpeakerphone}");
                        agora.value.switchSpeakerphone();
                        setState(() {
                          agora.value.enableSpeakerphone =
                              !agora.value.enableSpeakerphone;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          agora.value.enableSpeakerphone
                              ? Icons.volume_up
                              : Icons.volume_mute,
                          size: 35,
                          color: AppColors.appAccentColor,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.chatVisibilityChange,
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
      },
    );
  }
}
