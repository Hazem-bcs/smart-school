import 'package:smart_school/features/homework/presentation/blocs/question_bloc/question_bloc.dart';
import 'package:smart_school/widgets/app_exports.dart';

import '../widgets/question_card.dart';

class OneHomeworkPage extends StatefulWidget {
  final int questionId;

  const OneHomeworkPage({super.key, required this.questionId});

  @override
  State<OneHomeworkPage> createState() => _OneHomeworkPageState();
}

class _OneHomeworkPageState extends State<OneHomeworkPage> {
  @override
  void initState() {
    context.read<QuestionBloc>().add(
      GetListQuestionEvent(homeWorkId: widget.questionId),
    );
    super.initState();
  }

  final Map<int, bool> answers = {};
  final Map<int, int> marks = {};

  int get totalScore {
    int sum = 0;
    answers.forEach((key, value) {
      if (value == true) {
        sum += marks[key] ?? 0;
      }
    });
    return sum;
  }

  void finishExam() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('result of exam'),
            content: Text(
              'your mark is  $totalScore from ${marks.values.fold(0, (a, b) => a + b)}',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  },
                child: const Text('accept'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: AppStrings.homeWork,),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlocBuilder<QuestionBloc, QuestionState>(
          builder: (context, state) {
            if (state is QuestionInitial || state is QuestionLoadingState) {
              return AppLoadingWidget();
            } else if (state is QuestionFailureState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.message}'),
                    ElevatedButton(
                      onPressed: () {
                        context.read<QuestionBloc>().add(
                          GetListQuestionEvent(homeWorkId: widget.questionId),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is GetListQuestionLoadedState) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.questionList.length,
                      itemBuilder:
                          (BuildContext context, int index) {
                        final question = state.questionList[index];

                        if (!marks.containsKey(question.questionNumber)) {
                          marks[question.questionNumber] = question.marks;
                        }

                        return QuestionCard(
                          questionNumber: question.questionNumber,
                          question: question.question,
                          options: question.options,
                          marks: question.marks,
                          correctAnswer: question.correctAnswer,
                          onAnswerSelected:
                              (
                              int qNum,
                              bool isCorrect,
                              int qMarks,
                              ) {
                            setState(() {
                              answers[qNum] = isCorrect;
                              marks[qNum] = qMarks;
                            });
                          },
                        );
                      },

                    ),
                  ),

                  ElevatedButton(
                    onPressed: finishExam,
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(primaryColor),
                    ),
                    child: const Text(
                      'finish exam ',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            }
            return Text("data");
          },
        ),
      ),
    );
  }
}
