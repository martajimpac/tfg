
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/dimensions.dart';
import '../../../../core/utils/Constants.dart';
import '../../../../core/utils/Utils.dart';
import '../../../../generated/l10n.dart';
import '../../../data/models/evaluacion_details_dm.dart';
import '../../../data/models/imagen_dm.dart';
import '../caducidad_indicator.dart';
import '../dialog/my_image_dialog.dart';

class TabEvaluacion extends StatelessWidget {
  final EvaluacionDetailsDataModel evaluacion;
  final List<ImagenDataModel> imagenes;

  const TabEvaluacion({
    super.key,
    required this.evaluacion,
    required this.imagenes,
  });


  void _showImageDialog(BuildContext context, Image image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyImageDialog(
          image: image,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.marginMedium),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.cornerRadius),
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.marginMedium),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Título de Datos de Evaluación
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            S.of(context).evaluationData,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.marginSmall),

                      // Información del Centro
                      _buildInfoRow(
                        context: context,
                        icon: Icons.business,
                        label: "${S.of(context).center}:",
                        value: evaluacion.nombreCentro,
                      ),

                      // Fecha de Realización
                      _buildInfoRow(
                        context: context,
                        icon: Icons.calendar_today,
                        label: "${S.of(context).completionDate}:",
                        value: DateFormat(DateFormatString).format(evaluacion.fechaRealizacion),
                      ),

                      // Fecha de Caducidad
                      _buildInfoRow(
                        context: context,
                        icon: Icons.calendar_today,
                        label: "${S.of(context).expirationDate}:",
                        value: DateFormat(DateFormatString).format(evaluacion.fechaCaducidad),
                      ),

                      const SizedBox(height: Dimensions.marginMedium),

                      Utils.menosDe30DiasParaCaducar(context, evaluacion.fechaCaducidad) || Utils.haCaducado(context, evaluacion.fechaCaducidad)
                          ?  Center(
                           child: CaducidadIndicator(fechaCaducidad: evaluacion.fechaCaducidad)
                          )
                          : Center(
                        child: Text(
                          Utils.getDifferenceBetweenDates(context, DateTime.now(), evaluacion.fechaCaducidad),
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: Dimensions.marginMedium),

                      Divider(
                        color: Theme.of(context).colorScheme.surface,
                        thickness: 1,
                      ),

                      /// Datos de la Máquina
                      const SizedBox(height: Dimensions.marginMedium),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            S.of(context).machineData,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.marginSmall),

                      // Denominación
                      _buildInfoRow(
                          context: context,
                          icon: Icons.settings,
                          label: "${S.of(context).denomination}:",
                          value: evaluacion.nombreMaquina
                      ),

                      // Fabricante
                      _buildInfoRow(
                        context: context,
                        icon: Icons.settings,
                        label: "${S.of(context).manufacturer}:",
                        value: evaluacion.fabricante?.isNotEmpty == true
                            ? evaluacion.fabricante!
                            : S.of(context).unknownManufacterer,
                      ),

                      // Número de Serie
                      _buildInfoRow(
                          context: context,
                          icon: Icons.settings,
                          label: "${S.of(context).serialNumber}:",
                          value: evaluacion.numeroSerie
                      ),

                      // Fecha de Fabricación
                      _buildInfoRow(
                        context: context,
                        icon: Icons.event,
                        label: "${S.of(context).manufacturedDate}:",
                        value: evaluacion.fechaFabricacion != null
                            ? DateFormat(DateFormatString).format(evaluacion.fechaFabricacion!)
                            : S.of(context).unknownDate,
                      ),

                      // Fecha de Puesta en Servicio
                      _buildInfoRow(
                        context: context,
                        icon: Icons.event_available,
                        label: "${S.of(context).comissioningDate}:",
                        value: evaluacion.fechaPuestaServicio != null
                            ? DateFormat(DateFormatString).format(evaluacion.fechaPuestaServicio!)
                            : S.of(context).unknownDate,
                      ),

                      // Fecha de Puesta en Servicio
                      _buildInfoRow(
                        context: context,
                        icon: Icons.event_available,
                        label: "${S.of(context).comissioningDate}:",
                        value: evaluacion.fechaPuestaServicio != null
                            ? DateFormat(DateFormatString).format(evaluacion.fechaPuestaServicio!)
                            : S.of(context).unknownDate,
                      ),


                      if (evaluacion.isMaqCarga) ...[
                        SizedBox(height: Dimensions.marginSmall),
                        Row(
                          children: [
                            Expanded(child:
                              Text(
                                  S.of(context).elevationMachine,
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSecondary)
                              )
                            ),
                            Checkbox(
                              value: true,
                              activeColor: Theme.of(context).appBarTheme.iconTheme?.color, // Color del fondo cuando está marcado
                              checkColor: Theme.of(context).colorScheme.surface,  // Color del check (✓)
                              onChanged: null,
                            ),
                          ],
                        ),
                      ],

                      if (evaluacion.isMaqMovil) ...[
                        SizedBox(height: Dimensions.marginSmall),
                        Row(
                          children: [
                            Expanded(child:
                              Text(
                                  S.of(context).mobileMachine,
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSecondary)
                              )
                            ),
                            Checkbox(
                              value: true,
                              activeColor: Theme.of(context).appBarTheme.iconTheme?.color, // Color del fondo cuando está marcado
                              checkColor: Theme.of(context).colorScheme.surface,  // Color del check (✓)
                              onChanged: null,
                            ),
                          ],
                        ),
                      ],


                      // Imágenes
                      const SizedBox(height: Dimensions.marginSmall),
                      SizedBox(
                        height: 200.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const ClampingScrollPhysics(),
                          itemCount: imagenes.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                _showImageDialog(
                                    context,
                                    Utils.showImage(imagenes[index])
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.all(8.0),
                                width: 200,
                                height: 200,
                                child: Utils.showImage(imagenes[index]),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: Dimensions.marginSmall),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.marginSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.onSecondary, semanticLabel: ''),
          const SizedBox(width: Dimensions.marginMedium),
          Expanded( // Para que la columna ocupe toodo el espacio disponible
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                Text(
                  value,
                  softWrap: true, // Permite que el texto se ajuste a múltiples líneas si es necesario.
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }




}
