import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  void _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    
    try {
      // TODO: Load profile from API
      await Future.delayed(const Duration(seconds: 1));
      
      final profile = ProfileModel(
        id: '1',
        name: 'أحمد محمد',
        email: 'ahmed@school.com',
        phone: '+966501234567',
        subject: 'الرياضيات',
        experience: '5 سنوات',
        avatar: null,
      );
      
      emit(ProfileLoaded(profile: profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      // TODO: Update profile via API
      emit(ProfileUpdated(profile: event.profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}

class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String subject;
  final String experience;
  final String? avatar;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.subject,
    required this.experience,
    this.avatar,
  });

  ProfileModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? subject,
    String? experience,
    String? avatar,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      subject: subject ?? this.subject,
      experience: experience ?? this.experience,
      avatar: avatar ?? this.avatar,
    );
  }
} 