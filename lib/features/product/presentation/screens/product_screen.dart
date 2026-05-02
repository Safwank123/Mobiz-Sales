import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:mobiz_sales_app/config/routes/app_routes.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../../domain/entities/product.dart';
import '../../../../core/helper/injection_container.dart' as di;
import '../../../../core/common_widgets/custom_image_widget.dart';
import '../../../../config/colors/app_colors.dart';
import '../../../../config/typography/app_typography.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          di.sl<ProductBloc>()..add(const FetchProducts(storeId: '112')),
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
            'Products',
            style: AppTypography.style20Bold.copyWith(color: AppColors.kAppOnSurface),
          ),
        ),
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            final isLoading = state is ProductLoading;
            
            if (state is ProductError) {
              return Center(
                child: Text(
                  state.message,
                  style: AppTypography.style16Regular.copyWith(color: AppColors.kAppError),
                ),
              );
            }
            
            final products = isLoading
                ? List.generate(6, (index) => const Product(id: '000', name: 'Placeholder Product Name', price: 99.99, imageUrl: ''))
                : (state is ProductLoaded ? state.products : <Product>[]);

            if (!isLoading && products.isEmpty) {
              return Center(
                child: Text(
                  'No products found.',
                  style: AppTypography.style16Regular.copyWith(color: AppColors.kAppTextSecondary),
                ),
              );
            }

            return Skeletonizer(
              enabled: isLoading,
              child: GridView.builder(
                padding: const EdgeInsets.all(24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
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
                    clipBehavior: Clip.antiAlias,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (isLoading) return;
                          context.pushNamed(
                            RouteNames.productDetail.name,
                            extra: product,
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                color: AppColors.kAppInputBackground,
                                child: CustomImageWidget(
                                  imageUrl: product.imageUrl.isNotEmpty
                                      ? product.imageUrl
                                      : 'assets/placeholder.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        product.name,
                                        style: AppTypography.style14SemiBold.copyWith(color: AppColors.kAppOnSurface),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                      style: AppTypography.style16Bold.copyWith(color: AppColors.kAppPrimary),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
