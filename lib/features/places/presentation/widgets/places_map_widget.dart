import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:parking_app/features/parking/presentation/screens/start_parking.dart';
import 'package:parking_app/features/places/presentation/notifiers/places_notifier.dart';
import 'package:parking_app/features/places/provider/places_provider.dart';
import 'package:parking_app/features/user/presentation/widgets/main_drawer.dart';

class PlacesMapWidget extends ConsumerStatefulWidget {
  const PlacesMapWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return PlacesMapWidgetState();
  }
}

class PlacesMapWidgetState extends ConsumerState<PlacesMapWidget> {
  late GoogleMapController _mapController;
  late PlacesNotifier _notifier;
  LatLng? currentLocation;
  bool hasPermission = false;

  @override
  void initState() {
    super.initState();
    _notifier = ref.read(placesNotifierProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _getCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (serviceEnabled == false) {
        setState(() {
          hasPermission = false;
        });
        return null;
      }
    }

    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        setState(() {
          hasPermission = false;
        });
        return null;
      }
    }
    try {
      LocationData locationData = await location.getLocation();
      final position =
          LatLng(locationData.latitude ?? 0.0, locationData.longitude ?? 0.0);
      setState(() {
        currentLocation = position;
      });

      _mapController.animateCamera(CameraUpdate.newLatLng(position));

      _notifier.setInitialState();
      _notifier.searchPlaces(
          currentLocation?.latitude ?? 0.0, currentLocation?.longitude ?? 0.0);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(placesNotifierProvider);
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
          toolbarHeight: 75,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: TextField(
            cursorColor: Theme.of(context).colorScheme.onBackground,
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            style: Theme.of(context).appBarTheme.titleTextStyle,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0),
                labelStyle: Theme.of(context).appBarTheme.titleTextStyle,
                labelText: 'Search...',
                floatingLabelBehavior: FloatingLabelBehavior.never,
                prefixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.search),
                  ],
                ),
                prefixIconColor:
                    Theme.of(context).appBarTheme.titleTextStyle?.color,
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                        style: BorderStyle.solid),
                    borderRadius: const BorderRadius.all(Radius.circular(25)))),
          )),
      body: GoogleMap(
          onMapCreated: _onMapCreated,
          markers: {
            ...state.places.map((place) {
              return Marker(
                  markerId: MarkerId(place.id),
                  onTap: () {
                    setState(() {
                      _notifier.setPlaceSelected(place);
                    });
                  },
                  infoWindow:
                      InfoWindow(title: place.name, snippet: place.address),
                  position: LatLng(place.latitude ?? 0, place.longitude ?? 0));
            })
          },
          initialCameraPosition: CameraPosition(
            target: currentLocation ?? const LatLng(0.0, 0.0),
            zoom: 11.0,
          )),
      bottomSheet: SizedBox(
        height: 300,
        width: double.infinity,
        child: ListView.builder(
            padding: const EdgeInsets.only(top: 20),
            itemCount: state.places.length,
            itemBuilder: (ctx, index) {
              return ListTile(
                title: Text(state.places[index].name ?? ""),
                leading: const Icon(Icons.local_parking),
                subtitle: Text(state.places[index].address ?? ""),
                trailing: state.selectedPlace == state.places[index]
                    ? InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (ctx) {
                            return StartParking(place: state.places[index]);
                          }));
                        },
                        child: Text(
                          'PARK HERE',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ))
                    : null,
              );
            }),
      ),
    );
  }
}
