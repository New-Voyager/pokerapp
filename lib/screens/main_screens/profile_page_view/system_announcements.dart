import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pokerapp/models/announcement_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:provider/provider.dart';

class SystemAnnouncements extends StatefulWidget {
  const SystemAnnouncements({Key key}) : super(key: key);

  @override
  _SystemAnnouncementsState createState() => _SystemAnnouncementsState();
}

class _SystemAnnouncementsState extends State<SystemAnnouncements> {
  AppTextScreen _appText;
  List<AnnouncementModel> announcements = [];

  @override
  void initState() {
    super.initState();
    _appText = getAppTextScreen("systemAnnouncement");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchAnnouncemnts();
    });
  }

  _fetchAnnouncemnts() async {
    announcements = await GameService.getSystemAnnouncements();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (_, theme, __) {
        return Container(
          decoration: AppDecorators.bgRadialGradient(theme),
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: CustomAppBar(
                theme: theme,
                context: context,
                titleText: _appText['title'],
              ),
              body: (announcements == null || announcements.isEmpty)
                  ? Center(
                      child: Text("No Announcements"),
                    )
                  : ListView.builder(
                      itemCount: announcements.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        AnnouncementModel model = announcements[index];
                        Widget icon = Icon(Icons.info_outline);
                        if (model.level == 'IMPORTANT') {
                            icon = SvgPicture.asset(
                              "assets/icons/critical.svg",
                                color: theme.accentColor,
                            );
                        }
                        return Container(
                          decoration:
                              AppDecorators.tileDecorationWithoutBorder(theme),
                          margin:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: ListTile(
                            leading: icon,
                            title: Text("${model.text}"),
                            subtitle: Text(
                                "${DateFormat("dd-MMM-yyyy").format((DateTime.parse(model.createdAt.toString())))}"),
                          ),
                        );
                      },
                    ),
            ),
          ),
        );
      },
    );
  }
}
