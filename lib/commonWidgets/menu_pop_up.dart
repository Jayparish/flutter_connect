import 'package:flutter/material.dart';
import 'package:photomall_connect/constants/common_constants.dart';
import 'package:popover/popover.dart';

class MenuPopUp extends StatefulWidget {
  final List <Widget> children;
  const MenuPopUp({super.key, required this.children});

  @override
  State<MenuPopUp> createState() => _MenuPopUpState();
}

class _MenuPopUpState extends State<MenuPopUp> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
            showPopover(
            arrowHeight: 2,height: 150,width: 120,
            context: context,
            bodyBuilder: (context) =>  Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Container(

                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    children: widget.children
                  ),
                ),
              )
            )  );


      },
      child: const Icon(
        Icons.more_vert,
        color: Color(photomallConnectColour),
        size: 28,
      ),
    );
  }
}



class MenuItems extends StatefulWidget {


  const MenuItems({super.key, });

  @override
  State<MenuItems> createState() => _MenuItemsState();
}

class _MenuItemsState extends State<MenuItems> {
  static Color textColour = Colors.black;
  Color iconColour = Colors.black;
  TextStyle style =
  TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: textColour);
  double iconSize = 22;
  @override
  Widget build(BuildContext context) {

    return Container(

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}