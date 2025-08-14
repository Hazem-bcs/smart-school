// lib/presentation/pages/assignment_details_page.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../domain/entities/assignment_entity.dart';

class AssignmentDetailsPage extends StatefulWidget {
  final AssignmentEntity assignment;
  const AssignmentDetailsPage({super.key, required this.assignment});

  @override
  State<AssignmentDetailsPage> createState() => _AssignmentDetailsPageState();
}

class _AssignmentDetailsPageState extends State<AssignmentDetailsPage> {
  final TextEditingController _submissionTextController = TextEditingController();
  File? _selectedImage;

  @override
  void dispose() {
    _submissionTextController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.assignment.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Status
            Text(
              widget.assignment.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _getStatusText(),
              style: TextStyle(
                fontSize: 16,
                color: _getStatusColor(),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),

            // Description and Info
            Text(
              'Description:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              widget.assignment.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            _buildInfoRow(
              'Due Date:',
              '${widget.assignment.dueDate.day}/${widget.assignment.dueDate.month}/${widget.assignment.dueDate.year}',
              Icons.calendar_today,
            ),
            const SizedBox(height: 8),

            _buildInfoRow(
              'Points:',
              '${widget.assignment.points}',
              Icons.scoreboard,
            ),
            const SizedBox(height: 16),

            if (widget.assignment.teacherAttachments.isNotEmpty)
              _buildAttachmentsSection(),

            const SizedBox(height: 24),

            // Conditional View based on status
            if (widget.assignment.submissionStatus == SubmissionStatus.graded)
              _buildGradedView(context)
            else
              _buildSubmissionView(context),
          ],
        ),
      ),
    );
  }

  // Method to build the graded view
  Widget _buildGradedView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Text(
          'Your Grade:',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          '${widget.assignment.grade}/${widget.assignment.points}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed: () {
              // TODO: Implement logic to view submitted work
            },
            child: const Text('View Submitted Work'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ),
      ],
    );
  }

  // Method to build the submission view
  Widget _buildSubmissionView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Answer:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _submissionTextController,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Type your answer here...',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _pickImageFromGallery,
          icon: const Icon(Icons.add_a_photo),
          label: const Text('Add Photo'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
        const SizedBox(height: 8),
        if (_selectedImage != null)
          Text('Selected image: ${_selectedImage!.path.split('/').last}'),

        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // TODO: Implement submission logic
            final submissionText = _submissionTextController.text;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Submission sent! Text: $submissionText, Image: ${_selectedImage?.path}')),
            );
          },
          child: const Text('Submit Assignment'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.green,
          ),
        ),
      ],
    );
  }

  // Helper methods
  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 8),
        Text('$label $value', style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildAttachmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attachments:',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        ...widget.assignment.teacherAttachments.map(
              (attachment) => _buildAttachmentItem(attachment),
        ),
      ],
    );
  }

  Widget _buildAttachmentItem(String fileName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.attachment, size: 20),
          const SizedBox(width: 8),
          Text(fileName),
        ],
      ),
    );
  }

  String _getStatusText() {
    if (widget.assignment.submissionStatus == SubmissionStatus.graded) {
      return 'Graded';
    } else if (DateTime.now().isAfter(widget.assignment.dueDate)) {
      return 'Late';
    } else {
      return 'Not Submitted yet';
    }
  }

  Color _getStatusColor() {
    if (widget.assignment.submissionStatus == SubmissionStatus.graded) {
      return Colors.green;
    } else if (DateTime.now().isAfter(widget.assignment.dueDate)) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }
}