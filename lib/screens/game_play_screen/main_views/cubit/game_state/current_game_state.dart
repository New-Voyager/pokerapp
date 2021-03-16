part of 'current_game_cubit.dart';

abstract class CurrentGameState extends Equatable {
  const CurrentGameState();
}

class CurrentGameInitial extends CurrentGameState {
  @override
  List<Object> get props => [];
}

class CurrentGameLoading extends CurrentGameState {
  @override
  List<Object> get props => [];
}

class CurrentGameLoaded extends CurrentGameState {

  @override
  List<Object> get props => [];
}
