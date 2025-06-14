import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../fetch_image/fetch_image_state.dart';
import 'package:image_picker/image_picker.dart';

class FetchImageCubit extends Cubit<FetchImageState> {
  FetchImageCubit() : super(FetchImageInitial());
  File? image;
  fetchImage()async
  {
    try{
      XFile? image= await ImagePicker().pickImage(source: ImageSource.camera);
      if(image !=null)
        {
          this.image = File(image.path);
          emit(FetchImageDone(File(image.path)));
        }
      else {
        emit(FetchImageInitial());
      }
    }
    catch(error)
    {
      emit(FetchImageInitial());
    }
  }
}
