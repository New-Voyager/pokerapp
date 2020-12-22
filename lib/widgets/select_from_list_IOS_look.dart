import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';

class IOSLikeCheckList extends StatefulWidget {
  final List<String> list;
  final int selectedIndex;
  final Function(int) onTap;

  IOSLikeCheckList({this.list, this.selectedIndex, this.onTap});

  @override
  _IOSLikeCheckListState createState() => _IOSLikeCheckListState();
}

class _IOSLikeCheckListState extends State<IOSLikeCheckList> {
  int isSelected;

  @override
  void initState() {
    isSelected = widget.selectedIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      body: ListView.separated(
        itemCount: widget.list.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              setState(() {
                isSelected = index;
              });
              widget.onTap(index);
            },
            leading: isSelected == index
                ? Icon(
                    Icons.check,
                    color: Colors.white,
                  )
                : Container(
                    width: 20.0,
                  ),
            title: Text(
              widget.list[index],
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Color(0xff707070),
          );
        },
      ),
    );
  }
}
