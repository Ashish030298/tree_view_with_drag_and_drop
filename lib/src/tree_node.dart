/// A node in the tree structure that can hold custom data of any type.
///
/// The [TreeNode] class represents a node in a hierarchical tree structure.
/// It can contain custom data of type [T] and supports parent-child relationships.
class TreeNode<T> {
  /// Unique identifier for this node
  final String id;

  /// The custom data associated with this node
  final T data;

  /// Child nodes of this node
  final List<TreeNode<T>> children;

  /// Whether this node is currently expanded (showing children)
  bool isExpanded;

  /// Additional metadata that can be attached to the node
  final Map<String, dynamic>? metadata;

  /// Creates a tree node with the given properties.
  ///
  /// [id] must be unique within the tree.
  /// [data] contains the custom data for this node.
  /// [children] is the list of child nodes (defaults to empty list).
  /// [isExpanded] determines if children are visible (defaults to false).
  /// [metadata] can store additional information about the node.
  TreeNode({
    required this.id,
    required this.data,
    List<TreeNode<T>>? children,
    this.isExpanded = false,
    this.metadata,
  }) : children = children != null ? List.from(children) : [];

  /// Creates a copy of this node with optional changes to properties
  TreeNode<T> copyWith({
    String? id,
    T? data,
    List<TreeNode<T>>? children,
    bool? isExpanded,
    Map<String, dynamic>? metadata,
  }) {
    return TreeNode<T>(
      id: id ?? this.id,
      data: data ?? this.data,
      children: children ?? this.children,
      isExpanded: isExpanded ?? this.isExpanded,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Checks if this node has any children
  bool get hasChildren => children.isNotEmpty;

  @override
  String toString() {
    return 'TreeNode(id: $id, data: $data, children: ${children.length}, isExpanded: $isExpanded)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TreeNode<T> && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}