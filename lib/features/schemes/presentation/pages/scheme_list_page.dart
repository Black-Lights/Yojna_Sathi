import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/schemes_bloc.dart';
import '../../data/models/scheme.dart';
import 'scheme_detail_page.dart';

class SchemeListPage extends StatelessWidget {
  final String? category;
  final bool eligibleOnly;

  const SchemeListPage({super.key, this.category, this.eligibleOnly = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SchemesBloc>()
        ..add(category != null
            ? FilterSchemesByCategoryEvent(category!)
            : LoadSchemesEvent()),
      child: SchemeListView(
        category: category,
        eligibleOnly: eligibleOnly,
      ),
    );
  }
}

class SchemeListView extends StatefulWidget {
  final String? category;
  final bool eligibleOnly;

  const SchemeListView({
    super.key,
    this.category,
    this.eligibleOnly = false,
  });

  @override
  State<SchemeListView> createState() => _SchemeListViewState();
}

class _SchemeListViewState extends State<SchemeListView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category ?? 'All Schemes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<SchemesBloc>().add(
                    widget.category != null
                        ? FilterSchemesByCategoryEvent(widget.category!)
                        : LoadSchemesEvent(),
                  );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search schemes...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<SchemesBloc>().add(
                                widget.category != null
                                    ? FilterSchemesByCategoryEvent(
                                        widget.category!)
                                    : LoadSchemesEvent(),
                              );
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  context
                      .read<SchemesBloc>()
                      .add(SearchSchemesEvent(value));
                } else {
                  context.read<SchemesBloc>().add(
                        widget.category != null
                            ? FilterSchemesByCategoryEvent(widget.category!)
                            : LoadSchemesEvent(),
                      );
                }
              },
            ),
          ),

          // Schemes List
          Expanded(
            child: BlocBuilder<SchemesBloc, SchemesState>(
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
                          'Error loading schemes',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<SchemesBloc>().add(
                                  widget.category != null
                                      ? FilterSchemesByCategoryEvent(
                                          widget.category!)
                                      : LoadSchemesEvent(),
                                );
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is SchemesLoaded) {
                  if (state.schemes.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.inbox,
                              size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            'No schemes found',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Try adjusting your search or filters',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.schemes.length,
                    itemBuilder: (context, index) {
                      final scheme = state.schemes[index];
                      return _SchemeCard(scheme: scheme);
                    },
                  );
                }

                return const Center(child: Text('Load schemes to begin'));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SchemeCard extends StatelessWidget {
  final Scheme scheme;

  const _SchemeCard({required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SchemeDetailPage(schemeId: scheme.schemeId),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getCategoryColor(scheme.category),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  scheme.category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Scheme Name
              Text(
                scheme.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Ministry
              Row(
                children: [
                  const Icon(Icons.account_balance, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      scheme.ministry,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                scheme.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),

              // Benefit Amount (if available)
              if (scheme.benefits.amount != null)
                Row(
                  children: [
                    const Icon(Icons.currency_rupee,
                        size: 16, color: Colors.green),
                    Text(
                      '₹${_formatAmount(scheme.benefits.amount!)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      scheme.benefits.type,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
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

  String _formatAmount(double amount) {
    if (amount >= 10000000) {
      return '${(amount / 10000000).toStringAsFixed(1)} Cr';
    } else if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)} L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)} K';
    }
    return amount.toStringAsFixed(0);
  }
}
