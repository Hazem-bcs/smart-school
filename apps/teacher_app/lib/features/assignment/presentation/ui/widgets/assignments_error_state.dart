import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/assignment_bloc.dart';
import '../../blocs/assignment_event.dart';
import '../../../../../core/responsive/responsive_helper.dart';
import '../../../domain/entities/assignment.dart';

class AssignmentsErrorState extends StatelessWidget {
  final String message;
  final String? searchQuery;
  final String? filter;

  const AssignmentsErrorState({
    super.key,
    required this.message,
    this.searchQuery,
    this.filter,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<AssignmentBloc>().add(
          LoadAssignments(
            searchQuery: searchQuery,
            filter: filter != null ? _parseFilter(filter!) : null,
          ),
        );
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height - 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[400],
                ),
                SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24)),
                Text(
                  'حدث خطأ أثناء تحميل الواجبات',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 8, tablet: 12, desktop: 16)),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 24, desktop: 32),
                  ),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 24, tablet: 32, desktop: 40)),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<AssignmentBloc>().add(
                      LoadAssignments(
                        searchQuery: searchQuery,
                        filter: filter != null ? _parseFilter(filter!) : null,
                      ),
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة المحاولة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24),
                      vertical: ResponsiveHelper.getSpacing(context, mobile: 12, tablet: 16, desktop: 20),
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 16, tablet: 20, desktop: 24)),
                Text(
                  'اسحب للأسفل للتحديث',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to parse filter string back to enum
  // This is needed because we're passing filter as string for simplicity
  AssignmentStatus? _parseFilter(String filterString) {
    switch (filterString.toLowerCase()) {
      case 'graded':
        return AssignmentStatus.graded;
      case 'ungraded':
        return AssignmentStatus.ungraded;
      case 'all':
        return AssignmentStatus.all;
      default:
        return null;
    }
  }
} 