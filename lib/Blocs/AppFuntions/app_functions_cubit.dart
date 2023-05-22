import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'app_functions_state.dart';

class AppFunctionsCubit extends Cubit<AppFunctionsState> {
  AppFunctionsCubit() : super(const PasswordVisibile(isVisible: false));

  void changePasswordVisibility({required bool isVisible}) {
    if (isVisible) {
      emit(PasswordVisibile(isVisible: isVisible));
    } else {
      emit(PasswordInvisibile(isVisible: !isVisible));
    }
  }

  void changeTab({required int index}) {
    emit(TabChanged(index: index));
  }

  void changeCarousel({required int index}) {
    emit(CarouselChanged(index: index));
  }

  

  void changeAlignment({required bool align}) {
    emit(AlignmentChanged(alignment: !align));
  }
}
