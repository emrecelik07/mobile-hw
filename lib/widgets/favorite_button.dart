import 'package:flutter/material.dart';

/// Heart button that adds or removes an event from the favorites.
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onPressed,
    this.filledBackground = false,
  });

  final bool isFavorite;
  final VoidCallback onPressed;

  /// Draws a white circle behind the icon so it stays visible on images.
  final bool filledBackground;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
      style: filledBackground
          ? IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.9),
            )
          : null,
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? const Color(0xFFE53935) : null,
      ),
    );
  }
}
