import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme.dart';
import 'data/repositories/user_repository.dart';
import 'presentation/bloc/user_list/user_list_bloc.dart';
import 'presentation/screens/user_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = false;

  void _toggleTheme() => setState(() => _isDark = !_isDark);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => UserListBloc(UserRepository()))],
      child: MaterialApp(
        title: 'User Management',
        theme: _isDark ? darkTheme : lightTheme,
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
            body: UserListScreen(),
          ),
        ),
      ),
    );
  }
}
