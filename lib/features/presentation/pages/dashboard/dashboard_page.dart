part of 'dashboard_part.dart';

/// Dashboard sahifasi - Figma dizayniga mos
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DashboardBloc>()..add(const LoadDashboard()),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> with DashboardMixin{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<DashboardBloc>().add(const RefreshDashboard());
            // BLoC listener orqali yangilanishni kutish
            await Future.delayed(const Duration(seconds: 1));
          },
          color: AppColors.primary,
          child: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              // Loading holati
              if (state is DashboardLoading) {
                // Agar oldingi ma'lumot bo'lsa, uni ko'rsatish + loading indicator
                if (state.previousData != null) {
                  return _buildContent(
                    context,
                    state.previousData!,
                    isLoading: true,
                  );
                }
                return const DashboardLoadingWidget();
              }

              // Xato holati
              if (state is DashboardError) {
                // Agar oldingi ma'lumot bo'lsa, uni ko'rsatish + xato xabari
                if (state.previousData != null) {
                  return _buildContent(
                    context,
                    state.previousData!,
                    errorMessage: state.message,
                  );
                }
                return DashboardErrorWidget(
                  message: state.message,
                  onRetry: () {
                    context.read<DashboardBloc>().add(const LoadDashboard());
                  },
                );
              }

              // Muvaffaqiyatli yuklangan holat
              if (state is DashboardLoaded) {
                return _buildContent(context, state.data);
              }

              // Boshlang'ich holat
              return const DashboardLoadingWidget();
            },
          ),
        ),
      ),
    );
  }


}

