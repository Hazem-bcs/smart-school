import 'package:flutter/material.dart';
import '../../domain/entities/assignment_entity.dart';

class AssignmentCard extends StatefulWidget {
  final AssignmentEntity assignment;
  final VoidCallback onTap;

  const AssignmentCard({
    super.key,
    required this.assignment,
    required this.onTap,
  });

  @override
  State<AssignmentCard> createState() => _AssignmentCardState();
}

class _AssignmentCardState extends State<AssignmentCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    Color statusColor = _getStatusColor();
    final isNew = DateTime.now().difference(widget.assignment.createdAt).inHours <= 48;
    final isOverdue = DateTime.now().isAfter(widget.assignment.dueDate) && 
                      widget.assignment.submissionStatus == SubmissionStatus.notSubmitted;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _isHovered ? _scaleAnimation.value : 1.0,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: GestureDetector(
              onTap: widget.onTap,
              onTapDown: (_) => setState(() => _isHovered = true),
              onTapUp: (_) => setState(() => _isHovered = false),
              onTapCancel: () => setState(() => _isHovered = false),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(_isHovered ? 0.15 : 0.08),
                      blurRadius: _isHovered ? 12 : 8,
                      offset: Offset(0, _isHovered ? 4 : 2),
                    ),
                  ],
                  border: Border.all(
                    color: statusColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    // Status indicator bar
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Status icon
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getStatusIcon(),
                              color: statusColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.assignment.title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: theme.textTheme.titleMedium?.color,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (isNew)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.new_releases,
                                              size: 14,
                                              color: Colors.orange[700],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'جديد',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orange[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: isOverdue ? Colors.red : Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'تاريخ التسليم: ${_formatDate(widget.assignment.dueDate)}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isOverdue ? Colors.red : Colors.grey[600],
                                        fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.scoreboard,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'النقاط: ${widget.assignment.points}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: statusColor.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    _getStatusText(),
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Arrow icon
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getStatusText() {
    switch (widget.assignment.submissionStatus) {
      case SubmissionStatus.notSubmitted:
        if (DateTime.now().isAfter(widget.assignment.dueDate)) {
          return 'متأخر';
        }
        return 'لم يتم التسليم';
      case SubmissionStatus.submitted:
        return 'تم التسليم';
      case SubmissionStatus.graded:
        return 'مُقيّم: ${widget.assignment.grade}/${widget.assignment.points}';
    }
  }

  Color _getStatusColor() {
    if (widget.assignment.submissionStatus == SubmissionStatus.graded) {
      return Colors.green;
    } else if (widget.assignment.submissionStatus == SubmissionStatus.submitted) {
      return Colors.blue;
    } else if (DateTime.now().isAfter(widget.assignment.dueDate)) {
      return Colors.red;
    } else {
      return Colors.orange;
    }
  }

  IconData _getStatusIcon() {
    if (widget.assignment.submissionStatus == SubmissionStatus.graded) {
      return Icons.check_circle;
    } else if (widget.assignment.submissionStatus == SubmissionStatus.submitted) {
      return Icons.upload_file;
    } else if (DateTime.now().isAfter(widget.assignment.dueDate)) {
      return Icons.warning;
    } else {
      return Icons.assignment;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference < 0) {
      return 'منذ ${difference.abs()} يوم';
    } else if (difference == 0) {
      return 'اليوم';
    } else if (difference == 1) {
      return 'غداً';
    } else if (difference < 7) {
      return 'خلال $difference أيام';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
