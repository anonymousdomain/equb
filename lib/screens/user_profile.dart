import 'package:equb/provider/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProifle extends StatelessWidget {
  const UserProifle({super.key});

  @override
  Widget build(BuildContext context) {
    AuthState provider = Provider.of<AuthState>(context);
    final user = provider.user;
    print(user);
    return Container(
      child: Text('hello'),
    );
  }
}
