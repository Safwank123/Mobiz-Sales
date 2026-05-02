import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:mobiz_sales_app/config/routes/app_routes.dart';
import '../bloc/customer_bloc.dart';
import '../bloc/customer_event.dart';
import '../bloc/customer_state.dart';
import '../../domain/entities/customer.dart';
import '../../../../core/helper/injection_container.dart' as di;
import '../../../../config/colors/app_colors.dart';
import '../../../../config/typography/app_typography.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          di.sl<CustomerBloc>()
            ..add(const FetchCustomers(routeId: '84', storeId: '112')),
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
            'Customers',
            style: AppTypography.style20Bold.copyWith(
              color: AppColors.kAppOnSurface,
            ),
          ),
        ),
        body: BlocBuilder<CustomerBloc, CustomerState>(
          builder: (context, state) {
            final isLoading = state is CustomerLoading;
            
            if (state is CustomerError) {
              return Center(
                child: Text(
                  state.message,
                  style: AppTypography.style16Regular.copyWith(
                    color: AppColors.kAppError,
                  ),
                ),
              );
            }
            
            final customers = isLoading 
                ? List.generate(5, (index) => const Customer(id: '000', name: 'Placeholder Name', phone: '000-000-0000', address: 'Placeholder Address', ))
                : (state is CustomerLoaded ? state.customers : <Customer>[]);

            if (!isLoading && customers.isEmpty) {
              return Center(
                child: Text(
                  'No customers found.',
                  style: AppTypography.style16Regular.copyWith(
                    color: AppColors.kAppTextSecondary,
                  ),
                ),
              );
            }
            
            return Skeletonizer(
              enabled: isLoading,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                itemCount: customers.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final customer = customers[index];
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
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          if (isLoading) return;
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: AppColors.kAppWhite,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                            ),
                            builder: (context) => Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: AppColors.kAppInputBackground,
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '',
                                        style: AppTypography.style28Bold
                                            .copyWith(
                                              color: AppColors.kAppPrimary,
                                            ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Center(
                                    child: Text(
                                      customer.name,
                                      style: AppTypography.style24Bold.copyWith(
                                        color: AppColors.kAppOnSurface,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Center(
                                    child: Text(
                                      'Customer ID: ${customer.id}',
                                      style: AppTypography.style14Regular
                                          .copyWith(
                                            color: AppColors.kAppTextSecondary,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.phone_outlined,
                                      color: AppColors.kAppPrimary,
                                    ),
                                    title: Text(
                                      'Contact Number',
                                      style: AppTypography.style14Regular
                                          .copyWith(
                                            color: AppColors.kAppTextSecondary,
                                          ),
                                    ),
                                    subtitle: Text(
                                      customer.phone.isNotEmpty
                                          ? customer.phone
                                          : 'Not Available',
                                      style: AppTypography.style16SemiBold
                                          .copyWith(
                                            color: AppColors.kAppOnSurface,
                                          ),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  const Divider(
                                    color: AppColors.kAppBorder,
                                    height: 24,
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.location_on_outlined,
                                      color: AppColors.kAppPrimary,
                                    ),
                                    title: Text(
                                      'Address',
                                      style: AppTypography.style14Regular
                                          .copyWith(
                                            color: AppColors.kAppTextSecondary,
                                          ),
                                    ),
                                    subtitle: Text(
                                      customer.address.isNotEmpty
                                          ? customer.address
                                          : 'Not Available',
                                      style: AppTypography.style16SemiBold
                                          .copyWith(
                                            color: AppColors.kAppOnSurface,
                                          ),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: AppColors.kAppInputBackground,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.person_outline,
                                  color: AppColors.kAppPrimary,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      customer.name,
                                      style: AppTypography.style16SemiBold
                                          .copyWith(
                                            color: AppColors.kAppOnSurface,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      customer.phone.isNotEmpty
                                          ? customer.phone
                                          : 'No Phone',
                                      style: AppTypography.style14Regular
                                          .copyWith(
                                            color: AppColors.kAppTextSecondary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: AppColors.kAppTextSecondary,
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
