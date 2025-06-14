import 'package:bloc/bloc.dart';
import '../focus_node_cubit/focus_node_state.dart';
class FocusNodeCubit extends Cubit<FocusNodeChanged> {
  FocusNodeCubit() : super(FocusNodeChanged());

  void focusNodeUpdated()=>emit(FocusNodeChanged());

}
