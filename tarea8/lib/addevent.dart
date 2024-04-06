import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  AddEventState createState() => AddEventState();
}

class AddEventState extends State<AddEvent> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _photoPath;
  String? _audioPath;
  FlutterSoundRecorder? _audioRecorder = FlutterSoundRecorder();

  late Database db;

  @override
  void initState() {
    super.initState();
    _openDatabase();
    _initRecorder();
  }

  Future<void> _openDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, 'events.db');

    db = await openDatabase(path, onCreate: (db, version) async {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS event (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        event_date TEXT,
        event_title TEXT,
        event_description TEXT,
        event_photo_path TEXT,
        event_audio_path TEXT
      )
    ''');
    }, version: 1);
  }

  void _closeDatabase() async {
    await db.close();
  }

  @override
  void dispose() {
    _closeDatabase();
    _closeRecorder();
    _titleController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _insertEvent() async {
    await db.transaction((txn) async {
      await txn.insert(
          'event',
          {
            'event_date': _dateController.text,
            'event_title': _titleController.text,
            'event_description': _descriptionController.text,
            'event_photo_path': _photoPath,
            'event_audio_path': _audioPath
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _photoPath = image.path;
      });
    }
  }

  Future<void> _initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
    await _audioRecorder?.openRecorder();
  }

  Future<void> _closeRecorder() async {
    if (_audioRecorder != null) {
      await _audioRecorder?.closeRecorder();
      _audioRecorder = null;
    }
  }

  Future<void> _startStopRecording() async {
    if (_audioRecorder?.isRecording ?? false) {
      final path = await _audioRecorder?.stopRecorder();
      setState(() {
        _audioPath = path;
      });
    } else {
      await _audioRecorder?.startRecorder(
          toFile: 'audio_${DateTime.now().millisecondsSinceEpoch}');
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de eventos')),
      body: Center(
          child: SingleChildScrollView(
              child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Fecha')),
            TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titulo')),
            TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Tomar Foto'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startStopRecording,
              child: _audioRecorder?.isRecording ?? false
                  ? const Text('Detener Grabación')
                  : const Text('Iniciar Grabación'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () => _insertEvent(),
                child: const Text('Agregar evento'))
          ],
        ),
      ))),
    );
  }
}
