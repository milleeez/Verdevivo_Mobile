import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../models/post.dart';
import '../widgets/auth_modal.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final Map<String, bool> _showComments = {};
  final Map<String, TextEditingController> _commentControllers = {};
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Todos';
  String _searchQuery = '';

  final List<Map<String, String>> _imagePresets = [
    {'name': 'Jardim', 'path': 'assets/images/garden.jpg'},
    {'name': 'Monstera', 'path': 'assets/images/monstera.jpg'},
    {'name': 'Calathea', 'path': 'assets/images/calathea.jpg'},
    {'name': 'Ficus', 'path': 'assets/images/ficus.jpg'},
    {'name': 'Jiboia', 'path': 'assets/images/jiboia.jpg'},
    {'name': 'Samambaia', 'path': 'assets/images/samambaia.jpg'},
    {'name': 'Cacto', 'path': 'assets/images/cactus.jpg'},
    {'name': 'Sansevieria', 'path': 'assets/images/sansevieria.jpg'},
    {'name': 'Zamioculca', 'path': 'assets/images/zamioculca.jpg'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    for (var c in _commentControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _showCommunityRulesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.greenLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.shield_outlined, color: AppColors.greenDark, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Diretrizes da Comunidade',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.greenDark,
                          ),
                        ),
                        Text(
                          'Cultivando um espaço saudável e acolhedor',
                          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textLight),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildRuleItem('🌱', 'Dicas e fotos reais', 'Compartilhe suas experiências práticas e fotos do seu jardim.'),
              _buildRuleItem('💧', 'Respeito e gentileza', 'Somos todos aprendizes e entusiastas da botânica. Apoie os iniciantes.'),
              _buildRuleItem('🌿', 'Sem spam ou desinformação', 'Mantenha o foco em plantas, cultivo e bem-estar do verde.'),
              _buildRuleItem('❤️', 'Interações transparentes', 'Curtidas e comentários reais, sem algoritmos invasivos.'),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenDark,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Entendido!'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRuleItem(String emoji, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.greenLighter,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.greenDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPostModal(BuildContext context, {CommunityPost? existing}) {
    final state = Provider.of<AppState>(context, listen: false);
    if (!state.isLoggedIn) {
      AuthModal.show(
        context,
        isSignUp: false,
        initialMessage: 'Crie uma conta ou faça login para compartilhar na comunidade.',
      );
      return;
    }

    final isEdit = existing != null;
    final titleController = TextEditingController(text: existing?.title ?? '');
    final descController = TextEditingController(text: existing?.desc ?? '');
    String selectedCategory = existing?.category ?? 'Dicas';
    String? selectedImage = existing?.image ?? 'assets/images/monstera.jpg';

    final categories = ['Dicas', 'Conquistas', 'Dúvidas', 'Meu Jardim', 'Geral'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEdit ? 'Editar Publicação' : 'Nova Publicação',
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: AppColors.greenDark,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Categoria',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: categories.map((cat) {
                          final isSelected = selectedCategory == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(cat),
                              selected: isSelected,
                              selectedColor: AppColors.greenLight,
                              backgroundColor: AppColors.offWhite,
                              labelStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? AppColors.greenDark : AppColors.textLight,
                              ),
                              onSelected: (val) {
                                if (val) setModalState(() => selectedCategory = cat);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Título da publicação *',
                        hintText: 'Ex: Minha monstera produziu novas folhas!',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: descController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Descrição ou dica',
                        hintText: 'Conte para outros entusiastas seus cuidados...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Foto da Planta (opcional)',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textMuted),
                        ),
                        if (selectedImage != null)
                          TextButton(
                            onPressed: () => setModalState(() => selectedImage = null),
                            style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                            child: const Text('Sem foto', style: TextStyle(color: AppColors.dangerInk, fontSize: 12)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 76,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _imagePresets.length,
                        itemBuilder: (context, i) {
                          final item = _imagePresets[i];
                          final isPicked = selectedImage == item['path'];
                          return GestureDetector(
                            onTap: () => setModalState(() => selectedImage = item['path']),
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 76,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isPicked ? AppColors.coralDark : AppColors.border,
                                  width: isPicked ? 2.5 : 1,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      item['path']!,
                                      width: 76,
                                      height: 76,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  if (isPicked)
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: AppColors.coralDark,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.check, size: 14, color: Colors.white),
                                      ),
                                    ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.55),
                                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
                                      ),
                                      child: Text(
                                        item['name']!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 22),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.coralDark,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        final title = titleController.text.trim();
                        if (title.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Por favor, informe o título da publicação.'),
                              backgroundColor: AppColors.dangerInk,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }

                        if (isEdit) {
                          state.editPost(
                            existing.id,
                            title,
                            descController.text.trim(),
                            image: selectedImage,
                            category: selectedCategory,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: AppColors.greenDark,
                              content: Text('Publicação atualizada com sucesso!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        } else {
                          state.addPost(
                            title,
                            descController.text.trim(),
                            image: selectedImage,
                            category: selectedCategory,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: AppColors.greenDark,
                              content: Text('Publicado na comunidade VerdeVivo! 🎉'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                        Navigator.pop(ctx);
                      },
                      child: Text(isEdit ? 'Salvar Alterações' : 'Publicar'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmReportPost(BuildContext context, CommunityPost post) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.flag_outlined, color: AppColors.warningInk, size: 24),
              SizedBox(width: 8),
              Text('Denunciar Publicação', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.greenDark)),
            ],
          ),
          content: Text(
            'Deseja denunciar "${post.title}"? Nossa moderação analisará este conteúdo.',
            style: const TextStyle(fontSize: 13.5, color: AppColors.textMuted),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar', style: TextStyle(color: AppColors.textMuted)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.coralDark),
              onPressed: () {
                Provider.of<AppState>(context, listen: false).reportPost(post.id);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Denúncia enviada. Obrigado por proteger nossa comunidade!'),
                    backgroundColor: AppColors.greenDark,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Confirmar Denúncia'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeletePost(BuildContext context, CommunityPost post) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Excluir Publicação', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.greenDark)),
          content: Text(
            'Tem certeza que deseja apagar "${post.title}"? Esta ação não pode ser desfeita.',
            style: const TextStyle(fontSize: 13.5, color: AppColors.textMuted),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar', style: TextStyle(color: AppColors.textMuted)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.dangerInk),
              onPressed: () {
                Provider.of<AppState>(context, listen: false).deletePost(post.id);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Publicação excluída com sucesso.'),
                    backgroundColor: AppColors.greenDark,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  void _sharePost(BuildContext context, CommunityPost post) {
    final text = '🌿 ${post.title} — via VerdeVivo\n${post.desc}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Texto da publicação copiado para a área de transferência!'),
        backgroundColor: AppColors.greenDark,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final allPosts = state.posts;

    // Filter by category and search
    final filteredPosts = allPosts.where((p) {
      if (_selectedCategory == 'Minhas') {
        final isMine = p.userId == 'me' || (state.isLoggedIn && p.author == state.userName);
        if (!isMine) return false;
      } else if (_selectedCategory != 'Todos' && p.category != _selectedCategory) {
        return false;
      }

      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchTitle = p.title.toLowerCase().contains(query);
        final matchDesc = p.desc.toLowerCase().contains(query);
        final matchAuthor = p.author.toLowerCase().contains(query);
        if (!matchTitle && !matchDesc && !matchAuthor) return false;
      }

      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: RefreshIndicator(
        color: AppColors.greenMedium,
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 400));
          setState(() {});
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
          children: [
            // Mobile Header Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
                boxShadow: const [
                  BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Comunidade Verde',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.greenDark,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Troque dicas, fotos e conquistas',
                              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.greenDark,
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                        ),
                        icon: const Icon(Icons.shield_outlined, size: 15, color: AppColors.greenMedium),
                        label: const Text('Diretrizes', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                        onPressed: () => _showCommunityRulesSheet(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Mobile Search bar
                  Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.offWhite,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => setState(() => _searchQuery = val.trim()),
                      decoration: InputDecoration(
                        hintText: 'Buscar publicações, plantas...',
                        hintStyle: const TextStyle(fontSize: 13, color: AppColors.textLight),
                        prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textLight),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 16),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Horizontal Filter Chips (Mobile friendly scroll)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  'Todos',
                  'Dicas',
                  'Conquistas',
                  'Dúvidas',
                  'Meu Jardim',
                  'Minhas',
                ].map((category) {
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(
                        category == 'Minhas' ? '💚 Minhas' : category,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? AppColors.greenDark : AppColors.textLight,
                        ),
                      ),
                      backgroundColor: Colors.white,
                      selectedColor: AppColors.greenLight,
                      side: BorderSide(
                        color: isSelected ? AppColors.greenMedium : AppColors.border,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                      onSelected: (val) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 14),

            // Empty state
            if (filteredPosts.isEmpty)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 36),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: AppColors.greenLighter,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.park_outlined, size: 32, color: AppColors.greenMedium),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Nenhuma publicação encontrada',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.greenDark),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _searchQuery.isNotEmpty
                          ? 'Tente pesquisar por outros termos ou limpar a busca.'
                          : 'Seja o primeiro a compartilhar uma dica ou conquista com o grupo!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 16),
                    if (_searchQuery.isNotEmpty || _selectedCategory != 'Todos')
                      TextButton.icon(
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('Limpar filtros'),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                            _selectedCategory = 'Todos';
                          });
                        },
                      )
                    else
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.coralDark),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Criar publicação'),
                        onPressed: () => _showPostModal(context),
                      ),
                  ],
                ),
              )
            else
              // Posts List
              ...filteredPosts.map((post) {
                final areCommentsOpen = _showComments[post.id] ?? false;
                final isMine = post.userId == 'me' || (state.isLoggedIn && post.author == state.userName);

                if (!_commentControllers.containsKey(post.id)) {
                  _commentControllers[post.id] = TextEditingController();
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Post Header
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 12, 6, 10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 19,
                              backgroundColor: AppColors.greenLight,
                              child: Text(
                                post.author.isNotEmpty ? post.author[0].toUpperCase() : 'J',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: AppColors.greenDark,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          post.author,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: AppColors.greenDark,
                                          ),
                                        ),
                                      ),
                                      if (isMine) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: AppColors.coralLight,
                                            borderRadius: BorderRadius.circular(999),
                                          ),
                                          child: const Text(
                                            'Você',
                                            style: TextStyle(
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.coralInk,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Text(
                                        post.date,
                                        style: const TextStyle(fontSize: 11.5, color: AppColors.textLight),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text('•', style: TextStyle(fontSize: 10, color: AppColors.textLight)),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                        decoration: BoxDecoration(
                                          color: AppColors.greenLighter,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          post.category,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.greenInk,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Popup Menu for Mobile
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert, size: 20, color: AppColors.textLight),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              onSelected: (val) {
                                if (val == 'share') {
                                  _sharePost(context, post);
                                } else if (val == 'edit') {
                                  _showPostModal(context, existing: post);
                                } else if (val == 'delete') {
                                  _confirmDeletePost(context, post);
                                } else if (val == 'report') {
                                  _confirmReportPost(context, post);
                                }
                              },
                              itemBuilder: (ctx) => [
                                const PopupMenuItem(
                                  value: 'share',
                                  child: Row(
                                    children: [
                                      Icon(Icons.share_outlined, size: 18, color: AppColors.greenDark),
                                      SizedBox(width: 10),
                                      Text('Compartilhar'),
                                    ],
                                  ),
                                ),
                                if (isMine) ...[
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit_outlined, size: 18, color: AppColors.greenDark),
                                        SizedBox(width: 10),
                                        Text('Editar'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete_outline, size: 18, color: AppColors.dangerInk),
                                        SizedBox(width: 10),
                                        Text('Excluir', style: TextStyle(color: AppColors.dangerInk)),
                                      ],
                                    ),
                                  ),
                                ] else
                                  const PopupMenuItem(
                                    value: 'report',
                                    child: Row(
                                      children: [
                                        Icon(Icons.flag_outlined, size: 18, color: AppColors.warningInk),
                                        SizedBox(width: 10),
                                        Text('Denunciar'),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Post Image (Full-width mobile friendly)
                      if (post.image != null)
                        ClipRRect(
                          child: Image.asset(
                            post.image!,
                            height: 210,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const SizedBox(),
                          ),
                        ),

                      // Post Body
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.greenDark,
                                height: 1.3,
                              ),
                            ),
                            if (post.desc.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                post.desc,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  color: AppColors.text,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const Divider(height: 1, color: AppColors.border),

                      // Action Buttons (Touch friendly mobile row)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Like
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              icon: Icon(
                                post.liked ? Icons.favorite : Icons.favorite_border,
                                color: post.liked ? AppColors.coralDark : AppColors.textLight,
                                size: 19,
                              ),
                              label: Text(
                                post.likes > 0 ? '${post.likes}' : 'Curtir',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: post.liked ? AppColors.coralDark : AppColors.textMuted,
                                ),
                              ),
                              onPressed: () {
                                if (!state.isLoggedIn) {
                                  AuthModal.show(
                                    context,
                                    isSignUp: false,
                                    initialMessage: 'Faça login para curtir publicações na comunidade.',
                                  );
                                  return;
                                }
                                state.toggleLike(post.id);
                              },
                            ),

                            // Comments
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              icon: Icon(
                                areCommentsOpen ? Icons.chat_bubble : Icons.chat_bubble_outline,
                                color: areCommentsOpen ? AppColors.greenDark : AppColors.textLight,
                                size: 18,
                              ),
                              label: Text(
                                post.comments.isNotEmpty ? '${post.comments.length}' : 'Comentar',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: areCommentsOpen ? AppColors.greenDark : AppColors.textMuted,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _showComments[post.id] = !areCommentsOpen;
                                });
                              },
                            ),

                            // Share
                            IconButton(
                              icon: const Icon(Icons.share_outlined, size: 19, color: AppColors.textLight),
                              tooltip: 'Compartilhar',
                              onPressed: () => _sharePost(context, post),
                            ),
                          ],
                        ),
                      ),

                      // Comments Container
                      if (areCommentsOpen) ...[
                        const Divider(height: 1, color: AppColors.border),
                        Container(
                          color: AppColors.offWhite,
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (post.comments.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Center(
                                    child: Text(
                                      'Nenhum comentário ainda. Seja a primeira pessoa!',
                                      style: TextStyle(fontSize: 12, color: AppColors.textLight),
                                    ),
                                  ),
                                )
                              else
                                ...post.comments.map((c) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: 13,
                                            backgroundColor: AppColors.greenLight,
                                            child: Text(
                                              c.author.isNotEmpty ? c.author[0].toUpperCase() : '?',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.greenDark,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(14),
                                                border: Border.all(color: AppColors.border),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    c.author,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                      color: AppColors.greenDark,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    c.text,
                                                    style: const TextStyle(
                                                      fontSize: 12.5,
                                                      color: AppColors.text,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),

                              const SizedBox(height: 6),
                              // Comment input row with Send Button
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(999),
                                        border: Border.all(color: AppColors.border),
                                      ),
                                      child: TextField(
                                        controller: _commentControllers[post.id],
                                        textInputAction: TextInputAction.send,
                                        onSubmitted: (val) {
                                          final text = val.trim();
                                          if (text.isEmpty) return;
                                          if (!state.isLoggedIn) {
                                            AuthModal.show(
                                              context,
                                              isSignUp: false,
                                              initialMessage: 'Faça login para comentar.',
                                            );
                                            return;
                                          }
                                          state.addComment(post.id, text);
                                          _commentControllers[post.id]?.clear();
                                        },
                                        decoration: const InputDecoration(
                                          hintText: 'Escreva um comentário...',
                                          hintStyle: TextStyle(fontSize: 12.5, color: AppColors.textLight),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: AppColors.greenDark,
                                    child: IconButton(
                                      icon: const Icon(Icons.send_rounded, size: 17, color: Colors.white),
                                      onPressed: () {
                                        final controller = _commentControllers[post.id];
                                        final text = controller?.text.trim() ?? '';
                                        if (text.isEmpty) return;
                                        if (!state.isLoggedIn) {
                                          AuthModal.show(
                                            context,
                                            isSignUp: false,
                                            initialMessage: 'Faça login para comentar.',
                                          );
                                          return;
                                        }
                                        state.addComment(post.id, text);
                                        controller?.clear();
                                        FocusScope.of(context).unfocus();
                                      },
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
              }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.greenDark,
        foregroundColor: Colors.white,
        elevation: 3,
        icon: const Icon(Icons.edit),
        label: const Text('Publicar', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () => _showPostModal(context),
      ),
    );
  }
}
