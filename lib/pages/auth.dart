import 'package:flutter/material.dart';
import 'package:union_shop/widgets/header.dart';
import 'package:union_shop/widgets/footer.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AppHeader(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 48),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: DefaultTabController(
                        length: 2,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const TabBar(
                              labelColor: Color(0xFF4d2963),
                              unselectedLabelColor: Colors.black54,
                              tabs: [
                                Tab(text: 'Login'),
                                Tab(text: 'Sign Up'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 360,
                              child: TabBarView(
                                children: [
                                  // Login form
                                  _AuthLoginForm(),

                                  // Sign up form
                                  _AuthSignupForm(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}

class _AuthLoginForm extends StatefulWidget {
  @override
  State<_AuthLoginForm> createState() => _AuthLoginFormState();
}

class _AuthLoginFormState extends State<_AuthLoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _remember = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
                labelText: 'Email', border: OutlineInputBorder()),
            keyboardType: TextInputType.emailAddress,
            onSaved: (v) => _email = v ?? '',
          ),
          const SizedBox(height: 12),
          TextFormField(
            decoration: const InputDecoration(
                labelText: 'Password', border: OutlineInputBorder()),
            obscureText: true,
            onSaved: (v) => _password = v ?? '',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Checkbox(
                  value: _remember,
                  onChanged: (v) => setState(() => _remember = v ?? false)),
              const SizedBox(width: 8),
              const Text('Remember me'),
              const Spacer(),
              TextButton(
                  onPressed: () {}, child: const Text('Forgot password?')),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              _formKey.currentState?.save();
              // no-op: UI-only
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login submitted (UI only)')));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4d2963)),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14.0),
              child: Text('Sign In'),
            ),
          ),
          const SizedBox(height: 12),
          Center(
              child: TextButton(
                  onPressed: () =>
                      DefaultTabController.of(context).animateTo(1),
                  child: const Text('Don\'t have an account? Sign up'))),
        ],
      ),
    );
  }
}

class _AuthSignupForm extends StatefulWidget {
  @override
  State<_AuthSignupForm> createState() => _AuthSignupFormState();
}

class _AuthSignupFormState extends State<_AuthSignupForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
                labelText: 'Full name', border: OutlineInputBorder()),
            onSaved: (v) => _name = v ?? '',
          ),
          const SizedBox(height: 12),
          TextFormField(
            decoration: const InputDecoration(
                labelText: 'Email', border: OutlineInputBorder()),
            keyboardType: TextInputType.emailAddress,
            onSaved: (v) => _email = v ?? '',
          ),
          const SizedBox(height: 12),
          TextFormField(
            decoration: const InputDecoration(
                labelText: 'Password', border: OutlineInputBorder()),
            obscureText: true,
            onSaved: (v) => _password = v ?? '',
          ),
          const SizedBox(height: 12),
          TextFormField(
            decoration: const InputDecoration(
                labelText: 'Confirm password', border: OutlineInputBorder()),
            obscureText: true,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              _formKey.currentState?.save();
              // no-op: UI-only
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sign up submitted (UI only)')));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4d2963)),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14.0),
              child: Text('Create account'),
            ),
          ),
        ],
      ),
    );
  }
}
