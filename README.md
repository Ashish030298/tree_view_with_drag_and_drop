# Flutter Tree Drag Drop

A customizable Flutter tree view widget with intuitive drag-and-drop support for reordering nodes. Perfect for file explorers, organizational charts, menu systems, and any hierarchical data visualization.

[![pub package](https://img.shields.io/pub/v/tree_view_with_drag_and_drop.svg)](https://pub.dev/packages/tree_view_with_drag_and_drop)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## Features

✨ **Generic Data Support** - Use any data type with `TreeNode<T>`  
🎯 **Drag & Drop** - Intuitive reordering with visual feedback  
🎨 **Highly Customizable** - Control appearance and behavior  
📂 **Expand/Collapse** - Show or hide child nodes  
🎮 **Controller API** - Programmatically control the tree  
⚡ **Performance** - Efficiently handles large trees  
🔒 **Circular Dependency Prevention** - Built-in safety checks

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  tree_view_with_drag_and_drop: ^1.0.3
```

Then run:

```bash
flutter pub get
```

## Quick Start

### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:tree_view_with_drag_and_drop/tree_view_with_drag_and_drop.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List<TreeNode<String>> treeData;

  @override
  void initState() {
    super.initState();
    treeData = [
      TreeNode<String>(
        id: '1',
        data: 'Documents',
        children: [
          TreeNode<String>(id: '1.1', data: 'Work'),
          TreeNode<String>(id: '1.2', data: 'Personal'),
        ],
      ),
      TreeNode<String>(
        id: '2',
        data: 'Photos',
        children: [
          TreeNode<String>(id: '2.1', data: 'Vacation'),
          TreeNode<String>(id: '2.2', data: 'Family'),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Tree View Demo')),
        body: TreeView<String>(
          nodes: treeData,
          itemBuilder: (context, node, isExpanded) {
            return ListTile(
              leading: Icon(
                node.hasChildren ? Icons.folder : Icons.insert_drive_file,
              ),
              title: Text(node.data),
              trailing: node.hasChildren
                  ? Icon(isExpanded ? Icons.expand_more : Icons.chevron_right)
                  : null,
              onTap: node.hasChildren
                  ? () {
                      setState(() {
                        node.isExpanded = !node.isExpanded;
                      });
                    }
                  : null,
            );
          },
          onReorder: (draggedNode, targetNode, position) {
            print('Moved ${draggedNode.data} to $position of ${targetNode.data}');
            setState(() {
              // Tree is automatically updated
            });
          },
        ),
      ),
    );
  }
}
```

## Advanced Usage

### Custom Data Types

Use any data type with the generic `TreeNode<T>`:

```dart
class FileItem {
  final String name;
  final IconData icon;
  final int size;

  FileItem(this.name, this.icon, this.size);
}

final treeData = [
  TreeNode<FileItem>(
    id: '1',
    data: FileItem('Documents', Icons.folder, 0),
    children: [
      TreeNode<FileItem>(
        id: '1.1',
        data: FileItem('report.pdf', Icons.picture_as_pdf, 1024),
      ),
    ],
  ),
];

TreeView<FileItem>(
  nodes: treeData,
  itemBuilder: (context, node, isExpanded) {
    return ListTile(
      leading: Icon(node.data.icon),
      title: Text(node.data.name),
      subtitle: node.data.size > 0 
          ? Text('${node.data.size} bytes') 
          : null,
    );
  },
)
```

### Customization

#### Custom Appearance

```dart
TreeView<String>(
  nodes: treeData,
  config: TreeItemConfig(
    indentPerLevel: 32.0,
    dropIndicatorColor: Colors.green,
    dropIndicatorThickness: 3.0,
    highlightColor: Colors.green.shade50,
    highlightBorderColor: Colors.green,
    borderRadius: 12.0,
    dragOpacity: 0.5,
  ),
  itemBuilder: (context, node, isExpanded) {
    // Your custom item widget
  },
)
```

#### Custom Drag Feedback

```dart
TreeView<String>(
  nodes: treeData,
  itemBuilder: (context, node, isExpanded) {
    // Normal item
  },
  feedbackBuilder: (context, node) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.purple.shade100,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.drag_indicator, color: Colors.purple),
          SizedBox(width: 8),
          Text(node.data, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  },
)
```

### Using the Controller

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final TreeViewController<String> controller = TreeViewController<String>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: () => controller.expandAll(),
              child: Text('Expand All'),
            ),
            ElevatedButton(
              onPressed: () => controller.collapseAll(),
              child: Text('Collapse All'),
            ),
          ],
        ),
        Expanded(
          child: TreeView<String>(
            controller: controller,
            nodes: treeData,
            itemBuilder: (context, node, isExpanded) {
              // Your item widget
            },
          ),
        ),
      ],
    );
  }
}
```

### Callbacks

```dart
TreeView<String>(
  nodes: treeData,
  itemBuilder: (context, node, isExpanded) {
    // Item widget
  },
  onReorder: (draggedNode, targetNode, position) {
    print('Node ${draggedNode.id} moved ${position} ${targetNode.id}');
    // Update your data model if needed
  },
  onNodeExpanded: (node, isExpanded) {
    print('Node ${node.id} expanded: $isExpanded');
    // Save expansion state, analytics, etc.
  },
)
```

### Disable Drag & Drop

```dart
TreeView<String>(
  nodes: treeData,
  enableDragAndDrop: false,
  itemBuilder: (context, node, isExpanded) {
    // Read-only tree view
  },
)
```

## API Reference

### TreeNode<T>

| Property | Type | Description |
|----------|------|-------------|
| `id` | `String` | Unique identifier |
| `data` | `T` | Custom data |
| `children` | `List<TreeNode<T>>` | Child nodes |
| `isExpanded` | `bool` | Expansion state |
| `metadata` | `Map<String, dynamic>?` | Additional data |

### TreeView<T>

| Property | Type | Description |
|----------|------|-------------|
| `nodes` | `List<TreeNode<T>>` | Root nodes |
| `itemBuilder` | `Widget Function(...)` | Item widget builder |
| `feedbackBuilder` | `Widget Function(...)?` | Drag feedback builder |
| `config` | `TreeItemConfig` | Visual configuration |
| `enableDragAndDrop` | `bool` | Enable/disable drag & drop |
| `onReorder` | `Function(...)?` | Reorder callback |
| `onNodeExpanded` | `Function(...)?` | Expansion callback |
| `controller` | `TreeViewController<T>?` | Controller instance |

### TreeItemConfig

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `indentPerLevel` | `double` | `24.0` | Indent per level |
| `dropIndicatorColor` | `Color` | `Colors.blue` | Drop line color |
| `dropIndicatorThickness` | `double` | `2.0` | Drop line thickness |
| `highlightColor` | `Color` | `Color(0xFFE3F2FD)` | Highlight color |
| `highlightBorderColor` | `Color` | `Colors.blue` | Highlight border |
| `borderRadius` | `double` | `8.0` | Item border radius |
| `dragOpacity` | `double` | `0.3` | Dragging opacity |

### TreeViewController<T>

| Method | Description |
|--------|-------------|
| `expandAll()` | Expand all nodes |
| `collapseAll()` | Collapse all nodes |
| `treeData` | Get current tree data |
| `updateTreeData(List<TreeNode<T>>)` | Update tree data |

## Examples

Check out the [example](example/) directory for complete working examples:

- **Simple Tree** - Basic file explorer
- **Custom Data** - Using custom objects
- **Styled Tree** - Custom styling and themes
- **Controlled Tree** - Using the controller API

## Tips & Best Practices

1. **Unique IDs**: Always use unique IDs for each node
2. **Performance**: For large trees, consider lazy loading children
3. **State Management**: Integrate with your state management solution
4. **Persistence**: Save tree state (expansion, order) if needed
5. **Validation**: Validate drops in `onReorder` callback

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you find this package useful, please give it a ⭐️ on [GitHub](https://github.com/ashish030298/tree_view_with_drag_and_drop)!

For issues and feature requests, visit the [issue tracker](https://github.com/ashish030298/tree_view_with_drag_and_drop/issues).