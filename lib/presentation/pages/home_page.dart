import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/components/loading_spinkit.dart';
import 'package:flutter_chat_app/data/datasources/firebase_datasource.dart';
import 'package:flutter_chat_app/data/models/user_model.dart';
import 'package:flutter_chat_app/presentation/pages/chat_page.dart';
import 'package:flutter_chat_app/presentation/pages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0BCAD4),
        centerTitle: true,
        title: const Text('User Chat'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                  (route) => false);
            },
            icon: const Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: FirebaseDatasource.instance.allUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingSpinkit();
          }
          final List<UserModel> users = snapshot.data!
              .where((element) => element.id != currentUser!.uid)
              .toList();
          if (users.isEmpty) {
            return const Center(
              child: Text('No user found'),
            );
          }
          return ListView.separated(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF0BCAD4),
                  radius: 25,
                  child: Text(
                    users[index].name[0].toUpperCase() +
                        users[index].name[1].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(users[index].name),
                subtitle: Text(users[index].email),
                // trailing: const Text('last time'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ChatPage(
                          partnerUser: users[index],
                        );
                      },
                    ),
                  );
                },
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.grey.withOpacity(0.1),
              );
            },
          );
        },
      ),
    );
  }
}
