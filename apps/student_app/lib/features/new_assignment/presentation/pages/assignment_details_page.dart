
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
  final TextEditingController _submissionTextController =
      TextEditingController();
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

  void _submitAssignment() {
    // TODO: Implement actual submission logic (e.g., to a server)
    final submissionText = _submissionTextController.text;
    Navigator.pop(context, true); // Close the page and return a result
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.assignment.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            if (widget.assignment.teacherImageAttachment != null)
              _buildTeacherImageSection(),
            const SizedBox(height: 24),
            if (widget.assignment.submissionStatus == SubmissionStatus.graded)
              _buildGradedView(context)
            else if (widget.assignment.submissionStatus ==
                SubmissionStatus.submitted)
              _buildSubmittedView()
            else
              _buildSubmissionView(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Image Attachment:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              widget.assignment.teacherImageAttachment!,
              fit: BoxFit.cover,
              width: 300,
              height: 200,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const CircularProgressIndicator();
              },
              errorBuilder: (context, error, stackTrace) {
                return const Text('Failed to load image.');
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildGradedView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const Text(
          'Your Grade:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
        if (widget.assignment.teacherNote != null &&
            widget.assignment.teacherNote!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Teacher\'s Note:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.assignment.teacherNote!,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
      ],
    );
  }

  Widget _buildSubmittedView() {
    return Center(
      child: Column(
        children: [
          Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
          const SizedBox(height: 16),
          const Text(
            'Assignment Submitted!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your submission is awaiting grading.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

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
          onPressed: _submitAssignment,
          child: const Text('Submit Assignment'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 8),
        Text('$label $value', style: const TextStyle(fontSize: 16)),
      ],
    );
  }



  String _getStatusText() {
    if (widget.assignment.submissionStatus == SubmissionStatus.graded) {
      return 'Graded';
    } else if (widget.assignment.submissionStatus ==
        SubmissionStatus.submitted) {
      return 'Submitted';
    } else if (DateTime.now().isAfter(widget.assignment.dueDate)) {
      return 'Late';
    } else {
      return 'Not Submitted yet';
    }
  }

  Color _getStatusColor() {

    if (widget.assignment.submissionStatus == SubmissionStatus.graded) {
      return Colors.green;
    } else if (widget.assignment.submissionStatus ==
        SubmissionStatus.submitted) {
      return Colors.blue;
    } else if (DateTime.now().isAfter(widget.assignment.dueDate)) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }
}
