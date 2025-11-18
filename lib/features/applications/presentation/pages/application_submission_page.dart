import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../../../core/di/injection_container.dart';
import '../../../schemes/data/models/scheme.dart';
import '../bloc/applications_bloc.dart';

class ApplicationSubmissionPage extends StatefulWidget {
  final Scheme scheme;
  final String userId;

  const ApplicationSubmissionPage({
    super.key,
    required this.scheme,
    required this.userId,
  });

  @override
  State<ApplicationSubmissionPage> createState() => _ApplicationSubmissionPageState();
}

class _ApplicationSubmissionPageState extends State<ApplicationSubmissionPage> {
  final Map<String, File?> _selectedDocuments = {};
  final Map<String, String> _documentNames = {};
  
  // Common document types required for most schemes
  final List<String> _requiredDocuments = [
    'Aadhaar Card',
    'PAN Card',
    'Income Certificate',
    'Caste Certificate',
    'Residence Proof',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize document selections
    for (final doc in _requiredDocuments) {
      _selectedDocuments[doc] = null;
      _documentNames[doc] = '';
    }
  }

  Future<void> _pickDocument(String documentType) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedDocuments[documentType] = File(result.files.single.path!);
          _documentNames[documentType] = result.files.single.name;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking file: $e')),
        );
      }
    }
  }

  void _removeDocument(String documentType) {
    setState(() {
      _selectedDocuments[documentType] = null;
      _documentNames[documentType] = '';
    });
  }

  bool _canSubmit() {
    // At least Aadhaar and one more document should be uploaded
    return _selectedDocuments['Aadhaar Card'] != null &&
        _selectedDocuments.values.where((file) => file != null).length >= 2;
  }

  Future<void> _submitApplication() async {
    if (!_canSubmit()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload at least Aadhaar Card and one more document'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Submission'),
        content: Text(
          'Are you sure you want to apply for ${widget.scheme.name}?\n\n'
          'Documents to be submitted:\n${_selectedDocuments.entries.where((e) => e.value != null).map((e) => '• ${e.key}').join('\n')}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Submit'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final documents = Map<String, File>.fromEntries(
        _selectedDocuments.entries
            .where((entry) => entry.value != null)
            .map((entry) => MapEntry(entry.key, entry.value!)),
      );

      context.read<ApplicationsBloc>().add(
            SubmitApplicationEvent(
              userId: widget.userId,
              schemeId: widget.scheme.schemeId,
              documents: documents,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ApplicationsBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Apply for Scheme'),
        ),
        body: BlocConsumer<ApplicationsBloc, ApplicationsState>(
          listener: (context, state) {
            if (state is ApplicationSubmitted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Application submitted successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context, true);
            } else if (state is ApplicationsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ApplicationSubmitting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(value: state.progress),
                    const SizedBox(height: 16),
                    Text(
                      'Uploading documents... ${(state.progress * 100).toInt()}%',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text('Please wait, do not close this page'),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Scheme Info Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.scheme.name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.scheme.description,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[700],
                                ),
                          ),
                          if (widget.scheme.benefits.amount != null) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.currency_rupee, color: Colors.green),
                                Text(
                                  '₹${widget.scheme.benefits.amount}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Instructions
                  Text(
                    'Required Documents',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• Aadhaar Card is mandatory',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('• Upload at least one more document'),
                        Text('• Accepted formats: PDF, JPG, JPEG, PNG'),
                        Text('• Maximum file size: 5MB per document'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Document Upload Section
                  ..._requiredDocuments.map((docType) {
                    final isSelected = _selectedDocuments[docType] != null;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    isSelected ? Icons.check_circle : Icons.upload_file,
                                    color: isSelected ? Colors.green : Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          docType,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        if (isSelected)
                                          Text(
                                            _documentNames[docType]!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    IconButton(
                                      icon: const Icon(Icons.close, color: Colors.red),
                                      onPressed: () => _removeDocument(docType),
                                    ),
                                ],
                              ),
                              if (!isSelected) ...[
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: () => _pickDocument(docType),
                                    icon: const Icon(Icons.attach_file),
                                    label: const Text('Choose File'),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _canSubmit() ? _submitApplication : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Submit Application',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
