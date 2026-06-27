import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EditorProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  int? _projectId;
  String _projectName = "New Project";
  String _projectDuration = "00:15";
  String _projectSize = "1.5 MB";
  String? _thumbnail;

  bool _isPlaying = false;
  bool _isLoading = false;
  int _playheadMs = 0;
  int _totalDurationMs = 15000; // 15 seconds
  String _aspectRatioLabel = "16:9";

  Timer? _playbackTimer;

  // Timeline Tracks
  List<Map<String, dynamic>> _videoClips = [];
  List<Map<String, dynamic>> _audioClips = [];
  List<Map<String, dynamic>> _textClips = [];

  // Getters
  int? get projectId => _projectId;
  String get projectName => _projectName;
  String get projectDuration => _projectDuration;
  String get projectSize => _projectSize;
  String? get thumbnail => _thumbnail;

  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  int get playheadMs => _playheadMs;
  int get totalDurationMs => _totalDurationMs;
  String get aspectRatioLabel => _aspectRatioLabel;

  List<Map<String, dynamic>> get videoClips => _videoClips;
  List<Map<String, dynamic>> get audioClips => _audioClips;
  List<Map<String, dynamic>> get textClips => _textClips;

  double get playheadProgress => _totalDurationMs > 0 ? _playheadMs / _totalDurationMs : 0.0;

  void updateAspectRatio(String ratio) {
    _aspectRatioLabel = ratio;
    notifyListeners();
  }

  void seekTo(int positionMs) {
    if (positionMs < 0) positionMs = 0;
    if (positionMs > _totalDurationMs) positionMs = _totalDurationMs;
    _playheadMs = positionMs;
    notifyListeners();
  }

  void seekProgress(double progress) {
    seekTo((progress * _totalDurationMs).round());
  }

  void togglePlay() {
    if (_isPlaying) {
      _stopPlayback();
    } else {
      _startPlayback();
    }
  }

  void _startPlayback() {
    if (_playheadMs >= _totalDurationMs) {
      _playheadMs = 0;
    }
    _isPlaying = true;
    notifyListeners();

    _playbackTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _playheadMs += 100;
      if (_playheadMs >= _totalDurationMs) {
        _playheadMs = _totalDurationMs;
        _stopPlayback();
      }
      notifyListeners();
    });
  }

  void _stopPlayback() {
    _isPlaying = false;
    _playbackTimer?.cancel();
    _playbackTimer = null;
    notifyListeners();
  }

  // Import operations
  void importVideo(Map<String, String> media) {
    final name = media['name'] ?? 'Video';
    final img = media['img'] ?? '';
    final durationStr = media['duration'] ?? '00:15';
    
    // Parse duration string MM:SS to seconds
    final parts = durationStr.split(':');
    int secs = 15;
    if (parts.length == 2) {
      secs = (int.tryParse(parts[0]) ?? 0) * 60 + (int.tryParse(parts[1]) ?? 15);
    }
    
    _totalDurationMs = secs * 1000;
    _projectDuration = durationStr;
    _thumbnail = img;
    _projectName = name;

    // Create primary clip
    _videoClips = [
      {
        'id': 'video_0',
        'name': name,
        'img': img,
        'startMs': 0,
        'endMs': _totalDurationMs,
        'offsetMs': 0,
      }
    ];

    notifyListeners();
  }

  void addAudio(Map<String, String> media) {
    final name = media['name'] ?? 'Audio.mp3';
    _audioClips.add({
      'id': 'audio_${DateTime.now().millisecondsSinceEpoch}',
      'name': name,
      'startMs': 0,
      'endMs': 8000, // Default to 8 seconds
      'offsetMs': _playheadMs,
    });
    notifyListeners();
  }

  void addText(String text) {
    _textClips.add({
      'id': 'text_${DateTime.now().millisecondsSinceEpoch}',
      'name': text,
      'startMs': 0,
      'endMs': 4000, // Default to 4 seconds
      'offsetMs': _playheadMs,
    });
    notifyListeners();
  }

  // Video Splitting
  void splitClip() {
    // Find video clip containing playhead
    int targetIndex = -1;
    for (int i = 0; i < _videoClips.length; i++) {
      final clip = _videoClips[i];
      final int start = clip['offsetMs'] ?? 0;
      final int duration = (clip['endMs'] as int) - (clip['startMs'] as int);
      final int end = start + duration;
      
      if (_playheadMs > start && _playheadMs < end) {
        targetIndex = i;
        break;
      }
    }

    if (targetIndex != -1) {
      final clip = _videoClips[targetIndex];
      final int startOffset = clip['offsetMs'] ?? 0;
      final int splitTimeRelativeToClip = _playheadMs - startOffset;
      final int originalStartMs = clip['startMs'] ?? 0;
      final int originalEndMs = clip['endMs'] ?? 0;
      
      // Update existing clip to end at playhead
      final clipA = {
        ...clip,
        'endMs': originalStartMs + splitTimeRelativeToClip,
      };

      // Create new clip starting at playhead
      final clipB = {
        'id': 'video_${DateTime.now().millisecondsSinceEpoch}',
        'name': '${clip['name']} (Part 2)',
        'img': clip['img'],
        'startMs': originalStartMs + splitTimeRelativeToClip,
        'endMs': originalEndMs,
        'offsetMs': _playheadMs,
      };

      _videoClips[targetIndex] = clipA;
      _videoClips.insert(targetIndex + 1, clipB);
      
      notifyListeners();
    }
  }

  void removeTextClip(String id) {
    _textClips.removeWhere((clip) => clip['id'] == id);
    notifyListeners();
  }

  void removeAudioClip(String id) {
    _audioClips.removeWhere((clip) => clip['id'] == id);
    notifyListeners();
  }

  // Backend Sync
  Future<void> saveProject() async {
    _isLoading = true;
    notifyListeners();

    try {
      final timelineMap = {
        'videoClips': _videoClips,
        'audioClips': _audioClips,
        'textClips': _textClips,
        'aspectRatio': _aspectRatioLabel,
        'totalDurationMs': _totalDurationMs,
      };

      final timelineStr = jsonEncode(timelineMap);

      if (_projectId == null) {
        // Create new project in backend
        final result = await _apiService.createProject(
          name: _projectName,
          duration: _projectDuration,
          size: _projectSize,
          thumbnail: _thumbnail,
          timelineData: timelineStr,
        );
        _projectId = result['id'];
      } else {
        // Update existing project
        await _apiService.updateProject(
          _projectId!,
          name: _projectName,
          duration: _projectDuration,
          size: _projectSize,
          thumbnail: _thumbnail,
          timelineData: timelineStr,
        );
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadProject(int id) async {
    _isLoading = true;
    _projectId = id;
    notifyListeners();

    try {
      final data = await _apiService.getProject(id);
      _projectName = data['name'] ?? 'Untitled';
      _projectDuration = data['duration'] ?? '00:00';
      _projectSize = data['size'] ?? '0MB';
      _thumbnail = data['thumbnail'];
      
      final timelineStr = data['timeline_data'] as String?;
      if (timelineStr != null && timelineStr.isNotEmpty) {
        final timelineMap = jsonDecode(timelineStr) as Map<String, dynamic>;
        _aspectRatioLabel = timelineMap['aspectRatio'] ?? '16:9';
        _totalDurationMs = timelineMap['totalDurationMs'] ?? 15000;
        
        _videoClips = List<Map<String, dynamic>>.from(
          (timelineMap['videoClips'] as List? ?? []).map((x) => Map<String, dynamic>.from(x))
        );
        _audioClips = List<Map<String, dynamic>>.from(
          (timelineMap['audioClips'] as List? ?? []).map((x) => Map<String, dynamic>.from(x))
        );
        _textClips = List<Map<String, dynamic>>.from(
          (timelineMap['textClips'] as List? ?? []).map((x) => Map<String, dynamic>.from(x))
        );
      } else {
        // Clear timeline if empty
        _videoClips = [];
        _audioClips = [];
        _textClips = [];
        _playheadMs = 0;
        _totalDurationMs = 15000;
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void loadTemplate(Map<String, dynamic> template) {
    _projectId = null;
    _projectName = "${template['title'] ?? 'Template'} Edit";
    _projectDuration = template['duration'] ?? '00:15';
    _projectSize = template['size'] ?? '0 MB';
    _thumbnail = template['thumbnail_url'];
    _playheadMs = 0;

    final timelineStr = template['timeline_data'] as String?;
    if (timelineStr != null && timelineStr.isNotEmpty) {
      final timelineMap = jsonDecode(timelineStr) as Map<String, dynamic>;
      _aspectRatioLabel = timelineMap['aspectRatio'] ?? '16:9';
      _totalDurationMs = timelineMap['totalDurationMs'] ?? 15000;
      
      _videoClips = List<Map<String, dynamic>>.from(
        (timelineMap['videoClips'] as List? ?? []).map((x) => Map<String, dynamic>.from(x))
      );
      _audioClips = List<Map<String, dynamic>>.from(
        (timelineMap['audioClips'] as List? ?? []).map((x) => Map<String, dynamic>.from(x))
      );
      _textClips = List<Map<String, dynamic>>.from(
        (timelineMap['textClips'] as List? ?? []).map((x) => Map<String, dynamic>.from(x))
      );
    } else {
      _videoClips = [];
      _audioClips = [];
      _textClips = [];
      _totalDurationMs = 15000;
    }
    notifyListeners();
  }

  void initNewProject(String name) {
    _projectId = null;
    _projectName = name;
    _projectDuration = "00:00";
    _projectSize = "0 MB";
    _thumbnail = null;
    _playheadMs = 0;
    _totalDurationMs = 15000;
    _videoClips = [];
    _audioClips = [];
    _textClips = [];
    _aspectRatioLabel = "16:9";
    notifyListeners();
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    super.dispose();
  }
}
