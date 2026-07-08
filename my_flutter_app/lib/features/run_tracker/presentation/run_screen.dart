import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'run_state_controller.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';
import 'map_widget.dart';

class RunScreen extends StatelessWidget {
  const RunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RunStateController>();
    final mode = controller.activeMode;
    final accentColor = AppTheme.getAccentColor(mode);
    final isRaid = mode == 'RAID';

    return Scaffold(
      body: Stack(
        children: [
          // 1. Map Display Area (fills background)
          const Positioned.fill(
            child: MapWidget(),
          ),

          // Gradient Overlay to darken map top and bottom for readability
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      isRaid ? Colors.black.withOpacity(0.8) : Colors.black.withOpacity(0.2),
                      Colors.transparent,
                      Colors.transparent,
                      isRaid ? Colors.black.withOpacity(0.9) : Colors.black.withOpacity(0.25),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.25, 0.75, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // 2. Top Stats Board
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: AppTheme.getCardDecoration(mode),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        context,
                        label: 'DISTANCE',
                        value: '${(controller.totalDistanceMeters / 1000.0).toStringAsFixed(2)} km',
                        mode: mode,
                      ),
                      _buildStatItem(
                        context,
                        label: 'TIME',
                        value: _formatTime(controller.durationSeconds),
                        mode: mode,
                      ),
                      _buildStatItem(
                        context,
                        label: 'CALORIES',
                        value: '${((controller.totalDistanceMeters / 1000.0) * 60).toStringAsFixed(0)} kcal',
                        mode: mode,
                      ),
                      _buildStatItem(
                        context,
                        label: 'SPEED',
                        value: '${(controller.currentSpeed * 3.6).toStringAsFixed(1)} km/h',
                        mode: mode,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 3. Mode Indicator Tag
          Positioned(
            top: MediaQuery.of(context).padding.top + 115,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isRaid ? AppColors.raidBg : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: accentColor.withOpacity(0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: accentColor,
                            blurRadius: 4,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isRaid ? 'RAID MODE ACTIVE' : 'NORMAL MODE ACTIVE',
                      style: TextStyle(
                        color: AppTheme.getTextColor(mode),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4. Controls Layout at Bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Category Selector Bar (Horizontal selector overlay)
                if (!controller.isTracking)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: ['Run', 'Cycle', 'Walk', 'More'].map((cat) {
                        final isSelected = controller.selectedCategory == cat;
                        return GestureDetector(
                          onTap: () => controller.setCategory(cat),
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? accentColor
                                  : (isRaid ? const Color(0xFF1E1E1E) : Colors.white.withOpacity(0.8)),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : (isRaid ? Colors.grey.shade800 : Colors.grey.shade300),
                              ),
                            ),
                            child: Text(
                              cat,
                              style: TextStyle(
                                color: isSelected
                                    ? (isRaid ? Colors.black : Colors.white)
                                    : AppTheme.getTextColor(mode),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                // Main Buttons overlay
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Music control button
                      _buildIconButton(
                        icon: Icons.music_note,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Music controller coming soon!')),
                          );
                        },
                        mode: mode,
                      ),

                      // Central Start / Pause / Stop Button
                      _buildActionControls(context, controller, mode, accentColor),

                      // Settings button
                      _buildIconButton(
                        icon: Icons.settings,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Settings panel coming soon!')),
                          );
                        },
                        mode: mode,
                      ),
                    ],
                  ),
                ),

                // 5. Persistent Bottom Navigation Bar
                Container(
                  decoration: AppTheme.getBottomBarDecoration(mode),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(
                          icon: Icons.directions_run,
                          label: 'Activity',
                          isActive: true,
                          mode: mode,
                        ),
                        _buildNavItem(
                          icon: Icons.leaderboard,
                          label: 'Leaderboard',
                          isActive: false,
                          mode: mode,
                        ),
                        _buildNavItem(
                          icon: Icons.person,
                          label: 'Profile',
                          isActive: false,
                          mode: mode,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build individual statistic display cell
  Widget _buildStatItem(BuildContext context,
      {required String label, required String value, required String mode}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: mode == 'RAID' ? Colors.grey.shade500 : Colors.grey.shade600,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: AppTheme.getTextColor(mode),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Custom visual buttons on sides
  Widget _buildIconButton({required IconData icon, required VoidCallback onPressed, required String mode}) {
    final isRaid = mode == 'RAID';
    return Container(
      decoration: BoxDecoration(
        color: isRaid ? const Color(0xFF121212) : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: isRaid ? AppColors.raidAccent.withOpacity(0.3) : Colors.grey.shade300,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
          )
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: AppTheme.getTextColor(mode)),
        onPressed: onPressed,
      ),
    );
  }

  // Action controls for starting, pausing, and resuming workouts
  Widget _buildActionControls(BuildContext context, RunStateController controller, String mode, Color accentColor) {
    if (!controller.isTracking && controller.runPoints.isEmpty) {
      // Not tracking yet: Show Start Button (long press to toggle mode)
      return GestureDetector(
        onLongPress: () {
          controller.toggleMode();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Switched to ${controller.activeMode} MODE'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
            foregroundColor: mode == 'RAID' ? Colors.black : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 8,
            shadowColor: accentColor.withOpacity(0.4),
          ),
          onPressed: () => controller.startRun(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'START RUN',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
              const SizedBox(height: 2),
              Text(
                'Hold to switch mode',
                style: TextStyle(
                  fontSize: 9,
                  color: (mode == 'RAID' ? Colors.black54 : Colors.white70),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Tracking is active: Show Pause/Resume & Finish Buttons
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!controller.isTracking) ...[
            // Resume Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: mode == 'RAID' ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () => controller.resumeRun(),
              child: const Text('RESUME', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 16),
            // Finish Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () => controller.finishRun(),
              child: const Text('FINISH', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ] else ...[
            // Pause Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () => controller.pauseRun(),
              child: const Text('PAUSE', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ]
        ],
      );
    }
  }

  // Navigation Items builder
  Widget _buildNavItem({required IconData icon, required String label, required bool isActive, required String mode}) {
    final activeColor = AppTheme.getAccentColor(mode);
    final defaultColor = mode == 'RAID' ? Colors.grey.shade700 : Colors.grey.shade500;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? activeColor : defaultColor,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? activeColor : defaultColor,
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  // Format second counts to minutes and seconds
  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
