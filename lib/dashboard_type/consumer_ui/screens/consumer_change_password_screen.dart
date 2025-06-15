import 'package:flutter/material.dart';
import 'package:krishco/api_services/api_service.dart';
import 'package:krishco/widgets/cust_dialog_box/cust_dialog_box.dart';

class ConsumerChangePasswordScreen extends StatefulWidget {
  const ConsumerChangePasswordScreen({super.key});

  @override
  State<ConsumerChangePasswordScreen> createState() =>
      _ConsumerChangePasswordScreenState();
}

class _ConsumerChangePasswordScreenState
    extends State<ConsumerChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Change Password',
                  style: TextStyle(
                    color: Color(0xff0a6eff),
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildPasswordField(
                        controller: _currentController,
                        hint: 'Current Password(*)',
                        showPassword: _showCurrentPassword,
                        toggleVisibility: () => setState(() =>
                        _showCurrentPassword = !_showCurrentPassword),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Current password is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildPasswordField(
                        controller: _newController,
                        hint: 'New Password(*)',
                        showPassword: _showNewPassword,
                        toggleVisibility: () =>
                            setState(() => _showNewPassword = !_showNewPassword),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'New password is required';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildPasswordField(
                        controller: _confirmController,
                        hint: 'Confirm Password(*)',
                        showPassword: _showConfirmPassword,
                        toggleVisibility: () => setState(() =>
                        _showConfirmPassword = !_showConfirmPassword),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _newController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      _isLoading ? Center(child: SizedBox.square(dimension: 25, child: CircularProgressIndicator())):Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildButton(
                            label: 'Reset',
                            iconData: Icons.sync,
                            color: const Color(0xffef5a5a),
                            hoverColor: const Color(0xffd94a4a),
                            onPressed: () {
                              _formKey.currentState!.reset();
                              _currentController.clear();
                              _newController.clear();
                              _confirmController.clear();
                            },
                          ),
                          const SizedBox(width: 16),
                          _buildButton(
                            label: 'Change',
                            iconData: Icons.check,
                            color: const Color(0xff0ac81f),
                            hoverColor: const Color(0xff0a9e1a),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                final changePasswordObj =
                                    APIService.getInstance(context).changePassword;
                                final response = await changePasswordObj
                                    .changePassword(
                                  currentPassword: _currentController.text,
                                  newPassword: _newController.text,
                                );
                                if (response != null) {
                                  final status = response['isScuss'];
                                  if (status) {
                                    CustDialog.show(
                                        context: context,
                                        message: response['messages'] ??'Password Changed Successfully');
                                    _formKey.currentState!.reset();
                                    _currentController.clear();
                                    _newController.clear();
                                    _confirmController.clear();
                                  } else {
                                    CustDialog.show(
                                        context: context,
                                        message: response['messages'] ??
                                            'Password not changed');
                                  }
                                }
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool showPassword,
    required VoidCallback toggleVisibility,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !showPassword,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(Icons.password),
        suffixIcon: IconButton(
          icon: Icon(
              showPassword ? Icons.visibility : Icons.visibility_off,
              color: const Color(0xff00004d)),
          onPressed: toggleVisibility,
        ),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff0a6eff), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildButton({
    required String label,
    required IconData iconData,
    required Color color,
    required Color hoverColor,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: ElevatedButton.icon(
        label: Text(label),
        icon: Icon(iconData),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(fontSize: 16),
        ).copyWith(
          overlayColor: MaterialStateProperty.all(hoverColor.withOpacity(0.8)),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
