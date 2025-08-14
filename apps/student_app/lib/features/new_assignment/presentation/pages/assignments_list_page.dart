// lib/presentation/pages/assignments_list_page.dart

import 'package:flutter/material.dart';
import '../../domain/entities/assignment_entity.dart';
import '../../domain/usecases/get_assignments_usecase.dart';
import '../../data/repositories_impl/assignment_repository_impl.dart';
import '../../data/data_sources/assignment_remote_data_source.dart';
import '../widgets/assignment_card.dart';

// enum لتحديد حالة الفلترة
enum AssignmentFilter { all, graded, ungraded }

class AssignmentsListPage extends StatefulWidget {
  const AssignmentsListPage({super.key});

  @override
  State<AssignmentsListPage> createState() => _AssignmentsListPageState();
}

class _AssignmentsListPageState extends State<AssignmentsListPage> {
  final GetAssignmentsUseCase getAssignmentsUseCase = GetAssignmentsUseCase(
    AssignmentRepositoryImpl(AssignmentRemoteDataSourceImpl()),
  );

  AssignmentFilter _selectedFilter = AssignmentFilter.all;
  List<AssignmentEntity> _allAssignments = [];
  List<AssignmentEntity> _filteredAssignments = [];
  late Future<List<AssignmentEntity>> _assignmentsFuture;

  @override
  void initState() {
    super.initState();
    _assignmentsFuture = _fetchAssignments();
  }

  Future<List<AssignmentEntity>> _fetchAssignments() async {
    final result = await getAssignmentsUseCase('class_a');
    return result.fold(
          (failure) => throw failure,
          (assignments) {
        _allAssignments = assignments;
        _applyFilter();
        return _allAssignments;
      },
    );
  }

  void _applyFilter() {
    setState(() {
      List<AssignmentEntity> tempAssignments;

      switch (_selectedFilter) {
        case AssignmentFilter.all:
          tempAssignments = _allAssignments;
          break;
        case AssignmentFilter.graded:
          tempAssignments = _allAssignments.where((a) => a.submissionStatus == SubmissionStatus.graded).toList();
          break;
        case AssignmentFilter.ungraded:
          tempAssignments = _allAssignments.where((a) => a.submissionStatus != SubmissionStatus.graded).toList();
          break;
      }

      // الترتيب: المهام الجديدة أولاً، ثم المهام حسب تاريخ التسليم
      tempAssignments.sort((a, b) {
        final isNewA = DateTime.now().difference(a.createdAt).inHours <= 48;
        final isNewB = DateTime.now().difference(b.createdAt).inHours <= 48;

        if (isNewA && !isNewB) return -1;
        if (!isNewA && isNewB) return 1;

        return a.dueDate.compareTo(b.dueDate);
      });

      _filteredAssignments = tempAssignments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
      ),
      body: FutureBuilder<List<AssignmentEntity>>(
        future: _assignmentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No assignments found.'));
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildFilterButton('All', AssignmentFilter.all),
                        _buildFilterButton('Graded', AssignmentFilter.graded),
                        _buildFilterButton('Ungraded', AssignmentFilter.ungraded),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredAssignments.length,
                      itemBuilder: (context, index) {
                        final assignment = _filteredAssignments[index];
                        return AssignmentCard(
                          assignment: assignment,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              '/assignment_details',
                              arguments: assignment,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildFilterButton(String text, AssignmentFilter filter) {
    return ElevatedButton(
      onPressed: () {
        _selectedFilter = filter;
        _applyFilter();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedFilter == filter ? Colors.blue[100] : Colors.grey[200],
        foregroundColor: _selectedFilter == filter ? Colors.blue[900] : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(text),
    );
  }
}