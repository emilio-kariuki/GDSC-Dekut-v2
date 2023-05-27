import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gdsc_bloc/Data/Models/announcement_model.dart';
import 'package:gdsc_bloc/Data/Repository/providers.dart';

part 'announcement_state.dart';

class AnnouncementCubit extends Cubit<AnnouncementState> {
  AnnouncementCubit() : super(AnnouncementInitial());

   void getAnnoucements() async {
    try {
      emit(AnnouncementLoading());
      final announcements = await Providers().getAnnoucement();
      emit(AnnouncementSuccess(announcements: announcements));
    } catch (e) {
      emit(AnnouncementFailure(message: e.toString()));
    }
  }
}
