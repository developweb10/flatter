import 'package:flutter/material.dart';
import 'package:krushapp/ui/pages/home/chat_page.dart';
import 'package:krushapp/utils/utils.dart';

class CategorySelector extends StatefulWidget {

  final Function onClick;

  const CategorySelector({Key key, this.onClick}) : super(key: key);

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  int selectedIndex = 0;
  final List<String> categories = [
    'Messages',
    'My Krushes',
  ];
  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.0,
      color: Theme.of(context).primaryColor,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {

          return GestureDetector(
            onTap:  () {
              setState(() {
                selectedIndex = index;
              //  indexTab=index;

                widget.onClick(index);
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 35.0,
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  color: index == selectedIndex ? Colors.white : Colors.white60,
                  fontSize: 18.0,
                  fontWeight: FontWeight. bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
