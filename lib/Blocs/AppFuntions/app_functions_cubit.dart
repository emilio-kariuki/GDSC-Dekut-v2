import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gdsc_bloc/Data/Models/resource_model.dart';
import 'package:gdsc_bloc/Data/providers.dart';

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

  void searchResource({required String query}) async {
    try {
      emit(SearchResourceLoading());
      List<Resource> resources =
          await Providers().searchResources(query: query);
      print(resources[0].title);
      emit(SearchResourceSuccess(resources: resources));
    } catch (e) {
      emit(SearchResourceFailure(message: e.toString()));
    }
  }

  void changeAlignment({required bool align}) {
    emit(AlignmentChanged(alignment: !align));
  }
}
