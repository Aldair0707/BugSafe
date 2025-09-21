import 'package:flutter/material.dart';

class UserModel {
  final String fullName;
  final String username;
  final String email;
  final String phone;
  final String country;

  UserModel({
    this.fullName = "Full Name",
    this.username = "Username",
    this.email = "Email address",
    this.phone = "Phone number",
    this.country = "Country",
  });
}

class ProfileScreen extends StatelessWidget {
  final UserModel user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text("BUGSAFE", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo2.jpeg', width: 35, height: 35),
                const SizedBox(height: 2),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, size: 60, color: Colors.black),
            ),
            const SizedBox(height: 15),
            Text(
              user.fullName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(user.username, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 25),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: Text(user.email),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: Text(user.phone),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(user.country),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout),
              label: const Text("Log out", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
