import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/widgets/app_exports.dart';
import '../blocs/dues_bloc.dart';
import '../widgets/dues_card.dart';
import 'test_dues_connection_page.dart';

class DuesPage extends StatefulWidget {
  const DuesPage({super.key});

  @override
  State<DuesPage> createState() => _DuesPageState();
}

class _DuesPageState extends State<DuesPage> {
  late DuesBloc _duesBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _duesBloc = BlocProvider.of<DuesBloc>(context);
    _duesBloc.add(GetDuesListEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dues Details"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<DuesBloc>().add(GetDuesListEvent());
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            // Test Connection Button (only in debug mode)
            if (const bool.fromEnvironment('DEBUG'))
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TestDuesConnectionPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.bug_report),
                  label: const Text('اختبار الاتصال'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            // Dues List
            Expanded(
              child: BlocBuilder<DuesBloc, DuesState>(
                builder: (context, state) {
                  if (state is DuesInitial || state is DuesDataLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DuesDataLoadedState) {
                    if (state.dueList.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<DuesBloc>().add(GetDuesListEvent());
                        },
                        child: const SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: 200, // Adjust height as needed
                            child: Center(child: Text('No dues found.')),
                          ),
                        ),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<DuesBloc>().add(GetDuesListEvent());
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: state.dueList.length,
                        itemBuilder: (context, index) {
                          return DueCard(dueEntity: state.dueList[index]);
                        },
                      ),
                    );
                  } else if (state is DuesErrorState) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<DuesBloc>().add(GetDuesListEvent());
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: 200, // Adjust height as needed
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Error: ${state.message}'),
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<DuesBloc>().add(GetDuesListEvent());
                                  },
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return const Center(child: Text('Unknown state'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}