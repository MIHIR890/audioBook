import 'package:audioplayers/audioplayers.dart';
import 'package:dashboard/controller/audioBook_controller.dart';
import 'package:dashboard/model/audio_model.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
class MusicView extends StatefulWidget {
  final String audioName;
  final String audioAuthor;
  final String audioUrl;

  const MusicView({super.key, required this.audioName, required this.audioAuthor, required this.audioUrl});

  @override
  State<MusicView> createState() => _MusicViewState();
}

class _MusicViewState extends State<MusicView> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false; // Track whether the audio is playing
  int _currentIndex = 0; // Current index of the playlist
  late Future<List<Audiobook>> _playlist;

  late String _currentAudioName; // Current audio name
  late String _currentAudioAuthor; // Current audio author

  @override
  void initState() {
    super.initState();
    _playlist = ApiService.fetchAudiobooks();
    _currentAudioName = widget.audioName;
    _currentAudioAuthor = widget.audioAuthor;
  }

  void _playAudio(String audioUrl) async {
    await _audioPlayer.stop(); // Stop any currently playing audio
    await _audioPlayer.play(UrlSource(audioUrl)); // Play the new audio
    setState(() {
      _isPlaying = true;
    });
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _playAudio(widget.audioUrl);
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _updateCurrentAudio(List<Audiobook> playlist) {
    setState(() {
      _currentAudioName = playlist[_currentIndex].title;
      _currentAudioAuthor = playlist[_currentIndex].author;
    });
  }

  void _playNext(List<Audiobook> playlist) {
    if (_currentIndex < playlist.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _updateCurrentAudio(playlist);
      _playAudio(playlist[_currentIndex].audioUrl);
    }
  }

  void _playPrevious(List<Audiobook> playlist) {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _updateCurrentAudio(playlist);
      _playAudio(playlist[_currentIndex].audioUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: (){
            _audioPlayer.stop();
            Navigator.pop(context);
          },
            child: Icon(Icons.arrow_back_ios)),
        title: const Text(
          "Now Playing",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _audioPlayer.stop();
              Navigator.pop(context);
              // showCustomBottomSheet(context);
            },
            icon: const Icon(Icons.queue_music_outlined, color: Colors.white),
          )
        ],
      ),
      body: FutureBuilder<List<Audiobook>>(
        future: _playlist,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final playlist = snapshot.data!;
            return Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.blue.shade900, Colors.black])),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 180,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(50),
                                bottomRight: Radius.circular(50)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.orange.withOpacity(0.5),
                                  blurRadius: 0,
                                  spreadRadius: 5)
                            ]),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 140),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const CustomLikeButton(),
                                Column(
                                  children: [
                                    Text(
                                      _currentAudioName,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 34,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      _currentAudioAuthor,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {},
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.more_horiz,
                                      color: Colors.white),
                                )
                              ],
                            ),
                            const SizedBox(height: 40),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(
                                  Icons.shuffle,
                                  color: Colors.white,
                                ),
                                IconButton(
                                  onPressed: () => _playPrevious(playlist),
                                  icon: const Icon(
                                    Icons.arrow_left_sharp,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                FloatingActionButton(
                                  onPressed: _togglePlayPause,
                                  backgroundColor: Colors.orange,
                                  elevation: 10,
                                  child: Icon(
                                    _isPlaying
                                        ? Icons.pause_circle_outline_outlined
                                        : Icons.play_circle_outline_outlined,
                                    size: 35,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _playNext(playlist),
                                  icon: const Icon(
                                    Icons.arrow_right_sharp,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                const Icon(
                                  Icons.repeat_rounded,
                                  color: Colors.white,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: CircleAvatar(
                        radius: 120,
                        backgroundColor: Colors.black,
                        backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1639628735078-ed2f038a193e?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return const Center(child: Text("No audiobooks available."));
          }
        },
      ),
    );
  }
}


class CustomLikeButton extends StatelessWidget {
  const CustomLikeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return LikeButton(
      size: 30,
      circleSize: 30,
      circleColor: const CircleColor(start: Colors.teal, end: Colors.teal),
      bubblesColor: const BubblesColor(
        dotPrimaryColor: Colors.teal,
        dotSecondaryColor: Colors.teal,
      ),
      likeBuilder: (bool isLiked) {
        return isLiked
            ? const Icon(
          Icons.favorite,
          color: Colors.teal,
          size: 25,
        )
            : const Icon(
          Icons.favorite_border_outlined,
          color: Colors.white,
          size: 25,
        );
      },
    );
  }
}


void showCustomBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allows the bottom sheet to take full height
    backgroundColor: Colors.transparent, // To see the rounded corners effect
    builder: (context) => const CustomBottomSheet(),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
  );
}

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({super.key});

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  late Future<List<Audiobook>> _audiobooks;

  @override
  void initState() {
    super.initState();
      _audiobooks = ApiService.fetchAudiobooks();
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/1.1,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade900, Colors.black])),
      child:         FutureBuilder<List<Audiobook>>(
    future: _audiobooks,
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
    return Center(child: Text('Error: ${snapshot.error}'));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
    return Center(child: Text('No audiobooks available.'));
    }

    final audiobooks = snapshot.data!; return ListView.builder(
      itemCount: audiobooks.length,
      itemBuilder: (context, index) {
        final audiobook = audiobooks[index];
        return ListTile(
          // leading: Image.network(  audiobook.coverImage ?? 'https://example.com/placeholder.jpg',
          //     width: 50, height: 50, fit: BoxFit.cover),
          title: GestureDetector(
              onTap : () async {
                await _audioPlayer.stop(); // Stop any currently playing audio


                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MusicView(
                    audioName : audiobook.title,
                    audioAuthor : audiobook.author,
                    audioUrl : audiobook.audioUrl
                )));

              },child: Text(audiobook.title)),
          subtitle: Text(audiobook.author),

        );
      },
    );
    }),

    );
  }
}
