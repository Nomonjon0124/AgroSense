import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../bloc/dashboard/dashboard_bloc.dart';
import '../../bloc/dashboard/dashboard_event.dart';
import '../../bloc/dashboard/dashboard_state.dart';
import 'widgets/weather_card.dart';
import 'widgets/forecast_section.dart';
import 'widgets/field_status_section.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/dashboard_loading.dart';
import 'widgets/dashboard_error.dart';

part 'dashboard_page.dart';
part 'mixin/dashboard_mixin.dart';