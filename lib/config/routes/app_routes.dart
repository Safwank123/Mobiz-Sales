import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/customer/presentation/screens/customer_screen.dart';
import '../../features/product/presentation/screens/product_screen.dart';
import '../../features/product/presentation/screens/product_detail_screen.dart';
import '../../features/invoice/presentation/screens/invoice_screen.dart';
import '../../features/invoice/presentation/screens/invoice_detail_screen.dart';
import '../../features/invoice/presentation/screens/create_invoice_screen.dart';
import '../local/local_storage_services.dart';

enum RouteNames {
  login,
  dashboard,
  customers,
  products,
  productDetail,
  invoices,
  invoiceDetail,
  createInvoice,
}

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = LocalStorageServices.getToken() != null;
      final isLoggingIn = state.uri.toString() == '/login';

      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/dashboard';

      return null;
    },
    routes: [
      GoRoute(
        name: RouteNames.login.name,
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: RouteNames.dashboard.name,
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        name: RouteNames.customers.name,
        path: '/customers',
        builder: (context, state) => const CustomerScreen(),
      ),
      GoRoute(
        name: RouteNames.products.name,
        path: '/products',
        builder: (context, state) => const ProductScreen(),
      ),
      GoRoute(
        name: RouteNames.productDetail.name,
        path: '/product_detail',
        builder: (context, state) {
          return ProductDetailScreen(
            product: state.extra as dynamic,
          );
        },
      ),
      GoRoute(
        name: RouteNames.invoices.name,
        path: '/invoices',
        builder: (context, state) => const InvoiceScreen(),
      ),
      GoRoute(
        name: RouteNames.invoiceDetail.name,
        path: '/invoice_detail',
        builder: (context, state) => InvoiceDetailScreen(
          invoice: state.extra as dynamic,
        ),
      ),
      GoRoute(
        name: RouteNames.createInvoice.name,
        path: '/create_invoice',
        builder: (context, state) => const CreateInvoiceScreen(),
      ),
    ],
  );
}
