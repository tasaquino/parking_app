import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_app/features/vehicles/data/models/vehicle.dart';
import 'package:parking_app/features/vehicles/presentation/providers/list/vehicle_list_provider.dart';

class VehicleDropDown extends ConsumerStatefulWidget {
  final void Function(Vehicle)? onVehicleSelected;
  const VehicleDropDown({super.key, this.onVehicleSelected});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _VehicleDropDownState();
  }
}

class _VehicleDropDownState extends ConsumerState<VehicleDropDown> {
  Vehicle? vehicle;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadVehicles();
    });
  }

  void loadVehicles() async {
    ref.read(vehiclesNotifierProvider.notifier).fetchVehicles();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vehiclesNotifierProvider);
    final items = (state.vehicles ?? [])
        .map((e) => DropdownMenuItem(
              value: e,
              child: Text(e.registrationNumber),
            ))
        .toList();
    return DropdownButton(
        items: items,
        value: vehicle,
        onChanged: (vehicle) {
          if (widget.onVehicleSelected != null && vehicle != null) {
            widget.onVehicleSelected!(vehicle);
            setState(() {
              this.vehicle = vehicle;
            });
          }
        });
  }
}
