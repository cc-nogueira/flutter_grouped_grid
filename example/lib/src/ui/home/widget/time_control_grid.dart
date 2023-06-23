import 'package:flutter/material.dart';
import 'package:grouped_grid/grouped_grid.dart';

import '../../../domain/entity/time_control.dart';

class TimeControlGroupedGrid extends StatelessWidget {
  const TimeControlGroupedGrid({
    super.key,
    required this.colors,
    required this.columnCount,
    required this.data,
  });

  final ColorScheme colors;
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
    return Material(
      color: colors.shadow,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 8.0),
        child: Row(
          children: [
            Icon(_timeControlIcon(group), size: 20),
            const SizedBox(width: 4.0),
            Text(group.name),
          ],
        ),
      ),
    );
  }

  IconData _timeControlIcon(TimeControlType timeControlType) {
    return switch (timeControlType) {
      TimeControlType.bullet => Icons.rocket_launch,
      TimeControlType.blitz => Icons.flash_on,
      TimeControlType.rapid => Icons.timer,
      TimeControlType.classic => Icons.timelapse,
    };
  }

  /// Rounds the item number up to a multiple of the column count.
  /// This way we will render extra items to have a nice empty cell display.
  int _itemCountForGroup(TimeControlType key) => (data[key]!.length.toDouble() / columnCount).ceil() * columnCount;

  /// Build a [TimeControl] tile.
  Widget _itemBuilder(BuildContext context, ({TimeControlType key, int itemIndex}) group) {
    final items = data[group.key]!;
    // Empty cell?
    if (group.itemIndex >= items.length) {
      return const Material();
    }

    final timeControl = items[group.itemIndex];
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _favIcon(timeControl),
          _timeLabel(timeControl),
          _incrementTypeLabel(timeControl),
        ],
      ),
    );
  }

  Widget _timeLabel(TimeControl timeControl) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colors.onBackground),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(timeControl.givenTimeInMinutes.toString()),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: Text('|'),
            ),
            Text(timeControl.bonusTimeInSeconds.toString()),
          ],
        ),
      ),
    );
  }

  Widget _incrementTypeLabel(TimeControl timeControl) {
    final label = switch (timeControl.incrementType) {
      IncrementType.noIncrement => 'No Increment',
      IncrementType.fisher => 'Fischer',
    };
    return Text(label);
  }

  Widget _favIcon(TimeControl timeControl) => timeControl.favourite
      ? Icon(Icons.star_outlined, color: colors.primary, size: 24)
      : Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Icon(Icons.star_outline_outlined, color: colors.inversePrimary, size: 20),
        );
}
