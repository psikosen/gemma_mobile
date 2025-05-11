import 'package:flutter/material.dart';
import '../../core/di/injection_container.dart';
import '../../core/security/security_service.dart';

class PasscodeSetupPage extends StatefulWidget {
  const PasscodeSetupPage({Key? key}) : super(key: key);

  @override
  State<PasscodeSetupPage> createState() => _PasscodeSetupPageState();
}

class _PasscodeSetupPageState extends State<PasscodeSetupPage> {
  final TextEditingController _passcodeController = TextEditingController();
  final TextEditingController _confirmPasscodeController = TextEditingController();
  final SecurityService _securityService = sl.get<SecurityService>();
  
  String? _passcodeError;
  String? _confirmPasscodeError;
  bool _isBiometricsAvailable = false;
  bool _useBiometrics = false;
  
  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }
  
  Future<void> _checkBiometrics() async {
    final available = await _securityService.isBiometricsAvailable();
    if (mounted) {
      setState(() {
        _isBiometricsAvailable = available;
      });
    }
  }

  @override
  void dispose() {
    _passcodeController.dispose();
    _confirmPasscodeController.dispose();
    super.dispose();
  }

  void _validatePasscode() {
    setState(() {
      _passcodeError = null;
      _confirmPasscodeError = null;
      
      final passcode = _passcodeController.text;
      final confirmPasscode = _confirmPasscodeController.text;
      
      if (passcode.isEmpty) {
        _passcodeError = 'Passcode cannot be empty';
        return;
      }
      
      if (passcode.length < 4) {
        _passcodeError = 'Passcode must be at least 4 characters';
        return;
      }
      
      if (confirmPasscode != passcode) {
        _confirmPasscodeError = 'Passcodes do not match';
        return;
      }
    });
  }

  Future<void> _savePasscode() async {
    _validatePasscode();
    
    if (_passcodeError != null || _confirmPasscodeError != null) {
      return;
    }
    
    // Save passcode
    await _securityService.setPasscode(_passcodeController.text);
    
    // Enable biometrics if selected
    if (_useBiometrics) {
      await _securityService.enableBiometrics();
    }
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passcode set successfully')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Passcode'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Create a passcode to secure your chats',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _passcodeController,
              decoration: InputDecoration(
                labelText: 'Passcode',
                errorText: _passcodeError,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 6,
              onChanged: (_) => setState(() => _passcodeError = null),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasscodeController,
              decoration: InputDecoration(
                labelText: 'Confirm Passcode',
                errorText: _confirmPasscodeError,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 6,
              onChanged: (_) => setState(() => _confirmPasscodeError = null),
            ),
            if (_isBiometricsAvailable) ...[
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Use Biometrics for Authentication'),
                value: _useBiometrics,
                onChanged: (value) {
                  setState(() {
                    _useBiometrics = value;
                  });
                },
              ),
            ],
            const Spacer(),
            ElevatedButton(
              onPressed: _savePasscode,
              child: const Text('Save Passcode'),
            ),
          ],
        ),
      ),
    );
  }
}
