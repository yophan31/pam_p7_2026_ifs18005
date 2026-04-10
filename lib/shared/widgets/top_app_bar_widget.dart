// lib/shared/widgets/top_app_bar_widget.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/route_constants.dart';
import '../../core/theme/theme_notifier.dart';

/// Model untuk item menu di TopAppBar
class TopAppBarMenuItem {
  const TopAppBarMenuItem({
    required this.text,
    required this.icon,
    this.route,
    this.onTap,
    this.isDestructive = false,
  });

  final String text;
  final IconData icon;
  final String? route;
  final VoidCallback? onTap;
  final bool isDestructive;
}

/// Widget Top App Bar yang dapat dikonfigurasi — tema Planet
class TopAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const TopAppBarWidget({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.withSearch = false,
    this.searchQuery = '',
    this.onSearchQueryChange,
    this.menuItems = const [],
    this.actions,
  });

  final String title;
  final bool showBackButton;
  final bool withSearch;
  final String searchQuery;
  final ValueChanged<String>? onSearchQueryChange;
  final List<TopAppBarMenuItem> menuItems;

  /// Actions tambahan (misal tombol edit/hapus di halaman detail)
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<TopAppBarWidget> createState() => _TopAppBarWidgetState();
}

class _TopAppBarWidgetState extends State<TopAppBarWidget> {
  bool _isSearchActive = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final themeNotifier = ThemeProvider.of(context);
    final isDark = themeNotifier.isDark;

    return AppBar(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.5),
      scrolledUnderElevation: 4,
      // ── Tombol back ───────────────────────────────────────────────
      leading: widget.showBackButton
          ? IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(RouteConstants.planets);
          }
        },
      )
          : null,
      // ── Title / Search Field ──────────────────────────────────────
      title: _isSearchActive
          ? TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Cari planet...',
          border: InputBorder.none,
          hintStyle:
          TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        onChanged: widget.onSearchQueryChange,
      )
          : Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ikon planet kecil di sebelah judul
          Icon(
            Icons.public,
            size: 20,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            widget.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
      // ── Actions ───────────────────────────────────────────────────
      actions: [
        // Actions tambahan dari luar (edit, hapus, dsb.)
        if (widget.actions != null) ...widget.actions!,

        // Toggle dark/light mode — ikon bulan/matahari bertema luar angkasa
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => RotationTransition(
            turns: animation,
            child: FadeTransition(opacity: animation, child: child),
          ),
          child: IconButton(
            key: ValueKey(isDark),
            icon: Icon(
              isDark ? Icons.nightlight_round : Icons.wb_sunny_outlined,
            ),
            tooltip: isDark ? 'Ganti ke Light Mode' : 'Ganti ke Dark Mode',
            onPressed: themeNotifier.toggle,
          ),
        ),

        // Tombol search
        if (widget.withSearch)
          _isSearchActive
              ? IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () {
              setState(() => _isSearchActive = false);
              _searchController.clear();
              widget.onSearchQueryChange?.call('');
            },
          )
              : IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => setState(() => _isSearchActive = true),
          ),

        // Menu dropdown
        if (widget.menuItems.isNotEmpty)
          PopupMenuButton<TopAppBarMenuItem>(
            icon: const Icon(Icons.more_vert),
            color: colorScheme.primaryContainer,
            itemBuilder: (context) => widget.menuItems
                .map(
                  (item) => PopupMenuItem<TopAppBarMenuItem>(
                value: item,
                child: Row(
                  children: [
                    Icon(
                      item.icon,
                      size: 20,
                      color: item.isDestructive
                          ? colorScheme.error
                          : colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      item.text,
                      style: TextStyle(
                        color: item.isDestructive
                            ? colorScheme.error
                            : colorScheme.onSurface,
                        fontWeight: item.isDestructive
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            )
                .toList(),
            onSelected: (item) {
              if (item.route != null) context.go(item.route!);
              item.onTap?.call();
            },
          ),
      ],
    );
  }
}