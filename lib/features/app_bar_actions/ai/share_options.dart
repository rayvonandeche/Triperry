import 'package:flutter/material.dart';
import 'share_option_widget.dart';

/// Shows a bottom sheet with sharing options for AI recommendations
void showShareOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share Recommendations',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ShareOptionWidget(
                  icon: Icons.email,
                  title: 'Email',
                  onTap: () {
                    Navigator.pop(context);
                    // Implement email sharing
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening email...'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                ShareOptionWidget(
                  icon: Icons.message,
                  title: 'Message',
                  onTap: () {
                    Navigator.pop(context);
                    // Implement message sharing
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening messages...'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                ShareOptionWidget(
                  icon: Icons.share,
                  title: 'Social',
                  onTap: () {
                    Navigator.pop(context);
                    // Implement social sharing
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening share menu...'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                ShareOptionWidget(
                  icon: Icons.picture_as_pdf,
                  title: 'PDF',
                  onTap: () {
                    Navigator.pop(context);
                    // Implement PDF export
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Exporting as PDF...'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.add_task),
              title: const Text('Add to My Trips'),
              onTap: () {
                Navigator.pop(context);
                // Implement adding to trips
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Added to My Trips!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}
