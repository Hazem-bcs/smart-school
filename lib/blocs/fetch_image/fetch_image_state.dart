
import 'dart:io';

import 'package:image_picker/image_picker.dart';


abstract class FetchImageState {}

class FetchImageInitial extends FetchImageState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class FetchImageDone extends FetchImageState {
  final File imageUrl;
  FetchImageDone(this.imageUrl);
  @override
  // TODO: implement props
  List<Object?> get props => [imageUrl];
}
