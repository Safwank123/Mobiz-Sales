import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_detail_unit.dart';
import '../../../../core/helper/injection_container.dart' as di;
import '../../../../core/common_widgets/custom_image_widget.dart';
import '../../../../config/colors/app_colors.dart';
import '../../../../config/typography/app_typography.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<ProductBloc>()..add(FetchProductDetail(product.id)),
      child: Scaffold(
        backgroundColor: AppColors.kAppBackground,
        appBar: AppBar(
          backgroundColor: AppColors.kAppBackground,
          elevation: 0,
          leading: const BackButton(color: AppColors.kAppOnSurface),
          title: Text(
            'Product Detail',
            style: AppTypography.style20Bold.copyWith(color: AppColors.kAppOnSurface),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          color: AppColors.kAppInputBackground,
                          child: CustomImageWidget(
                            imageUrl: product.imageUrl.isNotEmpty ? product.imageUrl : 'assets/placeholder.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      product.name,
                      style: AppTypography.style24Bold.copyWith(color: AppColors.kAppOnSurface),
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      leading: const Icon(Icons.qr_code, color: AppColors.kAppPrimary),
                      title: Text('Product ID', style: AppTypography.style14Regular.copyWith(color: AppColors.kAppTextSecondary)),
                      subtitle: Text(
                        product.id,
                        style: AppTypography.style16SemiBold.copyWith(color: AppColors.kAppOnSurface),
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Available Units',
                style: AppTypography.style20Bold.copyWith(color: AppColors.kAppOnSurface),
              ),
              const SizedBox(height: 16),
              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  final isLoading = state is ProductDetailLoading;
                  
                  if (state is ProductError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: AppTypography.style16Regular.copyWith(color: AppColors.kAppError),
                      ),
                    );
                  }
                  
                  final units = isLoading
                      ? List.generate(3, (index) => const ProductDetailUnit(id: 0, productId: 0, unitId: 0, unitName: 'Placeholder', qty: 10.0, price: 99.99))
                      : (state is ProductDetailLoaded ? state.units : <ProductDetailUnit>[]);
                  
                  if (!isLoading && units.isEmpty) {
                    return Text(
                      'No units available.',
                      style: AppTypography.style16Regular.copyWith(color: AppColors.kAppTextSecondary),
                    );
                  }
                  
                  return Skeletonizer(
                    enabled: isLoading,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: units.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final unit = units[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.kAppWhite,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.kAppBorder),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.kAppBlack.withValues(alpha: 0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.kAppInputBackground,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.inventory_2_outlined, color: AppColors.kAppPrimary),
                            ),
                            title: Text(
                              unit.unitName,
                              style: AppTypography.style16SemiBold.copyWith(color: AppColors.kAppOnSurface),
                            ),
                            subtitle: Text(
                              'Qty: ${unit.qty.toStringAsFixed(1)}',
                              style: AppTypography.style14Regular.copyWith(color: AppColors.kAppTextSecondary),
                            ),
                            trailing: Text(
                              '\$${unit.price.toStringAsFixed(2)}',
                              style: AppTypography.style18Bold.copyWith(color: AppColors.kAppPrimary),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
