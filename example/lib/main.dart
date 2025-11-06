import 'package:flutter/material.dart';
import 'package:tree_view_with_drag_and_drop/flutter_tree_drag_drop.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tree View Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TreeViewDemo(),
    );
  }
}

class TreeViewDemo extends StatefulWidget {
  const TreeViewDemo({super.key});

  @override
  State<TreeViewDemo> createState() => _TreeViewDemoState();
}

class _TreeViewDemoState extends State<TreeViewDemo> {
  late List<TreeNode<FileItem>> treeData;
  final TreeViewController<FileItem> controller = TreeViewController<FileItem>();

  @override
  void initState() {
    super.initState();
    // Initialize sample tree data with custom objects
    treeData = [
      TreeNode<FileItem>(
        id: '1',
        data: FileItem('Documents', Icons.folder, FileType.folder),
        children: [
          TreeNode<FileItem>(
            id: '1.1',
            data: FileItem('Work', Icons.work, FileType.folder),
            children: [
              TreeNode<FileItem>(
                id: '1.1.1',
                data: FileItem('Project A.pdf', Icons.picture_as_pdf, FileType.pdf),
              ),
              TreeNode<FileItem>(
                id: '1.1.2',
                data: FileItem('Budget.xlsx', Icons.table_chart, FileType.spreadsheet),
              ),
            ],
          ),
          TreeNode<FileItem>(
            id: '1.2',
            data: FileItem('Personal', Icons.person, FileType.folder),
            children: [
              TreeNode<FileItem>(
                id: '1.2.1',
                data: FileItem('Resume.docx', Icons.description, FileType.document),
              ),
            ],
          ),
        ],
      ),
      TreeNode<FileItem>(
        id: '2',
        data: FileItem('Photos', Icons.photo_library, FileType.folder),
        children: [
          TreeNode<FileItem>(
            id: '2.1',
            data: FileItem('Vacation 2024', Icons.beach_access, FileType.folder),
            children: [
              TreeNode<FileItem>(
                id: '2.1.1',
                data: FileItem('beach.jpg', Icons.image, FileType.image),
              ),
              TreeNode<FileItem>(
                id: '2.1.2',
                data: FileItem('sunset.jpg', Icons.image, FileType.image),
              ),
            ],
          ),
          TreeNode<FileItem>(
            id: '2.2',
            data: FileItem('Family', Icons.family_restroom, FileType.folder),
          ),
        ],
      ),
      TreeNode<FileItem>(
        id: '3',
        data: FileItem('Videos', Icons.video_library, FileType.folder),
        children: [
          TreeNode<FileItem>(
            id: '3.1',
            data: FileItem('tutorial.mp4', Icons.play_circle, FileType.video),
          ),
        ],
      ),
      TreeNode<FileItem>(
        id: '4',
        data: FileItem('Music', Icons.library_music, FileType.folder),
        children: [
          TreeNode<FileItem>(
            id: '4.1',
            data: FileItem('Rock', Icons.music_note, FileType.folder),
          ),
          TreeNode<FileItem>(
            id: '4.2',
            data: FileItem('Jazz', Icons.music_note, FileType.folder),
          ),
          TreeNode<FileItem>(
            id: '4.3',
            data: FileItem('Classical', Icons.music_note, FileType.folder),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tree View with Drag & Drop'),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.unfold_more),
            onPressed: () => controller.expandAll(),
            tooltip: 'Expand All',
          ),
          IconButton(
            icon: const Icon(Icons.unfold_less),
            onPressed: () => controller.collapseAll(),
            tooltip: 'Collapse All',
          ),
        ],
      ),
      body: TreeView<FileItem>(
        controller: controller,
        nodes: treeData,
        config: const TreeItemConfig(
          indentPerLevel: 24.0,
          dropIndicatorColor: Colors.blue,
          dropIndicatorThickness: 2.0,
          highlightColor: Color(0xFFE3F2FD),
          highlightBorderColor: Colors.blue,
          borderRadius: 8.0,
        ),
        itemBuilder: (context, node, isExpanded) {
          final hasChildren = node.hasChildren;
          final fileItem = node.data;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: hasChildren
                  ? () {
                      setState(() {
                        node.isExpanded = !node.isExpanded;
                      });
                    }
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Opened: ${fileItem.name}'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Row(
                  children: [
                    // Expand/collapse icon
                    if (hasChildren)
                      Icon(
                        isExpanded ? Icons.expand_more : Icons.chevron_right,
                        size: 20,
                      )
                    else
                      const SizedBox(width: 20),
                    const SizedBox(width: 8),
                    // File/folder icon
                    Icon(
                      fileItem.icon,
                      color: hasChildren
                          ? Colors.amber.shade700
                          : _getFileTypeColor(fileItem.type),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    // File/folder name
                    Expanded(
                      child: Text(
                        fileItem.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // Drag indicator
                    Icon(
                      Icons.drag_indicator,
                      color: Colors.grey.shade400,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        feedbackBuilder: (context, node) {
          return Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    node.data.icon,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    node.data.name,
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        onReorder: (draggedNode, targetNode, position) {
          setState(() {
            // Tree is automatically updated
          });
          
          // Show snackbar with reorder info
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Moved "${draggedNode.data.name}" ${position.name} "${targetNode.data.name}"',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        onNodeExpanded: (node, isExpanded) {
          print('Node "${node.data.name}" expanded: $isExpanded');
        },
      ),
    );
  }

  Color _getFileTypeColor(FileType type) {
    switch (type) {
      case FileType.document:
        return Colors.blue.shade600;
      case FileType.spreadsheet:
        return Colors.green.shade600;
      case FileType.pdf:
        return Colors.red.shade600;
      case FileType.image:
        return Colors.purple.shade600;
      case FileType.video:
        return Colors.orange.shade600;
      case FileType.folder:
        return Colors.amber.shade700;
    }
  }
}

// Custom data model for demonstration
class FileItem {
  final String name;
  final IconData icon;
  final FileType type;

  FileItem(this.name, this.icon, this.type);

  @override
  String toString() => name;
}

enum FileType {
  folder,
  document,
  spreadsheet,
  pdf,
  image,
  video,
}