import 'package:smart_school/widgets/app_exports.dart';
import '../blocs/resource_bloc.dart';
import '../widgets/resource_card.dart';

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});
  @override
  State<ResourcesPage> createState() => _ResourcesListPageState();
}

class _ResourcesListPageState extends State<ResourcesPage> {
  @override
  void initState() {
    super.initState();
    context.read<ResourceBloc>().add(GetResourceDataListEvent());
  }

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
            onPressed: () {
              context.read<ResourceBloc>().add(GetResourceDataListEvent());
            },
            isDark: Theme.of(context).brightness == Brightness.dark,
          ),
        ],
      ),
      body: BlocBuilder<ResourceBloc, ResourceState>(
        builder: (context, state) {
          if (state is GetResourceDataLoadingState) {
            return const Center(
              child: AppLoadingWidget(),
            );
          } else if (state is ResourceDataListLoadedState) {
            final resources = state.resourceList;
            if (resources.isEmpty) {
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: const SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'No resources available at the moment.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.builder(
                  itemCount: resources.length,
                  itemBuilder: (context, index) {
                    final resource = resources[index];
                    return ResourceCard(resource: resource);
                  },
                ),
              );
            }
          } else if (state is ResourceErrorState) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Error: ${state.message}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ),
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: const SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Tap to load resources or pull down to refresh.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
