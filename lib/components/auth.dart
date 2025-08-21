import 'package:bluesky/atproto.dart';
import 'package:bluesky/bluesky.dart';
import 'package:flutter/material.dart';
import 'package:lumina/pages/home_page.dart';

Future<void> main() async {
  // Let's authenticate here.
  final session = await createSession(
    identifier: BskyController.text, // Like "shinyakato.dev"
    password: pwController.text,
  );

  print(session);

  // Just pass created session data.
  final bsky = Bluesky.fromSession(session.data);
}

final pwController = TextEditingController();
final BskyController = TextEditingController();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (BskyController.text.isEmpty || pwController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both handle and password')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final session = await createSession(
        identifier: BskyController.text,
        password: pwController.text,
      );

      print(session);

      final bsky = Bluesky.fromSession(session.data);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Header
            const Text("Think it. Post it.",
               style: TextStyle(
                fontSize: 24 * 1.1,
                 fontWeight: FontWeight.w600,
                 ),
                ),

            const Text("Log in to your Bluesky account",
             style: TextStyle(
              fontSize: 18 * 1.2,
               fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 180, 180, 180)
                )
               ),

            const SizedBox(height: 40),

            // Bluesky Handle
            SizedBox(
              width: 320,
              height: 40,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Bluesky Handle',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                      color: Color.fromARGB(94, 68, 137, 255),
                      width: 3,
                  ),
                 ),
                 hintStyle: TextStyle(
                  color: Color.fromARGB(255, 180, 180, 180)
                 ),
                ),
                controller: BskyController,
              ),
            ),

            const SizedBox(height: 14,),

            // App Password
            SizedBox(
              width: 320,
              height: 40,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'App Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                      color: Color.fromARGB(94, 68, 137, 255),
                      width: 3,
                  ),
                 ),
                 hintStyle: TextStyle(
                  color: Color.fromARGB(255, 180, 180, 180)
                 ),
                ),
                obscureText: true,
                controller: pwController,
              ),
            ),

            const SizedBox(height: 40,),

            // Continue button
            InkWell(
              onTap: _isLoading ? null : _handleLogin,
              child: Container(
                width: 320,
                height: 40,
                decoration: BoxDecoration(
                  color: _isLoading 
                    ? const Color.fromARGB(255, 29, 133, 218).withOpacity(0.6)
                    : const Color.fromARGB(255, 29, 133, 218),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Center(
                  child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Continue",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}