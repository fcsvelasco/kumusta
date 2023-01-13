import 'package:flutter/material.dart';

import '../styling/app_theme_data.dart';
import './icons_gridview.dart';
import './page_heading.dart';

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
