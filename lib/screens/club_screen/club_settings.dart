import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/club_update_input_model.dart';
import 'package:pokerapp/models/notifications_update_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/screens/main_screens/profile_page_view/profile_page_view_new.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/widgets/switch_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pokerapp/widgets/textfields.dart';

class ClubSettingsScreen extends StatefulWidget {
  final ClubHomePageModel clubModel;
  const ClubSettingsScreen({Key key, this.clubModel}) : super(key: key);

  @override
  _ClubSettingsScreenState createState() => _ClubSettingsScreenState();
}

class _ClubSettingsScreenState extends State<ClubSettingsScreen> {
  AppTextScreen _appScreenText;
  TextEditingController _controller = TextEditingController();
  ClubHomePageModel _clubModel;
  ClubNotifications _notifications;
  bool _loading = true;
  bool updated = false;
  bool notificationsUpdated = false;
  @override
  void initState() {
    _clubModel = widget.clubModel;
    _appScreenText = getAppTextScreen("clubSettings");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchClubInfo();
    });
    super.initState();
  }

  _fetchClubInfo() async {
    setState(() {
      _loading = true;
    });
    final ClubHomePageModel model =
        await ClubsService.getClubHomePageData(widget.clubModel.clubCode);
    final ClubNotifications notifications =
        await ClubsService.getClubNotifications(widget.clubModel.clubCode);
    if (model != null) {
      setState(() {
        _notifications = notifications;
        _clubModel = model;
      });
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    return Container(
      decoration: AppDecorators.bgImageGradient(theme),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            theme: theme,
            context: context,
            titleText: _appScreenText['title'],
            subTitleText: "Code : ${widget.clubModel.clubCode}",
            onBackHandle: () async {
              // save club settings
              if (updated) {
                await updateClubSettings();
              }
              if (notificationsUpdated) {
                await updateNotificationSettings();
              }
              Navigator.of(context).pop(updated);
            },
          ),
          body: _loading
              ? Center(child: CircularProgressWidget())
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Head section
                      Container(
                        decoration: AppDecorators.tileDecoration(theme),
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 80.dp,
                                  height: 80.dp,
                                  clipBehavior: Clip.hardEdge,
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width:
                                          _clubModel.picUrl.isEmpty ? 3.pw : 0,
                                      color: theme.secondaryColor,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.primaryColor,
                                        blurRadius: 1.pw,
                                        spreadRadius: 1.pw,
                                        offset: Offset(1.pw, 4.pw),
                                      ),
                                    ],
                                    image: _clubModel.picUrl.isEmpty
                                        ? null
                                        : DecorationImage(
                                            image: CachedNetworkImageProvider(
                                              _clubModel.picUrl,
                                              cacheManager:
                                                  ImageCacheManager.instance,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  alignment: Alignment.center,
                                  child: _clubModel.picUrl.isEmpty
                                      ? Text(
                                          HelperUtils.getClubShortName(
                                              _clubModel.clubName),
                                          style:
                                              AppDecorators.getHeadLine2Style(
                                                  theme: theme),
                                        )
                                      : SizedBox.shrink(),
                                ),
                                AppDimensionsNew.getHorizontalSpace(16),
                                Container(
                                  child: Text("${_clubModel.clubName}",
                                      style: AppDecorators.getHeadLine2Style(
                                          theme: theme)),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "${_clubModel.description}",
                                style: AppDecorators.getSubtitle3Style(
                                    theme: theme),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Change items
                      Visibility(
                        visible: (_clubModel.isOwner),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Column(
                                children: [
                                  //
                                  Container(
                                    decoration:
                                        AppDecorators.tileDecoration(theme),
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListTileItem(
                                          text:
                                              _appScreenText['changeClubName'],
                                          imagePath:
                                              AppAssetsNew.customizeImagePath,
                                          index: 1,
                                          onTapFunction: () async {
                                            await _updateClubDetails(
                                                SettingType.CLUB_NAME, theme);
                                            // Fetch user details from server
                                          },
                                        ),
                                        ListTileItem(
                                          text: _appScreenText[
                                              'changeClubDescription'],
                                          imagePath:
                                              AppAssetsNew.customizeImagePath,
                                          index: 2,
                                          onTapFunction: () async {
                                            await _updateClubDetails(
                                                SettingType.CLUB_DESCRIPTION,
                                                theme);
                                            // Fetch user details from server
                                          },
                                        ),
                                        ListTileItem(
                                          text: _appScreenText[
                                              'changeClubPicture'],
                                          imagePath:
                                              AppAssetsNew.customizeImagePath,
                                          index: 3,
                                          onTapFunction: () {
                                            _handleUploadPicture();
                                            // Fetch user details from server
                                          },
                                        ),
                                        Visibility(
                                          visible: _clubModel.picUrl.isNotEmpty,
                                          child: ListTileItem(
                                            text: _appScreenText[
                                                'deleteClubPicture'],
                                            imagePath:
                                                AppAssetsNew.customizeImagePath,
                                            index: 4,
                                            onTapFunction: () {
                                              _handleDeletePicture();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // club settings
                            _getClubSettings(theme),
                          ],
                        ),
                      ),

                      // Visibility(
                      //   visible: _clubModel.isOwner,
                      //   child: Container(
                      //     decoration: AppDecorators.tileDecoration(theme),
                      //     padding:
                      //         EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      //     margin:
                      //         EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           "Manager Roles",
                      //           style: AppDecorators.getAccentTextStyle(
                      //               theme: theme),
                      //           textAlign: TextAlign.center,
                      //         ),
                      //         _buildRadio(
                      //             value: _clubModel.role.seeTips,
                      //             label: 'Can See Tips',
                      //             onChange: (v) async {
                      //               _clubModel.role.seeTips = v;
                      //               updated = true;
                      //             },
                      //             theme: theme),
                      //         _buildRadio(
                      //             value: _clubModel.role.makeAnnouncement,
                      //             label: 'Can Make Announcement',
                      //             onChange: (v) async {
                      //               updated = true;
                      //               _clubModel.role.makeAnnouncement = v;
                      //             },
                      //             theme: theme),
                      //         _buildRadio(
                      //             value: _clubModel.role.hostGames,
                      //             label: 'Can Host Games',
                      //             onChange: (v) async {
                      //               updated = true;
                      //               _clubModel.role.hostGames = v;
                      //             },
                      //             theme: theme),
                      //         _buildRadio(
                      //             value: _clubModel.role.viewMemberActivities,
                      //             label: 'Can View Players Report',
                      //             onChange: (v) async {
                      //               updated = true;
                      //               _clubModel.role.viewMemberActivities = v;
                      //             },
                      //             theme: theme),
                      //         _buildRadio(
                      //             value: _clubModel.role.canUpdateCredits,
                      //             label: 'Can Update Credits',
                      //             onChange: (v) async {
                      //               updated = true;
                      //               _clubModel.role.canUpdateCredits = v;
                      //             },
                      //             theme: theme),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Visibility(
                        visible: true,
                        child: Container(
                          decoration: AppDecorators.tileDecoration(theme),
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Notifications",
                                style: AppDecorators.getAccentTextStyle(
                                    theme: theme),
                                textAlign: TextAlign.center,
                              ),
                              _buildRadio(
                                  value: _notifications.newGames,
                                  label: 'New Games',
                                  onChange: (v) async {
                                    _notifications.newGames = v;
                                    notificationsUpdated = true;
                                  },
                                  theme: theme),
                              _buildRadio(
                                  value: _notifications.creditUpdates,
                                  label: 'Credit Updates',
                                  onChange: (v) async {
                                    updated = true;
                                    _notifications.creditUpdates = v;
                                    notificationsUpdated = true;
                                  },
                                  theme: theme),
                              _buildRadio(
                                  value: _notifications.clubChat,
                                  label: 'Club Chat',
                                  onChange: (v) async {
                                    _notifications.clubChat = v;
                                    notificationsUpdated = true;
                                  },
                                  theme: theme),
                              _buildRadio(
                                  value: _notifications.clubAnnouncements,
                                  label: 'Club Announcements',
                                  onChange: (v) async {
                                    _notifications.clubAnnouncements = v;
                                    notificationsUpdated = true;
                                  },
                                  theme: theme),
                            ],
                          ),
                        ),
                      ),
                      // Leave club
                      Visibility(
                        visible: !(_clubModel.isOwner),
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Column(
                            children: [
                              //
                              Container(
                                decoration: AppDecorators.tileDecoration(theme),
                                padding: EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTileItem(
                                      text: _appScreenText['leaveClub'],
                                      imagePath:
                                          AppAssetsNew.customizeImagePath,
                                      index: 1,
                                      onTapFunction: () async {
                                        final response = await showPrompt(
                                            context,
                                            _appScreenText['confirm'],
                                            _appScreenText['confirmMessage'],
                                            positiveButtonText: "Yes",
                                            negativeButtonText: "No");
                                        log("$response");
                                        if (response != null &&
                                            response == true) {
                                          ConnectionDialog.show(
                                              context: context,
                                              loadingText: "Leaving club..");
                                          final result =
                                              await ClubsService.leaveClub(
                                                  _clubModel.clubCode);
                                          ConnectionDialog.dismiss(
                                            context: context,
                                          );

                                          if (result != null) {
                                            if (result == 'LEFT') {
                                              Alerts.showNotification(
                                                  titleText:
                                                      _appScreenText['success'],
                                                  subTitleText: _appScreenText[
                                                      'successSubText']);
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            } else {
                                              Alerts.showNotification(
                                                  titleText:
                                                      _appScreenText['fail'],
                                                  subTitleText: _appScreenText[
                                                      'failSubText']);
                                            }
                                          }
                                          // Fetch user details from server
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              AppDimensionsNew.getVerticalSizedBox(16),
                            ],
                          ),
                        ),
                      ),
                      AppDimensionsNew.getVerticalSizedBox(100),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildRadio({
    @required bool value,
    @required String label,
    @required void Function(bool v) onChange,
    @required AppTheme theme,
  }) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /* switch */
          SwitchWidget(
            label: label,
            value: value,
            onChange: onChange,
          ),
        ],
      );

  _updateClubDetails(SettingType type, AppTheme theme) async {
    String defaultText = type == SettingType.CLUB_NAME
        ? _clubModel.clubName
        : type == SettingType.CLUB_DESCRIPTION
            ? _clubModel.description
            : "";
    _controller = TextEditingController(text: defaultText);
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.fillInColor,
        title: Text(
          type == SettingType.CLUB_NAME
              ? _appScreenText['changeClubName']
              : type == SettingType.CLUB_DESCRIPTION
                  ? _appScreenText['changeDescription']
                  : "",
          style: AppDecorators.getSubtitle3Style(theme: theme),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CardFormTextField(
              controller: _controller,
              maxLines: type == SettingType.CLUB_DESCRIPTION ? 8 : 1,
              hintText: _appScreenText['enterText'],
              theme: theme,
            ),
            AppDimensionsNew.getVerticalSizedBox(12),
            RoundRectButton(
              text: _appScreenText['save'],
              theme: theme,
              onTap: () {
                if (_controller.text.isNotEmpty) {
                  Navigator.of(context).pop(_controller.text);
                }
              },
            ),
          ],
        ),
      ),
    );
    if (result != null && result.isNotEmpty) {
      ClubUpdateInput input = ClubUpdateInput(
        name: type == SettingType.CLUB_NAME ? result : _clubModel.clubName,
        description: type == SettingType.CLUB_DESCRIPTION
            ? result
            : _clubModel.description,
        showHighRankStats: type == SettingType.CLUB_SHOWHIGHRANK
            ? result
            : _clubModel.showHighRankStats,
      );

      await updateClubAPICall(input);

      //setState(() {});
    }
  }

  Widget _getClubSettings(AppTheme theme) {
    return Visibility(
        visible: true,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              //
              Container(
                decoration: AppDecorators.tileDecoration(theme),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                        alignment: Alignment.topRight,
                        child: TipButton(
                          theme: theme,
                          text:
                              '### Track Member Credits\nPlayers buyin/winning tracked for chips ledger\n ### Show Game Result\n If turned on, players can view game ledger',
                        )),
                    _buildRadio(
                        value: _clubModel.trackMemberCredit,
                        label: 'Track Member Credits',
                        onChange: (v) async {
                          ClubUpdateInput input = ClubUpdateInput(
                            trackMemberCredit: v,
                          );
                          await updateClubAPICall(input);
                          // Fetch user details from server
                        },
                        theme: theme),
                    _buildRadio(
                        value: _clubModel.showGameResult,
                        label: 'Show Game Result',
                        onChange: (v) async {
                          ClubUpdateInput input = ClubUpdateInput(
                            showGameResult: v,
                          );
                          await updateClubAPICall(input);
                          // Fetch user details from server
                        },
                        theme: theme),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  updateClubAPICall(ClubUpdateInput input) async {
    ConnectionDialog.show(
        context: context, loadingText: "${_appScreenText['updatingDetails']}");
    final res = await ClubsService.updateClubInput(_clubModel.clubCode, input);

    if (res != null && res == true) {
      Alerts.showNotification(
          titleText: "${_appScreenText['clubDetailsUpdated']}");
    } else {
      Alerts.showNotification(
          titleText: "${_appScreenText['failedToUpdateClubDetails']}");
    }
    await _fetchClubInfo();
    ConnectionDialog.dismiss(context: context);
  }

  updateClubNotificationSettings(ClubNotifications input) async {
    ConnectionDialog.show(
        context: context, loadingText: "${_appScreenText['updatingDetails']}");
    final res =
        await ClubsService.updateClubNotifications(_clubModel.clubCode, input);

    if (res != null && res == true) {
      Alerts.showNotification(
          titleText: "${_appScreenText['clubDetailsUpdated']}");
    } else {
      Alerts.showNotification(
          titleText: "${_appScreenText['failedToUpdateClubDetails']}");
    }
    //await _fetchClubInfo();
    ConnectionDialog.dismiss(context: context);
  }

  _handleUploadPicture() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      int length = await image.length();
      if (length > 500000) {
        Alerts.showNotification(
          titleText: _appScreenText['errorUpload'],
          subTitleText: _appScreenText['errorUploadSubtext'],
          duration: Duration(seconds: 5),
        );
        return;
      }
      log("Path : ${image.path}");
      ConnectionDialog.show(context: context, loadingText: "Uploading..");
      var request = MultipartRequest(
          'POST',
          Uri.parse(
            "${AppConfig.apiUrl}/upload",
          ));
      log("REQUEST : ${request.url}");
      request.files.add(await MultipartFile.fromPath('file', image.path));
      request.fields['clubCode'] = _clubModel.clubCode;
      request.headers['Authorization'] = 'jwt ${AppConfig.jwt}';

      var res = await request.send();
      if (mounted) {
        ConnectionDialog.dismiss(context: context);
        await _fetchClubInfo();
      }
    } else {
      log("Somethinfg Went worng!");
    }
  }

  _handleDeletePicture() {
    ClubUpdateInput input = ClubUpdateInput(picUrl: '');

    updateClubAPICall(input);
  }

  Future<void> updateClubSettings() async {
    if (updated) {
      ConnectionDialog.show(
          context: context, loadingText: "Updating settings...");
      await ClubsService.updateManagerRole(
          _clubModel.clubCode, _clubModel.role);
      log('updateClubSettings');
      ConnectionDialog.dismiss(context: context);
    }
  }

  Future<void> updateNotificationSettings() async {
    if (notificationsUpdated) {
      ConnectionDialog.show(
          context: context, loadingText: "Updating notifications...");
      await ClubsService.updateClubNotifications(
          _clubModel.clubCode, _notifications);
      ConnectionDialog.dismiss(context: context);
    }
  }
}

enum SettingType { CLUB_NAME, CLUB_DESCRIPTION, CLUB_SHOWHIGHRANK }
