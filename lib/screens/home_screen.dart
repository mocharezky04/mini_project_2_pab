import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/incident.dart';
import '../providers/incident_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/incident_datetime_formatter.dart';
import 'add_incident_screen.dart';
import 'detail_incident_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isDeleteDialogOpen = false;
  final Set<String> _deletingIncidentIds = <String>{};
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<IncidentProvider>().loadIncidents();
      }
    });
  }

  void _showSuccessSnackbar(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal logout: $e')),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _openAddIncidentScreen() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const AddIncidentScreen()),
    );

    if (created == true && mounted) {
      _showSuccessSnackbar('Insiden berhasil ditambahkan');
    }
  }

  Future<void> _openDetailIncidentScreen(Incident incident) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => DetailIncidentScreen(incident: incident),
      ),
    );

    if (updated == true && mounted) {
      _showSuccessSnackbar('Insiden berhasil diperbarui');
    }
  }

  Future<bool> _confirmDelete() async {
    if (_isDeleteDialogOpen) {
      return false;
    }
    setState(() => _isDeleteDialogOpen = true);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Yakin ingin menghapus insiden ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
    if (mounted) {
      setState(() => _isDeleteDialogOpen = false);
    }
    return confirmed ?? false;
  }

  Future<void> _deleteIncident(String incidentId) async {
    if (_deletingIncidentIds.contains(incidentId)) {
      return;
    }
    final shouldDelete = await _confirmDelete();
    if (!shouldDelete || !mounted) {
      return;
    }

    setState(() => _deletingIncidentIds.add(incidentId));
    try {
      await context.read<IncidentProvider>().deleteIncident(incidentId);
      _showSuccessSnackbar('Insiden berhasil dihapus');
    } finally {
      if (mounted) {
        setState(() => _deletingIncidentIds.remove(incidentId));
      }
    }
  }

  Future<void> _openThemePicker() async {
    final themeProvider = context.read<ThemeProvider>();
    final selected = await showModalBottomSheet<ThemeMode>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        final currentMode = themeProvider.themeMode;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Text(
                  'Pilih Tema',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              ListTile(
                title: const Text('Ikuti Sistem'),
                trailing: currentMode == ThemeMode.system
                    ? const Icon(Icons.check)
                    : null,
                onTap: () => Navigator.pop(sheetContext, ThemeMode.system),
              ),
              ListTile(
                title: const Text('Light'),
                trailing: currentMode == ThemeMode.light
                    ? const Icon(Icons.check)
                    : null,
                onTap: () => Navigator.pop(sheetContext, ThemeMode.light),
              ),
              ListTile(
                title: const Text('Dark'),
                trailing: currentMode == ThemeMode.dark
                    ? const Icon(Icons.check)
                    : null,
                onTap: () => Navigator.pop(sheetContext, ThemeMode.dark),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (selected != null && mounted) {
      themeProvider.setThemeMode(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IncidentProvider>();
    final deletingIncidentIds = Set<String>.from(_deletingIncidentIds);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cyber Incident Log'),
        actions: [
          IconButton(
            tooltip: 'Tema',
            icon: const Icon(Icons.brightness_6_outlined),
            onPressed: _openThemePicker,
          ),
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Column(
        children: [
          const _IncidentCounterBanner(),
          Expanded(
            child: _IncidentListSection(
              deletingIncidentIds: deletingIncidentIds,
              isDeleteLocked: _isDeleteDialogOpen,
              onOpenDetail: _openDetailIncidentScreen,
              onDelete: _deleteIncident,
              scrollController: _scrollController,
              isLoading: provider.isLoading,
              errorMessage: provider.errorMessage,
              onRetry: provider.loadIncidents,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddIncidentScreen,
        tooltip: 'Tambah insiden',
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}

class _IncidentCounterBanner extends StatelessWidget {
  const _IncidentCounterBanner();

  @override
  Widget build(BuildContext context) {
    final count = context.select<IncidentProvider, int>(
      (provider) => provider.incidents.length,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0B3C5D), Color(0xFF1D6FA3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Text(
        '$count incident tercatat',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _IncidentListSection extends StatefulWidget {
  const _IncidentListSection({
    required this.deletingIncidentIds,
    required this.isDeleteLocked,
    required this.onOpenDetail,
    required this.onDelete,
    required this.scrollController,
    required this.isLoading,
    required this.errorMessage,
    required this.onRetry,
  });

  final Set<String> deletingIncidentIds;
  final bool isDeleteLocked;
  final ValueChanged<Incident> onOpenDetail;
  final ValueChanged<String> onDelete;
  final ScrollController scrollController;
  final bool isLoading;
  final String? errorMessage;
  final Future<void> Function() onRetry;

  @override
  State<_IncidentListSection> createState() => _IncidentListSectionState();
}

class _IncidentListSectionState extends State<_IncidentListSection> {
  static const int _pageSize = 100;
  static const double _loadMoreOffsetPx = 640;
  int _visibleCount = _pageSize;
  int _latestTotalCount = 0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_handleScroll);
  }

  @override
  void didUpdateWidget(covariant _IncidentListSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController.removeListener(_handleScroll);
      widget.scrollController.addListener(_handleScroll);
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_handleScroll);
    super.dispose();
  }

  void _handleScroll() {
    if (!widget.scrollController.hasClients ||
        _visibleCount >= _latestTotalCount) {
      return;
    }

    final position = widget.scrollController.position;
    final shouldLoadMore =
        position.maxScrollExtent - position.pixels <= _loadMoreOffsetPx;
    if (!shouldLoadMore) {
      return;
    }

    setState(() {
      _visibleCount = math.min(_visibleCount + _pageSize, _latestTotalCount);
    });
  }

  @override
  Widget build(BuildContext context) {
    final incidents = context.watch<IncidentProvider>().incidents;
    _latestTotalCount = incidents.length;

    if (widget.isLoading && incidents.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.errorMessage != null && incidents.isEmpty) {
      return _ErrorState(
        message: widget.errorMessage!,
        onRetry: widget.onRetry,
      );
    }

    if (incidents.isEmpty) {
      return const _EmptyState();
    }

    final visibleCount = math.min(_visibleCount, incidents.length);
    final hasMore = visibleCount < incidents.length;

    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: Center(
              child: Icon(
                Icons.security_outlined,
                size: 170,
                color: const Color(0xFF98A2B3).withValues(alpha: 0.14),
              ),
            ),
          ),
        ),
        RefreshIndicator(
          onRefresh: widget.onRetry,
          child: ListView.builder(
            controller: widget.scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: hasMore ? visibleCount + 1 : visibleCount,
            itemBuilder: (context, index) {
              if (hasMore && index == visibleCount) {
                return const Padding(
                  padding: EdgeInsets.fromLTRB(8, 4, 8, 16),
                  child: Center(
                    child: Text(
                      'Scroll untuk memuat item berikutnya...',
                      style: TextStyle(color: Color(0xFF667085)),
                    ),
                  ),
                );
              }

              final incident = incidents[index];
              final item = _IncidentCardData.fromIncident(incident);
              return Padding(
                key: ValueKey(incident.id),
                padding: const EdgeInsets.only(bottom: 12),
                child: _IncidentListItem(
                  item: item,
                  isDeleteLocked: widget.isDeleteLocked,
                  deletingIncidentIds: widget.deletingIncidentIds,
                  onOpenDetail: widget.onOpenDetail,
                  onDelete: widget.onDelete,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _IncidentListItem extends StatelessWidget {
  const _IncidentListItem({
    required this.item,
    required this.isDeleteLocked,
    required this.deletingIncidentIds,
    required this.onOpenDetail,
    required this.onDelete,
  });

  final _IncidentCardData item;
  final bool isDeleteLocked;
  final Set<String> deletingIncidentIds;
  final ValueChanged<Incident> onOpenDetail;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    final isDeleteBusy =
        isDeleteLocked || deletingIncidentIds.contains(item.id);

    return RepaintBoundary(
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onOpenDetail(item.rawIncident),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.incidentCode} - ${item.title}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (isDeleteBusy)
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: Padding(
                          padding: EdgeInsets.all(2),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    else
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Hapus insiden',
                        onPressed: () => onDelete(item.id),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _InfoChip(label: item.incidentTypeLabel, color: item.typeColor),
                    _InfoChip(label: item.severityLabel, color: item.severityColor),
                    _InfoChip(label: item.statusLabel, color: item.statusColor),
                    _InfoChip(
                      label: item.detectedAtLabel,
                      color: _IncidentCardData.dateColor,
                    ),
                    _InfoChip(label: item.analystLabel, color: item.analystColor),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IncidentCardData {
  const _IncidentCardData({
    required this.id,
    required this.incidentCode,
    required this.title,
    required this.severityLabel,
    required this.statusLabel,
    required this.incidentTypeLabel,
    required this.detectedAtLabel,
    required this.analystLabel,
    required this.severityColor,
    required this.statusColor,
    required this.typeColor,
    required this.analystColor,
    required this.rawIncident,
  });

  static const Color dateColor = Color(0xFF475467);
  static const Color defaultAnalystColor = Color(0xFF155EEF);
  static const Color defaultTypeColor = Color(0xFF6941C6);

  final String id;
  final String incidentCode;
  final String title;
  final String severityLabel;
  final String statusLabel;
  final String incidentTypeLabel;
  final String detectedAtLabel;
  final String analystLabel;
  final Color severityColor;
  final Color statusColor;
  final Color typeColor;
  final Color analystColor;
  final Incident rawIncident;

  factory _IncidentCardData.fromIncident(Incident incident) {
    final severityText = incident.severity;
    final statusText = incident.status;
    return _IncidentCardData(
      id: incident.id,
      incidentCode: incident.incidentCode,
      title: incident.title,
      severityLabel: 'Tingkat Keparahan: $severityText',
      incidentTypeLabel: 'Tipe Insiden: ${incident.incidentType}',
      statusLabel: 'Status: $statusText',
      detectedAtLabel:
          'Waktu Deteksi: ${formatIncidentDateTime(incident.incidentAt)}',
      analystLabel: 'Analis SOC: ${incident.socAnalyst}',
      severityColor: _severityColor(severityText),
      statusColor: _statusColor(statusText),
      typeColor: defaultTypeColor,
      analystColor: defaultAnalystColor,
      rawIncident: incident,
    );
  }

  static Color _severityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return const Color(0xFFB42318);
      case 'medium':
        return const Color(0xFFB54708);
      default:
        return const Color(0xFF027A48);
    }
  }

  static Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'closed':
        return const Color(0xFF175CD3);
      default:
        return const Color(0xFF7A2E0E);
    }
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Color(0xFFB42318)),
            const SizedBox(height: 12),
            const Text(
              'Gagal memuat data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF667085)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                onRetry();
              },
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDarkMode
        ? Color.lerp(color, Colors.white, 0.1)!.withValues(alpha: 0.22)
        : color.withValues(alpha: 0.12);
    final textColor =
        isDarkMode ? Color.lerp(color, Colors.white, 0.45)! : color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.security_outlined, size: 48, color: Color(0xFF98A2B3)),
            SizedBox(height: 12),
            Text(
              'Belum ada incident',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 6),
            Text(
              'Tekan tombol Tambah untuk membuat catatan insiden baru.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF667085)),
            ),
          ],
        ),
      ),
    );
  }
}
