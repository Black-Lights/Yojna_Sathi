import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../config/routes/app_router.dart';
import '../../../schemes/presentation/bloc/schemes_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SchemaMitra'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRouter.notifications);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRouter.settings);
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Schemes'),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: 'Applications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildSchemesTab();
      case 2:
        return _buildApplicationsTab();
      case 3:
        return _buildProfileTab();
      default:
        return const SizedBox();
    }
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to SchemaMitra',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text('Find government schemes you are eligible for'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Categories',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          _buildCategoryGrid(),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      {'name': 'Agriculture', 'icon': Icons.agriculture},
      {'name': 'Education', 'icon': Icons.school},
      {'name': 'Health', 'icon': Icons.health_and_safety},
      {'name': 'Housing', 'icon': Icons.home},
      {'name': 'Women & Child', 'icon': Icons.family_restroom},
      {'name': 'Employment', 'icon': Icons.work},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Card(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRouter.schemeList,
                arguments: {'category': category['name']},
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(category['icon'] as IconData, size: 40),
                const SizedBox(height: 8),
                Text(
                  category['name'] as String,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSchemesTab() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRouter.schemeList);
        },
        child: const Text('View All Schemes'),
      ),
    );
  }

  Widget _buildApplicationsTab() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRouter.applicationsList);
        },
        child: const Text('View Applications'),
      ),
    );
  }

  Widget _buildProfileTab() {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? user?.email ?? 'User';
    final initial = displayName.isNotEmpty ? displayName.substring(0, 1).toUpperCase() : 'U';
    
    return ListView(
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(user?.displayName ?? user?.email ?? 'User'),
          accountEmail: Text(user?.email ?? ''),
          currentAccountPicture: CircleAvatar(
            child: Text(initial),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text('Edit Profile'),
          onTap: () {
            Navigator.of(context).pushNamed(AppRouter.profileEdit);
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            context.read<AuthBloc>().add(SignOutEvent());
            Navigator.of(context).pushReplacementNamed(AppRouter.login);
          },
        ),
      ],
    );
  }
}
