// lib/shared/widgets/error_widget.dart

import 'package:flutter/material.dart';

/// Widget untuk menampilkan pesan error dengan tombol retry
class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ikon satelit rusak — lebih relevan dengan tema planet/antariksa
            Icon(
              Icons.satellite_alt_outlined,
              size: 72,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Sinyal Terputus',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Hubungkan Ulang'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}