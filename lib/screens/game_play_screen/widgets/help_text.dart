import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';

class HelpText extends StatefulWidget {
  final String text;
  final bool show;
  final AppTheme theme;
  final Function onTap;
  const HelpText({Key key, this.show = true, this.text, this.theme, this.onTap})
      : super(key: key);

  @override
  State<HelpText> createState() => _HelpTextState();
}

class _HelpTextState extends State<HelpText> {
  bool show = true;
  @override
  void initState() {
    super.initState();
    show = widget.show;
  }

  @override
  Widget build(BuildContext context) {
    if (!show) {
      return Container();
    }

    return Stack(clipBehavior: Clip.none, children: [
      InkWell(
          onTap: () {
            setState(() {
              show = false;
            });

            if (widget.onTap != null) {
              widget.onTap();
            }
          },
          child: Column(children: [
            SizedBox(height: 15),
            Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: widget.theme.primaryColorWithDark(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(width: 1, color: widget.theme.accentColor)),
                child: Text(widget.text,
                    style:
                        AppDecorators.getHeadLine6Style(theme: widget.theme))),
          ])),
      Positioned(
        right: 10.0,
        top: 5.0,
        child: GestureDetector(
          onTap: () {
            //Navigator.of(context).pop();
            setState(() {
              show = false;
            });
            if (widget.onTap != null) {
              widget.onTap();
            }
          },
          child: Align(
            alignment: Alignment.topRight,
            child: CircleAvatar(
              radius: 8.0,
              foregroundColor: widget.theme.accentColor,
              backgroundColor: widget.theme.accentColor,
              child:
                  Icon(Icons.close, size: 12, color: widget.theme.primaryColor),
            ),
          ),
        ),
      ),
    ]);
  }
}
