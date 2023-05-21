import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:parking_app/features/parking/data/models/parking.dart';
import 'package:parking_app/features/parking/presentation/providers/parking_providers.dart';
import 'package:parking_app/features/parking/presentation/providers/parking_state.dart';
import 'package:parking_app/features/places/data/models/parking_place.dart';
import 'package:parking_app/features/vehicles/presentation/widgets/vehicle_drop_down.dart';

class StartParking extends ConsumerStatefulWidget {
  final Parking? parking;
  final ParkingPlace place;
  const StartParking({super.key, required this.place, this.parking});

  @override
  ConsumerState<StartParking> createState() => _StartParkingState();
}

class _StartParkingState extends ConsumerState<StartParking> {
  int _periodInMinutes = 0;
  final DateTime _initialTime = DateTime.now();
  late DateFormat dateFormatter;
  final double _pricePerMinute = 0.001; // some fictional price
  final startParkingText = 'Start parking';
  final stopParkingText = 'Stop parking';

  @override
  void initState() {
    super.initState();
    dateFormatter = DateFormat('Hm', 'en-US');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(parkingNotifierProvider.notifier)
          .setInitialState(widget.parking);
    });
  }

  double _calculatePrice() {
    return _periodInMinutes * _pricePerMinute;
  }

  String _getPeriodText() {
    if (_periodInMinutes > 59) {
      double hours = _periodInMinutes / 60;
      double min = _periodInMinutes % 60;

      return "${hours.toInt()}h${min.toInt()}m";
    } else {
      return "${_periodInMinutes}m";
    }
  }

  void _increasePeriod() {
    setState(() {
      _periodInMinutes = _periodInMinutes + 10;
    });
  }

  void _decreasePeriod() {
    if (_periodInMinutes > 0) {
      setState(() {
        _periodInMinutes = _periodInMinutes - 10;
      });
    }
  }

  String _parkingButtonText(ParkingState state) {
    switch (state.state) {
      case ParkingPossibleStates.initial:
        return startParkingText;
      case ParkingPossibleStates.stopping:
      case ParkingPossibleStates.stopped:
      case ParkingPossibleStates.started:
      case ParkingPossibleStates.starting:
        return stopParkingText;
      default:
        return startParkingText;
    }
  }

  void _registerParking(ParkingState state) {
    if (state.selectedVehicle == null) {
      const snackBar = SnackBar(
        content: Text('Please select a vehicle'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if (state.currentParking?.end == null &&
        state.currentParking?.start != null) {
      if (state.selectedVehicle != null) {
        ref.read(parkingNotifierProvider.notifier).stopParking(
            state.selectedVehicle!,
            _calculatePrice(),
            widget.place,
            state.currentParking?.parkingID ?? "");
      }
    } else {
      ref.read(parkingNotifierProvider.notifier).startParking(
          state.selectedVehicle!, _calculatePrice(), widget.place);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(parkingNotifierProvider);

    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 75,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(
            _parkingButtonText(state),
            style: Theme.of(context).appBarTheme.titleTextStyle,
          )),
      body: state.state == ParkingPossibleStates.stopped
          ? const ReceiptWidget()
          : Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.place.name ?? ""} at ${widget.place.address ?? ""}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontSize: 16),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: VehicleDropDown(
                                onVehicleSelected: (vehicle) {
                                  ref
                                      .read(parkingNotifierProvider.notifier)
                                      .setVehicleSelected(vehicle);
                                },
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${_getPeriodText()} until...",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontSize: 16),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                  DateFormat('Hm', 'en-US').format(
                                      _initialTime.add(
                                          Duration(minutes: _periodInMinutes))),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25)),
                            ),
                          ],
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.credit_card,
                                size: 50,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text("Price: ${_calculatePrice()}"),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoundButtonWidget(
                              onTap: () => _increasePeriod(),
                              iconData: Icons.add,
                              padding:
                                  const EdgeInsets.only(right: 30, top: 30),
                            ),
                            RoundButtonWidget(
                              onTap: () => _decreasePeriod(),
                              iconData: Icons.remove,
                              padding: const EdgeInsets.only(top: 30),
                            ),
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 80),
                            child: InkWell(
                              onTap: () {
                                _registerParking(state);
                              },
                              child: Container(
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Theme.of(context).primaryColor),
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        _parkingButtonText(state),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ],
                    )
                  ]),
            ),
    );
  }
}

class RoundButtonWidget extends StatelessWidget {
  final IconData iconData;
  final EdgeInsets? padding;
  final void Function() onTap;
  const RoundButtonWidget(
      {super.key, required this.iconData, this.padding, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(top: 20),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).primaryColor),
            color: Theme.of(context).canvasColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 50,
                color: Theme.of(context).primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ReceiptWidget extends StatelessWidget {
  const ReceiptWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      'Thank you for parking with us :)',
      style: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(color: Theme.of(context).colorScheme.primary),
    ));
  }
}
