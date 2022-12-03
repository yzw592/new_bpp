import 'package:flutter/material.dart';
import 'custom_search_page.dart';

class CustomSearch extends StatelessWidget {
  final Icon icon;
  final String type;
  const CustomSearch({Key? key, required this.icon, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: () {
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=> CustomSearchPage(type: type,)));
    }, icon: icon);
  }
}
