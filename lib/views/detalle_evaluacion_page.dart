import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:modernlogintute/components/my_button.dart';
import 'package:modernlogintute/components/my_textfield.dart';
import 'package:modernlogintute/main.dart';
import 'package:modernlogintute/theme/dimensions.dart';
import 'package:modernlogintute/views/checklist_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:convert/convert.dart';

class DetalleEvaluaccionPage extends StatefulWidget {
  const DetalleEvaluaccionPage({Key? key}) : super(key: key);

  @override
  _DetalleEvaluaccionPageState createState() => _DetalleEvaluaccionPageState();
}

class _DetalleEvaluaccionPageState extends State<DetalleEvaluaccionPage> {
  final controller = TextEditingController();

  /*final _imageStream = supabase
      .from('maq_imagenes')
      .stream(primaryKey: ['idimg']); //TODO FILTRAR POR INSPECCION

  Future<void> _deleteImages() async {
    // Guardar los bytes de la imagen en la base de datos Supabase
    await supabase.from("maq_imagenes").delete().eq("ideval", 2);

    setState(() {
    });
  }

  Future<void> _deleteImage(String imageid, int index) async {
    await supabase.from("maq_imagenes").delete().eq("idimg", imageid);
    // Actualiza la lista de imágenes para reflejar el cambio en la interfaz de usuario
    *//*setState(() {
      _imageStream.removeAt(index); // Elimina la imagen de la lista local
    });*//*
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(child:
                Container()
              /*StreamBuilder<List<Map<String, dynamic>>>(
                stream: _imageStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  //
                  final images = snapshot.data!;
                  //
                  // if (images.isEmpty) {
                  //   return const Center(child: Text('No hay imágenes disponibles'));
                  // }

                  return ListView.builder(
                    itemCount: images.length,
                    itemBuilder: (context, index) {

                      final cadenaRecortada = images[index]['imagen'].substring(4, images[index]['imagen'].length - 2); //quitar "[" y "]" caracteres ascii

                      debugPrint("marta cadena $cadenaRecortada");

                      List<String> listaString = cadenaRecortada.split('2c'); //quitar caracteres "," ascii

                      debugPrint("marta hex ${listaString.join(',')}");

                      List<int> listaDecimal = [];
                      for (var it in listaString) {

                        String numeroSinImpares = '';

                        for (int i = 0; i < it.length; i++) {
                          // Si la posición es par, agregar el dígito a la cadena resultante
                          if (i % 2 != 0) {
                            numeroSinImpares += it[i];
                          }
                        }
                        listaDecimal.add(int.parse(numeroSinImpares));
                      }
                      final listaBytes = Uint8List.fromList(listaDecimal);

                      return ListTile(
                          onTap: () => _deleteImage(images[index]['idimg'], index),
                          leading: Image.memory(
                            listaBytes,
                            width: 200,
                            height: 200,
                          )
                      );
                    },
                  );
                },
              )*/
            ),
            MyButton(
              adaptableWidth: true,
              onTap: () {
                //_deleteImages
              },
              text: "Eliminar todas las imágenes",
            ),
          ],
        )

      );
  }
}
