import 'package:service_repository/service_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../class/bloc_events_class.dart';
import '../../../../../components/estetica_appbar.dart';
import '../bloc/service_page_bloc.dart';

class CreateUpdateServicesScreen extends StatelessWidget {
  final ServiceModel? service;
  final ServicePageBloc bloc;

  const CreateUpdateServicesScreen({Key? key, this.service, required this.bloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: service?.name ?? '');
    final TextEditingController descriptionController =
        TextEditingController(text: service?.description ?? '');
    final TextEditingController priceController =
        TextEditingController(text: service?.price.toString() ?? '');

    return BlocProvider.value(
      value: bloc,
      child: FormularioService(
          nameController: nameController,
          descriptionController: descriptionController,
          priceController: priceController,
          service: service),
    );
  }
}

class FormularioService extends StatelessWidget {
  const FormularioService({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.priceController,
    required this.service,
  });

  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final ServiceModel? service;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: CustomScrollView(
        slivers: [
          esteticaBar(
              titulo: 'Estetica Beatriz',
              leadingActive: true,
              actionsActive: false,
              ticketActive: false,
              context: context),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (service != null) {
                          context.read<ServicePageBloc>().add(
                                Event(
                                  ServicePageEventsType.updateService,
                                  data: ServiceModel(
                                    serviceId: service!.serviceId,
                                    name: nameController.text,
                                    description: descriptionController.text,
                                    price: priceController.text,
                                  ),
                                ),
                              );
                        } else {
                          context.read<ServicePageBloc>().add(
                                Event(
                                  ServicePageEventsType.addService,
                                  data: ServiceModel(
                                    serviceId: FirebaseServiceRepo()
                                        .servicesCollection
                                        .doc()
                                        .id,
                                    name: nameController.text,
                                    description: descriptionController.text,
                                    price: priceController.text,
                                  ),
                                ),
                              );
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text(
                          service != null ? 'Update Service' : 'Add Service'),
                    ),
                  ],
                ),
              )
            ]),
          )
        ],
      ),
    ));
  }
}
