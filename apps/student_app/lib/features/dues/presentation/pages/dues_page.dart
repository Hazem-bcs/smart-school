import 'package:smart_school/widgets/app_exports.dart';
import '../blocs/dues_bloc.dart';
import '../widgets/dues_card.dart';


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
      appBar: AppBarWidget(title: "Dues Details"),
      body: Container(
        margin: EdgeInsets.all(10),
        child: BlocBuilder<DuesBloc, DuesState>(
          builder: (context, state) {
            if (state is DuesInitial || state is DuesDataLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DuesDataLoadedState) {
              if (state.dueList.isEmpty) {
                return const Center(child: Text('No dues found.'));
              }
              return ListView.builder(
                itemCount: state.dueList.length,
                itemBuilder: (context, index) {
                  return DueCard(dueEntity: state.dueList[index]);
                },
              );
            } else if (state is DuesErrorState) {
              return Center(
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
              );
            }
            return const Center(child: Text('Unknown state'));
          },
        ),
      ),
    );
  }
}