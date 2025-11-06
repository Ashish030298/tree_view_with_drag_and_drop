/// A Flutter package that provides a customizable tree view with drag-and-drop support.
///
/// This package allows you to display hierarchical data in a tree structure
/// with the ability to reorder nodes via intuitive drag-and-drop interactions.
///
/// ## Features
///
/// - **Generic Data Support**: Use any data type with `TreeNode<T>`
/// - **Drag & Drop**: Reorder nodes by dragging and dropping
/// - **Customizable**: Customize appearance and behavior
/// - **Expand/Collapse**: Show or hide child nodes
/// - **Controller**: Programmatically control the tree
///
/// ## Usage
///
/// ```dart
/// import 'package:tree_view_with_drag_and_drop/flutter_tree_drag_drop.dart';
///
/// // Create tree nodes
/// final nodes = [
///   TreeNode<String>(
///     id: '1',
///     data: 'Parent',
///     children: [
///       TreeNode<String>(id: '1.1', data: 'Child 1'),
///       TreeNode<String>(id: '1.2', data: 'Child 2'),
///     ],
///   ),
/// ];
///
/// // Use in a widget
/// TreeView<String>(
///   nodes: nodes,
///   itemBuilder: (context, node, isExpanded) {
///     return ListTile(
///       title: Text(node.data),
///       leading: Icon(node.hasChildren ? Icons.folder : Icons.file),
///       onTap: node.hasChildren
///           ? () {
///               node.isExpanded = !node.isExpanded;
///             }
///           : null,
///     );
///   },
///   onReorder: (draggedNode, targetNode, position) {
///     print('Node ${draggedNode.id} moved to ${position} of ${targetNode.id}');
///   },
/// )
/// ```

export './src/tree_node.dart';
export './src/tree_view.dart';
export './src/draggable_tree_item.dart';
export './src/drop_position.dart';