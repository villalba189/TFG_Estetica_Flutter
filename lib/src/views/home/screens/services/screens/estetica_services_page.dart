import 'dart:developer';

import 'package:estetica_app/src/styles/colors.dart';
import 'package:estetica_app/src/widgets/estetica_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_repository/service_repository.dart';

import '../../../../../class/bloc_events_class.dart';
import '../bloc/service_page_bloc.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<ServiceModel> services = context.read<ServicePageBloc>().services;
    return BlocBuilder<ServicePageBloc, BlocEvent>(
      builder: (context, state) {
        if (state is Loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is Failure) {
          return Center(
            child: Text(state.errorType),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: services
                .map(
                  (service) => GestureDetector(
                      onTap: () {
                        log("Servicio añadido al ticket: ${service.serviceId}");
                        context.showSnackBar(
                            message:
                                'Servicio añadido al ticket ${service.name}');
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              service.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              service.description,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              service.price.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      )),
                )
                .toList(),
          );
        }
      },
    );
  }
}
