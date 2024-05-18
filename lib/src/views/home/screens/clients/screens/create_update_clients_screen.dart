import 'package:client_repository/client_repository.dart';
import 'package:estetica_app/src/resources/colors.dart';
import 'package:estetica_app/src/resources/spaces.dart';
import 'package:estetica_app/src/views/home/blocs/image_picker_cubit.dart';
import 'package:estetica_app/src/views/home/screens/clients/resources/strings.dart';
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
    cubit.removeImage();
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
    int discount = client?.discount ?? 0;
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

    String image =
        context.select((ImagePickerCubit cubit) => cubit.imageFile?.path ?? '');
    BlocEvent state = context.select((ClientPageBloc bloc) => bloc.state);
    return GestureDetector(
      onTap: () => clearFocusAndHideKeyboard(context),
      child: Scaffold(
          body: SafeArea(
        child: CustomScrollView(
          slivers: [
            esteticaBar(
                titulo: client != null
                    ? ClientStrings.updateClient
                    : ClientStrings.addClient,
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
                        onImageSelected: (imageSelect) {
                          context
                              .read<ImagePickerCubit>()
                              .setImageFile(imageSelect);
                        },
                        imagePath: (image == '' ? client?.image : image) ?? '',
                      ),
                      AppSpaces.spaceH24,
                      EsteticaTextFormField(
                        model: EsteticaTextFormFieldModel(
                          type: EsteticaTextFormFieldType.text,
                          controller: nameController,
                          labelText: ClientStrings.name,
                          hintText: ClientStrings.hintName,
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
                          labelText: ClientStrings.surname,
                          hintText: ClientStrings.hintSurname,
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
                          labelText: ClientStrings.email,
                          hintText: ClientStrings.hintEmail,
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
                          labelText: ClientStrings.phone,
                          hintText: ClientStrings.hintPhone,
                          errorText: phoneErrorVisible ? phoneError : null,
                        ),
                        onChanged: (String value) {
                          read.add(
                            Event(ClientPageErrorsType.telefonoNoValido,
                                data: value),
                          );
                        },
                      ),
                      AppSpaces.spaceH24,
                      DropdownButtonFormField<int>(
                        value: discount,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: ClientStrings.discount,
                          hintText: ClientStrings.hintDiscount,
                        ),
                        items: const [
                          DropdownMenuItem<int>(
                            value: 0,
                            child: Text(ClientStrings.noDiscount),
                          ),
                          DropdownMenuItem<int>(
                            value: 5,
                            child: Text(ClientStrings.discount5),
                          ),
                          DropdownMenuItem<int>(
                            value: 10,
                            child: Text(ClientStrings.discount10),
                          ),
                          DropdownMenuItem<int>(
                            value: 15,
                            child: Text(ClientStrings.discount15),
                          ),
                          DropdownMenuItem<int>(
                            value: 20,
                            child: Text(ClientStrings.discount20),
                          ),
                        ],
                        onChanged: (value) {
                          discount = value!;
                        },
                        dropdownColor: AppColors.colorWhite,
                      ),
                      AppSpaces.spaceH36,
                      SizedBox(
                        width: double.infinity,
                        child: EsteticaButton(
                          model: EsteticaButtonModel(
                              text: client != null
                                  ? ClientStrings.updateClient
                                  : ClientStrings.addClient,
                              type: EsteticaButtonType.primary,
                              isEnable: !nameErrorVisible &&
                                  !surnameErrorVisible &&
                                  !emailErrorVisible &&
                                  !phoneErrorVisible &&
                                  nameController.text.isNotEmpty,
                              isLoading: (state is Loading)),
                          onTapFunction: () {
                            String id =
                                FirebaseClientRepo().clientsCollection.doc().id;
                            context.read<ClientPageBloc>().add(
                                  Event(ClientPageEventsType.addImagenStorage,
                                      data: [
                                        client?.clientId ?? id,
                                        nameController.text,
                                        image,
                                        (imagePath) {
                                          if (client != null) {
                                            context.read<ClientPageBloc>().add(
                                                  Event(
                                                    ClientPageEventsType
                                                        .updateClient,
                                                    data: ClientModel(
                                                        clientId:
                                                            client!.clientId,
                                                        name:
                                                            nameController.text,
                                                        surname:
                                                            surnameController
                                                                .text,
                                                        email: emailController
                                                            .text,
                                                        phone: phoneController
                                                            .text,
                                                        image: imagePath == ''
                                                            ? client?.image
                                                            : imagePath,
                                                        discount: discount),
                                                  ),
                                                );
                                          } else {
                                            context.read<ClientPageBloc>().add(
                                                  Event(
                                                    ClientPageEventsType
                                                        .addClient,
                                                    data: ClientModel(
                                                      clientId: id,
                                                      name: nameController.text,
                                                      surname: surnameController
                                                          .text,
                                                      email:
                                                          emailController.text,
                                                      phone:
                                                          phoneController.text,
                                                      image: imagePath == ''
                                                          ? null
                                                          : imagePath,
                                                      discount: discount,
                                                    ),
                                                  ),
                                                );
                                          }
                                          Navigator.of(context).pop();
                                        }
                                      ]),
                                );
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
