/// Represents the position where a dragged node can be dropped
/// relative to the target node.
enum DropPosition {
  /// Drop above the target node (as a sibling)
  above,

  /// Drop below the target node (as a sibling)
  below,

  /// Drop inside the target node (as a child)
  inside,
}