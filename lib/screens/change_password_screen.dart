import 'package:flutter/material.dart';
import 'package:krishco/api_services/api_service.dart';
import 'package:krishco/utilities/cust_colors.dart';
import 'package:krishco/widgets/cust_dialog_box/cust_dialog_box.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends State<ChangePasswordScreen> {
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: const EdgeInsets.all(16),
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   border: Border.all(color: Colors.black12,style: BorderStyle.solid),
        //   borderRadius: BorderRadius.circular(12),
        //   // boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
        // ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '  Set a New Password',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Color(0xff0a6eff),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),
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
        prefixIcon: Icon(Icons.lock,color: CustColors.nile_blue,),
        suffixIcon: IconButton(
          icon: Icon(
              showPassword ? Icons.visibility : Icons.visibility_off,
          ),
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


// class ChangePasswordScreen extends StatefulWidget {
//   const ChangePasswordScreen({super.key});
//
//   @override
//   State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
// }
//
// class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
//   final _formKey = GlobalKey<FormState>();
//
//   final _currentController = TextEditingController();
//   final _newController = TextEditingController();
//   final _confirmController = TextEditingController();
//
//   bool _showCurrentPassword = false;
//   bool _showNewPassword = false;
//   bool _showConfirmPassword = false;
//   bool _isLoading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Change Password'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Update your password securely',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 24),
//
//               _passwordField(
//                 label: 'Current Password',
//                 controller: _currentController,
//                 showPassword: _showCurrentPassword,
//                 toggleVisibility: () =>
//                     setState(() => _showCurrentPassword = !_showCurrentPassword),
//                 validator: (val) => val == null || val.isEmpty
//                     ? 'Please enter current password'
//                     : null,
//               ),
//               const SizedBox(height: 16),
//
//               _passwordField(
//                 label: 'New Password',
//                 controller: _newController,
//                 showPassword: _showNewPassword,
//                 toggleVisibility: () =>
//                     setState(() => _showNewPassword = !_showNewPassword),
//                 validator: (val) {
//                   if (val == null || val.isEmpty) {
//                     return 'Please enter new password';
//                   } else if (val.length < 6) {
//                     return 'Must be at least 6 characters';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//
//               _passwordField(
//                 label: 'Confirm Password',
//                 controller: _confirmController,
//                 showPassword: _showConfirmPassword,
//                 toggleVisibility: () =>
//                     setState(() => _showConfirmPassword = !_showConfirmPassword),
//                 validator: (val) =>
//                 val != _newController.text ? 'Passwords do not match' : null,
//               ),
//               const SizedBox(height: 32),
//
//               _isLoading
//                   ? const Center(
//                 child: CircularProgressIndicator(),
//               )
//                   : Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       icon: const Icon(Icons.refresh),
//                       label: const Text('Reset'),
//                       onPressed: () {
//                         _formKey.currentState?.reset();
//                         _currentController.clear();
//                         _newController.clear();
//                         _confirmController.clear();
//                       },
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: FilledButton.icon(
//                       icon: const Icon(Icons.check),
//                       label: const Text('Change'),
//                       onPressed: _submit,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _passwordField({
//     required String label,
//     required TextEditingController controller,
//     required bool showPassword,
//     required VoidCallback toggleVisibility,
//     FormFieldValidator<String>? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       obscureText: !showPassword,
//       validator: validator,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         prefixIcon: const Icon(Icons.lock_outline),
//         suffixIcon: IconButton(
//           icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
//           onPressed: toggleVisibility,
//         ),
//       ),
//     );
//   }
//
//   void _submit() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => _isLoading = true);
//     final response = await APIService.getInstance(context).changePassword.changePassword(
//       currentPassword: _currentController.text,
//       newPassword: _newController.text,
//     );
//
//     if (response != null) {
//       final status = response['isScuss'];
//       final message = response['messages'] ?? 'Something went wrong';
//
//       CustDialog.show(context: context, message: message);
//
//       if (status) {
//         _formKey.currentState?.reset();
//         _currentController.clear();
//         _newController.clear();
//         _confirmController.clear();
//       }
//     }
//
//     setState(() => _isLoading = false);
//   }
// }
