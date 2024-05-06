import 'dart:developer';

import 'package:client_repository/client_repository.dart';
import 'package:estetica_app/src/styles/spaces.dart';
import 'package:estetica_app/src/views/home/blocs/image_picker_cubit.dart';
import 'package:estetica_app/src/widgets/estetica_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../class/bloc_events_class.dart';
import '../../../../../components/estetica_appbar.dart';
import '../../../../../resources/utils.dart';
import '../../../../../widgets/estetica_button.dart';
import '../../../components/image_picker_widget.dart';
import '../bloc/client_page_bloc.dart';

class CreateUpdateClientsScreen extends StatelessWidget {
  final ClientModel? client;
  final ClientPageBloc bloc;
  final ImagePickerCubit cubit;

  const CreateUpdateClientsScreen(
      {Key? key, this.client, required this.bloc, required this.cubit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: client?.name ?? '');
    final TextEditingController emailController =
        TextEditingController(text: client?.email ?? '');
    final TextEditingController phoneController =
        TextEditingController(text: client?.phone ?? '');
    final TextEditingController surnameController =
        TextEditingController(text: client?.surname ?? '');

    return MultiBlocProvider(
      providers: [
        BlocProvider<ClientPageBloc>.value(value: bloc),
        BlocProvider<ImagePickerCubit>.value(value: cubit),
      ],
      child: FormularioClient(
        nameController: nameController,
        surnameController: surnameController,
        emailController: emailController,
        phoneController: phoneController,
        client: client,
      ),
    );
  }
}

class FormularioClient extends StatelessWidget {
  const FormularioClient({
    super.key,
    required this.nameController,
    required this.surnameController,
    required this.emailController,
    required this.phoneController,
    required this.client,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController surnameController;
  final ClientModel? client;

  @override
  Widget build(BuildContext context) {
    final ClientPageBloc read = context.read<ClientPageBloc>();
    bool nameErrorVisible =
        context.select((ClientPageBloc bloc) => bloc.nameErrorVisible);
    bool surnameErrorVisible =
        context.select((ClientPageBloc bloc) => bloc.surnameErrorVisible);
    bool emailErrorVisible =
        context.select((ClientPageBloc bloc) => bloc.emailErrorVisible);
    bool phoneErrorVisible =
        context.select((ClientPageBloc bloc) => bloc.phoneErrorVisible);
    String nameError = context.select((ClientPageBloc bloc) => bloc.nameError);
    String surnameError =
        context.select((ClientPageBloc bloc) => bloc.surnameError);
    String emailError =
        context.select((ClientPageBloc bloc) => bloc.emailError);
    String phoneError =
        context.select((ClientPageBloc bloc) => bloc.phoneError);

    String imagePath = context.select((ClientPageBloc bloc) => bloc.imagePath);

    String image =
        context.select((ImagePickerCubit cubit) => cubit.imageFile?.path ?? '');
    return GestureDetector(
      onTap: () => clearFocusAndHideKeyboard(context),
      child: Scaffold(
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
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      AppSpaces.spaceH24,
                      ImagePickerWidget(
                        onImageSelected: (_image) {
                          context.read<ImagePickerCubit>().setImageFile(_image);
                        },
                        imagePath: client?.image ?? image,
                      ),
                      AppSpaces.spaceH24,
                      EsteticaTextFormField(
                        model: EsteticaTextFormFieldModel(
                          type: EsteticaTextFormFieldType.text,
                          controller: nameController,
                          labelText: 'Name',
                          hintText: 'Enter your name',
                          errorText: nameErrorVisible ? nameError : null,
                        ),
                        onChanged: (String value) {
                          read.add(
                            Event(ClientPageErrorsType.nombreNoValido,
                                data: value),
                          );
                        },
                      ),
                      AppSpaces.spaceH24,
                      EsteticaTextFormField(
                        model: EsteticaTextFormFieldModel(
                          type: EsteticaTextFormFieldType.text,
                          controller: surnameController,
                          labelText: 'Surname',
                          hintText: 'Enter your surname',
                          errorText: surnameErrorVisible ? surnameError : null,
                        ),
                        onChanged: (String value) {
                          read.add(
                            Event(ClientPageErrorsType.apellidoNoValido,
                                data: value),
                          );
                        },
                      ),
                      AppSpaces.spaceH24,
                      EsteticaTextFormField(
                        model: EsteticaTextFormFieldModel(
                          type: EsteticaTextFormFieldType.email,
                          controller: emailController,
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          errorText: emailErrorVisible ? emailError : null,
                        ),
                        onChanged: (String value) {
                          read.add(
                            Event(ClientPageErrorsType.correoNoValido,
                                data: value),
                          );
                        },
                      ),
                      AppSpaces.spaceH24,
                      EsteticaTextFormField(
                        model: EsteticaTextFormFieldModel(
                          type: EsteticaTextFormFieldType.phone,
                          controller: phoneController,
                          labelText: 'Phone',
                          hintText: 'Enter your phone',
                          errorText: phoneErrorVisible ? phoneError : null,
                        ),
                        onChanged: (String value) {
                          read.add(
                            Event(ClientPageErrorsType.telefonoNoValido,
                                data: value),
                          );
                        },
                      ),
                      AppSpaces.spaceH36,
                      SizedBox(
                        width: double.infinity,
                        child: EsteticaButton(
                          model: EsteticaButtonModel(
                            text: 'Save',
                            type: EsteticaButtonType.primary,
                            isEnable: !nameErrorVisible &&
                                !surnameErrorVisible &&
                                !emailErrorVisible &&
                                !phoneErrorVisible &&
                                nameController.text.isNotEmpty,
                          ),
                          onTapFunction: () {
                            context.read<ClientPageBloc>().add(
                                  Event(ClientPageEventsType.addImagenStorage,
                                      data: [
                                        client?.clientId ??
                                            FirebaseClientRepo()
                                                .clientsCollection
                                                .doc()
                                                .id,
                                        nameController.text,
                                        image
                                      ]),
                                );
                            if (client != null) {
                              context.read<ClientPageBloc>().add(
                                    Event(
                                      ClientPageEventsType.updateClient,
                                      data: ClientModel(
                                        clientId: client!.clientId,
                                        name: nameController.text,
                                        surname: surnameController.text,
                                        email: emailController.text,
                                        phone: phoneController.text,
                                        image:
                                            imagePath == '' ? null : imagePath,
                                      ),
                                    ),
                                  );
                            } else {
                              context.read<ClientPageBloc>().add(
                                    Event(
                                      ClientPageEventsType.addClient,
                                      data: ClientModel(
                                        clientId: FirebaseClientRepo()
                                            .clientsCollection
                                            .doc()
                                            .id,
                                        name: nameController.text,
                                        surname: surnameController.text,
                                        email: emailController.text,
                                        phone: phoneController.text,
                                        image:
                                            imagePath == '' ? null : imagePath,
                                      ),
                                    ),
                                  );
                            }
                            context.read<ImagePickerCubit>().removeImage();
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ]),
            )
          ],
        ),
      )),
    );
  }
}
