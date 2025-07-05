import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
import '../../blocs/classes_bloc.dart';
import '../../../../../routing/navigation_extension.dart';

class ClassesPage extends StatefulWidget {
  const ClassesPage({super.key});

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  @override
  void initState() {
    super.initState();
    context.read<ClassesBloc>().add(const LoadClasses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('teacher.classes'.tr()),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            onPressed: () {
              context.goToSettings();
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: BlocListener<ClassesBloc, ClassesState>(
        listener: (context, state) {
          if (state is ClassSelected) {
            // Navigate to home page with selected class
            context.goToHome(className: state.selectedClass.name);
          } else if (state is ClassesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<ClassesBloc, ClassesState>(
          builder: (context, state) {
            if (state is ClassesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ClassesLoaded) {
              return _buildClassesList(state.classes);
            } else if (state is ClassesError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 15.w,
                      color: Colors.red,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Error loading classes',
                      style: TextStyle(
                        fontSize: 5.w,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ClassesBloc>().add(const LoadClasses());
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildClassesList(List<ClassModel> classes) {
    return ListView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final classModel = classes[index];
        return Card(
          margin: EdgeInsets.only(bottom: 3.h),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              context.read<ClassesBloc>().add(SelectClass(classModel));
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  // Class Icon
                  Container(
                    width: 15.w,
                    height: 15.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.class_,
                      color: Theme.of(context).primaryColor,
                      size: 8.w,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  
                  // Class Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          classModel.name,
                          style: TextStyle(
                            fontSize: 5.w,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          classModel.subject,
                          style: TextStyle(
                            fontSize: 4.w,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                              size: 4.w,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              '${classModel.studentsCount} students',
                              style: TextStyle(
                                fontSize: 3.5.w,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Arrow Icon
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey[400],
                    size: 4.w,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} 