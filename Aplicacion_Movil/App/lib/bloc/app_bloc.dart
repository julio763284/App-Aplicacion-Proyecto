import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {

  AppBloc() : super(LoadingState()) {

    on<AppStarted>((event, emit) async {
      emit(LoadingState());
      await Future.delayed(const Duration(seconds: 2));
      emit(LoginState());
    });

    on<GoToLogin>((event, emit) => emit(LoginState()));
    on<GoToHome>((event, emit) => emit(HomeState()));
    on<GoToHome2>((event, emit) => emit(Home2State()));
    on<GoToReportes>((event, emit) => emit(ReportesState()));
    on<GoToStock>((event, emit) => emit(StockState()));
    on<GoToGastos>((event, emit) => emit(GastosState()));
    on<GoToProveedores>((event, emit) => emit(ProveedoresState()));
    on<GoToConfiguracion>((event, emit) => emit(ConfiguracionState()));
    on<GoToNotificaciones>((event, emit) => emit(NotificacionesState()));
    on<GoToClientes>((event, emit) => emit(ClientesState()));
    on<GoToError>((event, emit) => emit(ErrorState()));
  }
}