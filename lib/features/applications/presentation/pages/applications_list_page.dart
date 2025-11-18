import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/applications_bloc.dart';
import '../../data/models/user_scheme.dart';

class ApplicationsListPage extends StatelessWidget {
  const ApplicationsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return BlocProvider(
      create: (context) => sl<ApplicationsBloc>()
        ..add(LoadUserApplicationsEvent(userId ?? '')),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Applications'),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                // TODO: Implement filter dialog
              },
            ),
          ],
        ),
        body: BlocBuilder<ApplicationsBloc, ApplicationsState>(
          builder: (context, state) {
            if (state is ApplicationsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ApplicationsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading applications',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<ApplicationsBloc>()
                            .add(LoadUserApplicationsEvent(userId ?? ''));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is ApplicationsLoaded) {
              if (state.applications.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Applications Yet',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start exploring schemes and apply',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<ApplicationsBloc>()
                      .add(LoadUserApplicationsEvent(userId ?? ''));
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.applications.length,
                  itemBuilder: (context, index) {
                    final application = state.applications[index];
                    return _ApplicationCard(application: application);
                  },
                ),
              );
            }

            return const Center(child: Text('Loading...'));
          },
        ),
      ),
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  final UserScheme application;

  const _ApplicationCard({required this.application});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to application detail page
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Application details coming soon')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Scheme ID: ${application.schemeId}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _StatusBadge(status: application.status),
                ],
              ),
              const SizedBox(height: 12),
              
              // Application Date
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Applied: ${_formatDate(application.appliedAt ?? application.lastUpdated)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Application Reference
              if (application.applicationRef != null) ...[
                Row(
                  children: [
                    const Icon(Icons.confirmation_number, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      'Ref: ${application.applicationRef}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],

              // Documents Count
              Row(
                children: [
                  const Icon(Icons.attach_file, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    '${application.documents.length} documents uploaded',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),

              // Rejection Reason or Approval Details
              if (application.status.toLowerCase() == 'rejected' &&
                  application.rejectionReason != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info, size: 16, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          application.rejectionReason!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              if (application.status.toLowerCase() == 'approved' &&
                  application.approvalDetails != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, size: 16, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          application.approvalDetails!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      case 'under review':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
