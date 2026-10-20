import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final Map<String, bool> _showComments = {};

  void _showNewPostDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Nova Publicação', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: AppColors.greenDark)),
                  IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Título da publicação *',
                  hintText: 'Ex: Minha monstera produziu novas folhas!',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Descrição ou dica',
                  hintText: 'Compartilhe sua experiência de cuidado...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.coralDark,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  if (titleController.text.trim().isEmpty) return;
                  Provider.of<AppState>(context, listen: false).addPost(titleController.text.trim(), descController.text.trim());
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(backgroundColor: AppColors.greenDark, content: Text('Publicado na comunidade VerdeVivo!')),
                  );
                },
                child: const Text('Publicar'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final posts = state.posts;

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: posts.length + 1,
        itemBuilder: (context, idx) {
          if (idx == 0) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Comunidade Verde', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.greenDark)),
                  Text('Compartilhe dicas, fotos e conquistas do seu jardim com outros entusiastas.', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                ],
              ),
            );
          }

          final post = posts[idx - 1];
          final areCommentsOpen = _showComments[post.id] ?? false;

          return Card(
            margin: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.greenLight,
                    child: Text(post.author.isNotEmpty ? post.author[0] : 'J', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.greenDark)),
                  ),
                  title: Text(post.author, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.greenDark)),
                  subtitle: Text(post.date, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                ),
                if (post.image != null)
                  ClipRRect(
                    child: Image.asset(
                      post.image!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox(),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.title, style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold, color: AppColors.greenDark)),
                      const SizedBox(height: 6),
                      Text(post.desc, style: const TextStyle(fontSize: 13.5, color: AppColors.text, height: 1.4)),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                      icon: Icon(post.liked ? Icons.favorite : Icons.favorite_border, color: post.liked ? AppColors.coralDark : AppColors.textLight, size: 20),
                      label: Text('${post.likes > 0 ? post.likes : 'Curtir'}', style: TextStyle(color: post.liked ? AppColors.coralDark : AppColors.textMuted)),
                      onPressed: () => state.toggleLike(post.id),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.mode_comment_outlined, color: AppColors.textLight, size: 20),
                      label: Text('${post.comments.length} Comentários', style: const TextStyle(color: AppColors.textMuted)),
                      onPressed: () {
                        setState(() {
                          _showComments[post.id] = !areCommentsOpen;
                        });
                      },
                    ),
                  ],
                ),
                if (areCommentsOpen) ...[
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...post.comments.map((c) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: AppColors.greenLighter, borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c.author, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: AppColors.greenDark)),
                                const SizedBox(height: 2),
                                Text(c.text, style: const TextStyle(fontSize: 13, color: AppColors.text)),
                              ],
                            ),
                          ),
                        )),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onSubmitted: (val) {
                                  if (val.trim().isNotEmpty) {
                                    state.addComment(post.id, val.trim());
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: 'Escreva um comentário...',
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(999)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.greenDark,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit),
        label: const Text('Publicar'),
        onPressed: () => _showNewPostDialog(context),
      ),
    );
  }
}
