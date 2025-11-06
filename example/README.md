# Flutter Tree Drag Drop Example

This example demonstrates how to use the `tree_view_with_drag_and_drop` package to create an interactive file explorer with drag-and-drop functionality.

## Features Demonstrated

- ✨ Custom data types (`FileItem` class)
- 🎨 Custom styling and icons
- 📂 Folder and file representations
- 🎯 Expand/collapse all functionality
- 🔄 Drag and drop reordering
- 📱 Responsive feedback
- 🎮 Controller API usage

## Running the Example

1. Navigate to the example directory:
   ```bash
   cd example
   ```

2. Get dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Code Structure

### Custom Data Model

The example uses a custom `FileItem` class to represent files and folders:

```dart
class FileItem {
  final String name;
  final IconData icon;
  final FileType type;
  
  FileItem(this.name, this.icon, this.type);
}

enum FileType {
  folder,
  document,
  spreadsheet,
  pdf,
  image,
  video,
}
```

### Tree Structure

The tree is initialized with a hierarchical structure:

```dart
treeData = [
  TreeNode<FileItem>(
    id: '1',
    data: FileItem('Documents', Icons.folder, FileType.folder),
    children: [
      TreeNode<FileItem>(
        id: '1.1',
        data: FileItem('Work', Icons.work, FileType.folder),
        children: [...],
      ),
    ],
  ),
];
```

### Custom Item Builder

The `itemBuilder` creates the visual representation:

```dart
itemBuilder: (context, node, isExpanded) {
  return Material(
    child: InkWell(
      onTap: () { /* Handle tap */ },
      child: Row(
        children: [
          // Expand/collapse icon
          // File/folder icon
          // Name text
          // Drag indicator
        ],
      ),
    ),
  );
}
```

### Controller Usage

The example demonstrates using the controller for expand/collapse all:

```dart
final controller = TreeViewController<FileItem>();

// In AppBar actions:
IconButton(
  icon: Icon(Icons.unfold_more),
  onPressed: () => controller.expandAll(),
),
IconButton(
  icon: Icon(Icons.unfold_less),
  onPressed: () => controller.collapseAll(),
),
```

## Learning Points

1. **Generic Types**: How to use custom data types with `TreeNode<T>`
2. **Custom Builders**: Creating custom UI for tree items
3. **Event Handling**: Responding to reorder and expansion events
4. **Controller API**: Programmatic tree manipulation
5. **State Management**: Using `setState()` to update the tree

## Customization Ideas

Try modifying the example:

- Change colors and icons
- Add more file types
- Implement search functionality
- Add context menus
- Save tree state to local storage
- Add file size information
- Implement sorting

## Need Help?

Check out the main [README](../README.md) for more information and examples.