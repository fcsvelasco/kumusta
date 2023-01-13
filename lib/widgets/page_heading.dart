import 'package:flutter/material.dart';

class PageHeading extends StatelessWidget {
  //const PageHeading({Key? key}) : super(key: key);
  final String pageTitle;
  final String? pageDescription;
  final Color? pageTitleColor;
  final Color? pageDescriptionColor;

  const PageHeading({
    required this.pageTitle,
    this.pageDescription,
    this.pageTitleColor,
    this.pageDescriptionColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          pageTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: pageTitleColor ?? Theme.of(context).primaryColor,
          ),
        ),
        if (pageDescription != null)
          const SizedBox(
            height: 10,
          ),
        if (pageDescription != null)
          Text(
            pageDescription!,
            style: TextStyle(
              color: pageDescriptionColor,
            ),
          ),
      ],
    );
  }
}
