import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'edit_task_dialog.dart';
import 'active_tasks_tab.dart';
import 'completed_tasks_tab.dart';

const Color darkBlue = Color(0xFF1E3A8A);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: darkBlue),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: darkBlue,
          foregroundColor: Colors.white,
        ),
        tabBarTheme: TabBarThemeData(
          indicator: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.white, width: 3),
            ),
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const TodoPage(),
    );
  }
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> with TickerProviderStateMixin {
  final _controller = TextEditingController();
  List<Map<String, dynamic>> tasks = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    final data = await DBHelper().getTasks();
    setState(() => tasks = data);
  }

  Future<void> _addTask() async {
    if (_controller.text.isEmpty) return;
    await DBHelper().insertTask(_controller.text);
    _controller.clear();
    _loadTasks();
  }

  Future<void> _toggleTask(int id, int isDone) async {
    await DBHelper().updateTask(id, isDone == 1 ? 0 : 1);
    _loadTasks();
  }

  Future<void> _deleteTask(int id) async {
    await DBHelper().deleteTask(id);
    _loadTasks();
  }

  void _editTask(int id, String title) {
    EditTaskDialog.show(
      context,
      taskId: id,
      taskTitle: title,
      onTaskUpdated: _loadTasks,
    );
  }

  PreferredSizeWidget _buildAppBar(int active, int completed) => AppBar(
    title: const Text(
      "My Tasks",
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    bottom: TabBar(
      controller: _tabController,
      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white54,
      tabs: [
        Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.assignment), const SizedBox(width: 8), Text("Active ($active)"),
        ])),
        Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.check_circle), const SizedBox(width: 8), Text("Completed ($completed)"),
        ])),
      ],
    ),
  );

  Widget _buildInputField() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2))],
    ),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            style: const TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              hintText: "Add a new task...",
              hintStyle: TextStyle(color: Colors.grey.shade400),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: darkBlue, width: 2)),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        FloatingActionButton.extended(
          onPressed: _addTask,
          icon: const Icon(Icons.add),
          label: const Text("Add"),
          backgroundColor: darkBlue,
          foregroundColor: Colors.white,
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final activeTasks = tasks.where((t) => t['isDone'] == 0).toList();
    final completedTasks = tasks.where((t) => t['isDone'] == 1).toList();

    return Scaffold(
      appBar: _buildAppBar(activeTasks.length, completedTasks.length),
      body: Column(
        children: [
          _buildInputField(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ActiveTasksTab(activeTasks: activeTasks, onToggleTask: _toggleTask, onDeleteTask: _deleteTask, onEditTask: _editTask),
                CompletedTasksTab(completedTasks: completedTasks, onToggleTask: _toggleTask, onDeleteTask: _deleteTask, onEditTask: _editTask),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
