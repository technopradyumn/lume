// lib/presentation/blocs/dashboard/dashboard_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/dashboard_repository.dart';
import '../../../core/utils/error_handler.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _dashboardRepo;

  DashboardCubit({required DashboardRepository dashboardRepository}) 
      : _dashboardRepo = dashboardRepository, 
        super(DashboardInitial());

  Future<void> fetchDashboard() async {
    emit(DashboardLoading());
    try {
      final stats = await _dashboardRepo.getChannelStats();
      final videos = await _dashboardRepo.getChannelVideos();
      emit(DashboardLoaded(stats, videos));
    } catch (e) {
      emit(DashboardError(extractErrorMessage(e)));
    }
  }
}
