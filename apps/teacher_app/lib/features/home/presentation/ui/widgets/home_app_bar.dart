import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: 0,
      title: Text(
        'Dashboard',
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundImage: const NetworkImage(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCwbuL0ZiDMlk21d_cKtbpty8WoXWwySyGPVjGH2-e69ZAKGbiQjraud70q83qALhpx_rFdwh2p3Y0sRc3D7CbjMYdDIdu8fl6SlYiGagcEu5D-0npFOrOSepq90hGqkpXcNeTLbYFZKTO4FDfR6LNKLoRL8MpA7KNHBpbxwjEFIz-oQrL-b0O9FXdHqvKxVNgfpt_21HRS4jKHncoQBHK_lSE9FulUBsR8n6xRMgauziyWJo9exGOKF1w2Rvz_3CZYGEnBeyke2cEZ',
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 