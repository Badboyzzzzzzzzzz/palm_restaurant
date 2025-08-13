// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/models/delivery.dart';
import 'package:palm_ecommerce_app/models/photo.dart';
import 'package:palm_ecommerce_app/ui/provider/address_provider.dart';
import 'package:palm_ecommerce_app/ui/provider/authentication_provider.dart';
import 'package:palm_ecommerce_app/ui/screens/checkout/check_out.dart';
import 'package:palm_ecommerce_app/ui/screens/checkout/widget/choose_location.dart';
import 'package:palm_ecommerce_app/util/data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserLocation extends StatefulWidget {
  const UserLocation({super.key});
  @override
  State<UserLocation> createState() => _UserLocationState();
}

class _UserLocationState extends State<UserLocation> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String selectedLocation = '';
  String selectedLocationPlace = '';
  bool isLoading = false;
  List<File> selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  // Address type selection
  String selectedAddressType = 'Home'; // Default to Home

  // Google Maps variables
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  bool _mapLoaded = false;

  // Add error state variable
  String? _error;

  Future<void> showConfirmationDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 55,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Success!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Your address has been saved successfully',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> pickImage() async {
    // Show a dialog to choose between camera and gallery
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library, color: Colors.orange),
                title: Text('Photo Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  _processPickedImage(image);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.orange),
                title: Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.camera);
                  _processPickedImage(image);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _processPickedImage(XFile? image) {
    if (image != null) {
      setState(() {
        if (selectedImages.length < 3) {
          selectedImages.add(File(image.path));
          // Save path to global variable
          addressPhotoPaths.add(image.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Maximum 3 photos allowed')),
          );
        }
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      setState(() {
        isLoading = true;
      });
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Location permission denied"),
            backgroundColor: Colors.red,
          ));
          setState(() {
            isLoading = false;
          });
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Location permissions are permanently denied, please enable in settings"),
          backgroundColor: Colors.red,
        ));
        setState(() {
          isLoading = false;
        });
        return;
      }
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      // Update global variables
      lat = position.latitude.toString();
      long = position.longitude.toString();

      // Debug print location data
      print("DEBUG: Location retrieved - Lat: $lat, Long: $long");

      // Get address from coordinates
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address =
            "${place.name}, ${place.thoroughfare}, ${place.subLocality}, ${place.locality}, ${place.country}";
        setState(() {
          selectedLocationPlace = address;
          saveChooseAddressPlace = address;
          isLoading = false;
        });

        // Debug print address data
        print("DEBUG: Address retrieved - $address");

        // Update map location
        _updateMapLocation();
      } else {
        setState(() {
          selectedLocationPlace =
              "Location found, but address details unavailable";
          saveChooseAddressPlace = selectedLocationPlace;
          isLoading = false;
        });

        // Debug print address data
        print("DEBUG: No address details available for coordinates");

        // Update map location
        _updateMapLocation();
      }
    } catch (e) {
      print("Error getting current location: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to get current location: $e"),
        backgroundColor: Colors.red,
      ));
      setState(() {
        isLoading = false;
        _error = "Failed to get location: $e";
      });
    }
  }

  // Update map location and marker
  void _updateMapLocation() {
    if (_mapController != null && lat.isNotEmpty && long.isNotEmpty) {
      double latitude = double.parse(lat);
      double longitude = double.parse(long);

      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(latitude, longitude),
        ),
      );

      setState(() {
        _markers = {
          Marker(
            markerId: MarkerId('current_location'),
            position: LatLng(latitude, longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange),
          ),
        };
      });
    }
  }

  // Load user data from authentication provider
  void _loadUserDataFromAuth() {
    try {
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      final user = authProvider.userInfo;

      if (user != null) {
        // Only pre-fill if the fields are empty or contain default values
        if (_nameController.text.isEmpty ||
            _nameController.text == nameAddress) {
          setState(() {
            _nameController.text = user.name ?? '';
            nameAddress = user.name ?? '';
          });
        }
        if (_phoneController.text.isEmpty ||
            _phoneController.text == phoneAddress) {
          setState(() {
            _phoneController.text = user.phone ?? '';
            phoneAddress = user.phone ?? '';
          });
        }
      }
    } catch (e) {
      print("Error loading user data from auth: $e");
    }
  }

  @override
  void initState() {
    // Only get current location if we don't already have coordinates from choose_location
    if (lat.isEmpty || long.isEmpty) {
      _getCurrentLocation(); // Get current location when screen initializes
    } else {
      // If we already have coordinates, just update the map
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateMapLocation();
      });
    }

    // Load existing data if available
    if (nameAddress.isNotEmpty) {
      _nameController.text = nameAddress;
    }

    if (phoneAddress.isNotEmpty) {
      _phoneController.text = phoneAddress;
    }
    // Set the selected location from global variables
    if (saveChooseAddressPlace.isNotEmpty) {
      setState(() {
        selectedLocationPlace = saveChooseAddressPlace;
      });
    }
    for (String path in addressPhotoPaths) {
      if (selectedImages.length < 3 && path.isNotEmpty) {
        try {
          selectedImages.add(File(path));
        } catch (e) {
          print("Error loading image: $e");
        }
      }
    }
    // Load user data from authentication after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserDataFromAuth();
      // Fetch addresses when the screen loads
      Provider.of<AddressProvider>(context, listen: false).fetchAddresses();
    });
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  // Function to save address to backend
  Future<bool> saveAddressToBackend() async {
    try {
      // Check if required fields are filled
      if (_nameController.text.isEmpty ||
          _phoneController.text.isEmpty ||
          saveChooseAddressPlace.isEmpty ||
          lat.isEmpty ||
          long.isEmpty) {
        print("DEBUG: Required fields missing:");
        print("Name: ${_nameController.text.isEmpty ? 'MISSING' : 'OK'}");
        print("Phone: ${_phoneController.text.isEmpty ? 'MISSING' : 'OK'}");
        print("Address: ${saveChooseAddressPlace.isEmpty ? 'MISSING' : 'OK'}");
        print("Latitude: ${lat.isEmpty ? 'MISSING' : lat}");
        print("Longitude: ${long.isEmpty ? 'MISSING' : long}");

        setState(() {
          _error = "Please fill all required fields";
        });
        return false;
      }

      // Get AddressProvider instance
      final addressProvider =
          Provider.of<AddressProvider>(context, listen: false);

      // Create AddressType object
      final addressType = AddressType(
        addressType: selectedAddressType,
      );

      // Create list of Photo objects from image paths
      List<Photo> photos =
          selectedImages.map((image) => Photo.fromPath(image.path)).toList();

      // Create address model with address_type_id
      final address = DeliveryAddressModel(
        latitude: lat,
        longitude: long,
        address: saveChooseAddressPlace,
        addressType: addressType,
        photo: photos,
        phone: _phoneController.text,
        fullName: _nameController.text,
      );

      // Debug print the address object
      print("DEBUG: Submitting address:");
      print("Name: ${address.fullName}");
      print("Phone: ${address.phone}");
      print("Address: ${address.address}");
      print("Lat/Long: ${address.latitude}/${address.longitude}");
      print("Address Type: ${address.addressType?.addressType}");
      print("Photos count: ${address.photo?.length ?? 0}");

      // Save using the provider
      return await addressProvider.addAddress(address);
    } catch (e) {
      print("Error saving address: $e");
      setState(() {
        _error = e.toString();
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AddressProvider, AuthenticationProvider>(
      builder: (context, addressProvider, authProvider, child) {
        if ((_nameController.text.isEmpty || _phoneController.text.isEmpty) &&
            authProvider.userInfo != null) {
          if (_nameController.text.isEmpty) {
            _nameController.text = authProvider.userInfo?.name ?? '';
          }
          if (_phoneController.text.isEmpty) {
            _phoneController.text = authProvider.userInfo?.phone ?? '';
          }
        }
        return Scaffold(
          appBar: AppBar(
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
            title: Text('Edit Address',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5)),
            backgroundColor: Color(0xFFF5D248),
            elevation: 0,
          ),
          body: addressProvider.isLoading || isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Delivery Address Header
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: const Color(0xFFF5D248),
                            size: 24,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Delivery Address',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFF5D248),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Map Container with Google Maps
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 200,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15)),
                                    child: lat.isNotEmpty && long.isNotEmpty
                                        ? GoogleMap(
                                            onMapCreated: (GoogleMapController
                                                controller) {
                                              _mapController = controller;
                                              setState(() {
                                                _mapLoaded = true;
                                              });
                                              // Set initial marker if coordinates are available
                                              if (lat.isNotEmpty &&
                                                  long.isNotEmpty) {
                                                _updateMapLocation();
                                              }
                                            },
                                            initialCameraPosition:
                                                CameraPosition(
                                              target: LatLng(
                                                double.tryParse(lat) ?? 11.5564,
                                                double.tryParse(long) ??
                                                    104.9282,
                                              ),
                                              zoom: 16.0,
                                            ),
                                            markers: _markers,
                                            onTap: (LatLng position) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CurrentLocationScreen()));
                                            },
                                            zoomControlsEnabled: false,
                                            mapToolbarEnabled: false,
                                            myLocationButtonEnabled: false,
                                            scrollGesturesEnabled: true,
                                            zoomGesturesEnabled: true,
                                            tiltGesturesEnabled: false,
                                            rotateGesturesEnabled: false,
                                            mapType: MapType.normal,
                                          )
                                        : Container(
                                            width: double.infinity,
                                            height: 200,
                                            color: Colors.grey.shade200,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CircularProgressIndicator(
                                                      color: const Color(
                                                          0xFFF5D248)),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    'Loading map...',
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                  ),
                                  // Orange pin in center (only show if map is not loaded or no coordinates)
                                  if (!_mapLoaded ||
                                      lat.isEmpty ||
                                      long.isEmpty)
                                    Positioned(
                                      top: 0,
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: Icon(
                                          Icons.location_on,
                                          color: const Color(0xFFF5D248),
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  // Navigation button
                                  Positioned(
                                    bottom: 16,
                                    right: 16,
                                    child: GestureDetector(
                                      onTap: () async {
                                        await _getCurrentLocation();
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF5D248),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.navigation_rounded,
                                          color: Colors.white,
                                          size: 26,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Google logo
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("G",
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                          Text("o",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                          Text("o",
                                              style: TextStyle(
                                                  color: Colors.yellow,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                          Text("g",
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                          Text("l",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                          Text("e",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(15)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      selectedLocationPlace.isNotEmpty
                                          ? selectedLocationPlace
                                          : 'HR98+QV8, Pur SenChey, ភ្នំពេញ, Cambodia',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CurrentLocationScreen()));
                                    },
                                    icon: Icon(Icons.chevron_right,
                                        color: Colors.grey, size: 24),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),

                      // Receiver Name Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Receiver Name',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                '*',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: 'Enter receiver name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                            ),
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),

                      // Phone Number Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Phone Number',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                '*',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: 'Enter phone number',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                            ),
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 32),

                      // Photo Upload Section
                      Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5D248),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.photo,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Photo (up to 3 photos)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Photo Grid
                      Row(
                        children: [
                          // Add Photo Button
                          GestureDetector(
                            onTap: pickImage,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xFFF5D248)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.add,
                                color: const Color(0xFFF5D248),
                                size: 30,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),

                          // Selected Photos
                          ...selectedImages.map((image) => Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: FileImage(image),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            // Also remove from global variable
                                            addressPhotoPaths
                                                .remove(image.path);
                                            selectedImages.remove(image);
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                      SizedBox(height: 32),

                      // Address Type Selection
                      Text(
                        'Address Type',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 16),

                      // Address Type Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Company Button
                          _buildAddressTypeButton(
                            type: 'Company',
                            icon: Icons.business,
                            isSelected: selectedAddressType == 'Company',
                          ),

                          // Home Button
                          _buildAddressTypeButton(
                            type: 'Home',
                            icon: Icons.home,
                            isSelected: selectedAddressType == 'Home',
                          ),

                          // School Button
                          _buildAddressTypeButton(
                            type: 'School',
                            icon: Icons.school,
                            isSelected: selectedAddressType == 'School',
                          ),

                          // Other Button
                          _buildAddressTypeButton(
                            type: 'Other',
                            icon: Icons.add,
                            isSelected: selectedAddressType == 'Other',
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: addressProvider.isLoading
                        ? null
                        : () async {
                            if (_nameController.text.isEmpty ||
                                _phoneController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Please fill all required fields')),
                              );
                              return;
                            }

                            setState(() {
                              nameAddress = _nameController.text;
                              phoneAddress = _phoneController.text;
                              // Save photo paths to global variable
                              addressPhotoPaths = selectedImages
                                  .map((file) => file.path)
                                  .toList();
                              // Clear any previous errors
                              _error = null;
                            });

                            // Save to backend using provider
                            bool success = await saveAddressToBackend();

                            if (success) {
                              showConfirmationDialog(context);

                              // Navigate back after saving
                              Future.delayed(Duration(milliseconds: 1500), () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CheckOut()),
                                );
                              });
                            } else {
                              String errorMessage = addressProvider.error ??
                                  _error ??
                                  'Failed to save address';
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(errorMessage)),
                              );

                              // Debug print the error
                              print(
                                  "DEBUG: Save address failed: $errorMessage");
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5D248),
                      disabledBackgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper method to build address type button
  Widget _buildAddressTypeButton({
    required String type,
    required IconData icon,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAddressType = type;
        });
      },
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFF5D248) : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    isSelected ? const Color(0xFFF5D248) : Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey,
              size: 28,
            ),
          ),
          SizedBox(height: 8),
          Text(
            type,
            style: TextStyle(
              color: isSelected ? const Color(0xFFF5D248) : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
