import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePage extends StatelessWidget {
  final String name;
  final String email;
  final String profileImageUrl;

  ProfilePage({
    required this.name,
    required this.email,
    required this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[200],
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: profileImageUrl,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 40,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              email,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 32),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Profile'),
              onTap: () {
                // Handle edit profile action
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Handle logout action
              },
            ),
          ],
        ),
      ),
    );
  }
}
