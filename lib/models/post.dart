class PostComment {
  final String author;
  final String text;

  PostComment({required this.author, required this.text});
}

class CommunityPost {
  final String id;
  final String author;
  final String? avatar;
  final String date;
  String title;
  String desc;
  String? image;
  String category;
  int likes;
  bool liked;
  final List<PostComment> comments;
  final String? userId;
  bool reported;

  CommunityPost({
    required this.id,
    required this.author,
    this.avatar,
    required this.date,
    required this.title,
    required this.desc,
    this.image,
    this.category = 'Geral',
    this.likes = 0,
    this.liked = false,
    required this.comments,
    this.userId,
    this.reported = false,
  });

  static List<CommunityPost> getDefaultPosts() {
    return [
      CommunityPost(
        id: 'post1',
        author: 'Fernanda Lima',
        date: 'Ontem',
        title: 'Minha monstera floresceu!',
        desc: 'Depois de 2 anos de cuidado, minha Costela-de-Adão finalmente teve novas fenestras incríveis. Compartilho a felicidade!',
        image: 'assets/images/monstera.jpg',
        category: 'Conquistas',
        likes: 12,
        liked: false,
        comments: [
          PostComment(author: 'Rafael', text: 'Que maravilha! Parabéns!'),
        ],
      ),
      CommunityPost(
        id: 'post2',
        author: 'Carlos M.',
        date: '3 dias atrás',
        title: 'Dica: umidade para calathea',
        desc: 'Para quem tem dificuldade com calatheas, a dica é manter um umidificador ou bandeja com pedrinhas e água próximo.',
        image: 'assets/images/calathea.jpg',
        category: 'Dicas',
        likes: 8,
        liked: false,
        comments: [],
      ),
      CommunityPost(
        id: 'post3',
        author: 'Ana Souza',
        date: '5 dias atrás',
        title: 'Antes e depois da minha sala',
        desc: 'Transformei meu espaço com plantas de interior e agora sinto o ar muito mais leve e agradável.',
        image: 'assets/images/garden.jpg',
        category: 'Meu Jardim',
        likes: 19,
        liked: false,
        comments: [
          PostComment(author: 'Beatriz', text: 'Ficou lindo!'),
          PostComment(author: 'João', text: 'Inspiração demais!'),
        ],
      ),
    ];
  }
}
