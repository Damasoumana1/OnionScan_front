import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onion_scan/core/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// Simuler les publications de la communauté
List<Map<String, dynamic>> communityPosts = [];

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final TextEditingController _postController = TextEditingController();
  final Map<int, TextEditingController> _commentControllers = {};
  final Map<String, TextEditingController> _editCommentControllers = {};
  final Map<int, TextEditingController> _editPostControllers = {};
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  String? _audioPath;
  bool _isRecording = false;
  Map<int, bool> _isPlaying = {};
  Map<int, bool> _isLiked = {};

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    _isPlaying = {};
    _isLiked = {};
    _initRecorderAndPlayer();
    _loadPosts();
    print('InitState executed at ${DateTime.now()}');
  }

  Future<void> _initRecorderAndPlayer() async {
    await _recorder!.openRecorder();
    await _player!.openPlayer();
    final directory = await getTemporaryDirectory();
    _audioPath = '${directory.path}/temp_audio.aac';
    print('Recorder and player initialized, audioPath: $_audioPath');
  }

  Future<void> _loadPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final postsJson = prefs.getString('communityPosts');
    print('Loading posts, postsJson: $postsJson');
    if (postsJson != null) {
      try {
        final decodedPosts = jsonDecode(postsJson) as List;
        setState(() {
          communityPosts = decodedPosts.map((post) => Map<String, dynamic>.from(post)).toList();
          _isLiked = {};
          _isPlaying = {};
          for (int i = 0; i < communityPosts.length; i++) {
            _isLiked[i] = false;
            _isPlaying[i] = false;
          }
        });
        print('Posts loaded successfully: $communityPosts');
      } catch (e) {
        print('Error decoding posts JSON: $e');
        communityPosts = [
          {
            'username': 'Amadou Traoré',
            'message': 'J’ai remarqué des taches brunes sur mes oignons. Quelqu’un a une idée de ce problème ?',
            'imagePath': 'assets/images/sample_onion.jpg',
            'profilePicture': 'assets/images/amadou_profile.jpg',
            'likes': 15,
            'comments': 12,
            'shares': 0,
            'commentList': [],
            'audioPath': null,
            'reshareComment': null,
            'resharedBy': null,
          },
          {
            'username': 'Azi Dao',
            'message': 'Je teste un nouveau conseil pour la culture des oignons pendant la saison sèche...',
            'imagePath': null,
            'profilePicture': 'assets/images/azi_profile.jpg',
            'likes': 8,
            'comments': 5,
            'shares': 0,
            'commentList': [],
            'audioPath': null,
            'reshareComment': null,
            'resharedBy': null,
          },
        ];
        await _savePosts();
      }
    } else {
      communityPosts = [
        {
          'username': 'Amadou Traoré',
          'message': 'J’ai remarqué des taches brunes sur mes oignons. Quelqu’un a une idée de ce problème ?',
          'imagePath': 'assets/images/sample_onion.jpg',
          'profilePicture': 'assets/images/amadou_profile.jpg',
          'likes': 15,
          'comments': 12,
          'shares': 0,
          'commentList': [],
          'audioPath': null,
          'reshareComment': null,
          'resharedBy': null,
        },
        {
          'username': 'Azi Dao',
          'message': 'Je teste un nouveau conseil pour la culture des oignons pendant la saison sèche...',
          'imagePath': null,
          'profilePicture': 'assets/images/azi_profile.jpg',
          'likes': 8,
          'comments': 5,
          'shares': 0,
          'commentList': [],
          'audioPath': null,
          'reshareComment': null,
          'resharedBy': null,
        },
      ];
      await _savePosts();
      print('No saved posts, initialized with default data: $communityPosts');
    }
  }

  Future<void> _savePosts() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setString('communityPosts', jsonEncode(communityPosts));
      print('Posts saved successfully: $communityPosts');
    } catch (e) {
      print('Error saving posts: $e');
    }
  }

  Future<bool> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    return false;
  }

  void _submitPost() {
    if (_postController.text.isNotEmpty || _selectedImage != null || _audioPath != null) {
      setState(() {
        communityPosts.insert(0, {
          'username': 'Utilisateur',
          'message': _postController.text,
          'imagePath': _selectedImage?.path,
          'profilePicture': 'assets/images/user_profile.jpg',
          'likes': 0,
          'comments': 0,
          'shares': 0,
          'commentList': [],
          'audioPath': _audioPath != null && _audioPath!.isNotEmpty ? _audioPath : null,
          'reshareComment': null,
          'resharedBy': null,
        });
        // Réorganiser les index des maps après insertion
        final newIsLiked = <int, bool>{};
        final newIsPlaying = <int, bool>{};
        newIsLiked[0] = false;
        newIsPlaying[0] = false;
        for (int i = 1; i <= communityPosts.length - 1; i++) {
          newIsLiked[i] = _isLiked[i - 1] ?? false;
          newIsPlaying[i] = _isPlaying[i - 1] ?? false;
        }
        _isLiked = newIsLiked;
        _isPlaying = newIsPlaying;
        _editPostControllers[0] = TextEditingController(text: _postController.text);
        print('New post added: ${communityPosts[0]}');
      });
      _postController.clear();
      setState(() {
        _selectedImage = null;
        _audioPath = null;
      });
      _savePosts();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Publication ajoutée !')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez ajouter du texte, une image ou un enregistrement vocal.')),
      );
    }
  }

  void _cancelImage() {
    setState(() {
      _selectedImage = null;
      print('Image selection cancelled');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image annulée !')),
    );
  }

  void _pickImage() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          print('Image selected: ${_selectedImage!.path}');
        });
      }
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez autoriser l’accès à la galerie dans les paramètres.')),
      );
    }
  }

  void _startRecording() async {
    final hasPermission = await _requestMicrophonePermission();
    if (hasPermission) {
      try {
        await _recorder!.startRecorder(toFile: _audioPath);
        setState(() {
          _isRecording = true;
        });
        print('Recording started');
      } catch (e) {
        print('Erreur lors du démarrage de l’enregistrement : $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de l’enregistrement.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission d’enregistrement refusée.')),
      );
    }
  }

  void _stopRecording() async {
    try {
      await _recorder!.stopRecorder();
      setState(() {
        _isRecording = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message vocal enregistré !')),
      );
      print('Recording stopped, audioPath: $_audioPath');
    } catch (e) {
      print('Erreur lors de l’arrêt de l’enregistrement : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de l’arrêt de l’enregistrement.')),
      );
    }
  }

  void _playAudio(int index, String audioPath) async {
    try {
      bool isCurrentlyPlaying = _isPlaying[index] ?? false;
      if (isCurrentlyPlaying) {
        await _player!.stopPlayer();
        setState(() {
          _isPlaying[index] = false;
        });
      } else {
        await _player!.startPlayer(fromURI: audioPath);
        setState(() {
          _isPlaying[index] = true;
        });
      }
      print('Audio playback toggled for index $index, isPlaying: ${_isPlaying[index]}');
    } catch (e) {
      print('Erreur lors de la lecture de l’audio : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la lecture de l’audio.')),
      );
    }
  }

  void _likePost(int index) {
    setState(() {
      bool isCurrentlyLiked = _isLiked[index] ?? false;
      if (isCurrentlyLiked) {
        communityPosts[index]['likes'] = (communityPosts[index]['likes'] ?? 0) - 1;
        _isLiked[index] = false;
      } else {
        communityPosts[index]['likes'] = (communityPosts[index]['likes'] ?? 0) + 1;
        _isLiked[index] = true;
      }
      print('Liked post at index $index, new likes: ${communityPosts[index]['likes']}, isLiked: ${_isLiked[index]}');
    });
    _savePosts();
  }

  void _addComment(int index) {
    final controller = _commentControllers[index];
    if (controller != null && controller.text.isNotEmpty) {
      setState(() {
        communityPosts[index]['commentList'] = [
          ...(communityPosts[index]['commentList'] ?? []),
          {'username': 'Utilisateur', 'comment': controller.text}
        ];
        communityPosts[index]['comments'] = (communityPosts[index]['comments'] ?? 0) + 1;
        _commentControllers[index] = TextEditingController();
        print('Comment added to post $index: ${communityPosts[index]['commentList']}');
      });
      _savePosts();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer un commentaire.')),
      );
    }
  }

  void _sharePost(int index) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController _commentController = TextEditingController();
        return AlertDialog(
          title: const Text('Republier'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Ajouter un commentaire (optionnel) :'),
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(hintText: 'Votre commentaire...'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  final postToShare = Map<String, dynamic>.from(communityPosts[index]);
                  postToShare['shares'] = (postToShare['shares'] ?? 0) + 1;
                  postToShare['resharedBy'] = 'Utilisateur';
                  postToShare['reshareComment'] = _commentController.text.isNotEmpty ? _commentController.text : null;
                  communityPosts.insert(0, postToShare);
                  // Réorganiser les index des maps après insertion
                  final newIsLiked = <int, bool>{};
                  final newIsPlaying = <int, bool>{};
                  newIsLiked[0] = false;
                  newIsPlaying[0] = false;
                  for (int i = 1; i <= communityPosts.length - 1; i++) {
                    newIsLiked[i] = _isLiked[i - 1] ?? false;
                    newIsPlaying[i] = _isPlaying[i - 1] ?? false;
                  }
                  _isLiked = newIsLiked;
                  _isPlaying = newIsPlaying;
                  _editPostControllers[0] = TextEditingController(text: postToShare['message']);
                  print('Shared post at index $index, new shares: ${postToShare['shares']}, new post list: $communityPosts');
                });
                _savePosts();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Publication republiée !')),
                );
              },
              child: const Text('Republier'),
            ),
          ],
        );
      },
    );
  }

  void _editPost(int index) {
    showDialog(
      context: context,
      builder: (context) {
        _editPostControllers[index] ??= TextEditingController(text: communityPosts[index]['message']);
        return AlertDialog(
          title: const Text('Modifier la publication'),
          content: TextField(
            controller: _editPostControllers[index],
            maxLines: 3,
            decoration: const InputDecoration(hintText: 'Modifier le message...'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  communityPosts[index]['message'] = _editPostControllers[index]!.text;
                });
                _savePosts();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Publication modifiée !')),
                );
              },
              child: const Text('Sauvegarder'),
            ),
          ],
        );
      },
    );
  }

  void _deletePost(int index) {
    setState(() {
      communityPosts.removeAt(index);
      // Supprimer l'entrée correspondante et réorganiser les index
      final newIsLiked = <int, bool>{};
      final newIsPlaying = <int, bool>{};
      for (int i = 0; i < communityPosts.length; i++) {
        newIsLiked[i] = _isLiked[i + (i >= index ? 1 : 0)] ?? false;
        newIsPlaying[i] = _isPlaying[i + (i >= index ? 1 : 0)] ?? false;
      }
      _isLiked = newIsLiked;
      _isPlaying = newIsPlaying;
      _commentControllers.remove(index);
      _editPostControllers.remove(index);
      _savePosts();
      print('Post deleted at index $index, new list: $communityPosts');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Publication supprimée !')),
    );
  }

  void _editComment(int index, int commentIndex) {
    final key = '$index-$commentIndex';
    final comment = (communityPosts[index]['commentList'] as List)[commentIndex];
    _editCommentControllers[key] ??= TextEditingController(text: comment['comment']);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier le commentaire'),
          content: TextField(
            controller: _editCommentControllers[key],
            decoration: const InputDecoration(hintText: 'Modifier le commentaire...'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  (communityPosts[index]['commentList'] as List)[commentIndex]['comment'] = _editCommentControllers[key]!.text;
                });
                _savePosts();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Commentaire modifié !')),
                );
              },
              child: const Text('Sauvegarder'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _postController.dispose();
    _commentControllers.forEach((_, controller) => controller.dispose());
    _editPostControllers.forEach((_, controller) => controller.dispose());
    _editCommentControllers.forEach((_, controller) => controller.dispose());
    _recorder!.closeRecorder();
    _player!.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Building ForumScreen at ${DateTime.now()}, communityPosts: $communityPosts');
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            print('Retour vers /');
            context.go('/');
          },
        ),
        title: const Text(
          'Community Forum',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              print('Naviguer vers /notifications');
              context.push('/notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              print('Naviguer vers /settings');
              context.push('/settings');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Section Forum (test)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _postController,
                      decoration: InputDecoration(
                        hintText: 'Partagez votre expérience, posez une question...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      maxLines: 3,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: _submitPost,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Publier',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                      IconButton(
                        icon: Icon(
                          _isRecording ? Icons.stop : Icons.mic,
                          color: _isRecording ? Colors.red : Colors.grey,
                        ),
                        onPressed: _isRecording ? _stopRecording : _startRecording,
                        tooltip: _isRecording ? 'Arrêter l’enregistrement' : 'Enregistrer un message vocal',
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image, color: Colors.grey),
                label: const Text(
                  'Ajouter une image',
                  style: TextStyle(color: Colors.grey),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              if (_selectedImage != null) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Image.file(
                      _selectedImage!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading selected image: $error');
                        return const Text('Erreur lors du chargement de l’image');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      onPressed: _cancelImage,
                      tooltip: 'Annuler l’image',
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              if (communityPosts.isEmpty)
                const Center(
                  child: Text(
                    'Aucune publication pour le moment',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: communityPosts.length,
                  itemBuilder: (context, index) {
                    final post = communityPosts[index];
                    _commentControllers[index] ??= TextEditingController();
                    _editPostControllers[index] ??= TextEditingController(text: post['message']);
                    print('Rendering post at index $index: $post');
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (post['resharedBy'] != null) ...[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: const AssetImage('assets/images/user_profile.jpg'),
                                    onBackgroundImageError: (exception, stackTrace) {
                                      print('Erreur de chargement de l’image de profil republié : $exception');
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${post['resharedBy']} (republié)',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                ],
                              ),
                              if (post['reshareComment'] != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  '${post['resharedBy']}: ${post['reshareComment']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 8),
                            ],
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage(
                                    post['profilePicture'] ?? 'assets/images/default_profile.jpg',
                                  ),
                                  onBackgroundImageError: (exception, stackTrace) {
                                    print('Erreur de chargement de l’image de profil original : $exception');
                                  },
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  post['username'] ?? 'Utilisateur inconnu',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              post['message'] ?? 'Message vide',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.secondaryTextColor,
                              ),
                              softWrap: true,
                            ),
                            if (post['imagePath'] != null) ...[
                              const SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: post['imagePath'].startsWith('assets')
                                    ? Image.asset(
                                        post['imagePath'],
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 150,
                                        errorBuilder: (context, error, stackTrace) {
                                          print('Error loading asset image: $error');
                                          return const Text(
                                            'Erreur lors du chargement de l’image',
                                            style: TextStyle(color: Colors.red),
                                          );
                                        },
                                      )
                                    : Image.file(
                                        File(post['imagePath']),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 150,
                                        errorBuilder: (context, error, stackTrace) {
                                          print('Error loading file image: $error');
                                          return const Text(
                                            'Erreur lors du chargement de l’image',
                                            style: TextStyle(color: Colors.red),
                                          );
                                        },
                                      ),
                              ),
                            ],
                            if (post['audioPath'] != null) ...[
                              const SizedBox(height: 10),
                              ElevatedButton.icon(
                                onPressed: () => _playAudio(index, post['audioPath']),
                                icon: Icon((_isPlaying[index] ?? false) ? Icons.stop : Icons.play_arrow),
                                label: Text((_isPlaying[index] ?? false) ? 'Arrêter' : 'Écouter le message vocal'),
                              ),
                            ],
                            const SizedBox(height: 10),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Stack(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          (_isLiked[index] ?? false) ? Icons.favorite : Icons.favorite_border,
                                          color: (_isLiked[index] ?? false) ? Colors.red : Colors.grey,
                                        ),
                                        onPressed: () => _likePost(index),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Text(
                                          post['likes'].toString(),
                                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Stack(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.comment, color: Colors.grey),
                                        onPressed: () {},
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Text(
                                          post['comments'].toString(),
                                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.repeat, color: Colors.grey),
                                    onPressed: () => _sharePost(index),
                                    tooltip: 'Republier',
                                  ),
                                  Text(
                                    post['shares'].toString(),
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit, color: AppColors.primaryColor),
                                    onPressed: () => _editPost(index),
                                    tooltip: 'Modifier',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deletePost(index),
                                    tooltip: 'Supprimer',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _commentControllers[index],
                                    decoration: InputDecoration(
                                      hintText: 'Ajouter un commentaire...',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                  icon: const Icon(Icons.send, color: AppColors.primaryColor),
                                  onPressed: () => _addComment(index),
                                ),
                              ],
                            ),
                            if (post['commentList'] != null && (post['commentList'] as List).isNotEmpty) ...[
                              const SizedBox(height: 10),
                              const Text(
                                'Commentaires :',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              ...List.generate(
                                (post['commentList'] as List).length,
                                (commentIndex) {
                                  final comment = (post['commentList'] as List)[commentIndex];
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${comment['username']}: ${comment['comment']}',
                                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.edit, color: AppColors.primaryColor, size: 16),
                                          onPressed: () => _editComment(index, commentIndex),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}