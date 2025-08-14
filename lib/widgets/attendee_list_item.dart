import 'package:flutter/material.dart';
import '../models/attendee.dart';

class AttendeeListItem extends StatelessWidget {
  final Attendee attendee;
  final VoidCallback onEdit;

  const AttendeeListItem({
    Key? key,
    required this.attendee,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey.shade200, width: 1.0),
      ),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with initials
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    attendee.name.isNotEmpty ? attendee.name[0].toUpperCase() : '?',
                    style: textTheme.headlineSmall?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              // Attendee details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            attendee.name,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(color: Colors.green.shade100),
                          ),
                          child: Text(
                            'Active',
                            style: textTheme.labelSmall?.copyWith(
                              color: Colors.green.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    // Email
                    if (attendee.email.isNotEmpty) 
                      _buildInfoRow(
                        context,
                        Icons.email_outlined,
                        attendee.email,
                      ),
                    // Phone
                    if (attendee.phone != null && attendee.phone!.isNotEmpty)
                      _buildInfoRow(
                        context,
                        Icons.phone_outlined,
                        attendee.phone!,
                      ),
                    // Company
                    if (attendee.company != null && attendee.company!.isNotEmpty)
                      _buildInfoRow(
                        context,
                        Icons.business_outlined,
                        attendee.company!,
                      ),
                    // Designation
                    if (attendee.designation != null && attendee.designation!.isNotEmpty)
                      _buildInfoRow(
                        context,
                        Icons.work_outline,
                        attendee.designation!,
                      ),
                    // Last Updated
                    if (attendee.updatedAt != null)
                      _buildInfoRow(
                        context,
                        Icons.update_outlined,
                        'Updated ${_formatDate(DateTime.fromMillisecondsSinceEpoch(attendee.updatedAt!))}',
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade500,
                        ),
                      ),
                  ],
                ),
              ),
              // Edit button
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.edit_outlined,
                    color: theme.primaryColor,
                    size: 20.0,
                  ),
                ),
                onPressed: onEdit,
                tooltip: 'Edit attendee',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String text, {
    TextStyle? style,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16.0,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              text,
              style: style ??
                  Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade800,
                      ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} ${(difference.inDays / 30).floor() == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}
