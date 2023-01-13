import 'package:flutter/material.dart';

import '../styling/app_theme_data.dart';

class IconsGridView extends StatelessWidget {
  const IconsGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5),
            itemCount: ICONS.length,
            itemBuilder: ((context, index) {
              return InkWell(
                onTap: () {
                  Navigator.pop(context, index);
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 10,
                  child: GridTile(
                    child: Icon(
                      ICONS[index],
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
