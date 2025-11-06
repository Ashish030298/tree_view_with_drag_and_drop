import 'package:flutter/material.dart';
import 'tree_node.dart';
import 'draggable_tree_item.dart';
import 'drop_position.dart';

/// A customizable tree view widget with drag-and-drop support.
///
/// The [TreeView] widget displays hierarchical data in a tree structure
/// and supports reordering nodes via drag and drop.
///
/// Example:
/// ```dart
/// TreeView<String>(
///   nodes: myTreeData,
///   itemBuilder: (context, node, isExpanded) {
///     return ListTile(
///       title: Text(node.data),
///       leading: Icon(node.hasChildren ? Icons.folder : Icons.file),
///     );
///   },
///   onReorder: (draggedNode, targetNode, position) {
///     // Handle reordering
///   },
/// )
/// ```
class TreeView<T> extends StatefulWidget {
  /// The root nodes of the tree
  final List<TreeNode<T>> nodes;

  /// Builder for each tree item
  final Widget Function(BuildContext context, TreeNode<T> node, bool isExpanded) itemBuilder;

  /// Builder for the drag feedback widget (optional)
  final Widget Function(BuildContext context, TreeNode<T> node)? feedbackBuilder;

  /// Configuration for tree item appearance
  final TreeItemConfig config;

  /// Whether drag and drop is enabled
  final bool enableDragAndDrop;

  /// Callback when a node is reordered
  final Function(TreeNode<T> draggedNode, TreeNode<T> targetNode, DropPosition position)? onReorder;

  /// Callback when a node's expansion state changes
  final Function(TreeNode<T> node, bool isExpanded)? onNodeExpanded;

  /// Padding around the tree view
  final EdgeInsetsGeometry? padding;

  /// Controller for programmatic tree manipulation
  final TreeViewController<T>? controller;

  const TreeView({
    super.key,
    required this.nodes,
    required this.itemBuilder,
    this.feedbackBuilder,
    this.config = const TreeItemConfig(),
    this.enableDragAndDrop = true,
    this.onReorder,
    this.onNodeExpanded,
    this.padding,
    this.controller,
  });

  @override
  State<TreeView<T>> createState() => _TreeViewState<T>();
}

class _TreeViewState<T> extends State<TreeView<T>> {
  late List<TreeNode<T>> _treeData;

  @override
  void initState() {
    super.initState();
    _treeData = List.from(widget.nodes);
    widget.controller?._attach(this);
  }

  @override
  void didUpdateWidget(TreeView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.nodes != widget.nodes) {
      _treeData = List.from(widget.nodes);
    }
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach();
      widget.controller?._attach(this);
    }
  }

  @override
  void dispose() {
    widget.controller?._detach();
    super.dispose();
  }

  void _onReorder(TreeNode<T> draggedNode, TreeNode<T> targetNode, DropPosition position, bool isValidInsert) {
    setState(() {
      // Remove the dragged node from its current position
      _removeNode(_treeData, draggedNode);

      // Insert the dragged node at the new position
      _insertNode(_treeData, draggedNode, targetNode, position, isValidInsert);
    });

    // Notify callback
    widget.onReorder?.call(draggedNode, targetNode, position);
  }

  void _removeNode(List<TreeNode<T>> nodes, TreeNode<T> nodeToRemove) {
    for (int i = 0; i < nodes.length; i++) {
      if (nodes[i].id == nodeToRemove.id) {
        nodes.removeAt(i);
        return;
      }
      if (nodes[i].hasChildren) {
        _removeNode(nodes[i].children, nodeToRemove);
      }
    }
  }

  void _insertNode(
    List<TreeNode<T>> nodes,
    TreeNode<T> nodeToInsert,
    TreeNode<T> targetNode,
    DropPosition position,
    bool isValidInsert
  ) {
    for (int i = 0; i < nodes.length; i++) {
      if (nodes[i].id == targetNode.id) {
        switch (position) {
          case DropPosition.above:
            nodes.insert(i, nodeToInsert);
            return;
          case DropPosition.below:
            nodes.insert(i + 1, nodeToInsert);
            return;
          case DropPosition.inside:
            nodes[i].children.add(nodeToInsert);
            nodes[i].isExpanded = true;
            return;
        }
      }
      if (nodes[i].hasChildren) {
        _insertNode(nodes[i].children, nodeToInsert, targetNode, position, isValidInsert);
      }
    }
  }

  void _onToggle(TreeNode<T> node) {
    setState(() {});
    widget.onNodeExpanded?.call(node, node.isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: widget.padding ?? const EdgeInsets.all(16),
      children: _treeData.map((node) {
        return DraggableTreeItem<T>(
          node: node,
          level: 0,
          onReorder: _onReorder,
          onToggle: () => _onToggle(node),
          itemBuilder: widget.itemBuilder,
          feedbackBuilder: widget.feedbackBuilder,
          config: widget.config,
          enableDragAndDrop: widget.enableDragAndDrop,
        );
      }).toList(),
    );
  }

  /// Expands all nodes in the tree
  void expandAll() {
    setState(() {
      _expandAllNodes(_treeData);
    });
  }

  void _expandAllNodes(List<TreeNode<T>> nodes) {
    for (var node in nodes) {
      if (node.hasChildren) {
        node.isExpanded = true;
        _expandAllNodes(node.children);
      }
    }
  }

  /// Collapses all nodes in the tree
  void collapseAll() {
    setState(() {
      _collapseAllNodes(_treeData);
    });
  }

  void _collapseAllNodes(List<TreeNode<T>> nodes) {
    for (var node in nodes) {
      node.isExpanded = false;
      if (node.hasChildren) {
        _collapseAllNodes(node.children);
      }
    }
  }

  /// Gets the current tree data
  List<TreeNode<T>> get treeData => _treeData;

  /// Updates the tree data
  void updateTreeData(List<TreeNode<T>> newData) {
    setState(() {
      _treeData = List.from(newData);
    });
  }
}

/// Controller for programmatically manipulating the tree view
class TreeViewController<T> {
  _TreeViewState<T>? _state;

  void _attach(_TreeViewState<T> state) {
    _state = state;
  }

  void _detach() {
    _state = null;
  }

  /// Expands all nodes in the tree
  void expandAll() {
    _state?.expandAll();
  }

  /// Collapses all nodes in the tree
  void collapseAll() {
    _state?.collapseAll();
  }

  /// Gets the current tree data
  List<TreeNode<T>>? get treeData => _state?.treeData;

  /// Updates the tree data
  void updateTreeData(List<TreeNode<T>> newData) {
    _state?.updateTreeData(newData);
  }
}