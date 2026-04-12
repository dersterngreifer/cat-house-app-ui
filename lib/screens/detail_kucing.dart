import 'package:cat_store_app/models/data_kucing.dart';
import 'package:cat_store_app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DetailKucing extends StatefulWidget {
  final Kucing kucing;
  final int index;

  const DetailKucing({Key? key, required this.kucing, required this.index})
    : super(key: key);

  @override
  State<DetailKucing> createState() => _DetailKucingState();
}

class _DetailKucingState extends State<DetailKucing>
    with SingleTickerProviderStateMixin {
  late Kucing kucing;
  late int index;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    kucing = widget.kucing;
    index = widget.index;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String formatRupiah(int value) {
    String formatted = value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );
    return 'Rp $formatted';
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int years = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      years--;
    }
    return years;
  }

  Color _healthColor(String status) {
    if (status.toLowerCase().contains("sehat")) {
      return AppTheme.successColor;
    }
    if (status.toLowerCase().contains("cacat") ||
        status.toLowerCase().contains("sakit")) {
      return AppTheme.errorColor;
    }
    return AppTheme.warningColor;
  }

  Color _vaksinColor(String vaksin) {
    if (vaksin.toLowerCase().contains("rutin")) {
      return AppTheme.successColor;
    }
    if (vaksin.toLowerCase().contains("tertunda")) {
      return AppTheme.warningColor;
    }
    return AppTheme.textMuted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: _buildTransparentAppBar(),
      body: Stack(
        children: [
          // Main scroll content
          SingleChildScrollView(
            child: Column(
              children: [
                // Hero image with gradient overlay
                _buildHeroImage(),

                // Content section
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: AppTheme.backgroundGradient,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppTheme.spacing24,
                          AppTheme.spacing24,
                          AppTheme.spacing24,
                          0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitleSection(),
                            const SizedBox(height: AppTheme.spacing20),
                            _buildQuickStatsRow(),
                            const SizedBox(height: AppTheme.spacing32),
                            _buildSpecsSection(),
                            const SizedBox(height: AppTheme.spacing32),
                            _buildDescriptionSection(),
                            const SizedBox(height: 110),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Floating contact button
          _buildContactButton(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildTransparentAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(AppTheme.spacing8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(AppTheme.spacing8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: IconButton(
            icon: Icon(
              isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: isFavorite ? AppTheme.secondaryColor : Colors.white,
            ),
            onPressed: () => setState(() => isFavorite = !isFavorite),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroImage() {
    return Hero(
      tag: 'gbr_$index',
      child: Stack(
        children: [
          // Image
          SizedBox(
            height: 400,
            width: double.infinity,
            child: Image.network(
              kucing.foto,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: const Color(0xFF161635),
                  child: Center(
                    child: CircularProgressIndicator(
                      value: progress.expectedTotalBytes != null
                          ? progress.cumulativeBytesLoaded /
                                progress.expectedTotalBytes!
                          : null,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                );
              },
            ),
          ),
          // Gradient overlay (bottom fade into dark)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
            ),
          ),
          // Subtle top overlay for AppBar readability
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name + breed
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                kucing.nama,
                style: AppTheme.heading2.copyWith(
                  color: AppTheme.textLight,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: AppTheme.spacing8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing12,
                      vertical: AppTheme.spacing4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(
                        AppTheme.radiusMedium,
                      ),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      kucing.jenis,
                      style: AppTheme.caption.copyWith(
                        color: AppTheme.primaryDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing8,
                      vertical: AppTheme.spacing4,
                    ),
                    decoration: BoxDecoration(
                      color: _healthColor(
                        kucing.statusKesehatan,
                      ).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(
                        AppTheme.radiusMedium,
                      ),
                      border: Border.all(
                        color: _healthColor(
                          kucing.statusKesehatan,
                        ).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _healthColor(kucing.statusKesehatan),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacing4),
                        Text(
                          kucing.statusKesehatan,
                          style: AppTheme.caption.copyWith(
                            color: _healthColor(kucing.statusKesehatan),
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Price badge
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing16,
            vertical: AppTheme.spacing12,
          ),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.4),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                "Harga",
                style: AppTheme.caption.copyWith(
                  color: Colors.white.withOpacity(0.75),
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                formatRupiah(kucing.harga),
                style: AppTheme.caption.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatsRow() {
    final age = _calculateAge(kucing.tanggalLahir);
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: Colors.black.withOpacity(0.07), width: 1),
      ),
      child: Row(
        children: [
          _buildQuickStat(
            Icons.cake_rounded,
            "$age Tahun",
            "Umur",
            AppTheme.primaryColor,
          ),
          _buildStatSeparator(),
          _buildQuickStat(
            Icons.monitor_weight_outlined,
            "${kucing.beratBadan} kg",
            "Berat",
            AppTheme.accentColor,
          ),
          _buildStatSeparator(),
          _buildQuickStat(
            kucing.jenisKelamin.toLowerCase() == "jantan"
                ? Icons.male_rounded
                : Icons.female_rounded,
            kucing.jenisKelamin,
            "Kelamin",
            AppTheme.secondaryColor,
          ),
          _buildStatSeparator(),
          _buildQuickStat(
            Icons.vaccines_rounded,
            kucing.vaksinasi,
            "Vaksin",
            _vaksinColor(kucing.vaksinasi),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: AppTheme.spacing4),
          Text(
            value,
            style: AppTheme.caption.copyWith(
              color: AppTheme.textLight,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: AppTheme.caption.copyWith(
              color: AppTheme.textLight.withOpacity(0.4),
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatSeparator() {
    return Container(
      width: 1,
      height: 56,
      color: Colors.black.withOpacity(0.1),
    );
  }

  Widget _buildSpecsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Spesifikasi",
          style: AppTheme.heading3.copyWith(
            color: AppTheme.textLight,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          crossAxisSpacing: AppTheme.spacing12,
          mainAxisSpacing: AppTheme.spacing12,
          childAspectRatio: 1.6,
          children: [
            _buildSpecCard(
              Icons.pets_rounded,
              "Warna Bulu",
              kucing.warnaBulu,
              AppTheme.primaryColor,
            ),
            _buildSpecCard(
              Icons.restaurant_rounded,
              "Makanan",
              kucing.makanan,
              Colors.orange,
            ),
            _buildSpecCard(
              Icons.person_rounded,
              "Pemilik",
              kucing.pemilik,
              AppTheme.accentColor,
            ),
            _buildSpecCard(
              Icons.nfc_rounded,
              "Microchip",
              kucing.nomorMikrochip,
              AppTheme.secondaryColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpecCard(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      builder: (context, v, child) => Transform.scale(
        scale: v.clamp(0.0, 2.0),
        child: Opacity(opacity: v.clamp(0.0, 1.0), child: child),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing12),
        decoration: BoxDecoration(
          color: AppTheme.cardDarkColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: color.withOpacity(0.25), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.12),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacing8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              label,
              style: AppTheme.caption.copyWith(
                color: AppTheme.textLight.withOpacity(0.45),
                fontSize: 10,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: AppTheme.caption.copyWith(
                color: AppTheme.textLight,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Deskripsi",
          style: AppTheme.heading3.copyWith(
            color: AppTheme.textLight,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: AppTheme.spacing12),
        Container(
          padding: const EdgeInsets.all(AppTheme.spacing20),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.18),
              width: 1,
            ),
          ),
          child: Text(
            kucing.catatanKhusus,
            style: AppTheme.body1.copyWith(
              color: AppTheme.textLight.withOpacity(0.75),
              fontSize: 15,
              height: 1.7,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppTheme.spacing24,
          AppTheme.spacing16,
          AppTheme.spacing24,
          AppTheme.spacing32,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.backgroundColor.withOpacity(0.0),
              AppTheme.backgroundColor.withOpacity(0.9),
              AppTheme.backgroundColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: GestureDetector(
          onTap: () => _showContactDialog(),
          child: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.55),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                  spreadRadius: -5,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing32,
              vertical: AppTheme.spacing20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.phone_rounded, color: Colors.white, size: 22),
                const SizedBox(width: AppTheme.spacing12),
                Text(
                  "Hubungi ${kucing.pemilik}",
                  style: AppTheme.subtitle1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardDarkColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          side: BorderSide(
            color: AppTheme.primaryColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        title: Text(
          "Hubungi Pemilik",
          style: AppTheme.heading3.copyWith(
            color: AppTheme.textLight,
            fontSize: 20,
          ),
        ),
        content: Text(
          "Anda akan menghubungi ${kucing.pemilik} mengenai kucing ${kucing.nama}.",
          style: AppTheme.body2.copyWith(
            color: AppTheme.textLight.withOpacity(0.7),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal", style: TextStyle(color: AppTheme.textMuted)),
          ),
          Container(
            margin: const EdgeInsets.only(
              right: AppTheme.spacing8,
              bottom: AppTheme.spacing4,
            ),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Ya, Hubungi",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
