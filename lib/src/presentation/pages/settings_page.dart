import 'package:flutter/material.dart';
import '../../core/di/injection_container.dart';
import '../../core/security/security_service.dart';
import 'passcode_setup_page.dart';
import 'model_management_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SecurityService _securityService = sl.get<SecurityService>();
  bool _isPasscodeEnabled = false;
  bool _isBiometricsEnabled = false;
  bool _isBiometricsAvailable = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
    });

    final passcodeEnabled = await _securityService.isPasscodeEnabled();
    final biometricsEnabled = await _securityService.isBiometricsEnabled();
    final biometricsAvailable = await _securityService.isBiometricsAvailable();

    if (mounted) {
      setState(() {
        _isPasscodeEnabled = passcodeEnabled;
        _isBiometricsEnabled = biometricsEnabled;
        _isBiometricsAvailable = biometricsAvailable;
        _isLoading = false;
      });
    }
  }

  Future<void> _togglePasscode(bool value) async {
    if (value) {
      // Navigate to passcode setup
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PasscodeSetupPage(),
        ),
      );
      // Reload settings after returning
      _loadSettings();
    } else {
      // Disable passcode
      await _securityService.disablePasscode();
      await _securityService.disableBiometrics();
      _loadSettings();
    }
  }

  Future<void> _toggleBiometrics(bool value) async {
    if (value) {
      await _securityService.enableBiometrics();
    } else {
      await _securityService.disableBiometrics();
    }
    _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const ListTile(
                  title: Text(
                    'Security',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                SwitchListTile(
                  title: const Text('Enable Passcode'),
                  subtitle: const Text('Protect the app with a passcode'),
                  value: _isPasscodeEnabled,
                  onChanged: _togglePasscode,
                ),
                if (_isPasscodeEnabled && _isBiometricsAvailable)
                  SwitchListTile(
                    title: const Text('Enable Biometrics'),
                    subtitle:
                        const Text('Use fingerprint or face ID for authentication'),
                    value: _isBiometricsEnabled,
                    onChanged: _toggleBiometrics,
                  ),
                const Divider(),
                const ListTile(
                  title: Text(
                    'About',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('App Version'),
                  subtitle: const Text('1.0.0'),
                  trailing: const Icon(Icons.info_outline),
                  onTap: () {
                    // Show app info
                  },
                ),
                ListTile(
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to privacy policy
                  },
                ),
                const Divider(),
                const ListTile(
                  title: Text(
                    'AI Models',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Manage AI Models'),
                  subtitle: const Text('Download and manage local AI models'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ModelManagementPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
