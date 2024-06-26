import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rts_web/home/home_controller.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HomeLinearGauge extends StatefulWidget {
  const HomeLinearGauge({super.key});

  @override
  State<HomeLinearGauge> createState() => _HomeLinearGaugeState();
}

class _HomeLinearGaugeState extends State<HomeLinearGauge> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (homeController) => SfLinearGauge(
        orientation: LinearGaugeOrientation.vertical,
        showLabels: true,
        isAxisInversed: true,
        minimum: 0,
        maximum: 3,
        interval: 1,
        axisLabelStyle: Theme.of(context).textTheme.bodyMedium,
        //axisTrackExtent: 30,
        markerPointers: [
          LinearShapePointer(
            value: homeController.page,
            enableAnimation: true,
            animationDuration: 600,
            animationType: LinearAnimationType.easeInCirc,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
        barPointers: [
          LinearBarPointer(
            value: homeController.page,
            enableAnimation: true,
            animationDuration: 600,
            animationType: LinearAnimationType.easeInCirc,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
        labelFormatterCallback: (label) {
          if (label == '0') {
            return 'Intro';
          }
          if (label == '1') {
            return 'Races';
          }
          if (label == '2') {
            return 'The Known World';
          }
          if (label == '3') {
            return 'Whitepaper';
          }
          return label;
        }
      )
    );
  }
}
