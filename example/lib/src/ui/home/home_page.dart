import 'package:example/src/ui/home/widget/time_control_grid.dart';
import 'package:flutter/material.dart';

import '../../data/sample_data.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String title = 'Chess Time Controls';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
        forceMaterialTransparency: true,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
        decoration: BoxDecoration(
          color: colors.shadow,
          border: Border.all(color: colors.outline),
        ),
        child: TimeControlGroupedGrid(
          colors: colors,
          columnCount: 3,
          data: sampleData,
        ),
      ),
    );
  }
}
