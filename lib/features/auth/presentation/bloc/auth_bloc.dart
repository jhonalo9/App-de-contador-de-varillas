import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(seconds: 1));
      
      if (event.email == 'usuario@promart.com' && event.password == '123456') {
        emit(AuthAuthenticated(userId: '1', userName: 'Usuario Demo'));
      } else {
        emit(AuthError(message: 'Credenciales incorrectas'));
      }
    });
    
    on<LogoutEvent>((event, emit) {
      emit(AuthUnauthenticated());
    });
  }
}