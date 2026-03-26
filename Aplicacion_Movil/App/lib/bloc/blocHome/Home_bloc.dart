import 'package:bloc/bloc.dart';
import 'Home_event.dart';
import 'Home_state.dart';

class SubjectBloc extends Bloc<HomeEvent, HomeState> {
  SubjectBloc() : super(HomeInitial()) {
    on<GestionarProductosEvent>((event, emit) {
      emit(GestionarProductos());
    });
    on<GestionarReportesEvent>((event, emit) {
      emit(GestionarReportes());
    });
    on<VisualizarStockEvent>((event, emit) {
      emit(VisualizarStock());
    });
    on<GestionarClienteEvent>((event, emit) {
      emit(GestionarCliente());
    });
    on<GestionarProveedorEvent>((event, emit) {
      emit(GestionarProveedor());
    });
    on<RevisarAlertasEvent>((event, emit) {
      emit(RevisarAlertas());
    });
    on<ControlarFinanzasEvent>((event, emit) {
      emit(ControlarFinanzas());
    });
    on<GestionarInventarioEvent>((event, emit) {
      emit(GestionarInventario());
    });
    on<ConfiguracionEvent>((event, emit) {
      emit(Configuracion());
    });
  }
}
