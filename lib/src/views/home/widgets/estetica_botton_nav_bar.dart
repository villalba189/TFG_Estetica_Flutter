import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../../class/bloc_events_class.dart';
import '../../../styles/colors.dart';
import '../blocs/home_bloc.dart';
import '../enums/home_events_type.dart';

class EsteticaBottomNavBar extends StatelessWidget {
  const EsteticaBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final int index = context.select((HomeBloc bloc) => bloc.state.data ?? 0);
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.colorWhite,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            blurRadius: 30,
            color: Colors.black.withOpacity(0.4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GNav(
          gap: 8,
          iconSize: 24,
          hoverColor: Colors.grey,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          tabBackgroundColor: AppColors.primaryColorBold,
          tabs: const [
            GButton(
              icon: Icons.bubble_chart_rounded,
              iconColor: AppColors.primaryColorBold,
              iconActiveColor: AppColors.colorWhite,
              textColor: AppColors.colorWhite,
              text: 'Productos',
            ),
            GButton(
              icon: Icons.airline_seat_flat_rounded,
              iconColor: AppColors.primaryColorBold,
              iconActiveColor: AppColors.colorWhite,
              textColor: AppColors.colorWhite,
              text: 'Servicios',
            ),
            GButton(
              icon: Icons.account_circle_rounded,
              iconColor: AppColors.primaryColorBold,
              iconActiveColor: AppColors.colorWhite,
              textColor: AppColors.colorWhite,
              text: 'Clientes',
            ),
          ],
          selectedIndex: index,
          onTabChange: (index) {
            context
                .read<HomeBloc>()
                .add(Event(HomeEventsType.selectedIndex, data: index));
          },
        ),
      ),
    );
  }
}
