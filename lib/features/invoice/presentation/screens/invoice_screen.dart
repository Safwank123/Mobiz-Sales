import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:mobiz_sales_app/config/routes/app_routes.dart';
import '../bloc/invoice_bloc.dart';
import '../bloc/invoice_event.dart';
import '../bloc/invoice_state.dart';
import '../../domain/entities/invoice.dart';
import '../../../../core/helper/injection_container.dart' as di;
import '../../../../core/utils/app_prompts.dart';
import '../../../../config/colors/app_colors.dart';
import '../../../../config/typography/app_typography.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<InvoiceBloc>()..add(FetchInvoices()),
      child: Scaffold(
        backgroundColor: AppColors.kAppBackground,
        appBar: AppBar(
          backgroundColor: AppColors.kAppBackground,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.kAppOnSurface),
            onPressed: () => context.goNamed(RouteNames.dashboard.name),
          ),
          title: Text(
            'Invoices',
            style: AppTypography.style20Bold.copyWith(color: AppColors.kAppOnSurface),
          ),
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton.extended(
            backgroundColor: AppColors.kAppPrimary,
            foregroundColor: AppColors.kAppWhite,
            elevation: 4,
            onPressed: () {
              context.pushNamed(RouteNames.createInvoice.name).then((_) {
                if (context.mounted) {
                  context.read<InvoiceBloc>().add(FetchInvoices());
                }
              });
            },
            icon: const Icon(Icons.add),
            label: Text('Create Invoice', style: AppTypography.style14SemiBold),
          ),
        ),
        body: BlocConsumer<InvoiceBloc, InvoiceState>(
          listener: (context, state) {
            if (state is InvoiceCreated) {
              AppPrompts.showSuccess(message: 'Invoice created successfully');
            } else if (state is InvoiceError) {
              AppPrompts.showError(message: state.message);
            }
          },
          builder: (context, state) {
            final isLoading = state is InvoiceLoading;

            if (state is InvoiceError) {
              return Center(
                child: Text(
                  state.message,
                  style: AppTypography.style16Regular.copyWith(color: AppColors.kAppError),
                ),
              );
            }
            
            final invoices = isLoading
                ? List.generate(5, (index) => const Invoice(id: '0000', customerName: 'Loading Customer Name', date: '00-00-0000', totalAmount: 999.99))
                : (state is InvoiceLoaded ? state.invoices : <Invoice>[]);

            if (!isLoading && invoices.isEmpty) {
              return Center(
                child: Text(
                  'No invoices found.',
                  style: AppTypography.style16Regular.copyWith(color: AppColors.kAppTextSecondary),
                ),
              );
            }
            
            return Skeletonizer(
              enabled: isLoading,
              child: ListView.separated(
                padding: const EdgeInsets.all(24),
                itemCount: invoices.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final invoice = invoices[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.kAppWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.kAppBorder),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.kAppBlack.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          if (isLoading) return;
                          context.pushNamed(
                            RouteNames.invoiceDetail.name,
                            extra: invoice,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.kAppInputBackground,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.receipt_outlined, color: AppColors.kAppPrimary),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '#${invoice.id} - ${invoice.customerName}',
                                      style: AppTypography.style16SemiBold.copyWith(color: AppColors.kAppOnSurface),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      invoice.date,
                                      style: AppTypography.style14Regular.copyWith(color: AppColors.kAppTextSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '\$${invoice.totalAmount.toStringAsFixed(2)}',
                                style: AppTypography.style16Bold.copyWith(color: AppColors.kAppPrimary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
