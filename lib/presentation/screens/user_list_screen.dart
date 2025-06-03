import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/data/repositories/user_repository.dart';
import 'package:user_management_app/presentation/bloc/user_detail/user_detail_bloc.dart';
import 'package:user_management_app/presentation/bloc/user_detail/user_detail_event.dart';
import '../bloc/user_list/user_list_bloc.dart';
import '../bloc/user_list/user_list_event.dart';
import '../bloc/user_list/user_list_state.dart';
import '../widgets/user_list_item.dart';
import '../widgets/loading_indicator.dart';
import 'user_detail_screen.dart';

/// Main screen displaying paginated list of users with:
/// - Infinite scroll pagination
/// - Real-time search functionality
/// - Pull-to-refresh capability
/// - Navigation to user detail screen
class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});
  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  /// Handles pull-to-refresh action by resetting the user list
  Future<void> _handleRefresh() async {
    context.read<UserListBloc>().add(FetchUsers());
  }

  @override
  void initState() {
    super.initState();
    // Initial data load
    context.read<UserListBloc>().add(FetchUsers());
    // Set up infinite scroll listener
    _scrollController.addListener(_onScroll);
  }

  /// Handles infinite scroll logic
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<UserListBloc>().add(LoadMoreUsers());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                // Trigger search or reset based on query
                if (query.isEmpty) {
                  context.read<UserListBloc>().add(FetchUsers());
                } else {
                  context.read<UserListBloc>().add(SearchUsers(query));
                }
              },
            ),
          ),

          // User List with Refresh
          Expanded(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: BlocBuilder<UserListBloc, UserListState>(
                builder: (context, state) {
                  // Loading State
                  if (state is UserListLoading) {
                    return LoadingIndicator();
                  }
                  // Loaded State
                  else if (state is UserListLoaded) {
                    if (state.users.isEmpty) {
                      return const Center(child: Text('No users found.'));
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: state.hasReachedMax
                          ? state.users.length
                          : state.users.length + 1,
                      itemBuilder: (context, index) {
                        // Show loading indicator at bottom
                        if (index >= state.users.length) {
                          return LoadingIndicator();
                        }
                        final user = state.users[index];
                        return UserListItem(
                          user: user,
                          onTap: () {
                            // Navigate to detail screen with new BLoC instance
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (_) =>
                                      UserDetailBloc(UserRepository())
                                        ..add(FetchUserDetail(user.id)),
                                  child: UserDetailScreen(user: user),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                  // Error State
                  else if (state is UserListError) {
                    return Center(child: Text(state.message));
                  }

                  // Initial State
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
