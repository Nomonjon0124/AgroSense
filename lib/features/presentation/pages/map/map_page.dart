part of 'map_part.dart';

/// Xarita sahifasi - Figma dizayniga mos
class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MapBloc>()..add(const LoadMap()),
      child: const MapView(),
    );
  }
}

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with MapMixin{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MapBloc, MapState>(
        listener: (context, state) {
          if (!_isMapReady) return;

          // Joylashuv o'zgarganda xaritani harakatlantirish
          if (state is MapDataLoading && state.progress >= 50) {
            _mapController.move(state.mapCenter, 15);
          } else if (state is MapLoaded) {
            _mapController.move(state.data.mapCenter, 15);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              /// Xarita - DOIM ko'rsatiladi
              _buildMap(context, state),

              /// Loading Overlay
              if (state is MapDataLoading)
                LoadingOverlay(
                  progress: state.progress,
                  message: state.loadingMessage,
                ),

              /// Error overlay (xarita hali ko'rsatilgan holda)
              if (state is MapError && state.mapCenter != null)
                ErrorOverlay(
                  message: state.message,
                  onRetry: () {
                    context.read<MapBloc>().add(const LoadMap());
                  },
                ),

              /// Offline Status Badge (faqat yuklanganda)
              if (state is MapLoaded)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: OfflineStatusBadge(
                      isOnline: state.data.isOnline,
                      cachedTimeAgo: state.data.cachedTimeAgo,
                    ),
                  ),
                ),

              /// Control Buttons (faqat yuklanganda)
              if (state is MapLoaded)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 80,
                  right: 16,
                  child: Column(
                    children: [
                      MapControlButton(
                        icon: Icons.layers_outlined,
                        onTap: () {},
                      ),
                      const Gap(8),
                      MapControlButton(
                        icon: Icons.my_location,
                        onTap: () {
                          context.read<MapBloc>().add(
                            const GoToCurrentLocation(),
                          );
                        },
                      ),
                      const Gap(8),
                      MapControlButton(
                        icon: Icons.refresh,
                        isActive: true,
                        onTap: () {
                          context.read<MapBloc>().add(const RefreshMap());
                        },
                      ),
                    ],
                  ),
                ),

              /// Tanlangan dala bottom sheet
              if (state is MapLoaded && state.data.selectedField != null)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: FieldInfoSheet(
                    field: state.data.selectedField!,
                    onClose: () {
                      context.read<MapBloc>().add(const DeselectField());
                    },
                    onViewAnalysis: () {},
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

