import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_repository/service_repository.dart';

import '../../../../../class/bloc_events_class.dart';
import '../../../../../components/estetica_appbar.dart';
import '../../../../../widgets/estetica_button.dart';
import '../../../../../widgets/estetica_text_form_field.dart';
import '../../../blocs/image_picker_cubit.dart';
import '../../../components/image_picker_widget.dart';
import '../bloc/service_page_bloc.dart';

class CreateUpdateServicesScreen extends StatelessWidget {
  final ServiceModel? service;
  final ServicePageBloc bloc;
  final ImagePickerCubit cubit;

  const CreateUpdateServicesScreen(
      {Key? key, this.service, required this.bloc, required this.cubit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    cubit.removeImage();
    final TextEditingController nameController =
        TextEditingController(text: service?.name ?? '');
    final TextEditingController descriptionController =
        TextEditingController(text: service?.description ?? '');
    final TextEditingController priceController =
        TextEditingController(text: service?.price?.toStringAsFixed(2) ?? '');

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: bloc),
        BlocProvider.value(value: cubit),
      ],
      child: FormularioService(
        nameController: nameController,
        descriptionController: descriptionController,
        priceController: priceController,
        service: service,
      ),
    );
  }
}

class FormularioService extends StatelessWidget {
  const FormularioService({
    Key? key,
    required this.nameController,
    required this.descriptionController,
    required this.priceController,
    required this.service,
  }) : super(key: key);

  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final ServiceModel? service;

  @override
  Widget build(BuildContext context) {
    final ServicePageBloc read = context.read<ServicePageBloc>();
    bool nameErrorVisible =
        context.select((ServicePageBloc bloc) => bloc.nameErrorVisible);
    bool descriptionErrorVisible =
        context.select((ServicePageBloc bloc) => bloc.descriptionErrorVisible);
    bool priceErrorVisible =
        context.select((ServicePageBloc bloc) => bloc.priceErrorVisible);
    String nameError = context.select((ServicePageBloc bloc) => bloc.nameError);
    String descriptionError =
        context.select((ServicePageBloc bloc) => bloc.descriptionError);
    String priceError =
        context.select((ServicePageBloc bloc) => bloc.priceError);

    String image =
        context.select((ImagePickerCubit cubit) => cubit.imageFile?.path ?? '');

    BlocEvent state = context.select((ServicePageBloc bloc) => bloc.state);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            esteticaBar(
              titulo: 'Estetica Beatriz',
              leadingActive: true,
              actionsActive: false,
              ticketActive: false,
              context: context,
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      SizedBox(height: 24),
                      ImagePickerWidget(
                        onImageSelected: (_image) {
                          context.read<ImagePickerCubit>().setImageFile(_image);
                        },
                        imagePath: (image == '' ? service?.image : image) ?? '',
                      ),
                      SizedBox(height: 24),
                      EsteticaTextFormField(
                        model: EsteticaTextFormFieldModel(
                          type: EsteticaTextFormFieldType.text,
                          controller: nameController,
                          labelText: 'Name',
                          hintText: 'Enter your name',
                          errorText: nameErrorVisible ? nameError : null,
                        ),
                        onChanged: (value) {
                          read.add(Event(
                            ServicePageErrorsType.serviceNameNoValido,
                            data: value,
                          ));
                        },
                      ),
                      SizedBox(height: 24),
                      EsteticaTextFormField(
                        model: EsteticaTextFormFieldModel(
                          type: EsteticaTextFormFieldType.text,
                          controller: descriptionController,
                          labelText: 'Description',
                          hintText: 'Enter your description',
                          errorText:
                              descriptionErrorVisible ? descriptionError : null,
                        ),
                        onChanged: (value) {
                          read.add(Event(
                            ServicePageErrorsType.serviceDescriptionNoValido,
                            data: value,
                          ));
                        },
                      ),
                      SizedBox(height: 24),
                      EsteticaTextFormField(
                        model: EsteticaTextFormFieldModel(
                          type: EsteticaTextFormFieldType.number,
                          controller: priceController,
                          labelText: 'Price',
                          hintText: 'Enter your price',
                          errorText: priceErrorVisible ? priceError : null,
                        ),
                        onChanged: (value) {
                          read.add(Event(
                            ServicePageErrorsType.servicePriceNoValido,
                            data: value,
                          ));
                        },
                      ),
                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: EsteticaButton(
                          model: EsteticaButtonModel(
                            text: service != null
                                ? 'Update Service'
                                : 'Add Service',
                            type: EsteticaButtonType.primary,
                            isLoading: state is Loading,
                            isEnable: nameController.text.isNotEmpty &&
                                priceController.text.isNotEmpty &&
                                !nameErrorVisible &&
                                !descriptionErrorVisible &&
                                !priceErrorVisible,
                          ),
                          onTapFunction: () {
                            context.read<ServicePageBloc>().add(
                                  Event(ServicePageEventsType.addImagenStorage,
                                      data: [
                                        service?.serviceId ??
                                            FirebaseServiceRepo()
                                                .servicesCollection
                                                .doc()
                                                .id,
                                        nameController.text,
                                        image,
                                        (_imagePath) {
                                          double price = double.parse(
                                              priceController.text);
                                          if (service != null) {
                                            context.read<ServicePageBloc>().add(
                                                  Event(
                                                    ServicePageEventsType
                                                        .updateService,
                                                    data: ServiceModel(
                                                      serviceId:
                                                          service!.serviceId,
                                                      name: nameController.text,
                                                      description:
                                                          descriptionController
                                                              .text,
                                                      price: price,
                                                      image: _imagePath == ''
                                                          ? service?.image
                                                          : _imagePath,
                                                    ),
                                                  ),
                                                );
                                          } else {
                                            context.read<ServicePageBloc>().add(
                                                  Event(
                                                    ServicePageEventsType
                                                        .addService,
                                                    data: ServiceModel(
                                                      serviceId:
                                                          FirebaseServiceRepo()
                                                              .servicesCollection
                                                              .doc()
                                                              .id,
                                                      name: nameController.text,
                                                      description:
                                                          descriptionController
                                                              .text,
                                                      price: price,
                                                      image: _imagePath == ''
                                                          ? 'https://firebasestorage.googleapis.com/v0/b/estetica-app-tfg.appspot.com/o/producto.webp?alt=media&token=83be52f9-d03b-4723-832d-efeafd9ac9b7'
                                                          : _imagePath,
                                                    ),
                                                  ),
                                                );
                                          }
                                          Navigator.of(context).pop();
                                        },
                                      ]),
                                );
                          },
                        ),
                      )
                    ],
                  ),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
