// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: use_build_context_synchronously, file_names

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: unused_import
import 'package:apliko/core/UI/styles/styles.dart';
import 'package:apliko/features/authentication/domain/models/device.dart';
import 'package:apliko/features/authentication/presentation/cubit/auth_cubit.dart';

@RoutePage()
class DeviceDetailsPage extends StatefulWidget {
  final DeviceModel device;

  const DeviceDetailsPage({super.key, required this.device});

  @override
  State<DeviceDetailsPage> createState() => _DeviceDetailsPageState();
}

class _DeviceDetailsPageState extends State<DeviceDetailsPage> {
  // ترجمة مستويات الصلاحيات
  String _getLocalizedAccessLevel(String accessLevel) {
    switch (accessLevel.toLowerCase()) {
      case 'owner':
        return 'owner';
      case 'full':
        return 'full';
      case 'readonly':
        return 'readonly';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF0F3172,
      ), // Dark blue background like in the image
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3F85),
        title: Text(
          'Device ${widget.device.name}',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.router.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Device name section
            _buildInfoSection('Device', widget.device.name),

            const SizedBox(height: 16),

            // Description section
            _buildInfoSection('Descreption', widget.device.description),

            const SizedBox(height: 16),

            // Registration key section
            _buildInfoSection(
              'Register Key',
              widget.device.id,
            ), ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

            const SizedBox(height: 16),

            // Access Rights section - تم تعديله لعرض مستوى الصلاحية المترجم
            _buildInfoSection(
              'Authentics',
              _getLocalizedAccessLevel(widget.device.userAccessLevel),
            ),

            const SizedBox(height: 16),

            // // Parameters section
            // _buildInfoSection('Parameters', '-'),
            const SizedBox(height: 24),

            // تعديل عرض الأزرار حسب مستوى الصلاحية
            _buildActionButtons(),

            const SizedBox(height: 24),

            // Back button
            Center(
              child: TextButton.icon(
                onPressed: () => context.router.pop(),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                label: const Text(
                  'Back To All Devices',
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // تم تعديل عرض الأزرار حسب مستوى الصلاحية
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // عرض زر منح الوصول فقط للمالك
        if (_canManageAccess(widget.device.userAccessLevel))
          Expanded(child: _buildActionButton('Grant of authority')),

        // إضافة مسافة فقط إذا كان هناك زرين
        if (_canManageAccess(widget.device.userAccessLevel) &&
            _canGetRegistrationKey(widget.device.userAccessLevel))
          const SizedBox(width: 10),

        // عرض زر الحصول على مفتاح التسجيل للمالك أو وصول كامل
        if (_canGetRegistrationKey(widget.device.userAccessLevel))
          Expanded(child: _buildActionButton('Get the registration key')),
      ],
    );
  }

  Widget _buildInfoSection(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String text) {
    return ElevatedButton(
      onPressed: () {
        if (text == 'Grant of authority') {
          _showAccessDialog();
        } else if (text == 'Get the registration key') {
          // هنا يمكنك إضافة منطق الحصول على مفتاح التسجيل
          _showRegistrationKeyDialog();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFB6F15F),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF0F3172),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showAccessDialog() {
    // Controller for the email input
    final TextEditingController emailController = TextEditingController();

    // Access level selected (View only or Full access)
    String selectedAccess = 'ro'; // Default to read only

    // Create StatefulBuilder to manage state within dialog
    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: 400,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F3172), // Rich blue background
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dialog header with close button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Grant access rights',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Email field
                      const Text(
                        ' E_mail',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Enter E_mail Please',
                          hintStyle: TextStyle(
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.6),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white24),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white54),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          filled: true,
                          fillColor: Colors.blue.shade700,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Access level options
                      const Text(
                        'Validity level',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      const SizedBox(height: 10),

                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio<String>(
                                value: 'ro',
                                groupValue: selectedAccess,
                                onChanged: (value) {
                                  setState(() {
                                    selectedAccess = value!;
                                  });
                                },
                                activeColor: Colors.white,
                                fillColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                      (states) => Colors.white,
                                    ),
                              ),
                              const Text(
                                ' Read Only',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio<String>(
                                value: 'full',
                                groupValue: selectedAccess,
                                onChanged: (value) {
                                  setState(() {
                                    selectedAccess = value!;
                                  });
                                },
                                activeColor: Colors.white,
                                fillColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                      (states) => Colors.white,
                                    ),
                              ),
                              const Text(
                                ' Full Access',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Registration button
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            // في الـ confirm button handler
                            onPressed: () async {
                              final email = emailController.text.trim();
                              if (email.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please enter email address.',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              // التحقق من صحة الإيميل
                              if (!RegExp(
                                r'^[^@]+@[^@]+\.[^@]+',
                              ).hasMatch(email)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please enter a valid email address.',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              // عرض مؤشر التحميل
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder:
                                    (context) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                              );

                              try {
                                // استدعاء API
                                final result = await context
                                    .read<AuthCubit>()
                                    .grantDeviceAccess(
                                      widget.device.id,
                                      email,
                                      selectedAccess,
                                    );

                                // إغلاق مؤشر التحميل
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }

                                // إغلاق الحوار
                                Navigator.pop(context);

                                // عرض النتيجة
                                result.fold(
                                  (error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error: $error'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  },
                                  (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Access granted successfully to $email',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                );
                              } catch (e) {
                                // إغلاق مؤشر التحميل في حالة الخطأ
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Unexpected error: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB6F15F),
                              foregroundColor: Colors.blue.shade900,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: const Text(
                              'Confirm',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }

  void _showRegistrationKeyDialog() async {
    // عرض مؤشر التحميل
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // الحصول على مفتاح التسجيل من السيرفر
    final result = await context.read<AuthCubit>().getDeviceRegistrationKey(
      widget.device.id,
    );

    // إغلاق مؤشر التحميل
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    result.fold(
      // في حالة الخطأ
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      },
      // في حالة النجاح
      (registrationKey) {
        showDialog(
          context: context,
          builder:
              (context) => Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                  width: 400,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F3172),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.shade300, width: 1),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Register Key',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E3F85),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                registrationKey,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy, color: Colors.white),
                              onPressed: () {
                                // نسخ المفتاح إلى الحافظة
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Copy the key to the clipboard',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB6F15F),
                          foregroundColor: Colors.blue.shade900,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: const Text(
                          'Done',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        );
      },
    );
  }
}
