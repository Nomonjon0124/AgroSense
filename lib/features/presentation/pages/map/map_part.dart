import 'package:agro_sense/core/extensions/text_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../map/domain/entities/field_entity.dart';
import '../../bloc/map/map_bloc.dart';
import '../../bloc/map/map_event.dart';
import '../../bloc/map/map_state.dart';

part 'map_page.dart';
part 'mixin/map_mixin.dart';
part 'widgets/error_overlay.dart';
part 'widgets/filed_info_sheet.dart';
part 'widgets/loading_overlay.dart';
part 'widgets/map_control_button.dart';
part 'widgets/offline_status_badge.dart';
part 'widgets/progress_dot.dart';
part 'widgets/progress_line.dart';
part 'widgets/stat_card.dart';
part 'widgets/user_location_marker.dart';

