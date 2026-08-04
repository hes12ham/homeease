import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class AddressPickerScreen extends StatefulWidget {
  final LatLng? initialLocation;

  const AddressPickerScreen({super.key, this.initialLocation});

  @override
  State<AddressPickerScreen> createState() => _AddressPickerScreenState();
}

class _AddressPickerScreenState extends State<AddressPickerScreen> {
  GoogleMapController? _mapController;
  LatLng _selectedLocation = const LatLng(30.0444, 31.2357); // Cairo default
  String _address = '';
  String _area = '';
  bool _isLoading = false;
  bool _isGettingLocation = false;
  final _detailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _selectedLocation = widget.initialLocation!;
      _getAddressFromLatLng(_selectedLocation);
    } else {
      _getCurrentLocation();
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  // Get current GPS location
  Future<void> _getCurrentLocation() async {
    setState(() => _isGettingLocation = true);

    try {
      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showError('تم رفض صلاحية الموقع');
          setState(() => _isGettingLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showError('صلاحية الموقع مرفوضة نهائياً. فعّلها من الإعدادات.');
        setState(() => _isGettingLocation = false);
        return;
      }

      // Check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showError('خدمة الموقع مش مفعّلة. فعّلها من الإعدادات.');
        setState(() => _isGettingLocation = false);
        return;
      }

      // Get position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      final newLocation = LatLng(position.latitude, position.longitude);
      setState(() {
        _selectedLocation = newLocation;
        _isGettingLocation = false;
      });

      // Move camera to current location
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: newLocation, zoom: 17),
        ),
      );

      // Get address
      await _getAddressFromLatLng(newLocation);
    } catch (e) {
      setState(() => _isGettingLocation = false);
      _showError('مش قادر أحدد موقعك الحالي');
    }
  }

  // Convert coordinates to address
  Future<void> _getAddressFromLatLng(LatLng position) async {
    setState(() => _isLoading = true);

    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _area = [
            place.subLocality,
            place.locality,
            place.administrativeArea,
          ].where((s) => s != null && s.isNotEmpty).join('، ');

          _address = [
            place.street,
            place.subLocality,
            place.locality,
            place.administrativeArea,
            place.country,
          ].where((s) => s != null && s.isNotEmpty).join('، ');
        });
      }
    } catch (e) {
      setState(() {
        _address = '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
        _area = '';
      });
    }

    setState(() => _isLoading = false);
  }

  void _showError(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختر العنوان'),
        actions: [
          TextButton(
            onPressed: _address.isEmpty
                ? null
                : () {
                    final fullAddress = _detailsController.text.isNotEmpty
                        ? '$_address — ${_detailsController.text}'
                        : _address;

                    Navigator.pop(context, {
                      'address': fullAddress,
                      'area': _area,
                      'details': _detailsController.text,
                      'lat': _selectedLocation.latitude,
                      'lng': _selectedLocation.longitude,
                    });
                  },
            child: const Text('حفظ',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Map
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _selectedLocation,
                    zoom: 15,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  onTap: (latLng) {
                    setState(() => _selectedLocation = latLng);
                    _getAddressFromLatLng(latLng);
                  },
                  markers: {
                    Marker(
                      markerId: const MarkerId('selected'),
                      position: _selectedLocation,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueBlue),
                    ),
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                ),

                // Center crosshair
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 36),
                    child: Icon(Icons.location_on,
                        size: 42, color: Color(0xFF1565C0)),
                  ),
                ),

                // GPS Button
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.white,
                    onPressed: _isGettingLocation ? null : _getCurrentLocation,
                    child: _isGettingLocation
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location,
                            color: Color(0xFF1565C0)),
                  ),
                ),

                // Loading indicator
                if (_isLoading)
                  const Positioned(
                    top: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              SizedBox(width: 10),
                              Text('جاري تحديد العنوان...', style: TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Address Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Address display
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.location_on,
                          color: Color(0xFF1565C0), size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _area.isNotEmpty ? _area : 'اضغط على الخريطة لاختيار موقع',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          if (_address.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              _address,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Additional details
                TextField(
                  controller: _detailsController,
                  decoration: InputDecoration(
                    hintText: 'تفاصيل إضافية (رقم الشقة، الدور، علامة مميزة...)',
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                    prefixIcon: const Icon(Icons.apartment, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 14),

                // Confirm button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('تأكيد العنوان'),
                    onPressed: _address.isEmpty
                        ? null
                        : () {
                            final fullAddress =
                                _detailsController.text.isNotEmpty
                                    ? '$_address — ${_detailsController.text}'
                                    : _address;

                            Navigator.pop(context, {
                              'address': fullAddress,
                              'area': _area,
                              'details': _detailsController.text,
                              'lat': _selectedLocation.latitude,
                              'lng': _selectedLocation.longitude,
                            });
                          },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
