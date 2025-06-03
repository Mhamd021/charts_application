import 'package:charts_application/controllers/favorite_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModernFavoriteButton extends StatelessWidget {
  final int medicalCenterId;
  final Function() onToggle;
  final double size;

  const ModernFavoriteButton({
    super.key,
    required this.medicalCenterId,
    required this.onToggle,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    final FavoriteController controller = Get.find();
    
    return Obx(() {
      final isFavorite = controller.isFavorite.value;
      final isLoading = controller.isLoading.value;

      return GestureDetector(
        onTap: isLoading ? null : onToggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: isFavorite
                ? const LinearGradient(
                    colors: [Color(0xFFFF5374), Color(0xFFFF7B45)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isFavorite ? null : Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
            border: Border.all(
              color: isFavorite ? Colors.transparent : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isLoading
                    ? const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      )
                    : Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.white : Colors.grey.shade600,
                        size: size * 0.6,
                      ),
              ),
              if (!isLoading)
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(size),
                      onTap: isLoading ? null : onToggle,
                      splashColor: const Color(0xFFFF5374).withOpacity(0.2),
                      highlightColor: const Color(0xFFFF7B45).withOpacity(0.1),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}