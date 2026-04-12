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
              child: const SizedBox(height: AppTheme.spacing20),
            ),
            SliverToBoxAdapter(child: _buildCategoryChips()),
            SliverToBoxAdapter(
              child: const SizedBox(height: AppTheme.spacing24),
            ),
            SliverToBoxAdapter(child: _buildSectionHeader()),
            SliverToBoxAdapter(
              child: const SizedBox(height: AppTheme.spacing16),
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
      height: 46,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppTheme.spacing8),
        itemBuilder: (context, index) {
          final isSelected = selectedCategory == categories[index];
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = categories[index]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing20,
                vertical: AppTheme.spacing8,
              ),
              decoration: BoxDecoration(
                gradient: isSelected ? AppTheme.primaryGradient : null,
                color: isSelected ? null : AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : Colors.black.withOpacity(0.08),
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : [],
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : AppTheme.textLight.withOpacity(0.6),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 13,
                ),
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
          childAspectRatio: 0.63,
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
            padding: const EdgeInsets.only(bottom: AppTheme.spacing16),
            child: _buildListCard(kucing, originalIndex, index),
          );
        }, childCount: filteredCats.length),
      ),
    );
  }

  Widget _buildGridCard(Kucing kucing, int originalIndex, int animIndex) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 350 + (animIndex * 80)),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value.clamp(0.01, 2.0),
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
            gradient: AppTheme.cardGradient,
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.15),
                blurRadius: 25,
                offset: const Offset(0, 12),
                spreadRadius: -5,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Stack(
                children: [
                  Hero(
                    tag: 'gbr_$originalIndex',
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppTheme.radiusLarge),
                        topRight: Radius.circular(AppTheme.radiusLarge),
                      ),
                      child: SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: Image.network(
                          kucing.foto,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              color: const Color(0xFFF0ECFF),
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
                        ),
                      ),
                    ),
                  ),
                  // Favorite button
                  Positioned(
                    top: 10.0,
                    right: 10.0,
                    child: Container(
                      padding: const EdgeInsets.all(AppTheme.spacing8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.92),
                        shape: BoxShape.circle,
                        boxShadow: AppTheme.softShadow,
                      ),
                      child: Icon(
                        Icons.favorite_border_rounded,
                        color: AppTheme.secondaryColor,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),

              // Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kucing.nama,
                        style: AppTheme.subtitle2.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppTheme.spacing4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusSmall,
                          ),
                        ),
                        child: Text(
                          kucing.jenis,
                          style: AppTheme.caption.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              formatRupiah(kucing.harga),
                              style: AppTheme.caption.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.monitor_weight_outlined,
                                color: AppTheme.textMuted,
                                size: 13,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                "${kucing.beratBadan}kg",
                                style: AppTheme.caption.copyWith(
                                  color: AppTheme.textMuted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
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

  Widget _buildListCard(Kucing kucing, int originalIndex, int animIndex) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (animIndex * 70)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value < 0.0 ? 0.0 : (value > 1.0 ? 1.0 : value),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => _navigateToDetail(kucing, originalIndex),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: -3,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Image
              Hero(
                tag: 'gbr_$originalIndex',
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppTheme.radiusLarge),
                    bottomLeft: Radius.circular(AppTheme.radiusLarge),
                  ),
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: Image.network(kucing.foto, fit: BoxFit.cover),
                  ),
                ),
              ),

              // Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacing16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              kucing.nama,
                              style: AppTheme.subtitle2.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.favorite_border_rounded,
                            color: AppTheme.secondaryColor,
                            size: 18,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacing4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusSmall,
                          ),
                        ),
                        child: Text(
                          kucing.jenis,
                          style: AppTheme.caption.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing8),
                      Row(
                        children: [
                          Text(
                            formatRupiah(kucing.harga),
                            style: AppTheme.body2.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacing12),
                          Icon(
                            Icons.monitor_weight_outlined,
                            color: AppTheme.textMuted,
                            size: 13,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${kucing.beratBadan} kg",
                            style: AppTheme.caption.copyWith(
                              color: AppTheme.textMuted,
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
