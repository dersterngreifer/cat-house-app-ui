import 'package:cat_store_app/models/data_kucing.dart';
import 'package:cat_store_app/screens/detail_kucing.dart';
import 'package:cat_store_app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ListCat extends StatefulWidget {
  const ListCat({super.key});

  @override
  State<ListCat> createState() => _ListCatState();
}

class _ListCatState extends State<ListCat> with SingleTickerProviderStateMixin {
  bool isGridView = true;
  String selectedCategory = "Semua";
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();
  final List<String> categories = [
    "Semua",
    "Persia",
    "Maine Coon",
    "Scottish Fold",
    "Bengal",
    "Siamese",
  ];
  late AnimationController _animationController;
  final Set<int> _favoriteIndices = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String formatRupiah(int value) {
    String formatted = value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );
    return 'Rp $formatted';
  }

  List<Kucing> dataKucing = Kucing.getDataKucing();

  List<Kucing> get filteredCats {
    List<Kucing> filtered = dataKucing;
    if (selectedCategory != "Semua") {
      filtered = filtered
          .where((cat) => cat.jenis == selectedCategory)
          .toList();
    }
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((cat) {
        return cat.nama.toLowerCase().contains(searchQuery.toLowerCase()) ||
            cat.jenis.toLowerCase().contains(searchQuery.toLowerCase()) ||
            cat.warnaBulu.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
    return filtered;
  }

  void _navigateToDetail(Kucing kucing, int index) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            DetailKucing(kucing: kucing, index: index),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0.04, 0.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: _buildAppBar(),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildSearchBar()),
            SliverToBoxAdapter(
              child: const SizedBox(height: 16),
            ),
            SliverToBoxAdapter(child: _buildCategoryChips()),
            SliverToBoxAdapter(
              child: const SizedBox(height: 16),
            ),
            SliverToBoxAdapter(child: _buildSectionHeader()),
            SliverToBoxAdapter(
              child: const SizedBox(height: 12),
            ),
            filteredCats.isEmpty
                ? SliverToBoxAdapter(child: _buildEmptyState())
                : (isGridView ? _buildGridSliver() : _buildListSliver()),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppTheme.spacing40),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: 72,
      elevation: 0,
      backgroundColor: AppTheme.surfaceColor,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing8),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.pets_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: AppTheme.spacing12),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppTheme.primaryDark, AppTheme.primaryColor],
            ).createShader(bounds),
            child: Text(
              "CatHouse",
              style: AppTheme.heading3.copyWith(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          const Spacer(),
          // View toggle
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: IconButton(
              icon: Icon(
                isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
                color: AppTheme.primaryColor,
                size: 22,
              ),
              onPressed: () => setState(() => isGridView = !isGridView),
              padding: const EdgeInsets.all(AppTheme.spacing8),
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            ),
          ),
          const SizedBox(width: AppTheme.spacing12),
          // Profile avatar
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.4),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                "https://i.imgur.com/0g1mNKo.jpg",
                width: 38,
                height: 38,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacing24,
        28.0,
        AppTheme.spacing24,
        AppTheme.spacing20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Marketplace Kucing",
            style: AppTheme.heading2.copyWith(
              color: AppTheme.textLight,
              fontSize: 30,
            ),
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            "Temukan kucing impian Anda",
            style: AppTheme.body2.copyWith(
              color: AppTheme.textLight.withOpacity(0.55),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          border: Border.all(
            color: searchQuery.isNotEmpty
                ? AppTheme.primaryColor.withOpacity(0.5)
                : Colors.black.withOpacity(0.06),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: searchQuery.isNotEmpty
                  ? AppTheme.primaryColor.withOpacity(0.12)
                  : Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: AppTheme.textLight),
          onChanged: (value) => setState(() => searchQuery = value),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search_rounded,
              color: searchQuery.isNotEmpty
                  ? AppTheme.primaryColor
                  : AppTheme.textLight.withOpacity(0.4),
              size: 22,
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () => setState(() {
                      searchQuery = "";
                      _searchController.clear();
                    }),
                    child: Container(
                      margin: const EdgeInsets.only(right: AppTheme.spacing8),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.textLight.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: AppTheme.textLight.withOpacity(0.6),
                        size: 16,
                      ),
                    ),
                  ),
                Container(
                  margin: const EdgeInsets.all(AppTheme.spacing8),
                  padding: const EdgeInsets.all(AppTheme.spacing8),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing20,
              vertical: AppTheme.spacing16,
            ),
            border: InputBorder.none,
            hintText: 'Cari kucing kesayangan...',
            hintStyle: TextStyle(
              color: AppTheme.textLight.withOpacity(0.35),
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing24,
          vertical: 3,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppTheme.spacing8),
        itemBuilder: (context, index) {
          final isSelected = selectedCategory == categories[index];
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = categories[index]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                gradient: isSelected ? AppTheme.primaryGradient : null,
                color: isSelected ? null : Colors.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : AppTheme.primaryColor.withOpacity(0.12),
                  width: 1.2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.32),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                          spreadRadius: -2,
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (categories[index] == "Semua")
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        size: 13,
                        color: isSelected
                            ? Colors.white
                            : AppTheme.primaryColor,
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.pets_rounded,
                        size: 12,
                        color: isSelected
                            ? Colors.white
                            : AppTheme.primaryColor.withOpacity(0.7),
                      ),
                    ),
                  Text(
                    categories[index],
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : AppTheme.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Kucing Pilihan",
            style: AppTheme.heading3.copyWith(
              color: AppTheme.textLight,
              fontSize: 20,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing12,
              vertical: AppTheme.spacing4,
            ),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Text(
              "${filteredCats.length} kucing",
              style: AppTheme.caption.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridSliver() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppTheme.spacing16,
          mainAxisSpacing: AppTheme.spacing16,
          childAspectRatio: 0.69,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final kucing = filteredCats[index];
          final originalIndex = dataKucing.indexOf(kucing);
          return _buildGridCard(kucing, originalIndex, index);
        }, childCount: filteredCats.length),
      ),
    );
  }

  Widget _buildListSliver() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final kucing = filteredCats[index];
          final originalIndex = dataKucing.indexOf(kucing);
          return Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
            child: _buildListCard(kucing, originalIndex, index),
          );
        }, childCount: filteredCats.length),
      ),
    );
  }

  Widget _buildGridCard(Kucing kucing, int originalIndex, int animIndex) {
    final isFav = _favoriteIndices.contains(originalIndex);
    final isFemale = kucing.jenisKelamin.toLowerCase().contains("betina");

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 320 + (animIndex * 50)),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value.clamp(0.01, 1.0),
          child: Opacity(
            opacity: value < 0.0 ? 0.0 : (value > 1.0 ? 1.0 : value),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => _navigateToDetail(kucing, originalIndex),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.08),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
                spreadRadius: -2,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Container with Badges
              Stack(
                children: [
                  Hero(
                    tag: 'gbr_$originalIndex',
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppTheme.radiusLarge - 1),
                      ),
                      child: SizedBox(
                        height: 132,
                        width: double.infinity,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              kucing.foto,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return Container(
                                  color: const Color(0xFFF3F0FF),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value: progress.expectedTotalBytes != null
                                          ? progress.cumulativeBytesLoaded /
                                                progress.expectedTotalBytes!
                                          : null,
                                      color: AppTheme.primaryColor,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (_, __, ___) => Container(
                                color: const Color(0xFFF3F0FF),
                                child: const Center(
                                  child: Icon(
                                    Icons.pets_rounded,
                                    color: AppTheme.primaryLight,
                                    size: 32,
                                  ),
                                ),
                              ),
                            ),
                            // Subtle bottom gradient inside image
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 35,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.25),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Gender Badge on Top-Left
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isFemale
                                ? Icons.female_rounded
                                : Icons.male_rounded,
                            size: 12,
                            color: isFemale
                                ? const Color(0xFFFF3370)
                                : const Color(0xFF2E6FF2),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            kucing.jenisKelamin,
                            style: TextStyle(
                              color: isFemale
                                  ? const Color(0xFFFF3370)
                                  : const Color(0xFF2E6FF2),
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Favorite button on Top-Right
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isFav) {
                            _favoriteIndices.remove(originalIndex);
                          } else {
                            _favoriteIndices.add(originalIndex);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          isFav
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: AppTheme.secondaryColor,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  // Health dot badge on bottom-left inside image
                  Positioned(
                    bottom: 6,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: kucing.statusKesehatan.toLowerCase().contains("sehat")
                                  ? const Color(0xFF00E676)
                                  : const Color(0xFFFFB300),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            kucing.statusKesehatan,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Content Area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Name and Breed
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            kucing.nama,
                            style: AppTheme.subtitle2.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.5,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.09),
                                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                                ),
                                child: Text(
                                  kucing.jenis,
                                  style: AppTheme.caption.copyWith(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "• ${kucing.beratBadan}kg",
                                style: AppTheme.caption.copyWith(
                                  color: AppTheme.textSecondary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Price & Action Button Row
                      Container(
                        padding: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.black.withOpacity(0.04),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Harga Adopsi",
                                    style: TextStyle(
                                      color: AppTheme.textMuted,
                                      fontSize: 8.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    formatRupiah(kucing.harga),
                                    style: const TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12.5,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                gradient: AppTheme.primaryGradient,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryColor.withOpacity(0.35),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListCard(Kucing kucing, int originalIndex, int animIndex) {
    final isFav = _favoriteIndices.contains(originalIndex);
    final isFemale = kucing.jenisKelamin.toLowerCase().contains("betina");

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 280 + (animIndex * 50)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 16 * (1 - value)),
          child: Opacity(
            opacity: value < 0.0 ? 0.0 : (value > 1.0 ? 1.0 : value),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => _navigateToDetail(kucing, originalIndex),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.08),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.08),
                blurRadius: 18,
                offset: const Offset(0, 6),
                spreadRadius: -3,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Thumbnail with Hero and Badges
              Stack(
                children: [
                  Hero(
                    tag: 'gbr_$originalIndex',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      child: SizedBox(
                        width: 108,
                        height: 114,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              kucing.foto,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return Container(
                                  color: const Color(0xFFF3F0FF),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value: progress.expectedTotalBytes != null
                                          ? progress.cumulativeBytesLoaded /
                                                progress.expectedTotalBytes!
                                          : null,
                                      color: AppTheme.primaryColor,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (_, __, ___) => Container(
                                color: const Color(0xFFF3F0FF),
                                child: const Center(
                                  child: Icon(
                                    Icons.pets_rounded,
                                    color: AppTheme.primaryLight,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                            // Subtle gradient overlay at bottom
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 30,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.3),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Gender Icon Badge inside image top-left
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.92),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        isFemale ? Icons.female_rounded : Icons.male_rounded,
                        size: 13,
                        color: isFemale
                            ? const Color(0xFFFF3370)
                            : const Color(0xFF2E6FF2),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 12),

              // Detailed Content Area
              Expanded(
                child: SizedBox(
                  height: 114,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Header: Cat Name + Favorite Button
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  kucing.nama,
                                  style: AppTheme.subtitle2.copyWith(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15.5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                // Chips Row: Breed + Gender
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 7,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor.withOpacity(0.09),
                                        borderRadius: BorderRadius.circular(
                                          AppTheme.radiusSmall,
                                        ),
                                      ),
                                      child: Text(
                                        kucing.jenis,
                                        style: AppTheme.caption.copyWith(
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      kucing.jenisKelamin,
                                      style: TextStyle(
                                        color: isFemale
                                            ? const Color(0xFFFF4B82)
                                            : const Color(0xFF2E6FF2),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isFav) {
                                  _favoriteIndices.remove(originalIndex);
                                } else {
                                  _favoriteIndices.add(originalIndex);
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceColor.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isFav
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: AppTheme.secondaryColor,
                                size: 17,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Attributes: Health + Weight + Color
                      Row(
                        children: [
                          // Health Indicator
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: kucing.statusKesehatan.toLowerCase().contains("sehat")
                                  ? const Color(0xFF00E676)
                                  : const Color(0xFFFFB300),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            kucing.statusKesehatan,
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "•",
                            style: TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.monitor_weight_outlined,
                            size: 12,
                            color: AppTheme.textMuted,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            "${kucing.beratBadan} kg",
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      // Bottom: Price & Detail Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Harga Adopsi",
                                style: TextStyle(
                                  color: AppTheme.textMuted,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                formatRupiah(kucing.harga),
                                style: const TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14.5,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusMedium,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  "Detail",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 3),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacing32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: AppTheme.spacing40),
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing32),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.4),
                  blurRadius: 35,
                  spreadRadius: -5,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 56,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppTheme.spacing24),
          Text(
            "Tidak Ada Hasil",
            style: AppTheme.heading3.copyWith(color: AppTheme.textLight),
          ),
          const SizedBox(height: AppTheme.spacing12),
          Text(
            searchQuery.isNotEmpty
                ? "Tidak ada kucing yang cocok dengan\n\"$searchQuery\""
                : "Tidak ada kucing di kategori ini",
            style: AppTheme.body2.copyWith(
              color: AppTheme.textLight.withOpacity(0.5),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacing32),
          GestureDetector(
            onTap: () => setState(() {
              searchQuery = "";
              selectedCategory = "Semua";
              _searchController.clear();
            }),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing32,
                vertical: AppTheme.spacing16,
              ),
              decoration: BoxDecoration(
                gradient: AppTheme.accentGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentColor.withOpacity(0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.refresh_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: AppTheme.spacing8),
                  Text(
                    "Reset Filter",
                    style: AppTheme.subtitle2.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
