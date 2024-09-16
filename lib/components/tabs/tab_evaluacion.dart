import 'package:evaluacionmaquinas/modelos/evaluacion_details_dm.dart';
import 'package:evaluacionmaquinas/modelos/imagen_dm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../generated/l10n.dart';
import '../../theme/dimensions.dart';
import '../../utils/Constants.dart';
import '../../utils/Utils.dart';
import '../my_button.dart';

class TabEvaluacion extends StatelessWidget {
  final EvaluacionDetailsDataModel evaluacion;
  final List<ImagenDataModel> imagenes;

  const TabEvaluacion({
    super.key,
    required this.evaluacion,
    required this.imagenes,
  });

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
                color: Theme.of(context).colorScheme.onBackground,
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

                      // Datos de la Máquina
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

                      // Imágenes
                      const SizedBox(height: Dimensions.marginSmall),
                      SizedBox(
                        height: 200.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const ClampingScrollPhysics(),
                          itemCount: imagenes.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: const EdgeInsets.all(8.0),
                              width: 200,
                              height: 200,
                              child: Image.memory(
                                imagenes[index].imagen,
                                fit: BoxFit.cover,
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
            Icon(icon, color: Theme.of(context).colorScheme.onSecondary),
            const SizedBox(width: Dimensions.marginMedium),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 8),
                Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
                Text(value),
              ],
            ),

          ],
        )
    );
  }


}
