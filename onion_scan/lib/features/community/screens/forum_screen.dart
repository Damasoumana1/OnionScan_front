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
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  String? _audioPath;
  bool _isRecording = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    _initRecorderAndPlayer();
    _loadPosts();
  }

  Future<void> _initRecorderAndPlayer() async {
    await _recorder!.openRecorder();
    await _player!.openPlayer();
    final directory = await getTemporaryDirectory();
    _audioPath = '${directory.path}/temp_audio.aac';
  }

  Future<void> _loadPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final postsJson = prefs.getString('communityPosts');
    if (postsJson != null) {
      setState(() {
        communityPosts = List<Map<String, dynamic>>.from(jsonDecode(postsJson));
      });
    } else {
      // Initialiser avec des données par défaut si aucune donnée n'est sauvegardée
      communityPosts = [
        {
          'username': 'Amadou Traoré',
          'message': 'J’ai remarqué des taches brunes sur mes oignons. Quelqu’un a une idée de ce problème ? Voici une description plus longue pour tester : j’ai planté mes oignons il y a trois mois, et récemment, j’ai observé des taches brunes sur les feuilles. Cela semble s’étendre rapidement, et je suis inquiet pour ma récolte. Avez-vous des conseils pour traiter ce problème ou identifier la cause ?',
          'imagePath': 'assets/images/sample_onion.jpg',
          'profilePicture': 'assets/images/amadou_profile.jpg',
          'likes': 15,
          'comments': 12,
          'shares': 0,
          'commentList': [], // Liste pour stocker les commentaires
          'audioPath': null,
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
        },
      ];
      await _savePosts();
    }
    print('communityPosts au démarrage de ForumScreen : $communityPosts');
  }

  Future<void> _savePosts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('communityPosts', jsonEncode(communityPosts));
    print('Publications sauvegardées : $communityPosts');
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
        });
        print('communityPosts après ajout : $communityPosts');
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
    }
  }

  void _pickImage() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
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
    } catch (e) {
      print('Erreur lors de l’arrêt de l’enregistrement : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de l’arrêt de l’enregistrement.')),
      );
    }
  }

  void _playAudio(String audioPath) async {
    try {
      if (_isPlaying) {
        await _player!.stopPlayer();
        setState(() {
          _isPlaying = false;
        });
      } else {
        await _player!.startPlayer(fromURI: audioPath);
        setState(() {
          _isPlaying = true;
        });
      }
    } catch (e) {
      print('Erreur lors de la lecture de l’audio : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la lecture de l’audio.')),
      );
    }
  }

  void _likePost(int index) {
    setState(() {
      communityPosts[index]['likes'] = (communityPosts[index]['likes'] ?? 0) + 1;
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
      });
      controller.clear();
      _savePosts();
    }
  }

  void _sharePost(int index) {
    setState(() {
      communityPosts[index]['shares'] = (communityPosts[index]['shares'] ?? 0) + 1;
    });
    _savePosts();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Publication republiée !')),
    );
  }

  @override
  void dispose() {
    _postController.dispose();
    _commentControllers.forEach((_, controller) => controller.dispose());
    _recorder!.closeRecorder();
    _player!.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Construction de ForumScreen, communityPosts : $communityPosts');
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
                Image.file(
                  _selectedImage!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
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
                    print('Affichage de la publication $index : $post');
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage(
                                    post['profilePicture'] ?? 'assets/images/default_profile.jpg',
                                  ),
                                  onBackgroundImageError: (exception, stackTrace) {
                                    print('Erreur de chargement de l’image de profil : $exception');
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
                                onPressed: () => _playAudio(post['audioPath']),
                                icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                                label: Text(_isPlaying ? 'Arrêter' : 'Écouter le message vocal'),
                              ),
                            ],
                            const SizedBox(height: 10),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.favorite_border, color: Colors.grey),
                                    onPressed: () => _likePost(index),
                                  ),
                                  Text(
                                    post['likes'].toString(),
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(width: 5),
                                  IconButton(
                                    icon: const Icon(Icons.comment, color: Colors.grey),
                                    onPressed: () {},
                                  ),
                                  Text(
                                    post['comments'].toString(),
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(width: 5),
                                  IconButton(
                                    icon: const Icon(Icons.repeat, color: Colors.grey),
                                    onPressed: () => _sharePost(index),
                                    tooltip: 'Republier',
                                  ),
                                  Text(
                                    post['shares'].toString(),
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(width: 5),
                                  IconButton(
                                    icon: Icon(Icons.edit, color: AppColors.primaryColor),
                                    onPressed: () {},
                                    tooltip: 'Modifier',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {},
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
                                    child: Text(
                                      '${comment['username']}: ${comment['comment']}',
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
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