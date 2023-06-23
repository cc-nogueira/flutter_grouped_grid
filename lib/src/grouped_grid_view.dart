import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

class GroupedGridView<T> extends CustomScrollView {
  const GroupedGridView({
    super.key,
    required this.gridDelegate,
    required this.groupKeys,
    required this.itemBuilder,
    required this.itemCountForGroup,
    this.headerBuilder,
    this.footerBuilder,
    this.groupHeaderBuilder,
    this.groupFooterBuilder,
    this.groupStickyHeaders = true,
    this.addAutomaticKeepAlive = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.skipEmptyGroups = true,
    super.scrollDirection,
    super.reverse,
    super.controller,
    super.primary,
    super.physics,
    super.scrollBehavior,
    super.shrinkWrap,
    super.center,
    super.anchor,
    super.cacheExtent,
    super.semanticChildCount,
    super.dragStartBehavior,
    super.keyboardDismissBehavior,
    super.restorationId,
    super.clipBehavior,
  });

  final SliverGridDelegate gridDelegate;

  final Iterable<T> groupKeys;
  final WidgetBuilder? headerBuilder;
  final WidgetBuilder? footerBuilder;
  final Widget Function(BuildContext context, T group)? groupHeaderBuilder;
  final Widget Function(BuildContext context, T group)? groupFooterBuilder;

  final int Function(T group) itemCountForGroup;
  final Widget Function(BuildContext context, ({T key, int itemIndex}) group) itemBuilder;

  final bool groupStickyHeaders;
  final bool addAutomaticKeepAlive;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;

  final bool skipEmptyGroups;

  @override
  List<Widget> buildSlivers(BuildContext context) {
    final slivers = <Widget>[];

    if (headerBuilder != null) {
      slivers.add(SliverToBoxAdapter(child: headerBuilder!(context)));
    }

    for (final key in groupKeys) {
      final itemCount = itemCountForGroup(key);
      if (itemCount == 0 && skipEmptyGroups) {
        continue;
      }
      final section = <Widget>[];

      if (groupHeaderBuilder != null) {
        final header = groupHeaderBuilder!(context, key);
        section.add(groupStickyHeaders ? SliverPinnedHeader(child: header) : SliverToBoxAdapter(child: header));
      }

      section.add(
        SliverGrid.builder(
          gridDelegate: gridDelegate,
          itemCount: itemCount,
          itemBuilder: (context, index) => itemBuilder(context, (key: key, itemIndex: index)),
          addAutomaticKeepAlives: addAutomaticKeepAlive,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
        ),
      );

      if (groupFooterBuilder != null) {
        final footer = groupFooterBuilder!(context, key);
        section.add(SliverToBoxAdapter(child: footer));
      }

      slivers.add(
        MultiSliver(
          pushPinnedChildren: groupStickyHeaders,
          children: section,
        ),
      );
    }

    if (footerBuilder != null) {
      slivers.add(SliverToBoxAdapter(child: footerBuilder!(context)));
    }
    return slivers;
  }
}
