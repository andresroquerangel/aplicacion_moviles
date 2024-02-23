import 'dart:io';

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  File? _selectedImage;

  final _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final conNombre = TextEditingController();
    final conEmail = TextEditingController();
    final conPassword = TextEditingController();

    final txtNombre = TextFormField(
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Necesitas ingresar tu nombre';
        }
        return null;
      },
      controller: conNombre,
      decoration: const InputDecoration(
        labelText: 'Nombre de usuario',
        prefixIcon: Icon(Icons.person),
        border: UnderlineInputBorder(),
      ),
    );

    final txtEmail = TextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Necesitas ingresar tu correo electrónico';
        }
        if (!EmailValidator.validate(value)) {
          return 'El correo ingresado no es valido';
        }
        return null;
      },
      controller: conEmail,
      decoration: const InputDecoration(
        labelText: 'Correo electrónico',
        prefixIcon: Icon(Icons.email),
        border: UnderlineInputBorder(),
      ),
    );

    final txtPassword = TextFormField(
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Necesitas ingresar tu contraseña';
        }
        if (value.length < 4) {
          return 'Tu contraseña debe tener mínimo 5 caracteres';
        }
        return null;
      },
      controller: conPassword,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Contraseña',
        prefixIcon: Icon(Icons.password),
        border: UnderlineInputBorder(),
      ),
    );

    const space = SizedBox(
      height: 20,
    );

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('images/fondo_register.jpg'))),
        child: Stack(children: [
          Positioned(
            top: 100,
            right: 50,
            left: 50,
            child: Container(
              height: 150,
              decoration:
                  BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: _selectedImage != null
                  ? IconButton(
                      onPressed: () {
                        mostrarOptionBottomSheet(context);
                      },
                      icon: CircleAvatar(
                        backgroundImage: FileImage(_selectedImage!),
                        radius: 150,
                      ))
                  : IconButton(
                      onPressed: () {
                        mostrarOptionBottomSheet(context);
                      },
                      icon: const Icon(
                        Icons.photo,
                        size: 100,
                      )),
            ),
          ),
          Positioned(
            bottom: -15,
            left: 0,
            right: 0,
            child: Container(
                height: MediaQuery.of(context).size.height *
                    0.65, // Ajustar la altura del contenedor al 80% de la altura de la pantalla
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(70)),
                child: Container(
                  margin: const EdgeInsets.all(30),
                  child: Form(
                    key: _keyForm,
                    child: ListView(
                      children: [
                        const Text('Crear cuenta',
                            style: TextStyle(fontSize: 30)),
                        const SizedBox(
                          height: 40,
                        ),
                        txtNombre,
                        space,
                        txtEmail,
                        space,
                        txtPassword,
                        const SizedBox(
                          height: 40,
                        ),
                        TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              minimumSize: MaterialStateProperty.all(
                                  const Size(200, 50))),
                          onPressed: () {
                            if (_keyForm.currentState!.validate()) {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return SizedBox(
                                      height: 200,
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.check_circle_outline,
                                            color: Colors.green,
                                            size: 80,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text(
                                            'Te has registrado con éxito',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              conNombre.clear();
                                              conEmail.clear();
                                              conPassword.clear();
                                              Navigator.pop(context);
                                              Navigator.pushNamed(
                                                  context, "/despensa");
                                            },
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.blue),
                                                foregroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.white),
                                                minimumSize:
                                                    MaterialStateProperty.all(
                                                        const Size(200, 50))),
                                            child: Text('Continuar'),
                                          )
                                        ],
                                      ));
                                },
                              );
                            }
                          },
                          child: const Text('Registrarse'),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        ]),
      ),
    );
  }

  void mostrarOptionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    await _pickImageFromGallery();
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      minimumSize:
                          MaterialStateProperty.all(const Size(200, 50))),
                  child: const Text('Elegir imagen desde galeria.'),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () async {
                    await _pickImageFromCamera();
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      minimumSize:
                          MaterialStateProperty.all(const Size(200, 50))),
                  child: const Text('Elegir imagen desde la cámara.'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnImage == null) return;
    setState(() {
      _selectedImage = File(returnImage!.path);
    });
  }

  Future _pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnImage == null) return;
    setState(() {
      _selectedImage = File(returnImage!.path);
    });
  }
}
