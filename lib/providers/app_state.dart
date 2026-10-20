import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../models/task.dart';
import '../models/post.dart';
import '../models/notification_item.dart';
import '../models/diagnosis_result.dart';
import '../models/user_account.dart';

class Achievement {
  final String icon;
  final String title;
  final String desc;
  final bool unlocked;

  Achievement({
    required this.icon,
    required this.title,
    required this.desc,
    required this.unlocked,
  });
}

class AppState extends ChangeNotifier {
  // Accounts & Session
  final List<UserAccount> _accounts = [];
  UserAccount? _currentUser;

  List<Plant> _plants = Plant.getDefaultPlants();
  List<PlantTask> _tasks = PlantTask.getDefaultTasks();
  List<CommunityPost> _posts = CommunityPost.getDefaultPosts();
  List<NotificationItem> _notifications = NotificationItem.getDefaultNotifications();

  String _userBio = 'Cultivando meu refúgio verde em casa. Apaixonado(a) por aráceas e folhagens tropicais.';
  int _streakDays = 3;

  Map<String, List<String>> _gardenSpaces = {
    'Sala': ['p1', 'p2', 'p6'],
    'Quarto': ['p3'],
    'Varanda': ['p4'],
    'Escritório': ['p5', 'p8'],
    'Banheiro': ['p7'],
    'Jardim': [],
    'Área externa': [],
  };

  // Auth Getters
  bool get isLoggedIn => _currentUser != null;
  UserAccount? get currentUser => _currentUser;
  String get userName => _currentUser?.name ?? 'Visitante';
  String get userEmail => _currentUser?.email ?? '';
  String get userBio => _userBio;

  // Data Getters
  List<Plant> get plants => _plants;
  List<PlantTask> get tasks => _tasks;
  List<CommunityPost> get posts => _posts;
  List<NotificationItem> get notifications => _notifications;
  int get streakDays => _streakDays;
  Map<String, List<String>> get gardenSpaces => _gardenSpaces;

  int get unreadNotificationsCount => _notifications.where((n) => !n.read).length;
  List<Plant> get attentionPlants => _plants.where((p) => p.attention || p.humidity < 30).toList();
  List<Plant> get favoritePlants => _plants.where((p) => p.favorite).toList();
  int get completedTasksCount => _tasks.where((t) => t.done).length;

  // Authentication Methods
  AuthResult signUp(String name, String email, String password) {
    name = name.trim();
    email = email.trim().toLowerCase();
    password = password.trim();

    if (name.isEmpty) {
      return AuthResult(ok: false, error: 'Informe seu nome.');
    }
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      return AuthResult(ok: false, error: 'Informe um e-mail válido.');
    }
    if (password.length < 4) {
      return AuthResult(ok: false, error: 'A senha precisa ter ao menos 4 caracteres.');
    }
    if (_accounts.any((a) => a.email == email)) {
      return AuthResult(ok: false, error: 'Já existe uma conta com este e-mail. Faça login.');
    }

    final newAccount = UserAccount(
      name: name,
      email: email,
      password: password,
      createdAt: DateTime.now(),
    );
    _accounts.add(newAccount);
    _currentUser = newAccount;

