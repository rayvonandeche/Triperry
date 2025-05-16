import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/app_theme.dart';
import '../models/chat_message.dart';

class AttachmentSelector extends StatelessWidget {
  final Function(List<MessageAttachment>) onAttachmentsSelected;

  const AttachmentSelector({
    Key? key,
    required this.onAttachmentsSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Add Attachment',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAttachmentOption(
                context,
                icon: Icons.photo,
                label: 'Gallery',
                color: Colors.purple,
                onTap: () => _pickImage(context, ImageSource.gallery),
              ),
              _buildAttachmentOption(
                context,
                icon: Icons.camera_alt,
                label: 'Camera',
                color: AppTheme.primaryColor,
                onTap: () => _pickImage(context, ImageSource.camera),
              ),
              _buildAttachmentOption(
                context,
                icon: Icons.location_on,
                label: 'Location',
                color: Colors.green,
                onTap: () => _shareLocation(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: color.withOpacity(0.3), width: 1),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        onAttachmentsSelected([
          MessageAttachment(
            path: pickedFile.path,
            type: AttachmentType.image,
          ),
        ]);
        
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _shareLocation(BuildContext context) {
    // This would normally call a location plugin
    // For this prototype, we'll just use a dummy location
    onAttachmentsSelected([
      MessageAttachment(
        path: 'assets/map_thumbnail.png',
        type: AttachmentType.location,
        description: 'Current Location',
      ),
    ]);
    
    Navigator.pop(context);
  }
}
