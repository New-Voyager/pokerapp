import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/club_update_input_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/models/user_update_input.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/screens/main_screens/profile_page_view/profile_page_view_new.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/widgets/switch_widget.dart';
import 'package:image_picker/image_picker.dart';

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
  bool _loading = true;

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
    if (model != null) {
      setState(() {
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
      decoration: AppDecorators.bgRadialGradient(theme),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            theme: theme,
            context: context,
            titleText: _appScreenText['title'],
            subTitleText: "Code : ${_clubModel.clubCode}",
          ),
          body: _loading
              ? Center(child: CircularProgressWidget())
              : SingleChildScrollView(
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
                                        width: _clubModel.picUrl.isEmpty
                                            ? 3.pw
                                            : 0,
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
                                              ),
                                              fit: BoxFit.cover,
                                            )),
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
                                  // child: Row(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   children: [

                                  //    // AppDimensionsNew.getHorizontalSpace(8),
                                  //     // RoundIconButton(
                                  //     //   icon: Icons.edit,
                                  //     //   bgColor: theme.fillInColor,
                                  //     //   iconColor: theme.accentColor,
                                  //     //   size: 12.dp,
                                  //     //   onTap: () async {
                                  //     //     await _updateClubDetails(
                                  //     //         SettingType.CLUB_NAME, theme);
                                  //     //     // Fetch user details from server
                                  //     //   },
                                  //     // ),
                                  //   ],
                                  // ),
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
                                        ListTileItem(
                                          text: _appScreenText[
                                              'deleteClubPicture'],
                                          imagePath:
                                              AppAssetsNew.customizeImagePath,
                                          index: 1,
                                          onTapFunction: () {
                                            _handleDeletePicture();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Show high rank stats
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Column(
                                children: [
                                  //
                                  Container(
                                    decoration:
                                        AppDecorators.tileDecoration(theme),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildRadio(
                                            value: _clubModel.showHighRankStats,
                                            label: _appScreenText[
                                                'showHighRankStats'],
                                            onChange: (v) async {
                                              ClubUpdateInput input =
                                                  ClubUpdateInput(
                                                name: _clubModel.clubName,
                                                description:
                                                    _clubModel.description,
                                                showHighRankStats: v,
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
                            ),
                          ],
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
      request.fields['clubCode'] = widget.clubModel.clubCode;

      var res = await request.send();
      if (mounted) {
        ConnectionDialog.dismiss(context: context);
        await _fetchClubInfo();
      }
    } else {
      log("Somethinfg Went worng!");
    }
  }

  _handleDeletePicture() async {
    ConnectionDialog.show(
        context: context, loadingText: "${_appScreenText['updatingDetails']}");
    // final res; = await ClubsService.updateClubInput(_clubModel.clubCode, input);
    var res;
    // TODO delete club picture
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
}

enum SettingType { CLUB_NAME, CLUB_DESCRIPTION, CLUB_SHOWHIGHRANK }
