
import 'package:smart_school/widgets/app_exports.dart';
import 'package:core/theme/index.dart';
import 'package:core/theme/constants/app_colors.dart';
import '../blocs/dues_bloc.dart';
import '../widgets/index.dart';

/// الصفحة الرئيسية لعرض المستحقات
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: "تفاصيل المستحقات",
        actions: [
          AppBarActions.refresh(
            onPressed: () {
              context.read<DuesBloc>().add(GetDuesListEvent());
            },
            isDark: isDark,
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            // Test Connection Button (only in debug mode)
            if (const bool.fromEnvironment('DEBUG'))
              const DuesDebugButton(),
            
            // Dues Content
            Expanded(
              child: BlocBuilder<DuesBloc, DuesState>(
                builder: (context, state) {
                  return _buildContent(context, state, isDark);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// بناء المحتوى بناءً على حالة BLoC
  Widget _buildContent(BuildContext context, DuesState state, bool isDark) {
    if (state is DuesInitial || state is DuesDataLoadingState) {
      return const DuesLoadingWidget();
    } else if (state is DuesDataLoadedState) {
      if (state.dueList.isEmpty) {
        return DuesEmptyWidget(
          onRefresh: () async {
            context.read<DuesBloc>().add(GetDuesListEvent());
          },
        );
      }
      return DuesListWidget(
        duesList: state.dueList,
        onRefresh: () async {
          context.read<DuesBloc>().add(GetDuesListEvent());
        },
      );
    } else if (state is DuesErrorState) {
      return DuesErrorWidget(
        message: state.message,
        onRetry: () {
          context.read<DuesBloc>().add(GetDuesListEvent());
        },
      );
    }
    
    // Default state
    return Center(
      child: Text(
        'حالة غير معروفة',
        style: TextStyle(
          color: isDark ? AppColors.darkSecondaryText : AppColors.gray600,
        ),
      ),
    );
  }
}