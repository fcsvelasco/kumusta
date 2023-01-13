import 'package:flutter/material.dart';

import '../../styling/app_theme_data.dart';
import '../../styling/page_heading.dart';

class ChooseIconForm extends StatelessWidget {
  const ChooseIconForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: COLOR[0],
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20,
              ),
              const PageHeading(pageTitle: 'Choose Icon'),
              SizedBox(
                height: constraints.maxHeight * 0.5,
                width: constraints.maxWidth,
                child: const IconsGridView(),
              ),
              ThemedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Back'),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          );
        },
      ),
    );
  }
}

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
