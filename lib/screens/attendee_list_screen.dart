import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

import '../models/attendee.dart';
import '../services/attendee_service.dart';
import '../services/api_service.dart';
import '../widgets/attendee_list_item.dart';
import 'edit_attendee_screen.dart';

class AttendeeListScreen extends StatefulWidget {
  const AttendeeListScreen({super.key});

  @override
  State<AttendeeListScreen> createState() => _AttendeeListScreenState();
}

class _AttendeeListScreenState extends State<AttendeeListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch attendees when the screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAttendees();
    });
  }

  Future<void> _loadAttendees() async {
    await context.read<AttendeeService>().fetchAttendees();
  }

  void _navigateToEditScreen(Attendee attendee) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAttendeeScreen(attendee: attendee),
      ),
    );

    if (result == true) {
      // Refresh the list if an attendee was updated
      await _loadAttendees();
      if (mounted) {
        EasyLoading.showSuccess('Attendee updated successfully!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Attendee Management',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          Tooltip(
            message: 'Refresh',
            child: IconButton(
              icon: const Icon(Icons.refresh_rounded, size: 24),
              onPressed: _loadAttendees,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () {
              // Show debug information
              final service = context.read<AttendeeService>();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Debug Information'),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Loading: ${service.isLoading}'),
                        const SizedBox(height: 8),
                        Text('Error: ${service.error ?? 'None'}'),
                        const SizedBox(height: 8),
                        Text('Attendee Count: ${service.attendees.length}'),
                        const SizedBox(height: 8),
                        if (service.error != null)
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _showApiRequestDetails(context);
                            },
                            child: const Text('Show API Request Details'),
                          ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
            tooltip: 'Debug Information',
          ),
        ],
      ),
      body: Consumer<AttendeeService>(
        builder: (context, attendeeService, _) {
          // Show loading indicator only on initial load
          if (attendeeService.isLoading && attendeeService.attendees.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error message if there's an error
          if (attendeeService.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text(
                      'Failed to load attendees',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      attendeeService.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                      onPressed: _loadAttendees,
                    ),
                  ],
                ),
              ),
            );
          }

          // Show empty state if no attendees
          if (attendeeService.attendees.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.people_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No Attendees Found',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add a new attendee or check your connection',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                    onPressed: _loadAttendees,
                  ),
                ],
              ),
            );
          }

          // Show attendee list
          return RefreshIndicator(
            onRefresh: _loadAttendees,
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: attendeeService.attendees.length,
              itemBuilder: (context, index) {
                final attendee = attendeeService.attendees[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: AttendeeListItem(
                    attendee: attendee,
                    onEdit: () => _navigateToEditScreen(attendee),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showApiRequestDetails(BuildContext context) {
    final uri = Uri.parse('${ApiService.baseUrl}/attendees');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('API Request Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Endpoint:', style: TextStyle(fontWeight: FontWeight.bold)),
              SelectableText(uri.toString()),
              const SizedBox(height: 16),
              const Text('Headers:', style: TextStyle(fontWeight: FontWeight.bold)),
              SelectableText(
                const JsonEncoder.withIndent('  ').convert({
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                  'Authorization': 'Bearer ${ApiService.token}'
                }),
              ),
              const SizedBox(height: 16),
              const Text('Test Request:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final response = await http.get(
                      uri,
                      headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json',
                        'Authorization': 'Bearer ${ApiService.token}'
                      },
                    );
                    
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Response'),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Status Code: ${response.statusCode}'),
                                const SizedBox(height: 16),
                                const Text('Response Body:'),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: SelectableText(
                                    response.body,
                                    style: const TextStyle(fontFamily: 'monospace'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
                child: const Text('Test API Request'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
