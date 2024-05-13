import 'package:estetica_app/src/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../../class/bloc_events_class.dart';
import '../../../resources/colors.dart';
import '../blocs/home_bloc.dart';

class EsteticaBottomNavBar extends StatelessWidget {
  const EsteticaBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final int index = context.select((HomeBloc bloc) => bloc.state.data ?? 0);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.colorWhite,
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
          tabBackgroundColor: AppColors.primaryColor,
          tabs: const [
            GButton(
              icon: Icons.bubble_chart_rounded,
              iconColor: AppColors.primaryColor,
              iconActiveColor: AppColors.colorWhite,
              textColor: AppColors.colorWhite,
              text: AppStrings.products,
            ),
            GButton(
              icon: Icons.airline_seat_flat_rounded,
              iconColor: AppColors.primaryColor,
              iconActiveColor: AppColors.colorWhite,
              textColor: AppColors.colorWhite,
              text: AppStrings.services,
            ),
            GButton(
              icon: Icons.account_circle_rounded,
              iconColor: AppColors.primaryColor,
              iconActiveColor: AppColors.colorWhite,
              textColor: AppColors.colorWhite,
              text: AppStrings.clients,
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
