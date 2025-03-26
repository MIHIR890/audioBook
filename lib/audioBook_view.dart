import 'package:dashboard/controller/audioBook_controller.dart';
import 'package:dashboard/model/audio_model.dart';
import 'package:dashboard/music_player.dart';
import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:like_button/like_button.dart';

class AudiobookListScreen extends StatefulWidget {
  @override
  _AudiobookListScreenState createState() => _AudiobookListScreenState();
}

class _AudiobookListScreenState extends State<AudiobookListScreen> {
  late Future<List<Audiobook>> _audiobooks;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false; // Track whether the audio is playing

  @override
  void initState() {
    super.initState();
    _audiobooks = ApiService.fetchAudiobooks();
  }
  // Method to toggle play/pause
  void _togglePlayPause(Audiobook audiobook) {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play(UrlSource(audiobook.audioUrl));
    }
    setState(() {
      _isPlaying = !_isPlaying; // Toggle the play/pause state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audiobooks'),
      ),
      body: FutureBuilder<List<Audiobook>>(
        future: _audiobooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No audiobooks available.'));
          }

          final audiobooks = snapshot.data!;
          return ListView.builder(
            itemCount: audiobooks.length,
            itemBuilder: (context, index) {
              final audiobook = audiobooks[index];
              return ListTile(
                // leading: Image.network(  audiobook.coverImage ?? 'https://example.com/placeholder.jpg',
                //     width: 50, height: 50, fit: BoxFit.cover),
                title: GestureDetector(
                    onTap : (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> MusicView(
                          audioName : audiobook.title,
                          audioAuthor : audiobook.author,
                          audioUrl : audiobook.audioUrl
                      )));

                    },child: Text(audiobook.title)),
                subtitle: Text(audiobook.author),
                trailing: IconButton(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    _togglePlayPause(audiobook);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}


