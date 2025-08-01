// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:palm_ecommerce_app/ui/provider/address_provider.dart';
import 'package:palm_ecommerce_app/ui/screens/checkout/widget/edit_location.dart';
import 'package:palm_ecommerce_app/ui/widget/bottomNavigator.dart';
import 'package:palm_ecommerce_app/util/data.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({super.key});

  @override
  State<CurrentLocationScreen> createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  late GoogleMapController googleMapController;

  CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962), zoom: 14);

  Set<Marker> markers = {};
  LatLng selectedLatLng = LatLng(0, 0);
  String selectedAddress = '';
  bool isInitialLocationSet = false;

  @override
  void initState() {
    super.initState();
    _initializeCurrentLocation();
  }

  Future<void> showConfirmationDialog(BuildContext context, String message,
      {bool isSuccess = true}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isSuccess ? 'Success' : 'Error'),
          content: Row(
            children: [
              Icon(
                isSuccess ? Icons.check : Icons.error,
                color: isSuccess ? Colors.green : Colors.red,
              ),
              SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveAddress() async {
    try {
      // Store the selected location in global variables without API call
      lat = selectedLatLng.latitude.toString();
      long = selectedLatLng.longitude.toString();
      saveChooseAddressPlace = selectedAddress;
      await showConfirmationDialog(context, 'Location saved successfully!');
      // Navigate to UserLocation screen
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => UserLocation()));
    } catch (e) {
      await showConfirmationDialog(context, 'An error occurred: $e',
          isSuccess: false);
    }
  }

  Future<void> _initializeCurrentLocation() async {
    try {
      // Request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("Location permissions denied");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print("Location permissions are permanently denied");
        return;
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      LatLng currentLatLng = LatLng(position.latitude, position.longitude);
      setState(() {
        initialCameraPosition = CameraPosition(target: currentLatLng, zoom: 14);
        selectedLatLng = currentLatLng;
        markers.add(Marker(
            markerId: MarkerId('currentLocation'), position: currentLatLng));
        isInitialLocationSet = true;
      });

      getAddressFromLatLng(currentLatLng);
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressProvider>(
      builder: (context, addressProvider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFF5D248),
            elevation: 0,
            title: const Text("Location address",
                style: TextStyle(color: Colors.white, fontSize: 18)),
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black87,
                    size: 18,
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(Icons.home, color: Colors.white,size: 32,),
                  onPressed: () {
                    // Navigate to home page
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => BottomNavBar()));
                  },
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: initialCameraPosition,
                markers: markers,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                onMapCreated: (GoogleMapController controller) {
                  googleMapController = controller;
                  if (isInitialLocationSet) {
                    googleMapController.animateCamera(
                        CameraUpdate.newCameraPosition(initialCameraPosition));
                  } else {
                    getCurrentLocation();
                  }
                },
                onTap: (LatLng latLng) {
                  markers.clear();
                  markers.add(Marker(
                      markerId: MarkerId('selectedLocation'),
                      position: latLng,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueOrange)));
                  setState(() {
                    selectedLatLng = latLng;
                    getAddressFromLatLng(latLng);
                  });
                },
              ),
              // Current location button
              Positioned(
                bottom: 80,
                right: 16,
                child: FloatingActionButton(
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.navigation, color: Colors.white),
                  onPressed: () {
                    getCurrentLocation();
                  },
                ),
              ),
              if (addressProvider.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  ),
                ),
            ],
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: selectedAddress.isEmpty
                  ? null
                  : () {
                      _saveAddress();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5D248),
                disabledBackgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                'Confirm',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> getCurrentLocation() async {
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Location permission denied"),
            backgroundColor: Colors.red,
          ));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Location permissions are permanently denied, please enable in settings"),
          backgroundColor: Colors.red,
        ));
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      LatLng currentLatLng = LatLng(position.latitude, position.longitude);

      markers.clear();
      markers.add(Marker(
          markerId: MarkerId('currentLocation'),
          position: currentLatLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueOrange)));

      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: currentLatLng, zoom: 14)));

      setState(() {
        selectedLatLng = currentLatLng;
      });

      getAddressFromLatLng(currentLatLng);
    } catch (e) {
      print("Error getting current location: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "Failed to get current location. Please check your location permissions."),
        backgroundColor: Colors.red,
      ));
    }
  }

  void getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      Placemark place = placemarks[0];
      setState(() {
        selectedAddress =
            "${place.name}, ${place.thoroughfare}, ${place.subLocality}, ${place.locality}";
        // Update the global variable immediately when address is obtained
        saveChooseAddressPlace = selectedAddress;
        lat = latLng.latitude.toString();
        long = latLng.longitude.toString();
      });
    } catch (e) {
      print("Error getting address: $e");
      setState(() {
        selectedAddress = "Address not found";
      });
    }
  }
}
