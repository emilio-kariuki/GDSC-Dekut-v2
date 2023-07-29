import 'package:bloc/bloc.dart';
import 'package:gdsc_bloc/Data/Services/Providers/providers.dart';

part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit() : super(AdminInitial());

    void checkUserStatus() async {
    try {
      final isAdmin = await Providers().isUserAdmin();

      if (isAdmin) {
        emit( UserAdmin(isAdmin: true));
      } else {
        emit( UserNotAdmin(isAdmin: false));
      }
    } catch (e) {
      emit( UserNotAdmin(isAdmin: false));
    }
  }
}
