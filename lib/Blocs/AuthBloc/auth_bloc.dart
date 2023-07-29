import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gdsc_bloc/Blocs/AuthenticationBloc/authentication_bloc.dart';
import 'package:gdsc_bloc/Data/Services/Providers/providers.dart';
import 'package:meta/meta.dart';

import '../../Data/Services/Providers/user_providers.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<Login>((event, emit) async {
      try {
        emit(LoginLoading());
        final user = await UserProviders()
            .loginAccount(email: event.email, password: event.password);
        if (user) {
          AuthenticationBloc().add(LoggedIn());
          emit(LoginSuccess());
        } else {
          emit(const LoginFailure(message: 'Login Failed'));
        }
      } catch (e) {
        emit(LoginFailure(message: e.toString()));
      }
    });

    on<Register>((event, emit) async {
      try {
        emit(RegisterLoading());
        final user = await UserProviders().createAccount(
            email: event.email, password: event.password, name: event.name);
        if (user) {
          AuthenticationBloc().add(LoggedIn());
          emit(RegisterSuccess());
        } else {
          emit(const RegisterFailure(message: 'Register Failed'));
        }
      } catch (e) {
        emit(RegisterFailure(message: e.toString()));
      }
    });

    on<Logout>((event, emit) async {
      try {
        emit(LogoutLoading());
        final user = await UserProviders().logoutAccount();
        if (user) {
          AuthenticationBloc().add(LoggedOut());
          emit(LogoutSuccess());
        } else {
          emit(const LogoutFailure(message: 'Logout Failed'));
        }
      } catch (e) {
        emit(LogoutFailure(message: e.toString()));
      }
    });

    on<ResetPasswordEvent>((event, emit) async {
      try {
        emit(ResetPasswordLoading());
        final user = await UserProviders().resetPassword(email: event.email);
        if (user) {
          emit(ResetPasswordSuccess());
        } else {
          emit(const ResetPasswordFailure(message: 'Reset Password Failed'));
        }
      } catch (e) {
        emit(ResetPasswordFailure(message: e.toString()));
      }
    });

    on<ChangePassword>((event, emit) async {
      try {
        emit(ResetPasswordLoading());
        final user = await UserProviders().changePassword(
            email: event.email,
            oldPassword: event.oldPassword,
            newPassword: event.newPassword);
        if (user) {
          emit(ResetPasswordSuccess());
        } else {
          emit(const ResetPasswordFailure(message: 'Update Password Failed'));
        }
      } catch (e) {
        emit(ResetPasswordFailure(message: e.toString()));
      }
    });

    on<DeleteAccount>((event, emit) async {
      try {
        emit(DeleteAccountLoading());
        final user = await UserProviders()
            .deleteAccount(email: event.email, password: event.password);
        if (user) {
          emit(DeleteAccountSuccess());
        } else {
          emit(const DeleteAccountFailure(message: 'Delete Account Failed'));
        }
      } catch (e) {
        emit(DeleteAccountFailure(message: e.toString()));
      }
    });

    on<GoogleAuthentication>((event, emit) async {
      try {
        emit(GoogleLoginLoading());
        final user = await UserProviders().signInWithGoogle();

        if (user) {
          AuthenticationBloc().add(LoggedIn());
          emit(GoogleLoginSuccess());
        } else {
          emit(const GoogleLoginFailure(message: 'Google Login Failed'));
        }
      } catch (e) {
        emit(GoogleLoginFailure(message: e.toString()));
      }
    });
  }
}
