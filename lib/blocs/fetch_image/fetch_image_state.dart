
import 'dart:io';



abstract class FetchImageState {}

class FetchImageInitial extends FetchImageState {
  // TODO: implement props
  List<Object?> get props => [];
}
class FetchImageDone extends FetchImageState {
  final File imageUrl;
  FetchImageDone(this.imageUrl);
  // TODO: implement props
  List<Object?> get props => [imageUrl];
}
