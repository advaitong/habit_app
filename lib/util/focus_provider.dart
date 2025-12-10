import 'dart:async';
import 'package:flutter/material.dart';

enum TimerState { initial, running, paused, completed }

enum TimerMode { focus, breakTime }

class FocusProvider extends ChangeNotifier {
  // --- STATE VARIABLES ---
  int _focusDuration = 25 * 60;
  int _breakDuration = 5 * 60;
  int _timeRemaining = 25 * 60;
  Timer? _timer;

  TimerMode _mode = TimerMode.focus;
  TimerState _state = TimerState.initial;

  // ⭐ NEW: Track focus history for the HeatMap
  // Map<Date, Count of sessions>
  final Map<DateTime, int> _focusHistory = {};

  // --- GETTERS ---
  int get timeRemaining => _timeRemaining;
  String get formattedTime => _formatTime(_timeRemaining);
  TimerState get state => _state;
  TimerMode get mode => _mode;
  int get initialFocusDuration => _focusDuration;

  // Expose history for the heatmap
  Map<DateTime, int> get focusHistory => _focusHistory;

  // --- ACTIONS ---
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void setDuration(int minutes) {
    if (_state != TimerState.running) {
      _focusDuration = minutes * 60;
      _timeRemaining = _focusDuration;
      _mode = TimerMode.focus;
      _state = TimerState.initial;
      notifyListeners();
    }
  }

  void startTimer() {
    if (_state == TimerState.running) return;

    _state = TimerState.running;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        _timeRemaining--;
        notifyListeners();
      } else {
        _timer?.cancel();
        _state = TimerState.completed;
        _handleTimerCompletion();
        notifyListeners();
      }
    });
    notifyListeners();
  }

  void pauseTimer() {
    if (_state == TimerState.running) {
      _timer?.cancel();
      _state = TimerState.paused;
      notifyListeners();
    }
  }

  void resetTimer() {
    _timer?.cancel();
    _state = TimerState.initial;
    _mode = TimerMode.focus;
    _timeRemaining = _focusDuration;
    notifyListeners();
  }

  void _handleTimerCompletion() {
    // 1. If we just finished a FOCUS session, record it in history
    if (_mode == TimerMode.focus) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      if (_focusHistory.containsKey(today)) {
        _focusHistory[today] = _focusHistory[today]! + 1;
      } else {
        _focusHistory[today] = 1;
      }

      // Switch to break
      _mode = TimerMode.breakTime;
      _timeRemaining = _breakDuration;
      startTimer(); // Auto-start break
    } else {
      // Finished break, go back to focus
      _mode = TimerMode.focus;
      _timeRemaining = _focusDuration;
      _state = TimerState.initial;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
