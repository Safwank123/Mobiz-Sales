import 'package:flutter/material.dart';
import '../../domain/entities/invoice.dart';
import '../../../../config/colors/app_colors.dart';
import '../../../../config/typography/app_typography.dart';

class InvoiceDetailScreen extends StatelessWidget {
  final Invoice invoice;

  const InvoiceDetailScreen({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kAppBackground,
      appBar: AppBar(
        backgroundColor: AppColors.kAppBackground,
        elevation: 0,
        leading: const BackButton(color: AppColors.kAppOnSurface),
        title: Text(
          'Invoice Detail',
          style: AppTypography.style20Bold.copyWith(color: AppColors.kAppOnSurface),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
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
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.kAppInputBackground,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.receipt_long_outlined, size: 40, color: AppColors.kAppPrimary),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Invoice #${invoice.id}',
                style: AppTypography.style24Bold.copyWith(color: AppColors.kAppOnSurface),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                invoice.date,
                style: AppTypography.style14Regular.copyWith(color: AppColors.kAppTextSecondary),
                textAlign: TextAlign.center,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Divider(color: AppColors.kAppBorder, height: 1),
              ),
              ListTile(
                leading: const Icon(Icons.person_outline, color: AppColors.kAppPrimary),
                title: Text('Customer', style: AppTypography.style14Regular.copyWith(color: AppColors.kAppTextSecondary)),
                subtitle: Text(
                  invoice.customerName,
                  style: AppTypography.style16SemiBold.copyWith(color: AppColors.kAppOnSurface),
                ),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.kAppInputBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Amount:', style: AppTypography.style16SemiBold.copyWith(color: AppColors.kAppOnSurface)),
                    Text(
                      '\$${invoice.totalAmount.toStringAsFixed(2)}',
                      style: AppTypography.style20Bold.copyWith(color: AppColors.kAppPrimary),
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
}
