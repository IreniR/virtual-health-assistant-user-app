import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor = Colors.black;
  final Text title;
  final AppBar appBar;
  final List<Widget> widgets;
  final IconButton iconButton;

  const BaseAppBar(
      {Key key,
      @required this.title,
      @required this.appBar,
      this.widgets,
      this.iconButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: title,
      centerTitle: true,
      backgroundColor: backgroundColor,
      actions: widgets,
      leading: iconButton,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
