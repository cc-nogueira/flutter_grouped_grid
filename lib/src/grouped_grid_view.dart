import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

/// A [GridView] with grouped layout.
///
/// It is a generic class that may infer the generic type from the [groupKeys] iterable type.
///
/// Combines a [CustomScrollView] with a [SliverGrid] merging both configurations.
/// The implementation actually inherits from [CustomScrollView] with all its constructor parameters.
///
/// Defines [CustomScrollView.buildSlivers] to create all elements of this view:
///   * Global header (optional) by [headerBuilder] parameter.
///   * And for each grouped list of items:
///      - Group header (optional) by [groupHeaderBuilder] parameter.
///      - Item widget by [itemBuilder] parameter.
///      - Group footer (optional) by [groupFooterBuilder] parameter.
///   * Global footer (optional) by [footerBuilder] parameter.
///
/// Allows to define whether optional group headers will be rendered as sticky headers or not.
/// Allows to define whether empty groups will be skipped (no header and footer for empty groups).
///
/// Note that [itemBuilder] callback uses new Dart 3 Records in its signature :)
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

  /// The delegate that controls the size and position of the children, ex. [SliverGridDelegateWithFixedCrossAxisCount].
  final SliverGridDelegate gridDelegate;

  /// Iterable for all group keys.
  /// Values will be used for creating headers, footers and items in  in [buildSlivers].
  final Iterable<T> groupKeys;

  /// Optional global header builder.
  final WidgetBuilder? headerBuilder;

  /// Optional global footer builder.
  final WidgetBuilder? footerBuilder;

  /// Optional group header builder that will be invoked for each group key value.
  final Widget Function(BuildContext context, T key)? groupHeaderBuilder;

  /// Optional group footer builder that will be invoked for each group key value.
  final Widget Function(BuildContext context, T key)? groupFooterBuilder;

  /// Callback to define the number of items in each group.
  /// Will be called for each group key value in [buildSlivers].
  final int Function(T group) itemCountForGroup;

  /// Item builder with Dart 3 Records signature.
  /// Will be invoked for each group key value and each itemIndex in the range returned by [itemCountForGroup].
  final Widget Function(BuildContext context, ({T key, int itemIndex}) group) itemBuilder;

  /// Define whether group headers are sticky in the list of groups display.
  final bool groupStickyHeaders;

  /// Define whether empty groups will be skipped to not display it's group header and footer.
  final bool skipEmptyGroups;

  /// A [SliverGrid] property.
  final bool addAutomaticKeepAlive;

  /// A [SliverGrid] property.
  final bool addRepaintBoundaries;

  /// A [SliverGrid] property.
  final bool addSemanticIndexes;

  /// Build [CustomScrollView] slivers.
  ///
  /// Layout has:
  ///   * Global header (optional) by [headerBuilder] parameter.
  ///   * And for each grouped list of items:
  ///      - Group header (optional) by [groupHeaderBuilder] parameter.
  ///      - Item widget by [itemBuilder] parameter.
  ///      - Group footer (optional) by [groupFooterBuilder] parameter.
  ///   * Global footer (optional) by [footerBuilder] parameter.
  ///
  /// Allows to define whether optional group headers will be rendered as sticky headers or not.
  /// Allows to define whether empty groups will be skipped (no header and footer for empty groups).
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
