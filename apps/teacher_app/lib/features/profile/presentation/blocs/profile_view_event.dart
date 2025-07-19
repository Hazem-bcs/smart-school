import 'package:equatable/equatable.dart';

abstract class ProfileViewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileViewEvent {} 