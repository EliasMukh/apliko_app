// ignore_for_file: use_build_context_synchronously, duplicate_ignore, deprecated_member_use

import 'package:apliko/core/UI/router/router.gr.dart';
import 'package:apliko/core/UI/styles/styles.dart';

import 'package:apliko/features/authentication/domain/models/device.dart';
import 'package:apliko/features/authentication/presentation/cubit/auth_cubit.dart'
    show AuthCubit;
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controllers for the form fields
  final TextEditingController _deviceNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // List of devices
  List<DeviceModel> _devices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetch devices when the page loads
    _fetchDevices();
  }

  // ترجمة مستويات الصلاحيات
  String _getLocalizedAccessLevel(String accessLevel) {
    switch (accessLevel.toLowerCase()) {
      case 'owner':
        return 'Owner';
      case 'full':
        return '  Full';
      case 'readonly':
        return ' Read Only';
      default:
        return accessLevel;
    }
  }

  // إضافة دالة للتحقق من الصلاحيات
  bool _canManageAccess(String accessLevel) {
    return accessLevel.toLowerCase() == 'owner';
  }

  bool _canGetRegistrationKey(String accessLevel) {
    final level = accessLevel.toLowerCase();
    return level == 'owner' || level == 'full';
  }

  Future<void> _fetchDevices() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch devices using AuthCubit or a dedicated DeviceCubit if you create one
      final devices = await context.read<AuthCubit>().getDevices();
      setState(() {
        _devices = devices;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching devices: $e')));
    }
  }

  void _showAddDeviceDialog() {
    // Reset form fields
    _deviceNameController.clear();
    _descriptionController.clear();

    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 10 : 20,
            vertical: isSmallScreen ? 10 : 20,
          ),
          child: SingleChildScrollView(
            child: Container(
              width: isSmallScreen ? screenSize.width * 0.95 : 500,
              padding: EdgeInsets.all(isSmallScreen ? 15 : 20),
              decoration: BoxDecoration(
                color: const Color(0xFF0F3172),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blue.shade300, width: 1),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dialog header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Register New Device',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 16 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  SizedBox(height: isSmallScreen ? 15 : 20),

                  // Device name field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Device Name',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: _deviceNameController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Enter your device name',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: const Color(0xFF0F3172),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: isSmallScreen ? 12 : 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isSmallScreen ? 10 : 15),

                  SizedBox(height: isSmallScreen ? 10 : 15),

                  // Description field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Device Description',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: _descriptionController,
                        style: TextStyle(color: Colors.white),
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'Enter description for your device ',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: const Color(0xFF0F3172),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isSmallScreen ? 15 : 20),

                  // Register button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Validate inputs
                        if (_deviceNameController.text.trim().isEmpty ||
                            _descriptionController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please fill in all required fields',
                              ),
                            ),
                          );
                          return;
                        }

                        // Show loading indicator
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder:
                              (context) =>
                                  Center(child: CircularProgressIndicator()),
                        );

                        try {
                          // Create a DeviceModel object with the provided data
                          final deviceModel = DeviceModel(
                            id: '', // Will be populated by the server
                            name: _deviceNameController.text.trim(),
                            description: _descriptionController.text.trim(),
                            status: 'pending', // Default status
                            params: {},
                            userAccessLevel: '',
                          );

                          // Call the API to add device
                          final device = await context
                              .read<AuthCubit>()
                              .addDevice(deviceModel);

                          // Close loading dialog
                          Navigator.pop(context);

                          // Close the form dialog
                          Navigator.pop(context);

                          // Refresh devices list
                          setState(() {
                            _devices.add(device);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Device added successfully'),
                            ),
                          );
                        } catch (e) {
                          // Close loading dialog
                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error adding device: $e')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB6F15F),
                        padding: EdgeInsets.symmetric(
                          vertical: isSmallScreen ? 12 : 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'REGISTER',
                        style: TextStyle(
                          color: const Color(0xFF0F3172),
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 10 : 15),

                  // Help text
                  Text(
                    'If you have any questions about device registration, please refer to the user manual or contact our support team',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: isSmallScreen ? 10 : 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Method to get color based on device status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'online':
        return Colors.green;
      case 'offline':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Future<void> _navigateToSuperset(String deviceId) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => const Center(
              child: CircularProgressIndicator(color: Color(0xFFB6F15F)),
            ),
      );

      // Call API to get Superset link
      final either = await context.read<AuthCubit>().getSupersetLink(deviceId);

      // Close loading dialog
      Navigator.pop(context);

      either.fold(
        (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error getting Superset link: $error')),
          );
        },
        (linkData) {
          final link = linkData?['url_link'];
          if (link != null && link is String && link.isNotEmpty) {
            final url = Uri.parse(link);
            launchUrl(url, mode: LaunchMode.externalApplication);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Superset link not available for this device'),
              ),
            );
          }
        },
      );
    } catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    // Calculate grid crossAxisCount based on screen width
    int crossAxisCount = 1;
    if (size.width > 300) crossAxisCount = 2;
    if (size.width > 600) crossAxisCount = 3;
    if (size.width > 900) crossAxisCount = 4;
    if (size.width > 1200) crossAxisCount = 5;

    return Scaffold(
      backgroundColor: const Color(0xFF0F3172), // Dark blue background
      appBar:
          isSmallScreen
              ? AppBar(
                backgroundColor: const Color(0xFF1E3F85),
                title: const Text(
                  'My Devices',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                actions: [
                  // Refresh button
                  IconButton(
                    icon: Icon(Icons.refresh, color: Colors.white),
                    onPressed: _fetchDevices,
                  ),
                  // Exit button
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        // Logout logic
                        context.read<AuthCubit>().logout();
                        context.router.replace(LoginRoute());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB6F15F), // Neon yellow-green
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Log Out',
                          style: TextStyle(
                            color: Color(0xFF0F3172),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
              : null,
      body: SafeArea(
        child: Column(
          children: [
            // Header section for larger screens
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(children: [const Spacer()]),
            ),

            // Loading indicator
            if (_isLoading)
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFFB6F15F)),
                ),
              )
            else
              // Grid layout
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 10.0 : 16.0),
                  child: Column(
                    children: [
                      // Add Superset link button
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            // Если у нас есть хотя бы одно устройство, переходим в суперсет через это устройство
                            if (_devices.isNotEmpty &&
                                _devices[0].id.isNotEmpty) {
                              _navigateToSuperset(_devices[0].id);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'No devices available to access Superset',
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB6F15F),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'ПЕРЕЙТИ В SUPERSET',
                              style: TextStyle(
                                color: const Color(0xFF0F3172),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Devices grid
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: isSmallScreen ? 8 : 10,
                                mainAxisSpacing: isSmallScreen ? 8 : 10,
                                childAspectRatio: 1.0,
                              ),
                          itemCount:
                              _devices.length + 1, // +1 for the add button
                          itemBuilder: (context, index) {
                            // The first cell is the "Add" button
                            if (index == 0) {
                              return GestureDetector(
                                onTap: _showAddDeviceDialog,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFB6F15F,
                                    ), // Neon yellow-green
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.add,
                                      color: Color(0xFF0F3172),
                                      size: 40,
                                    ),
                                  ),
                                ),
                              );
                            }

                            // Display devices
                            final device = _devices[index - 1];
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFF2C4E9B),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xFF1E3F85).withOpacity(0.5),
                              ),
                              padding: EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // في جزء عرض الأجهزة في GridView.builder
                                  // نستبدل عرض الحالة بعرض مستوى الصلاحية:
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      color: const Color(0xFF0F3172),
                                    ),
                                    child: Text(
                                      _getLocalizedAccessLevel(
                                        device.userAccessLevel,
                                      ),
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  // Device name and status
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          device.name,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(device.status),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    device.description,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),

                                  Row(
                                    children: [
                                      // See more button
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () {
                                            context.router.push(
                                              DeviceDetailsRoute(
                                                device: device,
                                              ),
                                            );
                                          },
                                          style: buttonStyle(
                                            radius: 18,
                                            color: const Color(0xFFB6F15F),
                                          ),
                                          child: Text(
                                            'See More..',
                                            style: TextStyle(
                                              color: const Color(0xFF0F3172),
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Small space between buttons
                                      SizedBox(width: 4),

                                      // Superset button
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      // Floating action button for small screens
      floatingActionButton:
          isSmallScreen
              ? FloatingActionButton(
                onPressed: _showAddDeviceDialog,
                backgroundColor: const Color(0xFFB6F15F),
                child: const Icon(
                  Icons.add,
                  color: Color(0xFF0F3172),
                  size: 30,
                ),
              )
              : null,
    );
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
