import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/helper/injection_container.dart' as di;
import '../../../../core/utils/app_prompts.dart';

import '../../../customer/presentation/bloc/customer_bloc.dart';
import '../../../customer/presentation/bloc/customer_event.dart';
import '../../../customer/presentation/bloc/customer_state.dart';
import '../../../customer/domain/entities/customer.dart';

import '../../../product/presentation/bloc/product_bloc.dart';
import '../../../product/presentation/bloc/product_event.dart';
import '../../../product/presentation/bloc/product_state.dart';
import '../../../product/domain/entities/product.dart';

import '../bloc/invoice_bloc.dart';
import '../bloc/invoice_event.dart';
import '../bloc/invoice_state.dart';
import '../../../../config/colors/app_colors.dart';
import '../../../../config/typography/app_typography.dart';

class CartItem {
  final Product product;
  final int quantity;
  final double mrp;

  CartItem({required this.product, required this.quantity, required this.mrp});
  
  double get total => quantity * mrp;
}

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  Customer? _selectedCustomer;
  Product? _selectedProduct;
  final TextEditingController _quantityController = TextEditingController(text: '1');
  
  final List<CartItem> _cart = [];
  final double _discount = 0.0;

  double get _subtotal => _cart.fold(0.0, (sum, item) => sum + item.total);
  double get _grandTotal => _subtotal - _discount;

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _addToCart() {
    if (_selectedProduct == null) {
      AppPrompts.showError(message: 'Please select a product');
      return;
    }
    
    final qty = int.tryParse(_quantityController.text) ?? 1;
    if (qty <= 0) {
      AppPrompts.showError(message: 'Quantity must be greater than 0');
      return;
    }

    setState(() {
      _cart.add(CartItem(
        product: _selectedProduct!,
        quantity: qty,
        mrp: _selectedProduct!.price, 
      ));
      _selectedProduct = null;
      _quantityController.text = '1';
    });
  }

  void _submitInvoice(BuildContext context) {
    if (_selectedCustomer == null) {
      AppPrompts.showError(message: 'Please select a customer');
      return;
    }
    if (_cart.isEmpty) {
      AppPrompts.showError(message: 'Cart is empty');
      return;
    }

    final invoiceData = {
      "customer_id": int.tryParse(_selectedCustomer!.id) ?? 0,
      "store_id": 112,
      "user_id": 150,
      "van_id": 0,
      "save_mode": "normal",
      "order_type": 1,
      "discount": _discount,
      "total": _subtotal,
      "total_tax": 0,
      "grand_total": _grandTotal,
      "round_off": 0,
      "if_vat": 0,
      "remarks": "Created via Mobiz Sales App",
      "item_id": _cart.map((e) => int.tryParse(e.product.id) ?? 0).toList(),
      "quantity": _cart.map((e) => e.quantity).toList(),
      "mrp": _cart.map((e) => e.mrp).toList(),
      "product_type": _cart.map((e) => 1).toList(),
      "unit": _cart.map((e) => 1530).toList(), 
    };

    context.read<InvoiceBloc>().add(CreateInvoice(invoiceData));
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppTypography.style14Regular.copyWith(color: AppColors.kAppTextSecondary),
      filled: true,
      fillColor: AppColors.kAppInputBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<CustomerBloc>()..add(const FetchCustomers(routeId: '84', storeId: '112'))),
        BlocProvider(create: (_) => di.sl<ProductBloc>()..add(const FetchProducts(storeId: '112'))),
        BlocProvider(create: (_) => di.sl<InvoiceBloc>()),
      ],
      child: BlocConsumer<InvoiceBloc, InvoiceState>(
        listener: (context, state) {
          if (state is InvoiceCreated) {
            AppPrompts.showSuccess(message: 'Invoice created successfully!');
            context.pop(true);
          } else if (state is InvoiceError) {
            AppPrompts.showError(message: state.message);
          }
        },
        builder: (context, invoiceState) {
          return Scaffold(
            backgroundColor: AppColors.kAppBackground,
            appBar: AppBar(
              backgroundColor: AppColors.kAppBackground,
              elevation: 0,
              leading: const BackButton(color: AppColors.kAppOnSurface),
              title: Text(
                'Create Invoice',
                style: AppTypography.style20Bold.copyWith(color: AppColors.kAppOnSurface),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.kAppWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.kAppBorder),
                    ),
                    child: Column(
                      children: [
                        BlocBuilder<CustomerBloc, CustomerState>(
                          builder: (context, state) {
                            if (state is CustomerLoading) return const Center(child: CircularProgressIndicator(color: AppColors.kAppPrimary));
                            if (state is CustomerLoaded) {
                              return DropdownButtonFormField<Customer>(
                                decoration: _inputDecoration('Select Customer'),
                                initialValue: _selectedCustomer,
                                icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.kAppTextSecondary),
                                items: state.customers.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                                onChanged: (val) => setState(() => _selectedCustomer = val),
                              );
                            }
                            return Text('Failed to load customers', style: AppTypography.style14Regular.copyWith(color: AppColors.kAppError));
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: BlocBuilder<ProductBloc, ProductState>(
                                builder: (context, state) {
                                  if (state is ProductLoading) return const Center(child: CircularProgressIndicator(color: AppColors.kAppPrimary));
                                  if (state is ProductLoaded) {
                                    return DropdownButtonFormField<Product>(
                                      decoration: _inputDecoration('Select Product'),
                                      initialValue: _selectedProduct,
                                      isExpanded: true,
                                      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.kAppTextSecondary),
                                      items: state.products.map((p) => DropdownMenuItem(value: p, child: Text(p.name, overflow: TextOverflow.ellipsis))).toList(),
                                      onChanged: (val) => setState(() => _selectedProduct = val),
                                    );
                                  }
                                  return Text('Failed to load products', style: AppTypography.style14Regular.copyWith(color: AppColors.kAppError));
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                controller: _quantityController,
                                keyboardType: TextInputType.number,
                                decoration: _inputDecoration('Qty'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 48,
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _addToCart,
                            icon: const Icon(Icons.add_shopping_cart, size: 20),
                            label: Text('Add to Cart', style: AppTypography.style14SemiBold),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.kAppInputBackground,
                              foregroundColor: AppColors.kAppPrimary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Cart Items', style: AppTypography.style18Bold.copyWith(color: AppColors.kAppOnSurface)),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _cart.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = _cart[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.kAppWhite,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.kAppBorder),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            title: Text(item.product.name, style: AppTypography.style14SemiBold.copyWith(color: AppColors.kAppOnSurface)),
                            subtitle: Text(
                              'Qty: ${item.quantity} x \$${item.mrp.toStringAsFixed(2)}',
                              style: AppTypography.style12Regular.copyWith(color: AppColors.kAppTextSecondary),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '\$${item.total.toStringAsFixed(2)}',
                                  style: AppTypography.style16Bold.copyWith(color: AppColors.kAppPrimary),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: AppColors.kAppError),
                                  onPressed: () => setState(() => _cart.removeAt(index)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.kAppWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.kAppBorder),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal:', style: AppTypography.style14Regular.copyWith(color: AppColors.kAppTextSecondary)),
                            Text('\$${_subtotal.toStringAsFixed(2)}', style: AppTypography.style16SemiBold.copyWith(color: AppColors.kAppOnSurface)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Discount:', style: AppTypography.style14Regular.copyWith(color: AppColors.kAppTextSecondary)),
                            Text('\$${_discount.toStringAsFixed(2)}', style: AppTypography.style16SemiBold.copyWith(color: AppColors.kAppOnSurface)),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(color: AppColors.kAppBorder, height: 1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Grand Total:', style: AppTypography.style16Bold.copyWith(color: AppColors.kAppOnSurface)),
                            Text('\$${_grandTotal.toStringAsFixed(2)}', style: AppTypography.style20Bold.copyWith(color: AppColors.kAppPrimary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: invoiceState is InvoiceLoading ? null : () => _submitInvoice(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kAppPrimary,
                        foregroundColor: AppColors.kAppWhite,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: invoiceState is InvoiceLoading
                          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: AppColors.kAppWhite, strokeWidth: 2))
                          : Text('Save Invoice', style: AppTypography.style16SemiBold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
