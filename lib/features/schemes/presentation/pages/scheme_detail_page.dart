import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/schemes_bloc.dart';
import '../../data/models/scheme.dart';

class SchemeDetailPage extends StatelessWidget {
  final String schemeId;

  const SchemeDetailPage({super.key, required this.schemeId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<SchemesBloc>()..add(LoadSchemeDetailEvent(schemeId)),
      child: Scaffold(
        body: BlocBuilder<SchemesBloc, SchemesState>(
          builder: (context, state) {
            if (state is SchemesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SchemesError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading scheme',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<SchemesBloc>()
                            .add(LoadSchemeDetailEvent(schemeId));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is SchemeDetailLoaded) {
              return _SchemeDetailView(scheme: state.scheme);
            }

            return const Center(child: Text('Loading...'));
          },
        ),
      ),
    );
  }
}

class _SchemeDetailView extends StatelessWidget {
  final Scheme scheme;

  const _SchemeDetailView({required this.scheme});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              scheme.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _getCategoryColor(scheme.category),
                    _getCategoryColor(scheme.category).withOpacity(0.7),
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  _getCategoryIcon(scheme.category),
                  size: 80,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ),
          ),
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Badge
                Wrap(
                  spacing: 8,
                  children: [
                    Chip(
                      label: Text(scheme.category),
                      backgroundColor: _getCategoryColor(scheme.category),
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                    Chip(
                      label: Text(scheme.source),
                      backgroundColor: Colors.grey[300],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Ministry
                _InfoRow(
                  icon: Icons.account_balance,
                  label: 'Ministry',
                  value: scheme.ministry,
                ),
                const Divider(height: 32),

                // Benefits
                _SectionTitle(title: 'Benefits'),
                const SizedBox(height: 8),
                if (scheme.benefits.amount != null) ...[
                  Row(
                    children: [
                      const Icon(Icons.currency_rupee,
                          size: 32, color: Colors.green),
                      Text(
                        '₹${_formatAmount(scheme.benefits.amount!)}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${scheme.benefits.type} ${scheme.benefits.frequency != null ? "- ${scheme.benefits.frequency}" : ""}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                Text(scheme.benefits.description),
                const Divider(height: 32),

                // Description
                _SectionTitle(title: 'About the Scheme'),
                const SizedBox(height: 8),
                Text(scheme.description),
                const Divider(height: 32),

                // Eligibility
                _SectionTitle(title: 'Eligibility Criteria'),
                const SizedBox(height: 8),
                if (scheme.eligibility.minAge != null ||
                    scheme.eligibility.maxAge != null)
                  _EligibilityItem(
                    icon: Icons.cake,
                    label: 'Age',
                    value:
                        '${scheme.eligibility.minAge ?? "No min"} - ${scheme.eligibility.maxAge ?? "No max"} years',
                  ),
                if (scheme.eligibility.incomeMax != null)
                  _EligibilityItem(
                    icon: Icons.account_balance_wallet,
                    label: 'Income',
                    value: 'Up to ${scheme.eligibility.incomeMax}',
                  ),
                if (scheme.eligibility.categories.isNotEmpty)
                  _EligibilityItem(
                    icon: Icons.group,
                    label: 'Categories',
                    value: scheme.eligibility.categories.join(', '),
                  ),
                if (scheme.eligibility.occupations.isNotEmpty)
                  _EligibilityItem(
                    icon: Icons.work,
                    label: 'Occupations',
                    value: scheme.eligibility.occupations.join(', '),
                  ),
                if (scheme.eligibility.education.isNotEmpty)
                  _EligibilityItem(
                    icon: Icons.school,
                    label: 'Education',
                    value: scheme.eligibility.education.join(', '),
                  ),
                if (scheme.eligibility.states.isNotEmpty)
                  _EligibilityItem(
                    icon: Icons.location_on,
                    label: 'States',
                    value: scheme.eligibility.states.join(', '),
                  ),
                const Divider(height: 32),

                // Documents Required
                _SectionTitle(title: 'Documents Required'),
                const SizedBox(height: 8),
                ...scheme.documentsRequired.map(
                  (doc) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.description,
                            size: 20, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(child: Text(doc)),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 32),

                // Application Process
                _SectionTitle(title: 'How to Apply'),
                const SizedBox(height: 8),
                Text(scheme.applicationProcess),
                const SizedBox(height: 16),

                // Deadlines
                if (scheme.launchDate != null || scheme.deadline != null) ...[
                  const Divider(height: 32),
                  _SectionTitle(title: 'Important Dates'),
                  const SizedBox(height: 8),
                  if (scheme.launchDate != null)
                    _InfoRow(
                      icon: Icons.start,
                      label: 'Launch Date',
                      value: _formatDate(scheme.launchDate!),
                    ),
                  if (scheme.deadline != null)
                    _InfoRow(
                      icon: Icons.event,
                      label: 'Deadline',
                      value: _formatDate(scheme.deadline!),
                      isDeadline: true,
                    ),
                ],
                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _launchURL(scheme.officialLink),
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Official Website'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implement apply functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Application feature coming soon!'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.send),
                    label: const Text('Apply Now'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'agriculture':
        return Colors.green;
      case 'health':
        return Colors.red;
      case 'education':
        return Colors.blue;
      case 'housing':
        return Colors.orange;
      case 'business & entrepreneurship':
        return Colors.purple;
      case 'women & child development':
        return Colors.pink;
      case 'senior citizens & pension':
        return Colors.brown;
      default:
        return Colors.teal;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'agriculture':
        return Icons.agriculture;
      case 'health':
        return Icons.medical_services;
      case 'education':
        return Icons.school;
      case 'housing':
        return Icons.home;
      case 'business & entrepreneurship':
        return Icons.business;
      case 'women & child development':
        return Icons.child_care;
      case 'senior citizens & pension':
        return Icons.elderly;
      default:
        return Icons.category;
    }
  }

  String _formatAmount(double amount) {
    if (amount >= 10000000) {
      return '${(amount / 10000000).toStringAsFixed(2)} Crore';
    } else if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(2)} Lakh';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(2)} Thousand';
    }
    return amount.toStringAsFixed(0);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDeadline;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isDeadline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: isDeadline ? Colors.red : Colors.grey),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isDeadline ? Colors.red : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EligibilityItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _EligibilityItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 24, color: Colors.blue),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(value),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