    addNotification('Bem-vindo(a) ao VerdeVivo, $name! Comece adicionando uma planta.', 'leaf', 'green');
    notifyListeners();
    return AuthResult(ok: true, account: newAccount);
  }

  AuthResult signIn(String email, String password) {
    email = email.trim().toLowerCase();
    password = password.trim();

    final account = _accounts.firstWhere(
      (a) => a.email == email,
      orElse: () => UserAccount(name: '', email: '', password: '', createdAt: DateTime.now()),
    );

    if (account.email.isEmpty) {
      return AuthResult(ok: false, error: 'Nenhuma conta encontrada com este e-mail.');
    }
    if (account.password != password) {
      return AuthResult(ok: false, error: 'Senha incorreta.');
    }

    _currentUser = account;
    addNotification('Bem-vindo(a) de volta, ${account.name}!', 'check', 'green');
    notifyListeners();
    return AuthResult(ok: true, account: account);
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void resetData() {
    _plants = Plant.getDefaultPlants();
    _tasks = PlantTask.getDefaultTasks();
    _posts = CommunityPost.getDefaultPosts();
    _gardenSpaces = {
      'Sala': ['p1', 'p2', 'p6'],
      'Quarto': ['p3'],
      'Varanda': ['p4'],
      'Escritório': ['p5', 'p8'],
      'Banheiro': ['p7'],
      'Jardim': [],
      'Área externa': [],
    };
    _notifications = NotificationItem.getDefaultNotifications();
    notifyListeners();
  }

  // Plant Actions
  void toggleFavorite(String plantId) {
    final idx = _plants.indexWhere((p) => p.id == plantId);
    if (idx != -1) {
      _plants[idx].favorite = !_plants[idx].favorite;
      notifyListeners();
    }
  }

  void registerCare(String plantId, String careType, {String? notes}) {
    final idx = _plants.indexWhere((p) => p.id == plantId);
    if (idx != -1) {
      _plants[idx].lastWatered = 'Hoje';
      if (careType == 'Adubar') {
        _plants[idx].lastFert = 'Hoje';
      }
      _plants[idx].attention = false;
      addNotification('Cuidado registrado: $careType em ${_plants[idx].name}', 'check', 'green');
      notifyListeners();
    }
  }

  void addMeasurement(String plantId, double heightCm) {
    final idx = _plants.indexWhere((p) => p.id == plantId);
    if (idx != -1) {
      _plants[idx].heightCm = heightCm;
      _plants[idx].measurements.add(PlantMeasurement(date: 'Hoje', height: heightCm));
      notifyListeners();
    }
  }

  void addPlant(Plant plant) {
    _plants.add(plant);
    if (!_gardenSpaces.containsKey(plant.space)) {
      _gardenSpaces[plant.space] = [];
    }
    _gardenSpaces[plant.space]!.add(plant.id);
    addNotification('Você adicionou ${plant.name} ao seu jardim', 'leaf', 'coral');
    notifyListeners();
  }

  void updatePlant(Plant updated) {
    final idx = _plants.indexWhere((p) => p.id == updated.id);
    if (idx != -1) {
      final prevSpace = _plants[idx].space;
      _plants[idx] = updated;

      // Keep garden space in sync if space changed
      if (prevSpace != updated.space) {
        if (_gardenSpaces.containsKey(prevSpace)) {
          _gardenSpaces[prevSpace]!.remove(updated.id);
        }
        if (!_gardenSpaces.containsKey(updated.space)) {
          _gardenSpaces[updated.space] = [];
        }
        if (!_gardenSpaces[updated.space]!.contains(updated.id)) {
          _gardenSpaces[updated.space]!.add(updated.id);
        }
      }
      notifyListeners();
    }
  }

  void deletePlant(String plantId) {
    _plants.removeWhere((p) => p.id == plantId);
    _tasks.removeWhere((t) => t.plantId == plantId);
    _gardenSpaces.forEach((space, pids) {
      pids.remove(plantId);
    });
    notifyListeners();
  }

  // Task Actions
  void toggleTask(String taskId) {
    final idx = _tasks.indexWhere((t) => t.id == taskId);
    if (idx != -1) {
      _tasks[idx].done = !_tasks[idx].done;
      if (_tasks.every((t) => t.done)) {
        addNotification('Você completou todas as tarefas de hoje! 🎉', 'check', 'green');
      }
      notifyListeners();
    }
  }

  void addTask(PlantTask task) {
    _tasks.add(task);
    notifyListeners();
  }

  void removeTask(String taskId) {
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }

  // Community Actions
  void toggleLike(String postId) {
    final idx = _posts.indexWhere((p) => p.id == postId);
    if (idx != -1) {
      if (_posts[idx].liked) {
        _posts[idx].liked = false;
        _posts[idx].likes--;
      } else {
        _posts[idx].liked = true;
        _posts[idx].likes++;
      }
      notifyListeners();
    }
  }

  void addComment(String postId, String text) {
    final idx = _posts.indexWhere((p) => p.id == postId);
    if (idx != -1) {
      _posts[idx].comments.add(PostComment(author: userName, text: text));
      notifyListeners();
    }
  }

  void addPost(String title, String desc, {String? image}) {
    final newPost = CommunityPost(
      id: 'p_${DateTime.now().millisecondsSinceEpoch}',
      author: userName,
      date: 'Agora',
      title: title,
      desc: desc,
      image: image ?? 'assets/images/garden.jpg',
      likes: 0,
      liked: false,
      comments: [],
      userId: 'me',
    );
    _posts.insert(0, newPost);
    notifyListeners();
  }

  // Notifications
  void addNotification(String title, String icon, String iconBg) {
    _notifications.insert(0, NotificationItem(
      id: 'n_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      time: 'Agora',
      read: false,
      icon: icon,
      iconBg: iconBg,
    ));
    notifyListeners();
  }

  void markAllNotificationsRead() {
    for (var n in _notifications) {
      n.read = true;
    }
    notifyListeners();
  }

  void dismissNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  // Garden Space Management
  void assignPlantToSpace(String plantId, String space) {
    _gardenSpaces.forEach((k, v) => v.remove(plantId));
    if (!_gardenSpaces.containsKey(space)) {
      _gardenSpaces[space] = [];
    }
    _gardenSpaces[space]!.add(plantId);
    final plantIdx = _plants.indexWhere((p) => p.id == plantId);
    if (plantIdx != -1) {
      _plants[plantIdx].space = space;
    }
    notifyListeners();
  }

  // Profile
  void updateProfile(String name, String bio) {
    if (_currentUser != null) {
      _currentUser = UserAccount(
        name: name,
        email: _currentUser!.email,
        password: _currentUser!.password,
        createdAt: _currentUser!.createdAt,
      );
    }
    _userBio = bio;
    notifyListeners();
  }

  List<Achievement> getAchievements() {
    final healthyCount = _plants.where((p) => !p.attention && p.health != 'Precisa de água').length;
    final myPostsCount = _posts.where((p) => p.userId == 'me').length;

    return [
      Achievement(icon: '🌱', title: 'Primeira planta', desc: 'Cadastre sua primeira planta', unlocked: _plants.isNotEmpty),
      Achievement(icon: '🌿', title: '7 dias cuidando', desc: 'Complete dias de rotina consecutivos', unlocked: _streakDays >= 7),
      Achievement(icon: '🌳', title: 'Coleção botânica', desc: 'Tenha 8 ou mais plantas cadastradas', unlocked: _plants.length >= 8),
      Achievement(icon: '💚', title: 'Jardim saudável', desc: 'Tenha pelo menos 5 plantas saudáveis', unlocked: healthyCount >= 5),
      Achievement(icon: '💬', title: 'Membro ativo', desc: 'Compartilhe uma publicação na comunidade', unlocked: myPostsCount >= 1),
      Achievement(icon: '⭐', title: 'Colecionador', desc: 'Tenha 2 ou mais plantas favoritas', unlocked: favoritePlants.length >= 2),
    ];
  }
}
