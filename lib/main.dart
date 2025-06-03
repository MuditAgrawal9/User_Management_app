import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme.dart';
import 'data/repositories/user_repository.dart';
import 'presentation/bloc/user_list/user_list_bloc.dart';
import 'presentation/screens/user_list_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/models/post_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Register Hive adapter for PostModel
  Hive.registerAdapter(PostModelAdapter());

  await Hive.openBox<List>(
    'local_posts',
  ); // Box for storing local posts per user

  runApp(MyApp());
}

/// Root application widget with theme management and state initialization
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = false;

  /// Toggles between light and dark themes
  void _toggleTheme() => setState(() => _isDark = !_isDark);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => UserListBloc(UserRepository()))],
      child: MaterialApp(
        title: 'User Management',
        theme: _isDark ? darkTheme : lightTheme, // Theme configuration
        home: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text('User Management'),
              actions: [
                IconButton(
                  icon: Icon(_isDark ? Icons.light_mode : Icons.dark_mode),
                  onPressed: _toggleTheme,
                ),
              ],
            ),
            // Main screen displaying the user list
            body: UserListScreen(),
          ),
        ),
      ),
    );
  }
}
