import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';

/// A reusable list tile widget for displaying a user's avatar, name, and email.
/// Used in the user list screen to represent each user.
/// [user]: The user data to display.
/// [onTap]: Callback triggered when the tile is tapped.
class UserListItem extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap;

  const UserListItem({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) => ListTile(
    leading: CircleAvatar(backgroundImage: NetworkImage(user.image)),
    title: Text('${user.firstName} ${user.lastName}'),
    subtitle: Text(user.email),
    onTap: onTap,
  );
}
