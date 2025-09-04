import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/theme/constants/app_strings.dart';
import 'package:core/widgets/unified_loading_indicator.dart';
import 'package:smart_school/widgets/app_exports.dart';
import '../blocs/resource_bloc.dart';
import '../widgets/index.dart';

/// صفحة الموارد - تعرض قائمة بالموارد التعليمية المتاحة
class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});
  
  @override
  State<ResourcesPage> createState() => _ResourcesListPageState();
}

class _ResourcesListPageState extends State<ResourcesPage> {
  @override
  void initState() {
    super.initState();
    // تحميل الموارد عند فتح الصفحة
    context.read<ResourceBloc>().add(GetResourceDataListEvent());
  }

  /// دالة التحديث
  Future<void> _onRefresh() async {
    context.read<ResourceBloc>().add(GetResourceDataListEvent());
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: AppStrings.resources,
        actions: [
          AppBarActions.refresh(
            onPressed: _onRefresh,
            isDark: Theme.of(context).brightness == Brightness.dark,
          ),
        ],
      ),
      body: BlocBuilder<ResourceBloc, ResourceState>(
        builder: (context, state) {
          return _buildBodyContent(state);
        },
      ),
    );
  }

  /// بناء محتوى الجسم حسب الحالة
  Widget _buildBodyContent(ResourceState state) {
    if (state is GetResourceDataLoadingState) {
      return const Center(
        child: SmartSchoolLoading(
          message: AppStrings.loadingResources,
          type: LoadingType.dots,
        ),
      );
    } else if (state is ResourceDataListLoadedState) {
      final resources = state.resourceList;
      if (resources.isEmpty) {
        return ResourceEmptyStateWidget(onRefresh: _onRefresh);
      } else {
        return ResourceListWidget(
          resources: resources,
          onRefresh: _onRefresh,
        );
      }
    } else if (state is ResourceErrorState) {
      return ResourceErrorStateWidget(
        message: state.message,
        onRefresh: _onRefresh,
      );
    } else {
      return ResourceInitialStateWidget(onRefresh: _onRefresh);
    }
  }
}
