import 'package:flutter/material.dart';
import '../../core/di/injection_container.dart';
import '../../core/security/security_service.dart';

class PasscodeVerificationPage extends StatefulWidget {
  final Widget destination;

  const PasscodeVerificationPage({
    Key? key,
    required this.destination,
  }) : super(key: key);

  @override
  State<PasscodeVerificationPage> createState() => _PasscodeVerificationPageState();
}

class _PasscodeVerificationPageState extends State<PasscodeVerificationPage> {
  final TextEditingController _passcodeController = TextEditingController();
  final SecurityService _securityService = sl.get<SecurityService>();
  
  String? _passcodeError;
  bool _isCheckingBiometrics = false;
  
  @override
  void initState() {
    super.initState();
    _tryBiometricAuth();
  }
  
  Future<void> _tryBiometricAuth() async {
    final biometricsEnabled = await _securityService.isBiometricsEnabled();
    if (!biometricsEnabled) return;
    
    setState(() {
      _isCheckingBiometrics = true;
    });
    
    final success = await _securityService.authenticateWithBiometrics();
    
    if (mounted) {
      setState(() {
        _isCheckingBiometrics = false;
      });
      
      if (success) {
        _navigateToDestination();
      }
    }
  }

  @override
  void dispose() {
    _passcodeController.dispose();
    super.dispose();
  }

  Future<void> _verifyPasscode() async {
    setState(() {
      _passcodeError = null;
    });
    
    final passcode = _passcodeController.text;
    
    if (passcode.isEmpty) {
      setState(() {
        _passcodeError = 'Please enter your passcode';
      });
      return;
    }
    
    final isValid = await _securityService.verifyPasscode(passcode);
    
    if (mounted) {
      if (isValid) {
        _navigateToDestination();
      } else {
        setState(() {
          _passcodeError = 'Invalid passcode';
          _passcodeController.clear();
        });
      }
    }
  }
  
  void _navigateToDestination() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => widget.destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingBiometrics) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Authenticating with biometrics...'),
            ],
          ),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Passcode'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            const Icon(
              Icons.lock_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            const Text(
              'Enter your passcode to unlock RCHAT',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
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
              onSubmitted: (_) => _verifyPasscode(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _verifyPasscode,
              child: const Text('Unlock'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _tryBiometricAuth,
              child: const Text('Use Biometrics'),
            ),
          ],
        ),
      ),
    );
  }
}
