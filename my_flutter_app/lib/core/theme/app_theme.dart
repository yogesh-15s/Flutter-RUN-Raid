import 'package:flutter/material.dart';

class AppColors {
  // Normal Mode Colors
  static const Color normalAccent = Color(0xFF00E676); // Emerald Green
  static const Color normalBg = Color(0xFFF8F9FA); // Light Slate
  static const Color normalCard = Color(0xFFFFFFFF);
  static const Color normalText = Color(0xFF212529);

  // Raid Mode Colors
  static const Color raidAccent = Color(0xFFFF1744); // Flame Red / Crimson
  static const Color raidBg = Color(0xFF0A0A0A); // Pitch Black
  static const Color raidCard = Color(0xFF161616); // Carbon style
  static const Color raidText = Color(0xFFF8F9FA);
  static const Color raidGlassBorder = Color(0x33FF1744);
}

class AppTheme {
  // Get active text color
  static Color getTextColor(String mode) {
    return mode == 'RAID' ? AppColors.raidText : AppColors.normalText;
  }

  // Get active accent color
  static Color getAccentColor(String mode) {
    return mode == 'RAID' ? AppColors.raidAccent : AppColors.normalAccent;
  }

  // Get active card decoration (Raid carbon fiber/glass vs Normal white/slate)
  static BoxDecoration getCardDecoration(String mode) {
    if (mode == 'RAID') {
      return BoxDecoration(
        color: AppColors.raidCard.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.raidGlassBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.raidAccent.withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      );
    } else {
      return BoxDecoration(
        color: AppColors.normalCard.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      );
    }
  }

  // Dynamic bottom bar style
  static BoxDecoration getBottomBarDecoration(String mode) {
    if (mode == 'RAID') {
      return BoxDecoration(
        color: const Color(0xFF080808),
        border: Border(
          top: BorderSide(color: AppColors.raidAccent.withOpacity(0.3), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.raidAccent.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, -3),
          )
        ],
      );
    } else {
      return BoxDecoration(
        color: const Color(0xFFF1F3F5),
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
        ),
      );
    }
  }
}
