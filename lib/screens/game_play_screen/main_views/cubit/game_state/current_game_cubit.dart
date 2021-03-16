import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'current_game_state.dart';

class CurrentGameCubit extends Cubit<CurrentGameState> {
  CurrentGameCubit() : super(CurrentGameInitial());
}
