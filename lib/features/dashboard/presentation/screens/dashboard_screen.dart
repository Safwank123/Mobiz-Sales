import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../config/local/local_storage_services.dart';
import '../../../../config/colors/app_colors.dart';
import '../../../../config/typography/app_typography.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kAppBackground,
      appBar: AppBar(
        title: Text(
          'Mobiz Sales Dashboard' ,
          style: AppTypography.style20Bold.copyWith(
            color: AppColors.kAppOnSurface,
          ),
        ),
        backgroundColor: AppColors.kAppBackground,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.kAppError),
            onPressed: () async {
              await LocalStorageServices.clearAll();
              if (context.mounted) {
                context.goNamed(RouteNames.login.name);
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Overview',
                style: AppTypography.style24Bold.copyWith(
                  color: AppColors.kAppOnSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Manage your store efficiently',
                style: AppTypography.style16Regular.copyWith(
                  color: AppColors.kAppTextSecondary,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: [
                    _buildCard(context, 'Customers', Icons.people_outline, () {
                      context.goNamed(RouteNames.customers.name);
                    }),
                    _buildCard(
                      context,
                      'Products',
                      Icons.inventory_2_outlined,
                      () {
                        context.goNamed(RouteNames.products.name);
                      },
                    ),
                    _buildCard(
                      context,
                      'Invoices',
                      Icons.receipt_long_outlined,
                      () {
                        context.goNamed(RouteNames.invoices.name);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kAppWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.kAppBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.kAppBlack.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.kAppInputBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 36, color: AppColors.kAppPrimary),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: AppTypography.style16SemiBold.copyWith(
                    color: AppColors.kAppOnSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
