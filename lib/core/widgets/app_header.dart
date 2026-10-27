import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../routes/app_routes.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBack;
  final VoidCallback? onBack;
  final bool showNotifications;
  final bool showProfileAvatar;

  const AppHeader({
    super.key,
    this.title,
    this.showBack = false,
    this.onBack,
    this.showNotifications = true,
    this.showProfileAvatar = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16,
        right: 16,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceMuted,
        border: Border(
          bottom: BorderSide(color: AppColors.borderGray, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Back button OR Doctor Avatar
          if (showBack)
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: AppColors.textPrimary,
              ),
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            )
          else if (showProfileAvatar)
            GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.doctorProfile),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.purpleSurface,
                  border: Border.all(color: AppColors.purpleBorder, width: 1.5),
                ),
                child: const Center(
                  child: Icon(
                    Icons.person,
                    color: AppColors.primaryPurple,
                    size: 22,
                  ),
                ),
              ),
            )
          else
            const SizedBox(width: 40),

          // Center: Title or CareID Brand Logo
          if (title != null)
            Expanded(
              child: Text(
                title!,
                style: AppTypography.cardTitle.copyWith(fontSize: 18),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.primaryGradient.createShader(bounds),
                  child: Text(
                    'CARE',
                    style: AppTypography.screenTitle.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.tealButton,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'iD',
                    style: AppTypography.badgeSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.purpleSurface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'DOCTOR',
                    style: AppTypography.badgeSmall.copyWith(
                      color: AppColors.primaryPurple,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),

          // Right: Notification Bell with Red Badge OR Action Slot
          if (showNotifications)
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    size: 24,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.notificationCenter,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.criticalRed,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.surfaceMuted,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            const SizedBox(width: 40),
        ],
      ),
    );
  }
}
