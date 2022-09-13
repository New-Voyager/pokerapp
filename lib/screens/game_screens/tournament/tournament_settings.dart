import 'package:flutter/material.dart';
import 'package:pokerapp/models/game/new_game_provider.dart';
import 'package:pokerapp/models/tournament/tournament_settings.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/services/app/tournament_service.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/utils/platform.dart';
import 'package:pokerapp/widgets/button_widget.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/radio_list_widget.dart';
import 'package:pokerapp/widgets/switch.dart';
import 'package:pokerapp/widgets/textfields.dart';
import 'package:pokerapp/widgets/texts.dart';

class TournamentSettingsView extends StatefulWidget {
  static Future<int> show(
    BuildContext context,
  ) async {
    ConnectionDialog.show(context: context, loadingText: 'Please wait...');

    ConnectionDialog.dismiss(context: context);
    int tournamentId = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 30.0,
        ),
        child: TournamentSettingsView(),
      ),
    );
    return tournamentId;
  }

  TournamentSettingsView();

  static const sepV20 = const SizedBox(height: 20.0);
  static const sepV8 = const SizedBox(height: 8.0);
  static const sep12 = const SizedBox(height: 12.0);

  static const sepH10 = const SizedBox(width: 10.0);

  @override
  State<TournamentSettingsView> createState() => _TournamentSettingsViewState();
}

class _TournamentSettingsViewState extends State<TournamentSettingsView> {
  bool loading = false;

  TextEditingController _tecMaxPlayers = TextEditingController();
  TextEditingController _tecName = TextEditingController();
  TextEditingController _tecBotsCount = TextEditingController();
  RegisterBotsDialog _registerBotsDialog;
  TournamentSettings _tournamentSettings = TournamentSettings.defaultSettings();
  @override
  void initState() {
    loading = true;
    _tecMaxPlayers.text = _tournamentSettings.maxPlayers.toString();
    _tecName.text = _tournamentSettings.name;
    _tecBotsCount.text = '6';
    //_tournamentSettings.botsCount.toString();

    loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    if (loading) {
      return Container();
    }

    return Container(
      // decoration: AppDecorators.bgRadialGradient(theme).copyWith(
      //   border: Border.all(
      //     color: theme.secondaryColorWithDark(),
      //     width: 2,
      //   ),
      //   borderRadius: BorderRadius.circular(10),
      // ),
      constraints: BoxConstraints(maxWidth: AppDimensionsNew.maxWidth),
      decoration: BoxDecoration(color: theme.secondaryColorWithDark(0.40)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              HeadingWidget(
                heading: "Tournament Settings",
              ),
              Align(
                alignment: Alignment.centerRight,
                child: CircleImageButton(
                  onTap: () {
                    Navigator.pop(context, null);
                  },
                  theme: theme,
                  icon: Icons.close,
                ),
              ),
            ],
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: AppDecorators.tileDecorationWithoutBorder(theme),
              child: Scrollbar(
                thickness: PlatformUtils.isWeb ? 5 : 1,
                thumbVisibility: true,
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(right: 10),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelText(label: 'Name', theme: theme),
                        TournamentSettingsView.sepV8,
                        CardFormTextField(
                          hintText: "",
                          controller: _tecName,
                          maxLines: 1,
                          theme: theme,
                        ),
                      ],
                    ),
                    TournamentSettingsView.sepV20,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelText(label: 'Game Type', theme: theme),
                        TournamentSettingsView.sepV8,
                        RadioListWidget<String>(
                          defaultValue: 'HOLDEM',
                          wrap: true,
                          values: [
                            'HOLDEM',
                            'PLO',
                            'Hi-Lo',
                            // '5 Card',
                            // '5 Card Hi-Lo',
                            // '6 Card',
                            // '6 Card Hi-Lo',
                          ],
                          onSelect: (String value) {
                            if (value == 'PLO') {
                            } else if (value == 'Hi-Lo') {
                            } else if (value == '5 Card') {
                            } else if (value == '5 Card Hi-Lo') {
                            } else if (value == '6 Card') {
                            } else if (value == '6 Card Hi-Lo') {}

                            //setState(() {});
                          },
                        ),
                      ],
                    ),
                    TournamentSettingsView.sepV20,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelText(label: 'Max Players (300 max)', theme: theme),
                        TournamentSettingsView.sepV8,
                        CardFormTextField(
                          hintText: "",
                          controller: _tecMaxPlayers,
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          theme: theme,
                        ),
                      ],
                    ),
                    TournamentSettingsView.sepV20,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelText(label: 'Bots count', theme: theme),
                        TournamentSettingsView.sepV8,
                        CardFormTextField(
                          hintText: "",
                          controller: _tecBotsCount,
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          theme: theme,
                        ),
                      ],
                    ),
                    // _buildRadio(
                    //   label: "Test with bots",
                    //   value: false,
                    //   onChange: (bool b) {
                    //     _tournamentSettings.fillWithBots = b;
                    //   },
                    //   theme: theme,
                    // ),
                    TournamentSettingsView.sepV20,
                    ButtonWidget(
                      text: "Host",
                      onTap: () async {
                        _tournamentSettings.name = _tecName.text;
                        _tournamentSettings.maxPlayers =
                            int.parse(_tecMaxPlayers.text);
                        if (_tournamentSettings.maxPlayers == 0) {
                          _tournamentSettings.maxPlayers = 6;
                        }
                        _tournamentSettings.botsCount =
                            int.parse(_tecBotsCount.text);
                        if (_tournamentSettings.botsCount >
                            _tournamentSettings.maxPlayers) {
                          _tournamentSettings.botsCount =
                              _tournamentSettings.maxPlayers;
                        }

                        int tournamentId =
                            await TournamentService.scheduleTournament(
                                _tournamentSettings);

                        // register bots
                        if (tournamentId != null) {
                          _registerBotsDialog = RegisterBotsDialog();
                          _registerBotsDialog.show(context: context);
                          await TournamentService.registerBots(tournamentId);
                          _registerBotsDialog.dismiss(context: context);
                        }
                        Navigator.pop(context, tournamentId);
                      },
                    ),
                    TournamentSettingsView.sep12,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeperator(AppTheme theme) => Container(
        color: theme.fillInColor,
        width: double.infinity,
        height: 1.0,
      );

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
          SwitchWidget2(
            label: label,
            value: value,
            onChange: onChange,
          ),

          /* seperator */
          _buildSeperator(theme),
        ],
      );
}
