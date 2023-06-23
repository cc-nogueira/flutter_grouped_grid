# grouped_grid
[![Pub](https://img.shields.io/pub/v/grouped_grid.svg?style=flat-square)](https://pub.dev/packages/grouped_grid)
[![support](https://img.shields.io/badge/platform-android%20|%20ios%20|%20linux%20|%20macos%20|%20web%20|%20windows%20-blue.svg)](https://pub.dev/packages/grouped_grid)

A package to display a grouped grid of items.

## Preview
Image for the application in the example folder:

<img width="360px" src="https://github.com/cc-nogueira/flutter_grouped_grid/raw/media/example.gif" alt=""/>

## Features
Provides a grouped GridView variant with:
  - Support for main header and footer.
  - Support for group headers and footers (both optionals).
  - Option to use sticky group headers or not (defaults to sticky group headers).

## SDK Requirements
This package requires **Dart 3** as it uses ***Records syntax*** in the itemBuilder signature.
```yaml
environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.10.0"
 ```

## Usage
The example uses this code to create the grid of **TimeControl** items grouped by **TimeControlType**.

```dart
import 'package:flutter/material.dart';
import 'package:grouped_grid/grouped_grid.dart';

import '../../../domain/entity/time_control.dart';

class TimeControlGroupedGridView extends StatelessWidget {

  const TimeControlGroupedGridView({super.key, required this.data, required this.columnCount});

  final int columnCount;
  final Map<TimeControlType, List<TimeControl>> data;

  @override
  Widget build(BuildContext context) {
    return GroupedGridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnCount,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      groupKeys: data.keys,
      groupHeaderBuilder: _groupHeaderBuilder,
      itemCountForGroup: _itemCountForGroup,
      itemBuilder: _itemBuilder,
    );
  }

  Widget _groupHeaderBuilder(BuildContext context, TimeControlType group) {
    // see example folder
  }

  int _itemCountForGroup(TimeControlType key) {
    // see example folder
  }

  Widget _itemBuilder(BuildContext context, ({TimeControlType key, int itemIndex}) group) {
    // see example folder
  }
}

```

## Aknowlodgements
This project is a merge of ideas from two dart packages and I would like to thank both authors:
  - [group_grid_view](https://pub.dev/packages/group_grid_view)
  - [gouped_scroll_view](https://pub.dev/packages/grouped_scroll_view)