import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_constants.dart';

class TableState extends ChangeNotifier {
  /* This object holds the game status, table status, pot chips, and community cards */
  String _gameStatus;
  String _tableStatus;
  List<double> _potChips;
  double _potUpdatesChips;
  int _flipSpeed;
  String _rankStr;
  int _potToHighlight;
  bool _dimPots;
  bool dimBoard1;
  bool dimBoard2;
  String get whichWinner => _whichWinner;
  String _whichWinner;

  bool _dealerChoicePrompt = false;
  String _dealerChoicePromptPlayer = '';

  // This flag is used when processing query current state response
  // if we are in middle of hand result animation, wait for the next hand
  // to update the table
  bool resultInProgress = false;

  bool get showCardsShuffling => _showCardsShuffling;
  bool _showCardsShuffling;

  final math.Random r = math.Random();

  int get tableRefresh => _tableRefresh;
  int _tableRefresh;

  int get communityCardRefresh => _communityCardRefresh;
  int _communityCardRefresh;

  TableState({
    String tableStatus,
    List<double> potChips,
    double potUpdatesChips,
  }) {
    this.clear();
    this._tableStatus = tableStatus;
    this._potChips = potChips;
    this._potUpdatesChips = potUpdatesChips;
    this._flipSpeed = 500;
    this._showCardsShuffling = false;
    this.dimBoard1 = false;
    this.dimBoard2 = false;
  }

  void clear() {
    _dimPots = false;
    _potChips?.clear();
    _potUpdatesChips = null;
    _flipSpeed = 500;
    _rankStr = null;
    _potToHighlight = -1;
    _whichWinner = null;
    this.dimBoard1 = false;
    this.dimBoard2 = false;
  }

  void notifyAll() => notifyListeners();

  void setWhichWinner(String whichWinner) {
    _whichWinner = whichWinner;
    notifyAll();
  }

  void updateCardShufflingAnimation(bool animate) {
    _showCardsShuffling = animate;
    _tableStatus = AppConstants.TABLE_STATUS_GAME_RUNNING;
    notifyListeners();
  }

  void refreshTable() {
    const _100crore = 1000000000;
    _tableRefresh = r.nextInt(_100crore);
    // notifyListeners();
  }

  void updatePotToHighlightSilent(int potIdx) {
    _potToHighlight = potIdx;
  }

  bool get dimPots => _dimPots;

  void dimPotsSilent(bool b) {
    _dimPots = b;
  }

  /* public methods for updating values into our TableState */
  void updateTableStatusSilent(String tableStatus) {
    if (this._tableStatus == tableStatus) return;
    this._tableStatus = tableStatus;
  }

  /* public methods for updating values into Game status */
  void updateGameStatusSilent(String gameStatus) {
    if (this._gameStatus == gameStatus) return;
    this._gameStatus = gameStatus;
  }

  void updatePotChipsSilent({List<double> potChips, double potUpdatesChips}) {
    // log('updatePotChipsSilent: potChips: ${potChips} potUpdates: $potUpdatesChips');
    this._potChips = potChips;
    this._potUpdatesChips = potUpdatesChips;
  }

  void updatePotChipUpdatesSilent(double potUpdatesChips) {
    this._potUpdatesChips = potUpdatesChips;
  }

  void updateRankStrSilent(String rankStr) {
    this._rankStr = rankStr;
  }

  Future<void> _delay(int times) => Future.delayed(
        Duration(
          milliseconds:
              AppConstants.communityCardAnimationDuration.inMilliseconds *
                  times,
        ),
      );

  /* getters */
  String get rankStr => _rankStr;
  String get tableStatus => _tableStatus;
  String get gameStatus => _gameStatus;
  int get potToHighlight => _potToHighlight;
  List<double> get potChips => _potChips;
  double get potChipsUpdates => _potUpdatesChips;

  bool get gamePaused {
    if (_gameStatus == AppConstants.GAME_PAUSED) {
      return true;
    }
    return false;
  }

  bool get gameEnded {
    if (_gameStatus == AppConstants.GAME_ENDED) {
      return true;
    }
    return false;
  }

  bool get gameActive {
    if (_gameStatus == AppConstants.GAME_ACTIVE) {
      return true;
    }
    return false;
  }

  int get flipSpeed {
    return this._flipSpeed;
  }

  bool get dealerChoicePrompt => this._dealerChoicePrompt;

  String get dealerChoicePromptPlayer => this._dealerChoicePromptPlayer;

  void updateDealerChoicePrompt(bool prompt, String player) {
    _dealerChoicePrompt = false;
    _dealerChoicePromptPlayer = '';
    _showCardsShuffling = false;
    if (prompt) {
      _showCardsShuffling = true;
      _dealerChoicePrompt = true;
      _dealerChoicePromptPlayer = player;
    }
    notifyListeners();
  }
}
