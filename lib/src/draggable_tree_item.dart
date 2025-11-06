import 'package:flutter/material.dart';
import 'tree_node.dart';
import 'drop_position.dart';

/// Configuration for the tree item appearance
class TreeItemConfig {
  /// Indent per level in pixels
  final double indentPerLevel;

  /// Color of the drop indicator
  final Color dropIndicatorColor;

  /// Thickness of the drop indicator
  final double dropIndicatorThickness;

  /// Color when item is highlighted for drop
  final Color highlightColor;

  /// Border color when item is highlighted
  final Color highlightBorderColor;

  /// Border width when item is highlighted
  final double highlightBorderWidth;

  /// Border radius for items
  final double borderRadius;

  /// Opacity when item is being dragged
  final double dragOpacity;

  /// Elevation of dragging item
  final double dragElevation;

  const TreeItemConfig({
    this.indentPerLevel = 24.0,
    this.dropIndicatorColor = Colors.blue,
    this.dropIndicatorThickness = 2.0,
    this.highlightColor = const Color(0xFFE3F2FD),
    this.highlightBorderColor = Colors.blue,
    this.highlightBorderWidth = 2.0,
    this.borderRadius = 8.0,
    this.dragOpacity = 0.3,
    this.dragElevation = 4.0,
  });
}

/// A draggable and droppable tree item widget.
///
/// This widget represents a single item in the tree that can be dragged
/// and dropped to reorder the tree structure.
class DraggableTreeItem<T> extends StatefulWidget {
  /// The tree node this item represents
  final TreeNode<T> node;

  /// The nesting level (0 for root items)
  final int level;

  final int maxDepth;

  /// Callback when reorder occurs
  final Function(TreeNode<T>, TreeNode<T>, DropPosition) onReorder;

  /// Callback when node expansion state changes
  final VoidCallback onToggle;

  /// Builder for the item content
  final Widget Function(BuildContext context, TreeNode<T> node, bool isExpanded)
      itemBuilder;

  /// Builder for the drag feedback widget
  final Widget Function(BuildContext context, TreeNode<T> node)?
      feedbackBuilder;

  /// Configuration for the tree item appearance
  final TreeItemConfig config;

  /// Whether drag and drop is enabled
  final bool enableDragAndDrop;

  const DraggableTreeItem({
    super.key,
    required this.node,
    required this.level,
    this.maxDepth = 5,
    required this.onReorder,
    required this.onToggle,
    required this.itemBuilder,
    this.feedbackBuilder,
    this.config = const TreeItemConfig(),
    this.enableDragAndDrop = true,
  });

  @override
  State<DraggableTreeItem<T>> createState() => _DraggableTreeItemState<T>();
}

class _DraggableTreeItemState<T> extends State<DraggableTreeItem<T>> {
  DropPosition? _currentDropPosition;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.enableDragAndDrop)
          _buildDraggableItem()
        else
          _buildItemContent(),
        if (widget.node.isExpanded && widget.node.hasChildren)
          ...widget.node.children.map((child) {
            return DraggableTreeItem<T>(
              node: child,
              level: widget.level + 1,
              onReorder: widget.onReorder,
              onToggle: widget.onToggle,
              itemBuilder: widget.itemBuilder,
              feedbackBuilder: widget.feedbackBuilder,
              config: widget.config,
              enableDragAndDrop: widget.enableDragAndDrop,
            );
          }),
      ],
    );
  }

  Widget _buildDraggableItem() {
    return DragTarget<TreeNode<T>>(
      onWillAcceptWithDetails: (details) {
        final prospectiveDepth = _calculateNewDepth(details.data, widget.node,
              _currentDropPosition ?? DropPosition.inside);
        // Don't allow dropping on self and max depth
        return details.data.id != widget.node.id &&
       prospectiveDepth <= widget.maxDepth;

      },
      onAcceptWithDetails: (details) {
        if (_currentDropPosition != null) {
          widget.onReorder(
              details.data, widget.node, _currentDropPosition!);
        }
        setState(() => _currentDropPosition = null);
      },
      onMove: (details) {
        final RenderBox? box = context.findRenderObject() as RenderBox?;
        if (box == null) return;

        final localPosition = box.globalToLocal(details.offset);
        final itemHeight = box.size.height;

        setState(() {
          if (localPosition.dy < itemHeight * 0.25) {
            _currentDropPosition = DropPosition.above;
          } else if (localPosition.dy > itemHeight * 0.75) {
            _currentDropPosition = DropPosition.below;
          } else {
            _currentDropPosition = DropPosition.inside;
          }
        });
      },
      onLeave: (_) {
        setState(() => _currentDropPosition = null);
      },
      builder: (context, candidateData, rejectedData) {
        return Column(
          children: [
            if (_currentDropPosition == DropPosition.above)
              Container(
                height: widget.config.dropIndicatorThickness,
                color: widget.config.dropIndicatorColor,
                margin: EdgeInsets.only(
                    left: widget.level * widget.config.indentPerLevel),
              ),
            LongPressDraggable<TreeNode<T>>(
              data: widget.node,
              feedback: Material(
                elevation: widget.config.dragElevation,
                child: widget.feedbackBuilder != null
                    ? widget.feedbackBuilder!(context, widget.node)
                    : _buildDefaultFeedback(),
              ),
              childWhenDragging: Opacity(
                opacity: widget.config.dragOpacity,
                child: _buildItemContent(),
              ),
              child: _buildItemContent(),
            ),
            if (_currentDropPosition == DropPosition.below)
              Container(
                height: widget.config.dropIndicatorThickness,
                color: widget.config.dropIndicatorColor,
                margin: EdgeInsets.only(
                    left: widget.level * widget.config.indentPerLevel),
              ),
          ],
        );
      },
    );
  }

  Widget _buildItemContent() {
    final isHighlighted = _currentDropPosition == DropPosition.inside;

    return Container(
      margin: EdgeInsets.only(
        left: widget.level * widget.config.indentPerLevel,
        bottom: 4,
      ),
      decoration: BoxDecoration(
        color: isHighlighted ? widget.config.highlightColor : null,
        border: isHighlighted
            ? Border.all(
                color: widget.config.highlightBorderColor,
                width: widget.config.highlightBorderWidth,
              )
            : null,
        borderRadius: BorderRadius.circular(widget.config.borderRadius),
      ),
      child: widget.itemBuilder(context, widget.node, widget.node.isExpanded),
    );
  }

  Widget _buildDefaultFeedback() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(widget.config.borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.node.hasChildren ? Icons.folder : Icons.insert_drive_file,
            color: Colors.blue.shade700,
          ),
          const SizedBox(width: 8),
          Text(
            widget.node.data.toString(),
            style: TextStyle(
              color: Colors.blue.shade900,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Checks if [ancestor] is an ancestor of [descendant]
  bool _isDescendantOf(TreeNode<T> ancestor, TreeNode<T> descendant) {
    for (var child in ancestor.children) {
      if (child.id == descendant.id) return true;
      if (_isDescendantOf(child, descendant)) return true;
    }
    return false;
  }

  int _calculateNewDepth(TreeNode<T> nodeBeingDragged, TreeNode<T> targetNode,
      DropPosition position) {
    if (position == DropPosition.inside) {
      return widget.level + 1; // inside means child of current node
    } else {
      return widget.level; // above or below stays at the same level
    }
  }
}
