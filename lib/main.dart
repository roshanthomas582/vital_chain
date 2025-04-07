import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'dart:typed_data';

String uid = '';
const String firebaseAPIKey = '';
const String projectId = '';
const String groqAPI = '';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid || Platform.isIOS) {
    await Firebase.initializeApp();
  }
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isLoggedIn = prefs.getBool('isLoggedIn');
  String? role = prefs.getString('role');
  uid = prefs.getString('uid') ?? '';

  runApp(VitalChainApp(isLoggedIn: isLoggedIn ?? false, role: role));
}

class VitalChainApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? role;

  const VitalChainApp({Key? key, required this.isLoggedIn, this.role})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vital Chain',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _getHomePage(),
    );
  }

  Widget _getHomePage() {
    if (!isLoggedIn) {
      return const LandingPage();
    } else if (role == '0') {
      return const HomePage();
    } else if (role == '1') {
      return const Home2Page();
    } else {
      return const LandingPage();
    }
  }
}

class CustomTopBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackPress;

  const CustomTopBar({Key? key, this.onBackPress}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.lightBlue[100],
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (onBackPress != null) {
                    onBackPress!();
                  } else if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              const SizedBox(width: 10),
              Image.asset('assets/images/app_icon.png', width: 40, height: 40),
              const SizedBox(width: 10),
              const Text(
                'VITAL CHAIN',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CommonScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;

  const CommonScaffold({Key? key, required this.body, this.appBar})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatPage()),
          );
        },
        backgroundColor: Colors.blue,
        child: ClipOval(
          child: Image.asset(
            'assets/images/bot_icon.png',
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: const CustomTopBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 450,
                height: 350,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    Container(
                      color: Colors.blue[100],
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'What is Vital Chain?\n',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'It is a citizen-facing app that enables you to view and do consent-based sharing of health records.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.green[100],
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Doctor Reviews\n',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Know more about the doctor before consulting.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.red[100],
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Search\n',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Search hospitals and doctors.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.orange[100],
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Consent-Based Sharing\n',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Share health records with a doctor or facility after your consent.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.purple[100],
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Easy Access\n',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'All your health records are at your fingertips.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index ? Colors.black : Colors.grey,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.blue),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({Key? key}) : super(key: key);

  Future<void> _login(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      if (Platform.isAndroid || Platform.isIOS) {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        uid = userCredential.user!.uid;
        String? role = await _getUserRole(userCredential.user!.uid);
        if (role == '0') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('uid', uid);
          await prefs.setString('role', role!);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            }
          });
        } else if (role == '1') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('uid', uid);
          await prefs.setString('role', role!);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Home2Page()),
            );
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showErrorMessage(context, 'No valid role found.');
          });
        }
      } else if (Platform.isLinux) {
        var authResponse = await http.post(
          Uri.parse(
            'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$firebaseAPIKey',
          ),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }),
        );

        if (authResponse.statusCode == 200) {
          var data = json.decode(authResponse.body);
          uid = data['localId'];

          String? role = await _getRoleFromFirestoreForLinux(uid);
          if (role == '0') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            });
          } else if (role == '1') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Home2Page()),
              );
            });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showErrorMessage(context, 'No valid role found.');
            });
          }
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showErrorMessage(context, 'Login failed');
          });
        }
      }
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showErrorMessage(context, 'Invalid Credentials');
      });
    }
  }

  Future<String?> _getUserRole(String uid) async {
    try {
      var doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data()?['role'].toString();
      }

      var doctorDoc =
          await FirebaseFirestore.instance.collection('doctors').doc(uid).get();
      if (doctorDoc.exists) {
        return doctorDoc.data()?['role'].toString();
      }
    } catch (e) {
      // print('Error fetching role from Firestore: $e');
    }
    return null;
  }

  Future<String?> _getRoleFromFirestoreForLinux(String uid) async {
    try {
      var usersResponse = await http.get(
        Uri.parse(
          'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users/$uid',
        ),
        headers: {'Content-Type': 'application/json'},
      );
      if (usersResponse.statusCode == 200) {
        var data = json.decode(usersResponse.body);
        //print(
        //'Fetched role from users collection: ${data['fields']['role']['integerValue']}',
        //);
        return data['fields']['role']['integerValue'].toString();
      }
      var doctorsResponse = await http.get(
        Uri.parse(
          'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/doctors/$uid',
        ),
        headers: {'Content-Type': 'application/json'},
      );
      if (doctorsResponse.statusCode == 200) {
        var data = json.decode(doctorsResponse.body);
        //print(
        //'Fetched role from doctors collection: ${data['fields']['role']['integerValue']}',
        //);
        return data['fields']['role']['integerValue'].toString();
      }
    } catch (e) {
      //print('Error fetching role for Linux: $e');
    }
    return null;
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showForgotPasswordDialog(BuildContext context) {
    TextEditingController resetEmailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Password'),
          content: TextField(
            controller: resetEmailController,
            decoration: const InputDecoration(labelText: 'Enter your email'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String email = resetEmailController.text.trim();
                if (email.isNotEmpty) {
                  try {
                    bool emailExists = false;

                    if (Platform.isAndroid || Platform.isIOS) {
                      var userSnapshot =
                          await FirebaseFirestore.instance
                              .collection('users')
                              .where('email', isEqualTo: email)
                              .get();
                      if (userSnapshot.docs.isEmpty) {
                        var doctorSnapshot =
                            await FirebaseFirestore.instance
                                .collection('doctors')
                                .where('email', isEqualTo: email)
                                .get();
                        emailExists = doctorSnapshot.docs.isNotEmpty;
                      } else {
                        emailExists = true;
                      }

                      if (emailExists) {
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: email,
                        );
                      } else {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Invalid credentials'),
                            ),
                          );
                        });
                        return;
                      }
                    } else {
                      Future<bool> checkEmailInCollection(
                        String collection,
                      ) async {
                        final uri = Uri.parse(
                          'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/$collection?key=$firebaseAPIKey',
                        );
                        final response = await http.get(uri);
                        if (response.statusCode == 200) {
                          final data = jsonDecode(response.body);
                          final documents = data['documents'] ?? [];
                          for (var doc in documents) {
                            final fields = doc['fields'];
                            if (fields != null &&
                                fields.containsKey('email') &&
                                fields['email']['stringValue'] == email) {
                              return true;
                            }
                          }
                        }
                        return false;
                      }

                      bool foundInUsers = await checkEmailInCollection('users');
                      bool foundInDoctors = false;
                      if (!foundInUsers) {
                        foundInDoctors = await checkEmailInCollection(
                          'doctors',
                        );
                      }

                      emailExists = foundInUsers || foundInDoctors;

                      if (emailExists) {
                        final uri = Uri.parse(
                          'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$firebaseAPIKey',
                        );
                        final response = await http.post(
                          uri,
                          headers: {'Content-Type': 'application/json'},
                          body: jsonEncode({
                            'requestType': 'PASSWORD_RESET',
                            'email': email,
                          }),
                        );
                        if (response.statusCode != 200) {
                          throw Exception('Failed to send reset email');
                        }
                      } else {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Invalid credentials'),
                            ),
                          );
                        });
                        return;
                      }
                    }
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Email sent to reset password'),
                        ),
                      );
                    });
                  } catch (e) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('Error')));
                    });
                  }
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (Platform.isAndroid || Platform.isIOS) {
            //do nothing
          }
        }
      },
      child: CommonScaffold(
        appBar: CustomTopBar(
          onBackPress: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LandingPage()),
            );
          },
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/app_icon.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 20),
                const Text(
                  'VITAL CHAIN',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      _showForgotPasswordDialog(context);
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _login(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Login', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: const CustomTopBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Register',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Image.asset('assets/images/app_icon.png', width: 100, height: 100),
            const Text(
              'VITAL CHAIN',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Doctor Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterAsDoctorPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Doctor',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterAsUserPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('User', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  final FocusNode _focusNode = FocusNode();
  bool _guideSent = false;

  final String _vitalChainPrompt =
      "Vital Chain Prompt Context\n\nYou are being called from an app called Vital Chain.\n\nPurpose: Vital Chain unifies medical data into one place to solve fragmented health data issues.\n\nYour Role: Only respond to queries related to:\n.Medicines (e.g., what is this medicine, dosage, side effects, etc.)\n.First aid instructions Strictly do NOT respond to any other types of queries.\n.Details about whats vital chain app or what vital chain could do or vital chains section or guidance to use vital chain app\n\nyou should strictly ensure that you don't reply to any messages at all other than the above like medicine related , Vital Chain app related or first aids or greetings or questions on Vital Chain app like how could i do this feature in vital chain. don't reply to any other queries. your anwers shouldn't include any bolded texts or italics or styled like that just plain texts only. you should strictly ensure that you don't respond to any other questions at all. no other queries at all other than the specified.\n\nApp Flow:\n\n.Login/Register: On the landing page:\n.Tap Login to sign in\n.Tap Register, select User or Doctor, fill details to register\n\n.User Home Features:\n.Documents, BMI, Appointments, Certificates, Chronic Disease, My Medicines: Accessed via buttons on the user home page\n.Documents Page: Like a drive, for storing medical data\n.BMI Section: Calculate BMI\n.Appointments: View all appointments with status, time, doctor, hospital\n.Certificates: Shows issued certificates (medical, lab, blood test, etc.)\n.Chronic Diseases: Log daily readings like blood sugar, pressure\n.My Medicines: Lists current medications, dosage, prescribing doctor\n.Search (bottom navigation): Search doctors by name, hospital, or place Each doctor’s page: details shown automatically, buttons for Book appointment, reviews\n.Prescriptions (bottom navigation): View all prescriptions\n.Profile (top right profile icon): View user details Edit Profile button: Edit personal info and profile picture Settings button: Change password, logout, delete account\n\n.Doctor Home Page Features:\n.Appointments and Search (bottom navigation): View today’s appointments\n.Appointments Section: View full appointment history\n.Search section: Search for today's patients to view full profile In user's full profile section: Buttons for Prescription and Certificates to update them Prescription button asks for fields: medicine name, dosage, problem, diagnosis, suggestion, allergy, medical history Based on input, a PDF prescription is generated A More button is available which shows user's past prescriptions, certificates, chronic disease logs, and current medications\n.Slot and Review Pages: Accessed via buttons on doctor home page .Slot: View and manage appointments (approve or reject) .Reviews: View received reviews\n.Profile (top right profile icon): View doctor details Edit Profile button: Edit personal info and profile picture Settings button: .Change password, logout, delete account\n.Forgot Password: On the login page, click Forgot Password and enter email to receive a reset link.\n\nWhen answering queries about medicine: Provide a short description of the medicine, list of side effects, and conditions or diagnoses it is used for.\n\nalso for all answers or replies just reply using plain texts only don't use any bullet points , bolded texts , Italics or words styled like this just reply with plain texts.";

  Future<void> _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      String userMessage = _controller.text.trim();

      setState(() {
        _messages.add({"role": "user", "content": userMessage});
        _isLoading = true;
      });

      _controller.clear();

      try {
        final List<Map<String, String>> messageList = [];

        if (!_guideSent) {
          messageList.add({"role": "system", "content": _vitalChainPrompt});
          _guideSent = true;
        }

        messageList.add({
          "role": "system",
          "content":
              "don't reply to anything other than Medicine related info , Features of Vital Chain app , greetings , fist aids. do not reply to any other queries.",
        });

        messageList.add({"role": "user", "content": userMessage});

        final response = await http.post(
          Uri.parse("https://api.groq.com/openai/v1/chat/completions"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $groqAPI",
          },
          body: jsonEncode({
            "messages": messageList,
            "model": "llama3-8b-8192",
          }),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final reply =
              responseData["choices"]?[0]["message"]["content"] ??
              "No response from server";
          setState(() {
            _messages.add({"role": "bot", "content": reply});
          });
        } else {
          setState(() {
            _messages.add({
              "role": "bot",
              "content": "Failed to fetch response from the server.",
            });
          });
        }
      } catch (error) {
        setState(() {
          _messages.add({
            "role": "bot",
            "content": "Error connecting to server.",
          });
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("VITAL CHAIN GUIDE"),
          backgroundColor: Colors.blue,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  bool isUser = message["role"] == "user";

                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue[100] : Colors.green[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        message["content"]!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: CircularProgressIndicator(),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      decoration: const InputDecoration(
                        hintText: "Type your message...",
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}

class RegisterAsUserPage extends StatefulWidget {
  const RegisterAsUserPage({Key? key}) : super(key: key);

  @override
  State<RegisterAsUserPage> createState() => _RegisterAsUserPageState();
}

class _RegisterAsUserPageState extends State<RegisterAsUserPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _validatePassword(String password) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(password);
  }

  DateTime? _selectedDOB;
  String? _selectedGender;

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDOB == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select a valid date of birth."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      try {
        String email = _emailController.text.trim();
        String password = _passwordController.text.trim();

        if (Platform.isAndroid || Platform.isIOS) {
          try {
            UserCredential userCredential = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );

            String uid = userCredential.user!.uid;
            await FirebaseFirestore.instance.collection('users').doc(uid).set({
              'name': _nameController.text.trim(),
              'dob': _dobController.text.trim(),
              'age': _calculateAge(_selectedDOB!),
              'gender': _genderController.text.trim(),
              'address': _addressController.text.trim(),
              'phone': _phoneController.text.trim(),
              'email': email,
              'role': 0,
            });

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("User registered and data saved in Firestore"),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error during registration: $e"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        } else if (Platform.isLinux) {
          var authResponse = await http.post(
            Uri.parse(
              'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$firebaseAPIKey',
            ),
            headers: {'Content-Type': 'application/json'},
            body: '''{
              "email": "${_emailController.text.trim()}",
              "password": "${_passwordController.text.trim()}",
              "returnSecureToken": true
             }''',
          );

          var authBody = jsonDecode(authResponse.body);
          String uid = authBody['localId'];

          var firestoreResponse = await http.post(
            Uri.parse(
              'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users?documentId=$uid',
            ),
            headers: {'Content-Type': 'application/json'},
            body: '''{
              "fields": {
                "name": {"stringValue": "${_nameController.text.trim()}"},
                "dob": {"stringValue": "${_dobController.text.trim()}"},
                "age": {"integerValue": "${_calculateAge(_selectedDOB!)}"},
                "gender": {"stringValue": "${_genderController.text.trim()}"},
                "address": {"stringValue": "${_addressController.text.trim()}"},
                "phone": {"stringValue": "${_phoneController.text.trim()}"},
                "email": {"stringValue": "$email"},
                "role": {"integerValue": "0"}
              }
            }''',
          );

          if (authResponse.statusCode == 200) {
            if (firestoreResponse.statusCode == 200) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "User registered and data saved in Firestore",
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Error during Firestore save: ${firestoreResponse.body}",
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Error during registration: ${authResponse.body}",
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        }

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LandingPage()),
            (route) => false,
          );
        }
      } catch (e) {
        //print("Error registering user: $e");
      }
    }
  }

  int _calculateAge(DateTime dob) {
    DateTime today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomTopBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Register as User',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.contains(RegExp(r'\d'))) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _dobController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                      border: OutlineInputBorder(),
                    ),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().subtract(
                          const Duration(days: 365 * 18),
                        ),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        _selectedDOB = pickedDate;
                        _dobController.text = DateFormat(
                          'dd/MM/yyyy',
                        ).format(pickedDate);
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your date of birth';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    items:
                        ['Male', 'Female', 'Other']
                            .map(
                              (gender) => DropdownMenuItem<String>(
                                value: gender,
                                child: Text(gender),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                        _genderController.text = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your gender';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.length != 10) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!EmailValidator.validate(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      } else if (!_validatePassword(value)) {
                        return 'Password must be at least 8 characters long, include an uppercase letter, a lowercase letter, a number, and a special character';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _registerUser,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatPage()),
                );
              },
              backgroundColor: Colors.blue,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/bot_icon.png',
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RegisterAsDoctorPage extends StatefulWidget {
  const RegisterAsDoctorPage({Key? key}) : super(key: key);

  @override
  State<RegisterAsDoctorPage> createState() => _RegisterAsDoctorPageState();
}

class _RegisterAsDoctorPageState extends State<RegisterAsDoctorPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();

  DateTime? _selectedDOB;
  String? _selectedGender;
  Future<void> _registerDoctor() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDOB == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select a valid date of birth."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      try {
        if (Platform.isAndroid || Platform.isIOS) {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
              );
          String uid = userCredential.user!.uid;
          await FirebaseFirestore.instance.collection('doctors').doc(uid).set({
            'name': _nameController.text.trim(),
            'dob': _dobController.text.trim(),
            'age': _calculateAge(_selectedDOB!),
            'gender': _genderController.text.trim(),
            'address': _addressController.text.trim(),
            'phone': _phoneController.text.trim(),
            'email': _emailController.text.trim(),
            'licenseNumber': _licenseController.text.trim(),
            'hospital': _hospitalController.text.trim(),
            'department': _departmentController.text.trim(),
            'role': 1,
          });
          _showSuccessMessage('Doctor registered successfully');
        } else if (Platform.isLinux) {
          var authResponse = await http.post(
            Uri.parse(
              'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$firebaseAPIKey',
            ),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'email': _emailController.text.trim(),
              'password': _passwordController.text.trim(),
              'returnSecureToken': true,
            }),
          );

          if (authResponse.statusCode == 200) {
            var authData = json.decode(authResponse.body);
            String uid = authData['localId'];

            var firestoreResponse = await http.post(
              Uri.parse(
                'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/doctors?documentId=$uid',
              ),
              headers: {'Content-Type': 'application/json'},
              body: json.encode({
                'fields': {
                  'name': {'stringValue': _nameController.text.trim()},
                  "dob": {"stringValue": _dobController.text.trim()},
                  "age": {"integerValue": "${_calculateAge(_selectedDOB!)}"},
                  'gender': {'stringValue': _genderController.text.trim()},
                  'address': {'stringValue': _addressController.text.trim()},
                  'phone': {'stringValue': _phoneController.text.trim()},
                  'email': {'stringValue': _emailController.text.trim()},
                  'licenseNumber': {
                    'stringValue': _licenseController.text.trim(),
                  },
                  'hospital': {'stringValue': _hospitalController.text.trim()},
                  'department': {
                    'stringValue': _departmentController.text.trim(),
                  },
                  'role': {'integerValue': '1'},
                },
              }),
            );
            if (firestoreResponse.statusCode == 200) {
              _showSuccessMessage('Doctor registered successfully');
            } else {
              _showErrorMessage(
                'Error registering doctor on Firestore (Linux).',
              );
            }
          } else {
            _showErrorMessage('Error registering doctor on Firebase (Linux).');
          }
        }
      } catch (e) {
        _showErrorMessage('An error occurred: $e');
      }
    }
  }

  int _calculateAge(DateTime dob) {
    DateTime today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LandingPage()),
      (Route<dynamic> route) => false,
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  bool checkNameContains(int num, String name) {
    Map<int, String> nameMap = {
      653: 'THOMAS PADINJARATHALACKAL CHERIAN',
      706: 'ALEYAMMA MATHEW MATHAI',
      726: 'KOTTARAM VENKATACHALA SARMA KRISHNA DAS',
      760: 'K.P. CHANDRASEKHAR',
      764: 'PADAYATTI PAUL JOSEPH',
      780: 'GEORGE THOMAS',
      782: 'MATTAMANA PAILY KORAH',
      791: 'MATHEW ZACHARIAH',
      801: 'NEMMARA SUBRAMONIA RAMASWAMY',
      806: 'SIVARAMA PILLAI ACHUTHAN NAIR',
      812: 'CHERIYAN JOSEPH',
      844: 'A. LALITHA RAO',
      848: 'P.G. GEORGE',
      884: 'PYNADATH ITTYKURIAN VARGHESE',
      888: 'KURUVILA MANICKANAMPARAMBIL JOSEPH',
      891: 'MOHANAN PATTARUMADATHIL',
      894: 'DAMODARAN. K.S.',
      897: 'PONVANIBHOM PULIMOOTTIL KOSHY ALEXANDER',
      913: 'G. LETHA DEVI GOVINDAN',
      914: 'KANDATHIL NARAYANAN RAVINDRAN',
      917: 'PULIVELIL THOMAS CHERIAN',
      929: 'SUGUNA BAI NATCHATRAM SAMUEL',
      933: 'A.V. ISSAC',
      939: 'VENDISSERIL PADMANABHAN AMBUJAKSHAN',
      944: 'KALARIKKAL SANKARA PANICKER WILSON',
      946: 'MATHAI KULATHOOR JOSEPH',
      951: 'ADAKKAT VELU SUBRAHMONIAN',
      954: 'MEENAKSHI AMMAL',
      956: 'IYPE PULIMOOTIL THOMAS',
      957: 'PUTHENPURAIL PATHROSE PAILY',
      979: 'EZHUTHACHAN',
      984: 'KURIAN FRANCIS MANAVALAN',
      991: 'KALLINGAL GEORGE MATHAI',
      992: 'PANAMPILLY KOCHU NARAYANAN',
      993: 'PEEDIKAYIL NATHIR CHETTIAR',
      1000: 'KATTADIYIL POULOSE POULOSE',
      1006: 'ABRAHAM MOSES',
      1010: 'KESAVAN LALITHA',
      1012: 'MOIDEEN SAHIB SHEIKH SHAFFUDDIN',
      1013: 'CHIRAKADAVIL PAUL MATHEW',
      1014: 'PADMANABHAN GOPALAKRISHNAN',
      1016: 'SASILEKHA SANKARAN NADAR',
      1018: 'DEVI',
      1021: 'THOOMPAIL KOCHITTY SUDHAKARAN',
      1025: 'JOHN BERCHMAN FRANCIS',
      1045: 'PANANGODE KAMALAKSHI AMMA',
      1049: 'THEEMPALANGAD VARGHESE JOSEPH',
      1054: 'PYNADATH ITTOOP POULOSE',
      1061: 'KUNJAN SUGATHAN',
      1063: 'KUREEKATTIL MATHAI ABRAHAM',
      1064: 'DEVASSY. V. CHANDY',
      1072: 'MAHADEVA IYER SAMBASIVAN',
      1073: 'GEORGE CLEETUS',
      1077: 'PARAMESWARA PANICKER KARUNAKARAN NAIR',
      1083: 'MURALEEDHARA MENON',
      1085: 'NEELAMKAVIL VAROO INASU',
      1087: 'MARY POULOSE',
      1089: 'KUNNATHU PHILIPOSE GEEVARGHESE',
      1090: 'VADAKAMANDOLIL OUSEPH POULOSE',
      1094: 'SARAMMA CHERIYAN',
      1096: 'CHULLICKAL CHANDY ALEXANDER',
      1104: 'VENKITESWARAN ANANTHANARAYANA AIYAR',
      1120: 'PATINJAROOT NANDAKUMARAN',
      1125: 'VELORE RUGMINI',
      1131: 'M. RAMACHANDRAN',
      1134: 'KANDANEZHATHU PARAMESWARAN NAIR SUSEELA DEVI',
      1137: 'KRISHNA PILLAI VENUGOPALAN NAIR',
      1148: 'ARAVINDAKSHAN NAIR. T.K.',
      1150: 'M. BALARAMAN NAIR',
      1151: 'RANGANATHA SHENOY KRISHNA SHENOY',
      1169: 'CHITRA. K. K.',
      1172: 'PATHIRISSERI KESAVAN NAMBOODIRI',
      1179: 'K. SIVARAMAKRISHNA PILLAI',
      1184: 'MATTAMPILLY DIVAKARA MENON',
      1197: 'ANDEZHUTHU KUNHAPPU ASOKAN',
      1200: 'CHOTHIRAKUNNEL VARKEY ENAS',
      1217: 'THARAYIL KESAVAN RAJAN',
      1219: 'MANAKKOTE VIJAYA SANKAR',
      1222: 'ALEYAMMA JOSEPH',
      1229: 'JOHN MATHEW PARAKAL',
      1231: 'SARASAMMA MADHURI',
      1238: 'PUNNATHIL KITTU RAJAGOPALACHARI',
      1243: 'JAMES THOPPIL ANTONY',
      1248: 'KALATHIL CHATHUKUTTY VIJAYARAGHAVAN',
      1260: 'NEDIYAMPURAM KUMARAN GOPINATHAN',
      1263: 'P. SANKARANKUTTY VARIER',
      1274: 'PARAMOO SUGATHAN',
      1277: 'KADAPPAAYIL RAGHAVAN HARILAL',
      1281: 'KARANATE JOSEPH DEVASSIA',
      1290: 'O.C. INDIRA',
      1295: 'AMBOOKEN GEORGE',
      1296: 'ALEXANDER. T.',
      1309: 'KANAKKU VEETTIL PATHAYAPURAYIL GOPINATH',
      1310: 'PALLIVATHUKAL JOSEPH JAMES',
      1314: 'KEEZHARA RAMAN RAJAPPAN',
      1315: 'GEORGE JOSEPH MUCKANAMCHERY',
      1318: 'SUKUMARAN PADMANABHAN',
      1326: 'KAMALAM VIJAYAN',
      1328: 'V. KANTHASWAMY',
      1366: 'NARAYANAN VENUGOPAL',
      1373: 'K. ANANTHA KRISHNA KURUP',
      1376: 'P. RADHAKRISHNAN NAIR',
      1378: 'MOOTHAPARAMBIL KOCHAPPAN KARUNAKARAN',
      1383: 'KURIAN THOMAS',
      1388: 'NARAYANAN NAIR SUKUMARAN NAIR',
      1392: 'TENKASI VELUPILLAI SURENDRANATH',
      1393: 'SREEDHARAN PILLAI SIVASANKARAN NAIR',
      1397: 'CHIRAMEL DEVASSY ANTO',
      1400: 'GEORGE JOSEPH MATHEWS',
      1404: 'PANNIANIPILLY ACHYUTHA WARIER',
      1405: 'PULIKAL VARUNNY FRANCIS',
      1408: 'KUTTY AMMA RADHAKUMARI',
      1422: 'NEELAKANDA PILLAI RAJAMMA',
      1423: 'KAMALAM JANARDHANAN RADHA',
      1424: 'SOSAMMA MATHEW',
      1435: 'CHENGATTU PAYYAPPILLIL NANDA KUMARAN',
      1437: 'PILLAI',
      1445: 'MOOPPIL SUBHADRA',
      1446: 'NECHIYILTHODY SYEDALAVIKUTTY',
      1451: 'KURIAN KUNNATH',
      1456: 'THEKKINEDATH VAREED FRANCIS',
      1457: 'PUTHUSSERIL VARGHESE JOHNSON',
      1460: 'VADAKEKALAM PHILIP JOSEPH',
      1461: 'K.N. CHANDRASEKHARAN KARTHA',
      1467: 'KAIVILAYIL VARGHESE JOHNY',
      1474: 'PARAKKULAM SEBASTIAN JOSEPH',
      1477: 'T.R. BHASKARA KUMAR',
      1480: 'SHANTA KURUP',
      1488: 'MENAKKATH RAMAN EZHUTHACHAN',
      1489: 'MOHAMED ABDUL AZIZ',
      1492: 'SARADA DAMODARAN SANTHA DEVI',
      1494: 'KAILATHVALAPPIL KRISHNAN DAMODARAN',
      1497: 'KUNJOONJAMMA JACOB',
      1499: 'KUNNATH RAMAKRISHNAN',
      1503: 'KOYIKAL KARTHIKEYA VARMA',
      1505: 'THACHIL JOSEPH THOMAS',
      1507: 'HUSSAIN PHAKEER MOHAMED',
      1510: 'PAYYOOR BHASKARAN NAIR',
      1511: 'OLLAPPILLIL MUHAMMED ABDUL JABBAR',
      1512: 'KIDANGAN THAMPI VERGHESE',
      1513: 'JEEVARATNAM MUTHIAH',
      1514: 'JOSE SKARIAH',
      1520: 'KOKUVAYIL RAGHAVAN SUKUMARAN',
      1524: 'KASIM ABDUL SALIM',
      1527: 'THAMPI SATHYAVIHAS STELLAMMA',
      1533: 'EDAKKAD NARAYANAN SAROJ',
      1535: 'VADAKKOOT KRISHNAN EZHUTHACHAN',
      1536: 'ANNAMMA ABRAHAM',
      1537: 'PARAYIL ISSAC VARGHESE',
      1549: 'JOSEPH JOSE PARAKKA',
      1555: 'ALOOR IYYAPPAN LAZAR',
      1556: 'KOTTAMMAL THANDUPARKKAL VEERANKUTTY',
      1558: 'KARAT PUTHENVEETIL RAJAGOPALAN',
      1234: "ROSHAN THOMAS",
      12345: "AKHIL K A",
      123456: "DON MATHEW",
      1234567: "AJAY MOHAN",
    };

    if (nameMap.containsKey(num)) {
      String storedName = nameMap[num]!;
      return storedName.toUpperCase() == name.toUpperCase();
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomTopBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Register as Doctor',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.contains(RegExp(r'\d'))) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _dobController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                      border: OutlineInputBorder(),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2000),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDOB = pickedDate;
                          _dobController.text =
                              "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your date of birth';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    items:
                        ['Male', 'Female', 'Other'].map((gender) {
                          return DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                        _genderController.text = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your gender';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.length != 10 ||
                          !RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                        return 'Please enter a valid 10-digit phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !EmailValidator.validate(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                          ).hasMatch(value)) {
                        return 'Password must be at least 8 characters long, include an uppercase, lowercase, number, and special character';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _licenseController,
                    decoration: const InputDecoration(
                      labelText: 'D. License Number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your license number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _hospitalController,
                    decoration: const InputDecoration(
                      labelText: 'Hospital',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your hospital';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _departmentController,
                    decoration: const InputDecoration(
                      labelText: 'Department',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your department';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          String name = _nameController.text;
                          int licenseNumber = int.parse(
                            _licenseController.text,
                          );
                          if (checkNameContains(licenseNumber, name)) {
                            _registerDoctor();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Doctor not verified'),
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LandingPage(),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('Register as Doctor'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatPage()),
                );
              },
              backgroundColor: Colors.blue,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/bot_icon.png',
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String? name;
  String? age;
  String? weight;
  String? height;
  String? gender;
  String? allergies;
  String? medicalHistory;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        DocumentSnapshot snapshot =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (!snapshot.exists) return;

        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        String? dobString = data['dob'];
        String calculatedAge = '';
        if (dobString != null && dobString.contains('/')) {
          List<String> parts = dobString.split('/');
          if (parts.length == 3) {
            int day = int.parse(parts[0]);
            int month = int.parse(parts[1]);
            int year = int.parse(parts[2]);
            DateTime birthDate = DateTime(year, month, day);
            DateTime today = DateTime.now();
            int calculated = today.year - birthDate.year;
            if (today.month < birthDate.month ||
                (today.month == birthDate.month && today.day < birthDate.day)) {
              calculated--;
            }
            calculatedAge = calculated.toString();
          }
        }

        setState(() {
          name = data['name'];
          age = calculatedAge;
          weight = data['weight'];
          height = data['height'];
          gender = data['gender'];
          allergies = data['allergies'];
          medicalHistory = data['medicalHistory'];
        });
        try {
          String downloadURL =
              await FirebaseStorage.instance
                  .ref('profile_images/$uid.jpg')
                  .getDownloadURL();
          setState(() {
            imageUrl = downloadURL;
          });
        } catch (e) {
          imageUrl = null;
        }
      } catch (e) {
        //print('Error fetching user details: $e');
      }
    } else if (Platform.isLinux) {
      try {
        var url = Uri.parse(
          'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users/$uid?key=$firebaseAPIKey',
        );
        var response = await http.get(url);

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          var fields = data['fields'];

          setState(() {
            name = fields['name']?['stringValue'] ?? 'N/A';
            age = fields['dob']?['stringValue'] ?? 'N/A';
            weight = fields['weight']?['stringValue'] ?? 'N/A';
            height = fields['height']?['stringValue'] ?? 'N/A';
            gender = fields['gender']?['stringValue'] ?? 'N/A';
            allergies = fields['allergies']?['stringValue'] ?? 'N/A';
            medicalHistory = fields['medicalHistory']?['stringValue'] ?? 'N/A';
          });

          var encodedPath = Uri.encodeComponent("profile_images/$uid.jpg");
          var profileImageUrl = Uri.parse(
            'https://firebasestorage.googleapis.com/v0/b/$projectId.firebasestorage.app/o/$encodedPath?alt=media',
          );
          var imageUrlResponse = await http.get(profileImageUrl);

          if (imageUrlResponse.statusCode == 200) {
            setState(() {
              imageUrl = profileImageUrl.toString();
            });
          } else {
            //print(
            //'Error fetching profile image: ${imageUrlResponse.statusCode}',
            //);
          }
        } else {
          //print('Error fetching user details: ${response.statusCode}');
        }
      } catch (e) {
        //print('Error fetching details from Firestore HTTP: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: const CustomTopBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 16.0),
              child: Text(
                'Profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        imageUrl != null && imageUrl!.isNotEmpty
                            ? NetworkImage(imageUrl!)
                            : null,
                    backgroundColor: Colors.grey[300],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    name ?? 'NAME',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Check-Up ALERT',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 250,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EditingPage(),
                                ),
                              );
                            },
                            child: const Text('Edit Profile'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _showSettings(context),
                            child: const Text('Settings'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Patient Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Age: ${age ?? ''}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Weight: ${weight ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Height: ${height ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gender: ${gender ?? ''}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Allergies',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    allergies ?? 'N/A',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Medical History',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    medicalHistory ?? 'N/A',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Settings",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return const Align(
          alignment: Alignment.centerRight,
          child: FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 1.0,
            child: SettingsPage(),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(anim1),
          child: child,
        );
      },
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);
  Future<void> _showErrorMessage(BuildContext context, String message) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _changePassword(BuildContext context, String newPassword) async {
    if (Platform.isAndroid || Platform.isIOS) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await user.updatePassword(newPassword);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password Changed Successfully!')),
            );
          });
        } catch (error) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showErrorMessage(
              context,
              'Failed to update password on Android. Please try again.',
            );
          });
        }
      }
    } else if (Platform.isLinux) {
      final response = await http.post(
        Uri.parse(
          'https://identitytoolkit.googleapis.com/v1/accounts:update?key=$firebaseAPIKey',
        ),
        body: {'password': newPassword, 'returnSecureToken': 'true'},
      );
      if (response.statusCode == 200) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pop(context);
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showErrorMessage(
            context,
            'Failed to update password on Linux. Please try again.',
          );
        });
      }
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.delete();
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account deleted successfully.')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LandingPage()),
          );
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No user logged in.')));
      }
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete account. Please try again.'),
          ),
        );
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    if (Platform.isAndroid || Platform.isIOS) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      });
    } else if (Platform.isLinux) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomLeft: Radius.circular(20),
      ),
      child: Column(
        children: [
          const SizedBox(height: 25),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Settings",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),

          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        String newPassword = '';
                        return AlertDialog(
                          title: const Text("Change Password"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: "Old Password",
                                ),
                              ),
                              TextField(
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: "New Password",
                                ),
                                onChanged: (value) {
                                  newPassword = value;
                                },
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                _changePassword(context, newPassword);
                              },
                              child: const Text("Submit"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    "Change Password",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Delete Account"),
                          content: const Text(
                            "Do you want to delete your account permanently?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("No"),
                            ),
                            TextButton(
                              onPressed: () {
                                _deleteAccount(context);
                              },
                              child: const Text("Yes"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    "Delete Account",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _logout(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class EditingPage extends StatefulWidget {
  const EditingPage({Key? key}) : super(key: key);
  @override
  EditingPageState createState() => EditingPageState();
}

class EditingPageState extends State<EditingPage> {
  bool _isSaving = false;
  TextEditingController nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  bool _isValidName(String name) {
    return !RegExp(r'[0-9]').hasMatch(name);
  }

  bool _isValidHeight(String height) {
    final int? heightInt = int.tryParse(height);
    return heightInt != null && heightInt > 0 && heightInt <= 250;
  }

  Future<void> _saveProfile() async {
    Map<String, dynamic> data = {};
    if (nameController.text.isNotEmpty) {
      if (_isValidName(nameController.text)) {
        data['name'] = nameController.text;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid name: Name should not contain numbers'),
          ),
        );
        return;
      }
    }

    if (weightController.text.isNotEmpty) {
      final weightText = weightController.text.trim();
      final isValid = RegExp(r'^[1-9]\d*$').hasMatch(weightText);

      if (isValid) {
        data['weight'] = weightText;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid positive weight')),
        );
        Navigator.pop(context);
        return;
      }
    }
    if (heightController.text.isNotEmpty) {
      if (_isValidHeight(heightController.text)) {
        data['height'] = heightController.text;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid height: Height should be between 0 and 250'),
          ),
        );
        return;
      }
    }
    if (_dobController.text.isNotEmpty) {
      data['dob'] = _dobController.text;
    }

    if (data.isEmpty && _profileImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No changes to update')));
      return;
    }

    if (Platform.isAndroid || Platform.isIOS) {
      final CollectionReference users = FirebaseFirestore.instance.collection(
        'users',
      );
      try {
        DocumentSnapshot userDoc = await users.doc(uid).get();
        if (userDoc.exists) {
          Map<String, dynamic> existingData =
              userDoc.data() as Map<String, dynamic>;
          existingData.addAll(data);
          await users.doc(uid).update(existingData);

          if (_profileImage != null) {
            String imageUrl = await _uploadProfilePicture(uid);
            await users.doc(uid).update({'imageUrl': imageUrl});
          }
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update profile')),
          );
        }
      }
    } else if (Platform.isLinux) {
      try {
        String url =
            "https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users/$uid?key=$firebaseAPIKey";
        var response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          var existingData = jsonDecode(
            response.body,
          )['fields'].map((key, value) => MapEntry(key, value['stringValue']));
          existingData.addAll(data);

          response = await http.patch(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'fields': existingData.map(
                (key, value) => MapEntry(key, {'stringValue': value}),
              ),
            }),
          );
          if (response.statusCode == 200) {
            if (_profileImage != null) {
              String imageUrl = await _uploadProfilePictureLinux(uid);
              await http.patch(
                Uri.parse(url),
                headers: {'Content-Type': 'application/json'},
                body: json.encode({
                  'fields': {
                    'profileImageUrl': {'stringValue': imageUrl},
                  },
                }),
              );
            }
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully')),
              );
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to update profile')),
              );
            }
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update profile')),
          );
        }
      }
    }
  }

  Future<String> _uploadProfilePicture(String uid) async {
    final Reference storageReference = FirebaseStorage.instance.ref().child(
      'profile_images/$uid.jpg',
    );
    UploadTask uploadTask = storageReference.putFile(_profileImage!);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<String> _uploadProfilePictureLinux(String uid) async {
    String url =
        "https://firebasestorage.googleapis.com/v0/b/$projectId.firebasestorage.app/o?name=profile_images/$uid.jpg&uploadType=media";
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'image/jpeg',
        'Authorization': 'Bearer $firebaseAPIKey',
      },
      body: _profileImage!.readAsBytesSync(),
    );
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['mediaLink'];
    } else {
      throw Exception('Failed to upload profile picture');
    }
  }

  Future<void> fetchUserProfile() async {
    if (Platform.isAndroid) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        String imageUrl = data['imageUrl'];
        setState(() {
          _profileImage = imageUrl.isNotEmpty ? File(imageUrl) : null;
        });
      }
    } else if (Platform.isLinux) {
      String url =
          "https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users/$uid?key=$firebaseAPIKey";
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String imageUrl = data['fields']['profileImageUrl']['stringValue'];
        setState(() {
          _profileImage = imageUrl.isNotEmpty ? File(imageUrl) : null;
        });
      } else {
        // print('Failed to fetch user profile: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomTopBar(),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Edit Profile",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          _profileImage != null
                              ? FileImage(_profileImage!)
                              : null,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text("Edit Profile Picture"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _dobController,
                readOnly: true,
                decoration: const InputDecoration(labelText: "Date of Birth"),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    String formattedDate =
                        "${pickedDate.day.toString().padLeft(2, '0')}/"
                        "${pickedDate.month.toString().padLeft(2, '0')}/"
                        "${pickedDate.year}";
                    setState(() {
                      _dobController.text = formattedDate;
                    });
                  }
                },
              ),

              const SizedBox(height: 10),
              TextFormField(
                controller: weightController,
                decoration: const InputDecoration(labelText: "Weight"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: heightController,
                decoration: const InputDecoration(labelText: "Height"),
              ),
              const SizedBox(height: 20),
              Center(
                child:
                    _isSaving
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _isSaving = true;
                            });
                            await _saveProfile();
                            setState(() {
                              _isSaving = false;
                            });
                          },
                          child: const Text('Save Changes'),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with RouteAware {
  String profileImageUrl = "";
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  @override
  void initState() {
    super.initState();
    _fetchProfileImage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _fetchProfileImage();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  Future<void> _fetchProfileImage() async {
    String bucket = "$projectId.firebasestorage.app";
    String path = "profile_images/$uid.jpg";

    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final ref = FirebaseStorage.instance.ref().child(path);
        String url = await ref.getDownloadURL();
        setState(() {
          profileImageUrl = url;
        });
      } else {
        final encodedPath = Uri.encodeComponent(path);
        final url = Uri.parse(
          "https://firebasestorage.googleapis.com/v0/b/$bucket/o/$encodedPath?alt=media",
        );
        final response = await http.get(url);
        if (response.statusCode == 200) {
          setState(() {
            profileImageUrl = url.toString();
          });
        }
      }
    } catch (e) {
      // print("Error fetching profile image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (Platform.isAndroid || Platform.isIOS) {
            exit(0);
          }
        }
      },
      child: Scaffold(
        appBar: CustomTopBar(
          onBackPress: () {
            if (Platform.isAndroid || Platform.isIOS) {
              exit(0);
            }
          },
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 96),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Home Page",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfilePage(),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                profileImageUrl.isNotEmpty
                                    ? NetworkImage(profileImageUrl)
                                    : const AssetImage(
                                          'assets/images/profile_icon.png',
                                        )
                                        as ImageProvider,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text("Tap the profile icon to go to Profile Page"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Wrap(
                      spacing: 16.0,
                      runSpacing: 16.0,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildFeatureButton(
                          "Document",
                          Icons.description,
                          context,
                        ),
                        _buildFeatureButton(
                          "BMI Calculator",
                          Icons.calculate,
                          context,
                        ),
                        _buildFeatureButton(
                          "Appointments",
                          Icons.calendar_today,
                          context,
                        ),
                        _buildFeatureButton(
                          "Certificates",
                          Icons.medical_services,
                          context,
                        ),
                        _buildFeatureButton(
                          "Chronic Diseases",
                          Icons.health_and_safety,
                          context,
                        ),
                        _buildFeatureButton(
                          "My Medicine",
                          Icons.medication,
                          context,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavBar(context),
        floatingActionButton: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 20),
            child: _buildChatBotButton(context),
          ),
        ),
      ),
    );
  }

  static Widget _buildFeatureButton(
    String label,
    IconData icon,
    BuildContext context,
  ) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 64) / 2,
      child: GestureDetector(
        onTap: () {
          if (label == "Document") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DocumentPage()),
            );
          } else if (label == "Appointments") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AppointmentPage()),
            );
          } else if (label == "BMI Calculator") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BMICalculatorPage(),
              ),
            );
          } else if (label == "My Medicine") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyMedicinePage(uuid: uid),
              ),
            );
          } else if (label == "Certificates") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LabResultsPage(uuid: uid),
              ),
            );
          } else if (label == "Chronic Diseases") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChronicDiseasesPage(uuid: uid),
              ),
            );
          } else {
            // print('$label tapped');
          }
        },
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatBotButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatPage()),
        );
      },
      backgroundColor: Colors.blue,
      child: ClipOval(
        child: Image.asset(
          'assets/images/bot_icon.png',
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return SizedBox(
      height: 100,
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavButton(Icons.home, "Home", context, const HomePage()),
            _buildNavButton(
              Icons.search,
              "Search",
              context,
              const SearchPage(),
            ),
            _buildNavButton(
              Icons.medical_services,
              "Prescription",
              context,
              PrescriptionPage(uuid: uid),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildNavButton(
    IconData icon,
    String label,
    BuildContext context,
    Widget page,
  ) {
    return GestureDetector(
      onTap: () {
        if (ModalRoute.of(context)?.settings.name !=
            page.runtimeType.toString()) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => page,
              settings: RouteSettings(name: page.runtimeType.toString()),
            ),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> doctorList = [];
  List<Map<String, dynamic>> filteredList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    List<Map<String, dynamic>> tempDoctors = [];

    if (Platform.isAndroid || Platform.isIOS) {
      final doctorsCollection = FirebaseFirestore.instance.collection(
        'doctors',
      );
      final querySnapshot = await doctorsCollection.get();

      for (var doc in querySnapshot.docs) {
        tempDoctors.add({
          'id': doc.id,
          'name': doc['name'],
          'hospital': doc['hospital'],
          'department': doc['department'],
          'address': doc['address'],
        });
      }
    } else if (Platform.isLinux) {
      String url =
          "https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/doctors?key=$firebaseAPIKey";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['documents'] != null) {
          for (var doc in data['documents']) {
            final fields = doc['fields'];
            tempDoctors.add({
              'id': doc['name'].split('/').last,
              'name': fields['name']['stringValue'],
              'hospital': fields['hospital']['stringValue'],
              'department': fields['department']['stringValue'],
              'address': fields['address']['stringValue'],
            });
          }
        }
      }
    }

    setState(() {
      doctorList = tempDoctors;
      filteredList = tempDoctors;
    });
  }

  void filterDoctors(String query) {
    List<Map<String, dynamic>> tempFiltered =
        doctorList.where((doctor) {
          final name = doctor['name'].toLowerCase();
          final hospital = doctor['hospital'].toLowerCase();
          final address = doctor['address'].toLowerCase();
          return name.contains(query.toLowerCase()) ||
              hospital.contains(query.toLowerCase()) ||
              address.contains(query.toLowerCase());
        }).toList();

    setState(() {
      filteredList = tempFiltered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopBar(
        onBackPress: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search by Name or Hospital or place...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                ),
                onChanged: (value) => filterDoctors(value),
              ),
            ),
            Expanded(
              child:
                  filteredList.isEmpty
                      ? const Center(child: Text("No doctors found."))
                      : ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final doctor = filteredList[index];
                          final doctorId = doctor['id'];
                          return InkWell(
                            onTap: () {
                              if (doctorId != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ViewProfile2Page(
                                          doctorUid: doctorId,
                                        ),
                                  ),
                                );
                              }
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Name: ${doctor['name']}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Hospital: ${doctor['hospital']}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Department: ${doctor['department']}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Place: ${doctor['address']}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatPage()),
          );
        },
        backgroundColor: Colors.blue,
        child: ClipOval(
          child: Image.asset(
            'assets/images/bot_icon.png',
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return SizedBox(
      height: 100,
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavButton(Icons.home, "Home", context, const HomePage()),
            _buildNavButton(
              Icons.search,
              "Search",
              context,
              const SearchPage(),
            ),
            _buildNavButton(
              Icons.medical_services,
              "Prescription",
              context,
              PrescriptionPage(uuid: uid),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildNavButton(
    IconData icon,
    String label,
    BuildContext context,
    Widget page,
  ) {
    return GestureDetector(
      onTap: () {
        if (ModalRoute.of(context)?.settings.name !=
            page.runtimeType.toString()) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => page,
              settings: RouteSettings(name: page.runtimeType.toString()),
            ),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class PrescriptionPage extends StatefulWidget {
  final String uuid;
  const PrescriptionPage({Key? key, required this.uuid}) : super(key: key);

  @override
  PrescriptionPageState createState() => PrescriptionPageState();
}

class PrescriptionPageState extends State<PrescriptionPage> {
  String _selectedFilter = "Latest";
  bool _showFilterOptions = false;
  final List<String> _filters = ["Latest", "Earliest"];
  List<Reference> _files = [];

  @override
  void initState() {
    super.initState();
    _fetchPrescriptions();
  }

  Future<void> _fetchPrescriptions() async {
    final storageRef = FirebaseStorage.instance.ref().child(
      'prescription/${widget.uuid}/',
    );

    if (Platform.isAndroid || Platform.isIOS) {
      final ListResult result = await storageRef.listAll();
      setState(() {
        _files = result.items;
        _applyFilter();
      });
    }
  }

  void _applyFilter() {
    if (_selectedFilter == "Latest") {
      _files.sort((a, b) {
        DateTime dateA = _parseDateFromName(a.name);
        DateTime dateB = _parseDateFromName(b.name);
        return dateB.compareTo(dateA);
      });
    } else if (_selectedFilter == "Earliest") {
      _files.sort((a, b) {
        DateTime dateA = _parseDateFromName(a.name);
        DateTime dateB = _parseDateFromName(b.name);
        return dateA.compareTo(dateB);
      });
    }
  }

  DateTime _parseDateFromName(String name) {
    try {
      String withoutExtension = name.substring(0, name.length - 4);
      String dateString = withoutExtension.substring(
        withoutExtension.length - 10,
      );
      List<String> parts = dateString.split('-');
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);

      return DateTime(year, month, day);
    } catch (e) {
      return DateTime.now();
    }
  }

  Future<void> _downloadAndOpenFile(Reference fileRef) async {
    final String fileName = path.basename(fileRef.name).replaceAll('.pdf', '');
    if (Platform.isAndroid) {
      final Directory tempDir = await getTemporaryDirectory();
      final File tempFile = File('${tempDir.path}/$fileName.pdf');
      await fileRef.writeToFile(tempFile);
      OpenFile.open(tempFile.path);
    } else if (Platform.isLinux) {
      final String downloadUrl = await fileRef.getDownloadURL();
      final Directory tempDir = await getApplicationDocumentsDirectory();
      final File localFile = File('${tempDir.path}/$fileName.pdf');
      final http.Response response = await http.get(Uri.parse(downloadUrl));
      await localFile.writeAsBytes(response.bodyBytes);
      OpenFile.open(localFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (Platform.isAndroid || Platform.isIOS) {
            //do nothing
          }
        }
      },
      child: Scaffold(
        appBar: CustomTopBar(
          onBackPress: () {
            Navigator.pop(context);
          },
        ),
        body: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Prescription",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showFilterOptions = !_showFilterOptions;
                        });
                      },
                      icon: const Icon(Icons.filter_list),
                      label: const Text("Filter"),
                    ),
                    Text(
                      _selectedFilter,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (_showFilterOptions)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 4),
                    ],
                  ),
                  child: Column(
                    children:
                        _filters.map((filter) {
                          return ListTile(
                            title: Text(filter),
                            onTap: () {
                              setState(() {
                                _selectedFilter = filter;
                                _showFilterOptions = false;
                                _applyFilter();
                              });
                            },
                          );
                        }).toList(),
                  ),
                ),
              Expanded(
                child:
                    _files.isEmpty
                        ? const Center(
                          child: Text(
                            "No prescriptions available",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _files.length,
                          itemBuilder: (context, index) {
                            final fileRef = _files[index];
                            final fileName = path
                                .basename(fileRef.name)
                                .replaceAll('.pdf', '');

                            return GestureDetector(
                              onTap: () => _downloadAndOpenFile(fileRef),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      fileName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "Click here to download File",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
        floatingActionButton: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 20),
            child: _buildChatBotButton(context),
          ),
        ),
        bottomNavigationBar: _buildBottomNavBar(context),
      ),
    );
  }

  Widget _buildChatBotButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatPage()),
        );
      },
      backgroundColor: Colors.blue,
      child: ClipOval(
        child: Image.asset(
          'assets/images/bot_icon.png',
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return SizedBox(
      height: 100,
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavButton(Icons.home, "Home", context, const HomePage()),
            _buildNavButton(
              Icons.search,
              "Search",
              context,
              const SearchPage(),
            ),
            _buildNavButton(
              Icons.medical_services,
              "Prescription",
              context,
              PrescriptionPage(uuid: uid),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildNavButton(
    IconData icon,
    String label,
    BuildContext context,
    Widget page,
  ) {
    return GestureDetector(
      onTap: () {
        if (ModalRoute.of(context)?.settings.name !=
            page.runtimeType.toString()) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => page,
              settings: RouteSettings(name: page.runtimeType.toString()),
            ),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key? key}) : super(key: key);

  @override
  AppointmentPageState createState() => AppointmentPageState();
}

class AppointmentPageState extends State<AppointmentPage> {
  late Map<DateTime, List<Map<String, dynamic>>> _appointments;
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _appointments = {};
    _fetchAppointmentsForSelectedDay();
  }

  Future<void> _fetchAppointmentsForSelectedDay() async {
    String formattedDate = _formatDate(_selectedDay);

    if (Platform.isAndroid || Platform.isIOS) {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('appointments')
          .doc(formattedDate)
          .collection('appointment');

      QuerySnapshot snapshot = await docRef.get();
      if (snapshot.docs.isEmpty) {
        setState(() {
          _appointments[_selectedDay] = [];
        });
      } else {
        List<Map<String, dynamic>> appointmentList =
            snapshot.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

              List<String> timeList = [];
              if (data.containsKey('time') && data['time'] is List) {
                timeList = List<String>.from(
                  data['time'].map((v) => v.toString()),
                );
              } else {
                timeList = ['Not yet assigned'];
              }

              return {
                'status': data['status'] ?? 'Unknown',
                'doctor': data['name'] ?? 'Unknown',
                'hospital': data['hospital'] ?? 'Unknown',
                'time': timeList,
                'id': data['doctorid'] ?? 'Unknown',
              };
            }).toList();

        setState(() {
          _appointments[_selectedDay] = appointmentList;
        });
      }
    } else if (Platform.isLinux) {
      final url = Uri.parse(
        'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users/$uid/appointments/$formattedDate/appointment?key=$firebaseAPIKey',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['documents'] == null) {
          setState(() {
            _appointments[_selectedDay] = [];
          });
        } else {
          List<Map<String, dynamic>> appointmentList =
              data['documents'].map<Map<String, dynamic>>((doc) {
                Map<String, dynamic> fields = doc['fields'];

                List<String> timeList = [];
                if (fields.containsKey('time') &&
                    fields['time'].containsKey('arrayValue')) {
                  timeList = List<String>.from(
                    fields['time']['arrayValue']['values'].map(
                      (v) => v['stringValue'].toString(),
                    ),
                  );
                } else {
                  timeList = ['Not yet assigned'];
                }

                return {
                  'status': fields['status']['stringValue'] ?? 'Unknown',
                  'doctor': fields['name']['stringValue'] ?? 'Unknown',
                  'hospital': fields['hospital']['stringValue'] ?? 'Unknown',
                  'id': fields['doctorid']['stringValue'] ?? 'Unknown',

                  'time': timeList,
                };
              }).toList();

          setState(() {
            _appointments[_selectedDay] = appointmentList;
          });
        }
      } else {
        setState(() {
          _appointments[_selectedDay] = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: const CustomTopBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Appointments",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay =
                        focusedDay.isAfter(DateTime(2025, 12, 31))
                            ? DateTime(2025, 12, 31)
                            : focusedDay;
                  });
                  _fetchAppointmentsForSelectedDay();
                },
                calendarFormat: CalendarFormat.month,
                availableCalendarFormats: const {CalendarFormat.month: 'Month'},
              ),
              const SizedBox(height: 20),
              _buildAppointmentsForDay(_selectedDay),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  Widget _buildAppointmentsForDay(DateTime day) {
    List<Map<String, dynamic>> appointmentsForDay = _appointments[day] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Appointments for ${_formatDate(day)}:',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        if (appointmentsForDay.isEmpty)
          const Text('No appointments for this day.'),
        ...appointmentsForDay.map(
          (appointment) => GestureDetector(
            onTap: () => _showAppointmentDetails(appointment),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text('Status: ${appointment['status']}'),
            ),
          ),
        ),
      ],
    );
  }

  void _showAppointmentDetails(Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder: (context) {
        List<String> times =
            (appointment['time'] is List<String>)
                ? List<String>.from(appointment['time'])
                : ['Not yet assigned'];
        String timeDisplay = times.join(', ');

        return AlertDialog(
          title: const Text('Appointment Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Doctor: ${appointment['doctor']}'),
              Text('Hospital: ${appointment['hospital']}'),
              Text('Time: $timeDisplay'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () => _cancelAppointment(appointment),
              child: const Text(
                'Cancel Appointment',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _cancelAppointment(Map<String, dynamic> appointment) async {
    String formattedDate = _getFormattedDate(_selectedDay);
    String appointmentId = appointment['id'];

    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await FirebaseFirestore.instance
            .collection('doctors')
            .doc(appointment['id'])
            .collection('appointments')
            .doc('accepted')
            .collection(formattedDate)
            .doc(uid)
            .delete();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('appointments')
            .doc(formattedDate)
            .collection('appointment')
            .doc(appointmentId)
            .update({'status': 'canceled'});
      } else {
        await http.delete(
          Uri.parse(
            "https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/doctors/${appointment['id']}/appointments/accepted/$formattedDate/$uid",
          ),
          headers: {"Authorization": "Bearer $firebaseAPIKey"},
        );
        await http.patch(
          Uri.parse(
            "https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users/$uid/appointments/$formattedDate/appointment/$appointmentId",
          ),
          headers: {
            "Authorization": "Bearer $firebaseAPIKey",
            "Content-Type": "application/json",
          },
          body: json.encode({
            "fields": {
              "status": {"stringValue": "canceled"},
            },
          }),
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Appointment canceled successfully")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to cancel appointment: $e")),
        );
      }
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  String _getFormattedDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }
}

class BMICalculatorPage extends StatefulWidget {
  const BMICalculatorPage({Key? key}) : super(key: key);

  @override
  BMICalculatorPageState createState() => BMICalculatorPageState();
}

class BMICalculatorPageState extends State<BMICalculatorPage> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  double? _bmi;
  String _remark = '';

  void _calculateBMI() {
    final double? heightCm = double.tryParse(_heightController.text);
    final double? weightKg = double.tryParse(_weightController.text);

    if (heightCm != null && weightKg != null && heightCm > 0) {
      double heightM = heightCm / 100; // Convert cm to meters
      double bmi = weightKg / (heightM * heightM);

      setState(() {
        _bmi = bmi;
        _remark = _getRemark(bmi, heightM);
      });
    }
  }

  String _getRemark(double bmi, double heightM) {
    double idealMinWeight = 18.5 * (heightM * heightM);
    double idealMaxWeight = 24.9 * (heightM * heightM);
    double currentWeight = double.tryParse(_weightController.text) ?? 0;

    if (bmi < 18.5) {
      double neededWeight = idealMinWeight - currentWeight;
      return "Underweight by ${neededWeight.abs().toStringAsFixed(1)} kg";
    } else if (bmi > 24.9) {
      double excessWeight = currentWeight - idealMaxWeight;
      return "Overweight by ${excessWeight.abs().toStringAsFixed(1)} kg";
    } else {
      return "Normal weight";
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: const CustomTopBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "BMI Calculator",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Height (cm)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Weight (kg)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculateBMI,
                child: const Text("Calculate BMI"),
              ),
            ),
            if (_bmi != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your BMI: ${_bmi!.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _remark,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            _bmi! < 18.5 || _bmi! > 24.9
                                ? Colors.red
                                : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class MyMedicinePage extends StatefulWidget {
  final String? uuid;
  const MyMedicinePage({Key? key, required this.uuid}) : super(key: key);

  @override
  MyMedicinePageState createState() => MyMedicinePageState();
}

class MyMedicinePageState extends State<MyMedicinePage> {
  List<Map<String, dynamic>> medicines = [];

  @override
  void initState() {
    super.initState();
    fetchMedicines();
  }

  Future<void> fetchMedicines() async {
    if (Platform.isAndroid || Platform.isIOS) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uuid)
          .collection('Medicine')
          .get()
          .then((QuerySnapshot snapshot) {
            setState(() {
              medicines =
                  snapshot.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .where((medicine) => isValidMedicine(medicine))
                      .toList();
            });
          });
    } else if (Platform.isLinux) {
      String url =
          'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users/${widget.uuid}/Medicine?key=$firebaseAPIKey';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          medicines =
              (data['documents'] as List)
                  .map((doc) {
                    var fields = doc['fields'];
                    return {
                      'date': fields['date']['stringValue'],
                      'days': int.parse(fields['days']['integerValue']),
                      'morning': int.parse(fields['morning']['integerValue']),
                      'noon': int.parse(fields['noon']['integerValue']),
                      'evening': int.parse(fields['evening']['integerValue']),
                      'medicine': fields['medicine']['stringValue'],
                      'problem': fields['problem']?['stringValue'] ?? 'N/A',
                      'doctor': fields['doctor']?['stringValue'] ?? 'N/A',
                    };
                  })
                  .where((medicine) => isValidMedicine(medicine))
                  .toList();
        });
      }
    }
  }

  bool isValidMedicine(Map<String, dynamic> medicine) {
    String date = medicine['date'];
    int days = medicine['days'];
    DateTime startDate = DateFormat('dd/MM/yyyy').parse(date);
    DateTime endDate = startDate.add(Duration(days: days));
    DateTime currentDate = DateTime.now();
    return currentDate.isBefore(endDate);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (Platform.isAndroid || Platform.isIOS) {
            //do nothing
          }
        }
      },
      child: Scaffold(
        appBar: CustomTopBar(
          onBackPress: () {
            Navigator.pop(context);
          },
        ),

        body: Container(
          color: Colors.white,
          child:
              medicines.isEmpty
                  ? const Center(
                    child: Text(
                      "No medicines available",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  )
                  : ListView.builder(
                    itemCount: medicines.length,
                    itemBuilder: (context, index) {
                      var medicine = medicines[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: ListTile(
                            title: Text(medicine['medicine']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Morning: ${medicine['morning']}'),
                                Text('Noon: ${medicine['noon']}'),
                                Text('Evening: ${medicine['evening']}'),
                                Text('Days: ${medicine['days']}'),
                                Text('Start Date: ${medicine['date']}'),
                                Text('Doctor: ${medicine['doctor'] ?? 'N/A'}'),
                                Text(
                                  'Problem: ${medicine['problem'] ?? 'N/A'}',
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 40, bottom: 10),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatPage()),
              );
            },
            backgroundColor: Colors.blue,
            child: ClipOval(
              child: Image.asset(
                'assets/images/bot_icon.png',
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LabResultsPage extends StatefulWidget {
  final String uuid;
  const LabResultsPage({Key? key, required this.uuid}) : super(key: key);

  @override
  LabResultsPageState createState() => LabResultsPageState();
}

class LabResultsPageState extends State<LabResultsPage> {
  String _selectedFilter = "Latest";
  bool _showFilterOptions = false;
  final List<String> _filters = ["Latest", "Earliest"];
  List<Reference> _files = [];

  @override
  void initState() {
    super.initState();
    _fetchLabResults();
  }

  Future<void> _fetchLabResults() async {
    final storageRef = FirebaseStorage.instance.ref().child(
      'lab_results/${widget.uuid}/',
    );

    if (Platform.isAndroid || Platform.isIOS) {
      final ListResult result = await storageRef.listAll();
      setState(() {
        _files = result.items;
        _applyFilter();
      });
    }
  }

  void _applyFilter() {
    if (_selectedFilter == "Latest") {
      _files.sort((a, b) {
        DateTime dateA = _parseDateFromName(a.name);
        DateTime dateB = _parseDateFromName(b.name);
        return dateB.compareTo(dateA);
      });
    } else if (_selectedFilter == "Earliest") {
      _files.sort((a, b) {
        DateTime dateA = _parseDateFromName(a.name);
        DateTime dateB = _parseDateFromName(b.name);
        return dateA.compareTo(dateB);
      });
    }
  }

  DateTime _parseDateFromName(String name) {
    try {
      String withoutExtension = name.substring(0, name.length - 4);
      String dateString = withoutExtension.substring(
        withoutExtension.length - 10,
      );
      List<String> parts = dateString.split('-');
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (e) {
      return DateTime.now();
    }
  }

  Future<void> _downloadAndOpenFile(Reference fileRef) async {
    final String fileName = path.basename(fileRef.name).replaceAll('.pdf', '');
    if (Platform.isAndroid) {
      final Directory tempDir = await getTemporaryDirectory();
      final File tempFile = File('${tempDir.path}/$fileName.pdf');
      await fileRef.writeToFile(tempFile);
      OpenFile.open(tempFile.path);
    } else if (Platform.isLinux) {
      final String downloadUrl = await fileRef.getDownloadURL();
      final Directory tempDir = await getApplicationDocumentsDirectory();
      final File localFile = File('${tempDir.path}/$fileName.pdf');
      final http.Response response = await http.get(Uri.parse(downloadUrl));
      await localFile.writeAsBytes(response.bodyBytes);
      OpenFile.open(localFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (Platform.isAndroid || Platform.isIOS) {
            //do nothing
          }
        }
      },
      child: Scaffold(
        appBar: CustomTopBar(
          onBackPress: () {
            Navigator.pop(context);
          },
        ),

        body: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Certificates",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showFilterOptions = !_showFilterOptions;
                        });
                      },
                      icon: const Icon(Icons.filter_list),
                      label: const Text("Filter"),
                    ),
                    Text(
                      _selectedFilter,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (_showFilterOptions)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 4),
                    ],
                  ),
                  child: Column(
                    children:
                        _filters.map((filter) {
                          return ListTile(
                            title: Text(filter),
                            onTap: () {
                              setState(() {
                                _selectedFilter = filter;
                                _showFilterOptions = false;
                                _applyFilter();
                              });
                            },
                          );
                        }).toList(),
                  ),
                ),
              Expanded(
                child:
                    _files.isEmpty
                        ? const Center(
                          child: Text(
                            "No Certificates Available",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _files.length,
                          itemBuilder: (context, index) {
                            final fileRef = _files[index];
                            final fileName = path
                                .basename(fileRef.name)
                                .replaceAll('.pdf', '');

                            return GestureDetector(
                              onTap: () => _downloadAndOpenFile(fileRef),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      fileName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "Click here to download File",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
        floatingActionButton: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 20),
            child: _buildChatBotButton(context),
          ),
        ),
      ),
    );
  }

  Widget _buildChatBotButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatPage()),
        );
      },
      backgroundColor: Colors.blue,
      child: ClipOval(
        child: Image.asset(
          'assets/images/bot_icon.png',
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class DocumentPage extends StatefulWidget {
  const DocumentPage({Key? key}) : super(key: key);

  @override
  DocumentPageState createState() => DocumentPageState();
}

class DocumentPageState extends State<DocumentPage> {
  bool _isUploading = false;
  String _selectedFilter = "Latest";
  bool _showFilterOptions = false;
  final List<String> _filters = ["Latest", "Earliest"];
  List<Reference> _files = [];

  @override
  void initState() {
    super.initState();
    _fetchDocuments();
  }

  Future<void> _fetchDocuments() async {
    final storageRef = FirebaseStorage.instance.ref().child('documents/$uid/');

    if (Platform.isAndroid || Platform.isIOS) {
      final ListResult result = await storageRef.listAll();
      setState(() {
        _files = result.items;
        _applyFilter();
      });
    }
  }

  void _applyFilter() {
    if (_selectedFilter == "Latest") {
      _files.sort((a, b) {
        DateTime dateA = _parseDateFromName(a.name);
        DateTime dateB = _parseDateFromName(b.name);
        return dateB.compareTo(dateA);
      });
    } else if (_selectedFilter == "Earliest") {
      _files.sort((a, b) {
        DateTime dateA = _parseDateFromName(a.name);
        DateTime dateB = _parseDateFromName(b.name);
        return dateA.compareTo(dateB);
      });
    }
  }

  DateTime _parseDateFromName(String name) {
    try {
      String withoutExtension = name.substring(0, name.length - 4);
      String dateString = withoutExtension.substring(
        withoutExtension.length - 10,
      );
      List<String> parts = dateString.split('-');
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (e) {
      return DateTime.now();
    }
  }

  Future<void> _downloadAndOpenFile(Reference fileRef) async {
    final String fileName = path.basename(fileRef.name).replaceAll('.pdf', '');
    if (Platform.isAndroid) {
      final Directory tempDir = await getTemporaryDirectory();
      final File tempFile = File('${tempDir.path}/$fileName.pdf');
      await fileRef.writeToFile(tempFile);
      OpenFile.open(tempFile.path);
    } else if (Platform.isLinux) {
      final String downloadUrl = await fileRef.getDownloadURL();
      final Directory tempDir = await getApplicationDocumentsDirectory();
      final File localFile = File('${tempDir.path}/$fileName.pdf');
      final http.Response response = await http.get(Uri.parse(downloadUrl));
      await localFile.writeAsBytes(response.bodyBytes);
      OpenFile.open(localFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (Platform.isAndroid || Platform.isIOS) {
            //do nothing
          }
        }
      },
      child: Scaffold(
        appBar: CustomTopBar(
          onBackPress: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              ModalRoute.withName('/'),
            );
          },
        ),
        body: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Documents",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showFilterOptions = !_showFilterOptions;
                        });
                      },
                      icon: const Icon(Icons.filter_list),
                      label: const Text("Filter"),
                    ),
                    Text(
                      _selectedFilter,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (_showFilterOptions)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 4),
                    ],
                  ),
                  child: Column(
                    children:
                        _filters.map((filter) {
                          return ListTile(
                            title: Text(filter),
                            onTap: () {
                              setState(() {
                                _selectedFilter = filter;
                                _showFilterOptions = false;
                                _applyFilter();
                              });
                            },
                          );
                        }).toList(),
                  ),
                ),
              Expanded(
                child:
                    _files.isEmpty
                        ? const Center(
                          child: Text(
                            "No Documents Available",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _files.length,
                          itemBuilder: (context, index) {
                            final fileRef = _files[index];
                            final fileName = path
                                .basename(fileRef.name)
                                .replaceAll('.pdf', '');

                            return GestureDetector(
                              onTap: () => _downloadAndOpenFile(fileRef),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      fileName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "Click here to download File",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
        floatingActionButton: Stack(
          children: [
            Positioned(
              bottom: 16,
              left: 25,
              child: FloatingActionButton(
                onPressed: () {
                  _showFileUploadPopup(context);
                },
                child: const Icon(Icons.add),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: _buildChatBotButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBotButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatPage()),
        );
      },
      backgroundColor: Colors.blue,
      child: ClipOval(
        child: Image.asset(
          'assets/images/bot_icon.png',
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void _showFileUploadPopup(BuildContext context) {
    final TextEditingController fileNameController = TextEditingController();
    File? selectedFile;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Upload Document'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                      );
                  if (result != null) {
                    selectedFile = File(result.files.single.path!);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a PDF file'),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Select PDF File'),
              ),
              TextField(
                controller: fileNameController,
                decoration: const InputDecoration(labelText: 'Enter File Name'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),

            ElevatedButton(
              onPressed:
                  _isUploading
                      ? null
                      : () async {
                        setState(() {
                          _isUploading = true;
                        });

                        String fileName = fileNameController.text;
                        DateTime now = DateTime.now();
                        DateFormat formatter = DateFormat('dd-MM-yyyy');
                        String formattedDate = formatter.format(now);
                        String date = formattedDate;

                        if (fileName.isNotEmpty &&
                            date.isNotEmpty &&
                            selectedFile != null) {
                          await _uploadFileToFirebase(
                            selectedFile!,
                            fileName,
                            date,
                          );
                          if (context.mounted) Navigator.of(context).pop();
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please fill all fields and select a PDF file',
                                ),
                              ),
                            );
                          }
                        }

                        if (context.mounted) {
                          setState(() {
                            _isUploading = false;
                          });
                        }
                      },
              child:
                  _isUploading
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : const Text('Upload'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadFileToFirebase(
    File file,
    String fileName,
    String date,
  ) async {
    try {
      String fullFileName = '$fileName$date';
      Reference storageRef = FirebaseStorage.instance.ref().child(
        'documents/$uid/$fullFileName.pdf',
      );

      if (Platform.isAndroid) {
        await storageRef.putFile(file);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File uploaded successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error uploading file')));
      }
    }
  }
}

class ChronicDiseasesPage extends StatefulWidget {
  final String uuid;
  const ChronicDiseasesPage({Key? key, required this.uuid}) : super(key: key);

  @override
  ChronicDiseasesPageState createState() => ChronicDiseasesPageState();
}

class ChronicDiseasesPageState extends State<ChronicDiseasesPage> {
  List<Map<String, String>> chronicDiseases = [];
  String _selectedFilter = "All";
  bool _showFilterOptions = false;
  final List<String> _filters = ["All", "Latest", "Earliest"];
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _readingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchChronicDiseases();
  }

  Future<void> _fetchChronicDiseases() async {
    if (Platform.isAndroid || Platform.isIOS) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uuid)
          .collection('chronic disease')
          .get()
          .then((QuerySnapshot snapshot) {
            setState(() {
              chronicDiseases =
                  snapshot.docs
                      .map(
                        (doc) => {
                          'type': doc['type']?.toString() ?? '',
                          'reading': doc['reading']?.toString() ?? '',
                          'date': doc['date']?.toString() ?? '',
                        },
                      )
                      .toList();
              _applyFilter();
            });
          });
    } else if (Platform.isLinux) {
      final String apiUrl =
          'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users/${widget.uuid}/chronic%20disease';

      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          chronicDiseases =
              data['documents']
                  .map<Map<String, String>>((doc) {
                    final fields = doc['fields'];
                    return {
                      'type': fields['type']['stringValue']?.toString() ?? '',
                      'reading':
                          fields['reading']['stringValue']?.toString() ?? '',
                      'date': fields['date']['stringValue']?.toString() ?? '',
                    };
                  })
                  .toList()
                  .cast<Map<String, String>>();
          _applyFilter();
        });
      }
    }
  }

  void _applyFilter() {
    if (_selectedFilter == "Latest") {
      chronicDiseases.sort((a, b) {
        DateTime? dateA = _parseDate(a['date']);
        DateTime? dateB = _parseDate(b['date']);
        return dateB.compareTo(dateA);
      });
    } else if (_selectedFilter == "Earliest") {
      chronicDiseases.sort((a, b) {
        DateTime? dateA = _parseDate(a['date']);
        DateTime? dateB = _parseDate(b['date']);
        return dateA.compareTo(dateB);
      });
    }
  }

  DateTime _parseDate(String? dateString) {
    if (dateString == null ||
        !RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(dateString)) {
      throw FormatException("Invalid date format: $dateString");
    }
    final parts = dateString.split('/');
    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
  }

  Future<void> _submitChronicDisease() async {
    String type = _typeController.text.trim();
    String reading = _readingController.text.trim();
    String date = DateFormat('dd/MM/yyyy').format(DateTime.now());

    if (type.isNotEmpty && reading.isNotEmpty) {
      if (Platform.isAndroid || Platform.isIOS) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uuid)
            .collection('chronic disease')
            .add({'type': type, 'reading': reading, 'date': date});
      } else if (Platform.isLinux) {
        final String apiUrl =
            'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users/${widget.uuid}/chronic%20disease';
        final body = json.encode({
          'fields': {
            'type': {'stringValue': type},
            'reading': {'stringValue': reading},
            'date': {'stringValue': date},
          },
        });

        await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: body,
        );
      }
      if (mounted) {
        Navigator.of(context).pop();
        _fetchChronicDiseases();
      }
    }
  }

  void _showAddChronicDiseasePopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Chronic Disease'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _typeController,
                decoration: const InputDecoration(
                  labelText: 'Type (e.g., diabetes)',
                ),
              ),
              TextField(
                controller: _readingController,
                decoration: const InputDecoration(labelText: 'Reading'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: _submitChronicDisease,
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (Platform.isAndroid || Platform.isIOS) {
            //do nothing
          }
        }
      },
      child: Scaffold(
        appBar: CustomTopBar(
          onBackPress: () {
            Navigator.pop(context);
          },
        ),

        body: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Chronic Diseases",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showFilterOptions = !_showFilterOptions;
                        });
                      },
                      icon: const Icon(Icons.filter_list),
                      label: const Text("Filter"),
                    ),
                    Text(
                      _selectedFilter,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (_showFilterOptions)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 4),
                    ],
                  ),
                  child: Column(
                    children:
                        _filters.map((filter) {
                          return ListTile(
                            title: Text(filter),
                            onTap: () {
                              setState(() {
                                _selectedFilter = filter;
                                _showFilterOptions = false;
                                _applyFilter();
                              });
                            },
                          );
                        }).toList(),
                  ),
                ),
              Expanded(
                child:
                    chronicDiseases.isEmpty
                        ? const Center(
                          child: Text(
                            "No Data Available",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: chronicDiseases.length,
                          itemBuilder: (context, index) {
                            final disease = chronicDiseases[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Type: ${disease['type']}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text("Reading: ${disease['reading']}"),
                                  const SizedBox(height: 8),
                                  Text("Date: ${disease['date']}"),
                                ],
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
        floatingActionButton: Stack(
          children: [
            Positioned(
              bottom: 16,
              left: 25,
              child: FloatingActionButton(
                onPressed: _showAddChronicDiseasePopup,
                child: const Icon(Icons.add),
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: _buildChatBotButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBotButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatPage()),
        );
      },
      backgroundColor: Colors.blue,
      child: ClipOval(
        child: Image.asset(
          'assets/images/bot_icon.png',
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class Home2Page extends StatefulWidget {
  const Home2Page({Key? key}) : super(key: key);

  @override
  State<Home2Page> createState() => _Home2PageState();
}

class _Home2PageState extends State<Home2Page> {
  String profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    fetchProfileImage();
  }

  Future<void> fetchProfileImage() async {
    try {
      String storagePath = "profile_images/$uid.jpg";
      String bucketUrl =
          "https://firebasestorage.googleapis.com/v0/b/$projectId.firebasestorage.app/o/profile_images%2F$uid.jpg?alt=media";

      if (Platform.isAndroid || Platform.isIOS) {
        final ref = FirebaseStorage.instance.ref().child(storagePath);
        String url = await ref.getDownloadURL();
        setState(() {
          profileImageUrl = url;
        });
      } else {
        final response = await http.get(Uri.parse(bucketUrl));
        if (response.statusCode == 200) {
          setState(() {
            profileImageUrl = bucketUrl;
          });
        }
      }
    } catch (e) {
      //print("Error fetching profile image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (Platform.isAndroid || Platform.isIOS) {
            //do nothing
          }
        }
      },
      child: Scaffold(
        appBar: CustomTopBar(
          onBackPress: () {
            if (Platform.isAndroid || Platform.isIOS) {
              exit(0);
            }
          },
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 96),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Home Page",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Profile2Page(),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                profileImageUrl.isNotEmpty
                                    ? NetworkImage(profileImageUrl)
                                    : const AssetImage(
                                          'assets/images/profile_icon.png',
                                        )
                                        as ImageProvider,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text("Tap the profile icon to go to Profile Page"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildBlueButton(
                          context,
                          "Slot Booking",
                          Icons.schedule,
                          const BookingSlotPage(),
                        ),
                        const SizedBox(width: 20),
                        _buildBlueButton(
                          context,
                          "Reviews",
                          Icons.reviews,
                          const ReviewsPage(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavBar(context),
        floatingActionButton: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 20),
            child: _buildChatBotButton(context),
          ),
        ),
      ),
    );
  }

  static Widget _buildBlueButton(
    BuildContext context,
    String label,
    IconData icon,
    Widget page,
  ) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        fixedSize: const Size(130, 70),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChatBotButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatPage()),
        );
      },
      backgroundColor: Colors.blue,
      child: ClipOval(
        child: Image.asset(
          'assets/images/bot_icon.png',
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return SizedBox(
      height: 120,
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _circularNavButton(
                Icons.home,
                "Home",
                context,
                const Home2Page(),
              ),
              _circularNavButton(
                Icons.search,
                "Search",
                context,
                const Search2Page(),
              ),
              _circularNavButton(
                Icons.calendar_today,
                "Appointments",
                context,
                const Appointment2Page(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circularNavButton(
    IconData icon,
    String label,
    BuildContext context,
    Widget page,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            if (ModalRoute.of(context)?.settings.name !=
                page.runtimeType.toString()) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => page,
                  settings: RouteSettings(name: page.runtimeType.toString()),
                ),
              );
            }
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: Center(child: Icon(icon, color: Colors.white, size: 28)),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class Search2Page extends StatefulWidget {
  const Search2Page({Key? key}) : super(key: key);

  @override
  Search2PageState createState() => Search2PageState();
}

class Search2PageState extends State<Search2Page> {
  List<Map<String, dynamic>> appointments = [];
  List<Map<String, dynamic>> filteredAppointments = [];
  bool isSearching = false;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _fetchAppointments();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> _fetchAppointments() async {
    String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    try {
      List<Map<String, dynamic>> tempAppointments = [];
      if (Platform.isAndroid || Platform.isIOS) {
        final snapshot =
            await FirebaseFirestore.instance
                .collection('doctors')
                .doc(uid)
                .collection('appointments')
                .doc('accepted')
                .collection(currentDate)
                .get();

        tempAppointments =
            snapshot.docs.map((doc) {
              return {
                'name': doc['name'],
                'time': (doc['time'] as List<dynamic>).join(', '),
                'userid': doc['userid'],
              };
            }).toList();
      } else {
        final response = await http.get(
          Uri.parse(
            'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/doctors/$uid/appointments/accepted/$currentDate',
          ),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data.containsKey('documents')) {
            tempAppointments =
                data['documents'].map<Map<String, dynamic>>((doc) {
                  final fields = doc['fields'];
                  return {
                    'name': fields['name']['stringValue'],
                    'time':
                        fields['time']['arrayValue']['values']
                            ?.map((t) => t['stringValue'])
                            .join(', ') ??
                        '',
                    'userid': fields['userid']['stringValue'],
                  };
                }).toList();
          }
        }
      }

      if (_isMounted) {
        setState(() {
          appointments = tempAppointments;
          filteredAppointments = tempAppointments;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error fetching data')));
      }
    }
  }

  void _searchAppointments(String name) {
    if (name.isEmpty) {
      setState(() {
        filteredAppointments = appointments;
        isSearching = false;
      });
      return;
    }

    final results =
        appointments
            .where(
              (appt) => appt['name'].toLowerCase().contains(name.toLowerCase()),
            )
            .toList();

    setState(() {
      filteredAppointments = results;
      isSearching = true;
    });

    if (results.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No patients found')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopBar(
        onBackPress: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Home2Page()),
          );
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search by Name...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                ),
                onChanged: _searchAppointments,
              ),
            ),
            Expanded(
              child:
                  filteredAppointments.isEmpty
                      ? const Center(child: Text("No appointments found"))
                      : ListView.builder(
                        itemCount: filteredAppointments.length,
                        itemBuilder: (context, index) {
                          final appointment = filteredAppointments[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ViewProfilePage(
                                        uuid: appointment['userid'],
                                      ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      appointment['name'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Time: ${appointment['time']}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatPage()),
          );
        },
        backgroundColor: Colors.blue,
        child: ClipOval(
          child: Image.asset(
            'assets/images/bot_icon.png',
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return SizedBox(
      height: 120,
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _circularNavButton(
                Icons.home,
                "Home",
                context,
                const Home2Page(),
              ),
              _circularNavButton(
                Icons.search,
                "Search",
                context,
                const Search2Page(),
              ),
              _circularNavButton(
                Icons.calendar_today,
                "Appointments",
                context,
                const Appointment2Page(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circularNavButton(
    IconData icon,
    String label,
    BuildContext context,
    Widget page,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            if (ModalRoute.of(context)?.settings.name !=
                page.runtimeType.toString()) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => page,
                  settings: RouteSettings(name: page.runtimeType.toString()),
                ),
              );
            }
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: Center(child: Icon(icon, color: Colors.white, size: 28)),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class Profile2Page extends StatefulWidget {
  const Profile2Page({Key? key}) : super(key: key);

  @override
  Profile2PageState createState() => Profile2PageState();
}

class Profile2PageState extends State<Profile2Page> {
  String name = '';
  String specialization = '';
  String age = '';
  String hospital = '';
  String qualification = '';
  String gender = '';
  String workHistory = '';
  String profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchDoctorDetails();
  }

  Future<void> _fetchDoctorDetails() async {
    try {
      String doctorUid = uid;

      if (Platform.isAndroid) {
        try {
          DocumentSnapshot<Map<String, dynamic>> snapshot =
              await FirebaseFirestore.instance
                  .collection('doctors')
                  .doc(doctorUid)
                  .get();

          if (snapshot.exists && snapshot.data() != null) {
            final data = snapshot.data()!;
            String calculatedAge = 'N/A';
            String? dobString = data['dob'];
            if (dobString != null && dobString.contains('/')) {
              List<String> parts = dobString.split('/');
              if (parts.length == 3) {
                int day = int.tryParse(parts[0]) ?? 0;
                int month = int.tryParse(parts[1]) ?? 0;
                int year = int.tryParse(parts[2]) ?? 0;
                if (day > 0 && month > 0 && year > 0) {
                  DateTime birthDate = DateTime(year, month, day);
                  DateTime today = DateTime.now();
                  int ageValue = today.year - birthDate.year;
                  if (today.month < birthDate.month ||
                      (today.month == birthDate.month &&
                          today.day < birthDate.day)) {
                    ageValue--;
                  }
                  calculatedAge = ageValue.toString();
                }
              }
            }

            setState(() {
              name = data['name'] ?? 'N/A';
              specialization = data['specialization'] ?? 'N/A';
              age = calculatedAge;
              hospital = data['hospital'] ?? 'N/A';
              qualification = data['qualification'] ?? 'N/A';
              gender = data['gender'] ?? 'N/A';
              workHistory = data['workHistory'] ?? 'N/A';
              profileImageUrl = data['profileImageUrl'] ?? '';
            });
            if (profileImageUrl.isEmpty) {
              try {
                String imageUrl =
                    await FirebaseStorage.instance
                        .ref('profile_images/$doctorUid.jpg')
                        .getDownloadURL();
                setState(() {
                  profileImageUrl = imageUrl;
                });
              } catch (e) {
                //print('Error fetching profile image: $e');
              }
            }
          }
        } catch (e) {
          //print('Error fetching doctor data: $e');
        }
      } else if (Platform.isLinux) {
        String url =
            "https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/doctors/$doctorUid?key=$firebaseAPIKey";
        var response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body)['fields'];

          setState(() {
            name = data['name']?['stringValue'] ?? 'N/A';
            specialization = data['specialization']?['stringValue'] ?? 'N/A';
            age = data['dob']?['stringValue'] ?? 'N/A';
            hospital = data['hospital']?['stringValue'] ?? 'N/A';
            qualification = data['qualification']?['stringValue'] ?? 'N/A';
            gender = data['gender']?['stringValue'] ?? 'N/A';
            workHistory = data['workHistory']?['stringValue'] ?? 'N/A';
            profileImageUrl = data['profileImageUrl']?['stringValue'] ?? '';
          });

          if (profileImageUrl.isEmpty) {
            String imageUrl =
                "https://firebasestorage.googleapis.com/v0/b/$projectId/o/profile_images%2F$doctorUid.jpg?alt=media";
            setState(() {
              profileImageUrl = imageUrl;
            });
          }
        } else {
          //print('Failed to fetch data: ${response.statusCode}');
        }
      }
    } catch (e) {
      //print('Error fetching doctor details: $e');
    }
  }

  void _showSettings(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Settings",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return const Align(
          alignment: Alignment.centerRight,
          child: FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 1.0,
            child: SettingsPage(),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(anim1),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: const CustomTopBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 16.0),
              child: Text(
                'Profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        profileImageUrl.isNotEmpty
                            ? NetworkImage(profileImageUrl)
                            : null,
                    child:
                        profileImageUrl.isEmpty
                            ? const Icon(Icons.person, size: 50)
                            : null,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    name.isNotEmpty ? name : 'NAME',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    specialization.isNotEmpty
                        ? 'Specialized in: $specialization'
                        : 'Specialized in:',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 250,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Editing2Page(),
                                ),
                              );
                            },
                            child: const Text('Edit Profile'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _showSettings(context),
                            child: const Text('Settings'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Doctor Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text('Age: $age', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    'Hospital: $hospital',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Educational Qualification: $qualification',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text('Gender: $gender', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text(
                    'Work History',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    workHistory.isNotEmpty ? workHistory : '',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Editing2Page extends StatefulWidget {
  const Editing2Page({Key? key}) : super(key: key);

  @override
  Editing2PageState createState() => Editing2PageState();
}

class Editing2PageState extends State<Editing2Page> {
  bool isSaving = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController hospitalController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController workHistoryController = TextEditingController();
  final TextEditingController specializationController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String? profileImageUrl;
  String? signImageUrl;
  File? _profileImageFile;
  File? _signImageFile;

  @override
  void dispose() {
    nameController.dispose();
    _dobController.dispose();
    hospitalController.dispose();
    qualificationController.dispose();
    workHistoryController.dispose();
    specializationController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> pickImage({required bool isSignature}) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          if (isSignature) {
            _signImageFile = File(pickedFile.path);
          } else {
            _profileImageFile = File(pickedFile.path);
          }
        });
      }
    } catch (e) {
      //print('Error picking image: $e');
    }
  }

  Future<String?> uploadImage(File imageFile, String path) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      //print("Error uploading image: $e");
      return null;
    }
  }

  Future<void> saveProfile() async {
    final name = nameController.text.trim();
    final dobStr = _dobController.text.trim();
    final hospital = hospitalController.text.trim();
    final qualification = qualificationController.text.trim();
    final workHistory = workHistoryController.text.trim();
    final specialization = specializationController.text.trim();
    final address = addressController.text.trim();

    if (name.isNotEmpty && RegExp(r'\d').hasMatch(name)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name should not contain digits")),
      );
      return;
    }

    try {
      Map<String, dynamic> updatedFields = {};

      if (name.isNotEmpty) updatedFields['name'] = name;
      if (dobStr.isNotEmpty) updatedFields['dob'] = dobStr;
      if (hospital.isNotEmpty) updatedFields['hospital'] = hospital;
      if (qualification.isNotEmpty) {
        updatedFields['qualification'] = qualification;
      }
      if (workHistory.isNotEmpty) updatedFields['workHistory'] = workHistory;
      if (address.isNotEmpty) updatedFields['address'] = address;
      if (specialization.isNotEmpty) {
        updatedFields['specialization'] = specialization;
      }

      if (_profileImageFile != null) {
        String? imageUrl = await uploadImage(
          _profileImageFile!,
          'profile_images/$uid.jpg',
        );
        if (imageUrl != null) updatedFields['profileImageUrl'] = imageUrl;
      }

      if (_signImageFile != null) {
        String? signUrl = await uploadImage(_signImageFile!, 'sign/$uid.jpg');
        if (signUrl != null) updatedFields['signImageUrl'] = signUrl;
      }

      if (updatedFields.isEmpty) {
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("No changes to update")));
        }
        return;
      }

      if (Platform.isAndroid) {
        await FirebaseFirestore.instance
            .collection('doctors')
            .doc(uid)
            .update(updatedFields);
      } else if (Platform.isLinux) {
        final url =
            'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/doctors/$uid?key=$firebaseAPIKey';

        final existingResponse = await http.get(Uri.parse(url));
        if (existingResponse.statusCode == 200) {
          final existingData = json.decode(existingResponse.body);
          final existingFields = existingData['fields'] ?? {};

          updatedFields.forEach((key, value) {
            if (value != null) {
              existingFields[key] =
                  value is String
                      ? {"stringValue": value}
                      : {"integerValue": value};
            }
          });

          await http.patch(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({"fields": existingFields}),
          );
        } else {
          throw Exception('Failed to retrieve existing document');
        }
      }
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error updating profile: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomTopBar(),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Edit Profile",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          _profileImageFile != null
                              ? FileImage(_profileImageFile!)
                              : (profileImageUrl != null
                                  ? NetworkImage(profileImageUrl!)
                                  : null),
                      child:
                          _profileImageFile == null && profileImageUrl == null
                              ? const Icon(Icons.person, size: 50)
                              : null,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => pickImage(isSignature: false),
                      child: const Text("Edit Profile Picture"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _dobController,
                readOnly: true,
                decoration: const InputDecoration(labelText: "Date of Birth"),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    String formattedDate =
                        "${pickedDate.day.toString().padLeft(2, '0')}/"
                        "${pickedDate.month.toString().padLeft(2, '0')}/"
                        "${pickedDate.year}";
                    setState(() {
                      _dobController.text = formattedDate;
                    });
                  }
                },
              ),

              const SizedBox(height: 10),
              TextFormField(
                controller: hospitalController,
                decoration: const InputDecoration(labelText: "Hospital"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: qualificationController,
                decoration: const InputDecoration(
                  labelText: "Educational Qualification",
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: "Address"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: workHistoryController,
                decoration: const InputDecoration(labelText: "Work History"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: specializationController,
                decoration: const InputDecoration(labelText: "Specialization"),
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          _signImageFile != null
                              ? FileImage(_signImageFile!)
                              : (signImageUrl != null
                                  ? NetworkImage(signImageUrl!)
                                  : null),
                      child:
                          _signImageFile == null && signImageUrl == null
                              ? const Icon(Icons.edit, size: 50)
                              : null,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => pickImage(isSignature: true),
                      child: const Text("Edit Signature"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: ElevatedButton(
                  onPressed:
                      isSaving
                          ? null
                          : () async {
                            setState(() {
                              isSaving = true;
                            });

                            await saveProfile();

                            setState(() {
                              isSaving = false;
                            });
                          },
                  child:
                      isSaving
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : const Text("Save Changes"),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatPage()),
            ),
        backgroundColor: Colors.blue,
        child: ClipOval(
          child: Image.asset(
            'assets/images/bot_icon.png',
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class ViewProfilePage extends StatefulWidget {
  final String uuid;
  const ViewProfilePage({Key? key, required this.uuid}) : super(key: key);

  @override
  ViewProfilePageState createState() => ViewProfilePageState();
}

class ViewProfilePageState extends State<ViewProfilePage> {
  bool isRequestPressed = false;
  bool isUploading = false;
  final Color buttonTextColor = const Color(0xFF6A5ACD);

  String name = "null";
  String age = "null";
  String gender = "null";
  String imageUrl = "";
  String weight = "null";
  String height = "null";
  String allergies = "null";
  String medicalHistory = "null";

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await _fetchUserDetailsFromFirestore();
      await _fetchProfileImageFromFirebaseStorage();
    } else if (Platform.isLinux) {
      await _fetchUserDetailsFromHTTP();
      await _fetchProfileImageFromHTTP();
    }
  }

  Future<void> _fetchUserDetailsFromFirestore() async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.uuid)
              .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        String? dobString = data['dob'];
        String calculatedAge = "null";
        if (dobString != null && dobString.contains('/')) {
          List<String> parts = dobString.split('/');
          if (parts.length == 3) {
            int day = int.tryParse(parts[0]) ?? 0;
            int month = int.tryParse(parts[1]) ?? 0;
            int year = int.tryParse(parts[2]) ?? 0;
            if (day > 0 && month > 0 && year > 0) {
              DateTime birthDate = DateTime(year, month, day);
              DateTime today = DateTime.now();
              int ageValue = today.year - birthDate.year;
              if (today.month < birthDate.month ||
                  (today.month == birthDate.month &&
                      today.day < birthDate.day)) {
                ageValue--;
              }
              calculatedAge = ageValue.toString();
            }
          }
        }

        setState(() {
          name = data['name'] ?? 'null';
          age = calculatedAge;
          gender = data['gender'] ?? 'null';
          weight = data['weight'] ?? 'null';
          height = data['height'] ?? 'null';
          allergies = data['allergies'] ?? 'null';
          medicalHistory = data['medicalHistory'] ?? 'null';
        });

        // print('Fetched user details successfully: $data');
      } else {
        // print('User document does not exist.');
      }
    } catch (e) {
      // print('Error fetching user details from Firestore: $e');
    }
  }

  Future<void> _fetchProfileImageFromFirebaseStorage() async {
    try {
      String downloadURL =
          await FirebaseStorage.instance
              .ref('profile_images/${widget.uuid}.jpg')
              .getDownloadURL();

      setState(() {
        imageUrl = downloadURL;
      });

      // print('Fetched profile image successfully: $downloadURL');
    } catch (e) {
      // print('Error fetching profile image from Firebase Storage: $e');
    }
  }

  Future<void> _fetchUserDetailsFromHTTP() async {
    try {
      var url = Uri.parse(
        'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users/${widget.uuid}?key=$firebaseAPIKey',
      );
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var fields = data['fields'];

        setState(() {
          name = fields['name']?['stringValue'] ?? 'null';
          age = fields['age']?['stringValue'] ?? 'null';
          gender = fields['gender']?['stringValue'] ?? 'null';
          weight = fields['weight']?['stringValue'] ?? 'null';
          height = fields['height']?['stringValue'] ?? 'null';
          allergies = fields['allergies']?['stringValue'] ?? 'null';
          medicalHistory = fields['medicalHistory']?['stringValue'] ?? 'null';
        });

        // print('Fetched user details from HTTP: $fields');
      } else {
        // print('Failed to fetch user details from HTTP. Status: ${response.statusCode}');
      }
    } catch (e) {
      // print('Error fetching user details from Firestore HTTP: $e');
    }
  }

  Future<void> _fetchProfileImageFromHTTP() async {
    try {
      var profileImageUri = Uri.parse(
        'https://firebasestorage.googleapis.com/v0/b/$projectId.firebasestorage.app/o/profile_images%2F${Uri.encodeComponent(widget.uuid)}.jpg?alt=media',
      );
      var imageUrlResponse = await http.get(profileImageUri);

      if (imageUrlResponse.statusCode == 200) {
        setState(() {
          imageUrl = profileImageUri.toString();
        });
        // print('Fetched profile image successfully from HTTP: ${profileImageUri.toString()}');
      } else {
        // print('Error fetching profile image from HTTP: ${imageUrlResponse.statusCode}');
      }
    } catch (e) {
      // print('Error fetching profile image from Firebase Storage via HTTP: $e');
    }
  }

  void _showFileUploadPopup(BuildContext context) {
    final TextEditingController fileNameController = TextEditingController();
    File? selectedFile;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Upload Cerificates'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                      );
                  if (result != null) {
                    selectedFile = File(result.files.single.path!);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a PDF file'),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Select PDF File'),
              ),
              TextField(
                controller: fileNameController,
                decoration: const InputDecoration(labelText: 'Enter File Name'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),

            ElevatedButton(
              onPressed:
                  isUploading
                      ? null
                      : () async {
                        setState(() {
                          isUploading = true;
                        });

                        String fileName = fileNameController.text;
                        DateTime now = DateTime.now();
                        DateFormat formatter = DateFormat('dd-MM-yyyy');
                        String formattedDate = formatter.format(now);
                        String date = formattedDate;

                        if (fileName.isNotEmpty &&
                            date.isNotEmpty &&
                            selectedFile != null) {
                          await _uploadFileToFirebase(
                            selectedFile!,
                            fileName,
                            date,
                          );
                          if (context.mounted) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('File uploaded Sucessfully'),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please fill all fields and select a PDF file',
                              ),
                            ),
                          );
                          setState(() {
                            isUploading = false;
                          });
                        }
                      },
              child:
                  isUploading
                      ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : const Text('Upload'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadFileToFirebase(
    File pdfFile,
    String fileName,
    String date,
  ) async {
    String path = 'lab_results/${widget.uuid}/$fileName$date.pdf';

    if (Platform.isAndroid || Platform.isIOS) {
      try {
        Reference ref = FirebaseStorage.instance.ref().child(path);
        UploadTask uploadTask = ref.putFile(pdfFile);
        await uploadTask.whenComplete(() {
          //print('PDF uploaded successfully to Firebase Storage (Android).');
        });
      } catch (e) {
        //print('Failed to upload PDF to Firebase Storage (Android): $e');
      }
    } else if (Platform.isLinux) {
      try {
        const bucketName = "$projectId.firebasestorage.app";
        final encodedPath = Uri.encodeComponent(path);
        final url =
            'https://firebasestorage.googleapis.com/v0/b/$bucketName/o/$encodedPath?uploadType=media';
        List<int> fileBytes = pdfFile.readAsBytesSync();
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/pdf',
            'Content-Length': fileBytes.length.toString(),
          },
          body: fileBytes,
        );

        if (response.statusCode == 200) {
          //print('PDF uploaded successfully to Firebase Storage (Linux).');
        } else {
          //print('Failed to upload PDF (Linux): ${response.statusCode}');
          //print('Response body: ${response.body}');
        }
      } catch (e) {
        //print('Error uploading PDF (Linux): $e');
      }
    }
  }

  Widget _popupButton(String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 2,
        ),
        onPressed: onTap,
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: const CustomTopBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 16.0),
              child: Text(
                'Profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        imageUrl.isNotEmpty
                            ? NetworkImage(imageUrl)
                            : const AssetImage('assets/profile_pic.png')
                                as ImageProvider,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 140,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => UploadPrescriptionPage(
                                          uuid: widget.uuid,
                                        ),
                                  ),
                                );
                              },
                              child: Text(
                                'Prescription',
                                style: TextStyle(color: buttonTextColor),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 140,
                            child: ElevatedButton(
                              onPressed: () => _showFileUploadPopup(context),
                              child: Text(
                                'Certificates',
                                style: TextStyle(color: buttonTextColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 140,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            MyMedicinePage(uuid: widget.uuid),
                                  ),
                                );
                              },
                              child: Text(
                                'Medication',
                                style: TextStyle(color: buttonTextColor),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 140,
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.white,
                                      title: const Text(
                                        "Select Option",
                                        textAlign: TextAlign.center,
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _popupButton("Certificates", () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) => LabResultsPage(
                                                      uuid: widget.uuid,
                                                    ),
                                              ),
                                            );
                                          }),

                                          _popupButton("Prescription", () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        PrescriptionsPage(
                                                          uuid: widget.uuid,
                                                        ),
                                              ),
                                            );
                                          }),
                                          _popupButton("Chronic Diseases", () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        ChronicDiseasePage(
                                                          uuid: widget.uuid,
                                                        ),
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Text(
                                'More',
                                style: TextStyle(color: buttonTextColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Patient Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text('Age: $age', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Weight: $weight', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Height: $height', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Gender: $gender', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  const Text(
                    'Allergies',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(allergies, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  const Text(
                    'Medical History',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(medicalHistory, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewProfile2Page extends StatefulWidget {
  final String doctorUid;

  const ViewProfile2Page({Key? key, required this.doctorUid}) : super(key: key);

  @override
  ViewProfile2PageState createState() => ViewProfile2PageState();
}

class ViewProfile2PageState extends State<ViewProfile2Page> {
  bool isAppointmentRequested = false;
  String name = "null";
  String uname = "null";
  String specialization = "null";
  String age = "null";
  String hospital = "null";
  String qualification = "null";
  String gender = "null";
  String profileImageUrl = "";
  String his = "";

  @override
  void initState() {
    super.initState();
    _fetchDoctorDetails();
    _fetchUserName();
  }

  Future<void> _fetchDoctorDetails() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await _fetchDetailsFromFirestore();
      await _fetchProfileImageFromFirebaseStorage();
    } else if (Platform.isLinux) {
      await _fetchDetailsFromHTTP();
      await _fetchProfileImageFromHTTP();
    }
  }

  Future<void> _fetchDetailsFromFirestore() async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('doctors')
              .doc(widget.doctorUid)
              .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        String calculatedAge = 'null';
        String? dobString = data['dob'];
        if (dobString != null && dobString.contains('/')) {
          List<String> parts = dobString.split('/');
          if (parts.length == 3) {
            int day = int.tryParse(parts[0]) ?? 0;
            int month = int.tryParse(parts[1]) ?? 0;
            int year = int.tryParse(parts[2]) ?? 0;
            if (day > 0 && month > 0 && year > 0) {
              DateTime birthDate = DateTime(year, month, day);
              DateTime today = DateTime.now();
              int ageValue = today.year - birthDate.year;
              if (today.month < birthDate.month ||
                  (today.month == birthDate.month &&
                      today.day < birthDate.day)) {
                ageValue--;
              }
              calculatedAge = ageValue.toString();
            }
          }
        }

        setState(() {
          name = data['name'] ?? 'null';
          specialization = data['specialization'] ?? 'null';
          age = calculatedAge;
          hospital = data['hospital'] ?? 'null';
          qualification = data['qualification'] ?? 'null';
          gender = data['gender'] ?? 'null';
          his = data['workHistory'] ?? 'null';
        });
      } else {
        //print('Doctor document does not exist.');
      }
    } catch (e) {
      //print('Error fetching doctor details from Firestore: $e');
    }
  }

  Future<void> _fetchProfileImageFromFirebaseStorage() async {
    try {
      String downloadURL =
          await FirebaseStorage.instance
              .ref('profile_images/${widget.doctorUid}.jpg')
              .getDownloadURL();

      setState(() {
        profileImageUrl = downloadURL;
      });
    } catch (e) {
      //print('Error fetching profile image from Firebase Storage: $e');
    }
  }

  Future<void> _fetchDetailsFromHTTP() async {
    try {
      var url = Uri.parse(
        'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/doctors/${widget.doctorUid}?key=$firebaseAPIKey',
      );
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var fields = data['fields'];

        setState(() {
          name = fields['name']?['stringValue'] ?? 'null';
          specialization = fields['specialization']?['stringValue'] ?? 'null';
          age = fields['age']?['integerValue'] ?? 'null';
          hospital = fields['hospital']?['stringValue'] ?? 'null';
          qualification = fields['qualification']?['stringValue'] ?? 'null';
          gender = fields['gender']?['stringValue'] ?? 'null';
          his = fields['workHistory']?['stringValue'] ?? 'null';
        });
      } else {
        //print(
        //'Error fetching doctor details from HTTP: ${response.statusCode}',
        //);
      }
    } catch (e) {
      //print('Error fetching doctor details via HTTP: $e');
    }
  }

  Future<void> _fetchProfileImageFromHTTP() async {
    try {
      var profileImageUri = Uri.parse(
        'https://firebasestorage.googleapis.com/v0/b/$projectId.firebasestorage.app/o/profile_images%2F${widget.doctorUid}.jpg?alt=media',
      );
      var imageUrlResponse = await http.get(profileImageUri);

      if (imageUrlResponse.statusCode == 200) {
        setState(() {
          profileImageUrl = profileImageUri.toString();
        });
      } else {
        //print(
        //  'Error fetching profile image via HTTP: ${imageUrlResponse.statusCode}',
        // );
      }
    } catch (e) {
      //print('Error fetching profile image via HTTP: $e');
    }
  }

  Future<void> _fetchUserName() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        DocumentSnapshot snapshot =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        setState(() {
          uname = data['name'] ?? 'null';
        });
      } else if (Platform.isLinux) {
        var url = Uri.parse(
          'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users/$uid?key=$firebaseAPIKey',
        );
        var response = await http.get(url);

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          var fields = data['fields'];

          setState(() {
            uname = fields['name']?['stringValue'] ?? 'null';
          });
        } else {
          //print('Error fetching user name: ${response.statusCode}');
        }
      }
    } catch (e) {
      //print('Error fetching user name: $e');
    }
  }

  void _appointmentRequest() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) return;

    String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);

    if (Platform.isAndroid || Platform.isIOS) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('appointments')
          .doc(formattedDate)
          .collection('appointment')
          .doc(widget.doctorUid)
          .set({
            'doctorid': widget.doctorUid,
            'name': name,
            'hospital': hospital,
            'status': 'requested',
          }, SetOptions(merge: true));

      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(widget.doctorUid)
          .collection('appointments')
          .doc('requests')
          .collection('requestdetails')
          .add({'userid': uid, 'date': formattedDate, 'name': uname});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment Requested Successfully!')),
        );
      }
    } else if (Platform.isLinux) {
      var userRequestUrl = Uri.parse(
        'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users/$uid/appointments/$formattedDate/appointment/${widget.doctorUid}?key=$firebaseAPIKey',
      );
      var response = await http.get(userRequestUrl);

      if (response.statusCode == 200) {
        await http.patch(
          userRequestUrl,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'fields': {
              'doctorid': {'stringValue': widget.doctorUid},
              'name': {'stringValue': name},
              'hospital': {'stringValue': hospital},
              'status': {'stringValue': 'requested'},
            },
            'updateMask': {
              'fieldPaths': ['doctorid', 'name', 'hospital', 'status'],
            },
          }),
        );
      } else if (response.statusCode == 404) {
        await http.post(
          userRequestUrl,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'fields': {
              'doctorid': {'stringValue': widget.doctorUid},
              'name': {'stringValue': name},
              'hospital': {'stringValue': hospital},
              'status': {'stringValue': 'requested'},
            },
          }),
        );
      } else {
        //print('Error fetching document: ${response.statusCode}');
      }
      var doctorRequestUrl = Uri.parse(
        'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/doctors/${widget.doctorUid}/appointments/requests/requestdetails?key=$firebaseAPIKey',
      );
      await http.post(
        doctorRequestUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fields': {
            'userid': {'stringValue': uid},
            'date': {'stringValue': formattedDate},
            'name': {'stringValue': uname},
          },
        }),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment Requested Successfully!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: const CustomTopBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 16.0),
              child: Text(
                'Profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        profileImageUrl.isNotEmpty
                            ? NetworkImage(profileImageUrl)
                            : null,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Specialized in: $specialization',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 290,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _appointmentRequest,
                            style: ElevatedButton.styleFrom(
                              foregroundColor:
                                  isAppointmentRequested
                                      ? Colors.blue
                                      : Colors.purple,
                              backgroundColor: Colors.white,
                            ),
                            child: const Text('Appointment Request'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ReviewPage(
                                        doctorUid: widget.doctorUid,
                                      ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.purple,
                              backgroundColor: Colors.white,
                            ),
                            child: const Text('Reviews'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Doctor Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text('Age: $age', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    'Hospital: $hospital',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Educational Qualification: $qualification',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text('Gender: $gender', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text(
                    'Work History',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(his, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({Key? key}) : super(key: key);

  @override
  ReviewsPageState createState() => ReviewsPageState();
}

class ReviewsPageState extends State<ReviewsPage> {
  final List<Map<String, String>> _reviews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    _reviews.clear();
    try {
      if (Platform.isLinux) {
        final url = Uri.parse(
          'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/dreviews/$uid',
        );
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data.containsKey('fields') &&
              data['fields'].containsKey('reviews')) {
            final reviews = data['fields']['reviews']['arrayValue']['values'];
            setState(() {
              for (var review in reviews) {
                _reviews.add({
                  'name': review['mapValue']['fields']['name']['stringValue'],
                  'review':
                      review['mapValue']['fields']['review']['stringValue'],
                });
              }
            });
          }
        }
      } else {
        DocumentSnapshot doc =
            await FirebaseFirestore.instance
                .collection('dreviews')
                .doc(uid)
                .get();

        if (doc.exists && doc.data() != null) {
          var data = doc.data() as Map<String, dynamic>;
          if (data.containsKey('reviews')) {
            List<dynamic> firestoreReviews = data['reviews'];
            setState(() {
              for (var review in firestoreReviews) {
                _reviews.add({
                  'name': review['name'].toString(),
                  'review': review['review'].toString(),
                });
              }
            });
          }
        }
      }
    } catch (e) {
      //print('Error loading reviews: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomTopBar(
          onBackPress: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "User Reviews",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            _isLoading
                ? const CircularProgressIndicator()
                : _reviews.isEmpty
                ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "No reviews available.",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
                : Expanded(
                  child: ListView.builder(
                    itemCount: _reviews.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          _reviews[index]['name'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(_reviews[index]['review'] ?? ''),
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 40, bottom: 10),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatPage()),
            );
          },
          backgroundColor: Colors.blue,
          child: ClipOval(
            child: Image.asset(
              'assets/images/bot_icon.png',
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class ReviewPage extends StatefulWidget {
  final String doctorUid;
  const ReviewPage({Key? key, required this.doctorUid}) : super(key: key);

  @override
  ReviewPageState createState() => ReviewPageState();
}

class ReviewPageState extends State<ReviewPage> {
  final List<Map<String, String>> _reviews = [];

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  void _loadReviews() async {
    if (Platform.isLinux) {
      final url = Uri.parse(
        'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/dreviews/${widget.doctorUid}',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('fields') &&
            data['fields'].containsKey('reviews') &&
            data['fields']['reviews']['arrayValue'].containsKey('values')) {
          final reviews = data['fields']['reviews']['arrayValue']['values'];
          setState(() {
            _reviews.clear();
            for (var review in reviews) {
              final fields = review['mapValue']['fields'];
              _reviews.add({
                'name': fields['name']['stringValue'],
                'review': fields['review']['stringValue'],
                'uid': fields['uid']['stringValue'],
              });
            }
          });
        }
      }
    } else {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance
              .collection('dreviews')
              .doc(widget.doctorUid)
              .get();

      if (doc.exists && doc.data() != null) {
        List<dynamic> firestoreReviews = doc['reviews'];
        setState(() {
          _reviews.clear();
          for (var review in firestoreReviews) {
            _reviews.add({
              'name': review['name'],
              'review': review['review'],
              'uid': review['uid'],
            });
          }
        });
      }
    }
  }

  void _addReview() async {
    String reviewText = "";
    String reviewerName = "";

    if (Platform.isLinux) {
      final url = Uri.parse(
        'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users/$uid',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        reviewerName = data['fields']['name']['stringValue'];
      }
    } else {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        reviewerName = doc.get('name');
      }
    }
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Review"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Your Review"),
                onChanged: (value) => reviewText = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (reviewText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Review must not be empty!")),
                  );
                } else {
                  setState(() {
                    _reviews.add({
                      "name": reviewerName,
                      "review": reviewText,
                      "uid": uid,
                    });
                  });
                  _saveReview(reviewerName, reviewText);
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _saveReview(String name, String review) async {
    if (Platform.isLinux) {
      final url = Uri.parse(
        'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/dreviews/${widget.doctorUid}',
      );
      final response = await http.get(url);
      List<dynamic> existingReviews = [];

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('fields') &&
            data['fields'].containsKey('reviews') &&
            data['fields']['reviews'].containsKey('arrayValue') &&
            data['fields']['reviews']['arrayValue'].containsKey('values')) {
          existingReviews =
              data['fields']['reviews']['arrayValue']['values'] ?? [];
        }
      }

      existingReviews.add({
        "mapValue": {
          "fields": {
            "name": {"stringValue": name},
            "review": {"stringValue": review},
            "uid": {"stringValue": uid},
          },
        },
      });

      await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "fields": {
            "reviews": {
              "arrayValue": {"values": existingReviews},
            },
          },
        }),
      );
    } else {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('dreviews')
          .doc(widget.doctorUid);
      DocumentSnapshot doc = await docRef.get();
      if (doc.exists) {
        await docRef.update({
          "reviews": FieldValue.arrayUnion([
            {"name": name, "review": review, "uid": uid},
          ]),
        });
      } else {
        await docRef.set({
          "reviews": [
            {"name": name, "review": review, "uid": uid},
          ],
        });
      }
    }
  }

  void _deleteReview(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Review"),
          content: const Text("Do you want to delete this review?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                final reviewItem = _reviews[index];
                String? name = reviewItem["name"];
                String? review = reviewItem["review"];
                String? reviewUid = reviewItem["uid"];

                if (reviewUid != uid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("You can only delete your own review."),
                    ),
                  );
                  Navigator.pop(context);
                  return;
                }

                if (Platform.isLinux) {
                  final url = Uri.parse(
                    'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/dreviews/${widget.doctorUid}',
                  );

                  final response = await http.get(url);
                  List<dynamic> existingReviews = [];

                  if (response.statusCode == 200) {
                    final data = jsonDecode(response.body);
                    if (data.containsKey('fields') &&
                        data['fields'].containsKey('reviews') &&
                        data['fields']['reviews'].containsKey('arrayValue') &&
                        data['fields']['reviews']['arrayValue'].containsKey(
                          'values',
                        )) {
                      existingReviews =
                          data['fields']['reviews']['arrayValue']['values'] ??
                          [];
                    }
                  }

                  existingReviews.removeWhere((item) {
                    final fields = item["mapValue"]["fields"];
                    return fields["name"]["stringValue"] == name &&
                        fields["review"]["stringValue"] == review &&
                        fields["uid"]["stringValue"] == uid;
                  });

                  await http.patch(
                    url,
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode({
                      "fields": {
                        "reviews": {
                          "arrayValue": {"values": existingReviews},
                        },
                      },
                    }),
                  );
                } else {
                  final docRef = FirebaseFirestore.instance
                      .collection('dreviews')
                      .doc(widget.doctorUid);

                  await docRef.update({
                    "reviews": FieldValue.arrayRemove([
                      {"name": name, "review": review, "uid": uid},
                    ]),
                  });
                }

                setState(() {
                  _reviews.removeAt(index);
                });
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomTopBar(
          onBackPress: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "User Reviews",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _reviews.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(_reviews[index]["name"]!),
                      subtitle: Text("Review: ${_reviews[index]["review"]}"),
                      onTap: () => _deleteReview(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 60, bottom: 10),
            child: FloatingActionButton(
              onPressed: _addReview,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 40, bottom: 10),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatPage()),
                );
              },
              backgroundColor: Colors.blue,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/bot_icon.png',
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BookingSlotPage extends StatefulWidget {
  const BookingSlotPage({Key? key}) : super(key: key);

  @override
  BookingSlotPageState createState() => BookingSlotPageState();
}

class BookingSlotPageState extends State<BookingSlotPage> {
  List<Map<String, dynamic>> requests = [];

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    final today = DateTime.now();

    if (Platform.isAndroid) {
      try {
        QuerySnapshot snapshot =
            await FirebaseFirestore.instance
                .collection('doctors')
                .doc(uid)
                .collection('appointments')
                .doc('requests')
                .collection('requestdetails')
                .get();

        setState(() {
          requests =
              snapshot.docs
                  .map((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    String name = data['name'] ?? 'Unknown';
                    String userid = data['userid'] ?? 'Unknown';
                    String date = data['date'] ?? 'Unknown';

                    return {
                      'id': doc.id,
                      'name': name,
                      'userid': userid,
                      'date': date,
                    };
                  })
                  .where((request) {
                    try {
                      DateTime requestDate = DateFormat(
                        'dd-MM-yyyy',
                      ).parse(request['date']!);
                      return !requestDate.isBefore(
                        DateTime(today.year, today.month, today.day),
                      );
                    } catch (e) {
                      return false;
                    }
                  })
                  .toList();

          requests.sort((a, b) {
            DateTime dateA = DateFormat('dd-MM-yyyy').parse(a['date']);
            DateTime dateB = DateFormat('dd-MM-yyyy').parse(b['date']);
            return dateA.compareTo(dateB);
          });
        });
      } catch (e) {
        //print('Error fetching requests on Android: $e');
      }
    } else if (Platform.isLinux) {
      try {
        var url = Uri.parse(
          'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/doctors/$uid/appointments/requests/requestdetails?key=$firebaseAPIKey',
        );

        var response = await http.get(url);

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          var documents = data['documents'] as List<dynamic>;

          setState(() {
            requests =
                documents
                    .map((doc) {
                      var fields = doc['fields'] as Map<String, dynamic>;

                      String name = fields['name']['stringValue'] ?? 'Unknown';
                      String userid =
                          fields['userid']['stringValue'] ?? 'Unknown';
                      String date = fields['date']['stringValue'] ?? 'Unknown';

                      String docId = doc['name'].split('/').last;

                      return {
                        'id': docId,
                        'name': name,
                        'userid': userid,
                        'date': date,
                      };
                    })
                    .where((request) {
                      try {
                        DateTime requestDate = DateFormat(
                          'dd-MM-yyyy',
                        ).parse(request['date']!);
                        return !requestDate.isBefore(
                          DateTime(today.year, today.month, today.day),
                        );
                      } catch (e) {
                        return false;
                      }
                    })
                    .toList();

            requests.sort((a, b) {
              DateTime dateA = DateFormat('dd-MM-yyyy').parse(a['date']);
              DateTime dateB = DateFormat('dd-MM-yyyy').parse(b['date']);
              return dateA.compareTo(dateB);
            });
          });
        } else {
          //print('Error fetching requests on Linux: ${response.statusCode}');
        }
      } catch (e) {
        //print('Error fetching requests on Linux: $e');
      }
    }
  }

  String? formattedTime;
  String formatTime(String hh, String mm) {
    return "${hh.padLeft(2, '0')}:${mm.padLeft(2, '0')}";
  }

  Future<void> _showPopup(
    BuildContext context,
    Map<String, dynamic> requestData,
  ) async {
    String? formattedTime;
    TextEditingController hhController = TextEditingController();
    TextEditingController mmController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Request - ${requestData['date']}"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Enter Time (24-hour format)"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 40,
                        child: TextField(
                          controller: hhController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: "HH"),
                          maxLength: 2,
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty &&
                                  mmController.text.isNotEmpty) {
                                formattedTime = formatTime(
                                  hhController.text,
                                  mmController.text,
                                );
                              } else {
                                formattedTime = null;
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 40,
                        child: TextField(
                          controller: mmController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: "MM"),
                          maxLength: 2,
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty &&
                                  hhController.text.isNotEmpty) {
                                formattedTime = formatTime(
                                  hhController.text,
                                  mmController.text,
                                );
                              } else {
                                formattedTime = null;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed:
                      (formattedTime != null)
                          ? () {
                            _acceptRequest(
                              requestData,
                              formattedTime!,
                              requestData['id'],
                            );
                            Navigator.pop(context);
                          }
                          : null,
                  child: const Text('Submit'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _rejectRequest(requestData, requestData['id']);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Reject'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _acceptRequest(
    Map<String, dynamic> requestData,
    String formattedTime,
    String documentId,
  ) async {
    String name = requestData['name'];
    String userid = requestData['userid'];
    String date = requestData['date'];
    final currentDate = DateTime.now();
    final todayStr =
        "${currentDate.day.toString().padLeft(2, '0')}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.year}";
    if (date == todayStr) {
      final now = TimeOfDay.now();
      final parts = formattedTime.split(':');
      final selectedTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
      if (selectedTime.hour < now.hour ||
          (selectedTime.hour == now.hour &&
              selectedTime.minute <= now.minute)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Cannot assign a past time for today\'s appointment.',
            ),
          ),
        );
        Navigator.of(context).pop();
        return;
      }
    }

    if (Platform.isAndroid) {
      try {
        var appointmentsCollection = FirebaseFirestore.instance
            .collection('doctors')
            .doc(uid)
            .collection('appointments')
            .doc('accepted')
            .collection(date);

        var snapshot = await appointmentsCollection.get();
        for (var doc in snapshot.docs) {
          List<dynamic>? times = doc.data()['time'];
          if (times != null && times.contains(formattedTime)) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'There is already an appointment at the same time.',
                  ),
                ),
              );
              Navigator.of(context).pop();
            }
            return;
          }
        }

        var doctorRef = appointmentsCollection.doc(userid);
        var doctorDocSnapshot = await doctorRef.get();

        if (doctorDocSnapshot.exists) {
          await doctorRef.update({
            'time': FieldValue.arrayUnion([formattedTime]),
          });
        } else {
          await doctorRef.set({
            'date': date,
            'name': name,
            'userid': userid,
            'time': FieldValue.arrayUnion([formattedTime]),
          });
        }

        var userRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userid)
            .collection('appointments')
            .doc(date)
            .collection('appointment')
            .doc(uid);

        var userDocSnapshot = await userRef.get();

        if (userDocSnapshot.exists) {
          await userRef.update({
            'status': 'accepted',
            'time': FieldValue.arrayUnion([formattedTime]),
          });
        } else {
          await userRef.set({
            'status': 'accepted',
            'time': FieldValue.arrayUnion([formattedTime]),
          });
        }

        await FirebaseFirestore.instance
            .collection('doctors')
            .doc(uid)
            .collection('appointments')
            .doc('requests')
            .collection('requestdetails')
            .doc(documentId)
            .delete();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Request Accepted  Successfully!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error accepting request on Android: $e')),
          );
        }
      }
    } else if (Platform.isLinux) {
      try {
        var listUrl = Uri.parse(
          'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/doctors/$uid/appointments/accepted/$date?key=$firebaseAPIKey',
        );
        var listResponse = await http.get(listUrl);
        if (listResponse.statusCode == 200) {
          var data = jsonDecode(listResponse.body);
          if (data.containsKey('documents')) {
            for (var doc in data['documents']) {
              var times = doc['fields']?['time']?['arrayValue']?['values'];
              if (times != null) {
                for (var t in times) {
                  if (t['stringValue'] == formattedTime) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'There is already an appointment at the same time.',
                          ),
                        ),
                      );

                      Navigator.of(context).pop();
                    }
                    return;
                  }
                }
              }
            }
          }
        }
        var doctorDocUrl = Uri.parse(
          'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/doctors/$uid/appointments/accepted/$date/$userid?key=$firebaseAPIKey',
        );
        var doctorResponse = await http.get(doctorDocUrl);
        if (doctorResponse.statusCode == 200) {
          await http.patch(
            doctorDocUrl,
            body: jsonEncode({
              "fields": {
                "time": {
                  "arrayValue": {
                    "values": [
                      {"stringValue": formattedTime},
                    ],
                  },
                },
              },
            }),
            headers: {'Content-Type': 'application/json'},
          );
        } else {
          await http.patch(
            doctorDocUrl,
            body: jsonEncode({
              "fields": {
                "date": {"stringValue": date},
                "name": {"stringValue": name},
                "userid": {"stringValue": userid},
                "time": {
                  "arrayValue": {
                    "values": [
                      {"stringValue": formattedTime},
                    ],
                  },
                },
              },
            }),
            headers: {'Content-Type': 'application/json'},
          );
        }
        var userDocUrl = Uri.parse(
          'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users/$userid/appointments/$date/appointment/$uid'
          '?key=$firebaseAPIKey&updateMask.fieldPaths=status&updateMask.fieldPaths=time',
        );

        await http.patch(
          userDocUrl,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "fields": {
              "status": {"stringValue": "accepted"},
              "time": {
                "arrayValue": {
                  "values": [
                    {"stringValue": formattedTime},
                  ],
                },
              },
            },
          }),
        );
        var deleteRequestUrl = Uri.parse(
          'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/doctors/$uid/appointments/requests/requestdetails/$documentId?key=$firebaseAPIKey',
        );

        await http.delete(deleteRequestUrl);
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Request Accepted Successfully!')),
          );
        }
      } catch (e) {
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error accepting request on Linux: $e')),
          );
        }
      }
    }
  }

  void _rejectRequest(
    Map<String, dynamic> requestData,
    String documentId,
  ) async {
    String userid = requestData['userid'];
    String date = requestData['date'];

    if (Platform.isAndroid) {
      try {
        await FirebaseFirestore.instance
            .collection('doctors')
            .doc(uid)
            .collection('appointments')
            .doc('requests')
            .collection('requestdetails')
            .doc(documentId)
            .delete();
        var userRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userid)
            .collection('appointments')
            .doc(date)
            .collection('appointment')
            .doc(uid);
        await userRef.update({'status': 'rejected'});
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Rejected  successfully!')),
          );
        }
      } catch (e) {
        //print("Error rejecting request on Android: $e");
      }
    } else if (Platform.isLinux) {
      try {
        var deleteRequestUrl = Uri.parse(
          'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/doctors/$uid/appointments/requests/requestdetails/$documentId?key=$firebaseAPIKey',
        );
        await http.delete(deleteRequestUrl);
        var userUrl = Uri.parse(
          'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users/$userid/appointments/$date/appointment/$uid?key=$firebaseAPIKey',
        );

        await http.patch(
          userUrl,
          body: jsonEncode({
            "fields": {
              "status": {"stringValue": "rejected"},
            },
          }),
        );
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Rejected  successfully!')),
          );
        }
      } catch (e) {
        //print("Error rejecting request on Linux: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomTopBar(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appointment Requests',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  requests.isEmpty
                      ? const Center(
                        child: Text(
                          "No new appointment requests",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      )
                      : ListView.builder(
                        itemCount: requests.length,
                        itemBuilder: (context, index) {
                          var requestData = requests[index];
                          return GestureDetector(
                            onTap: () {
                              _showPopup(context, requestData);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Request - ${requestData['date']}\nName: ${requestData['name']}",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 40, bottom: 10),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatPage()),
            );
          },
          backgroundColor: Colors.blue,
          child: ClipOval(
            child: Image.asset(
              'assets/images/bot_icon.png',
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class UploadPrescriptionPage extends StatefulWidget {
  final String? uuid;

  const UploadPrescriptionPage({Key? key, required this.uuid})
    : super(key: key);

  @override
  UploadPrescriptionPageState createState() => UploadPrescriptionPageState();
}

class UploadPrescriptionPageState extends State<UploadPrescriptionPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _problemsController = TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _suggestionController = TextEditingController();
  final TextEditingController _allergyController = TextEditingController();
  final TextEditingController _mhistoryController = TextEditingController();

  final List<Map<String, TextEditingController>> _medicineControllers = [
    {
      'medicine': TextEditingController(),
      'morning': TextEditingController(),
      'noon': TextEditingController(),
      'evening': TextEditingController(),
      'days': TextEditingController(),
    },
  ];
  bool _isLoading = false;
  bool _issign = true;

  @override
  void dispose() {
    _problemsController.dispose();
    _diagnosisController.dispose();
    _suggestionController.dispose();
    for (var controllers in _medicineControllers) {
      controllers['medicine']?.dispose();
      controllers['morning']?.dispose();
      controllers['noon']?.dispose();
      controllers['evening']?.dispose();
      controllers['days']?.dispose();
    }
    super.dispose();
  }

  void _addMedicineField() {
    setState(() {
      _medicineControllers.add({
        'medicine': TextEditingController(),
        'morning': TextEditingController(),
        'noon': TextEditingController(),
        'evening': TextEditingController(),
        'days': TextEditingController(),
      });
    });
  }

  Future<int> submitAllergy() async {
    String? allergy =
        _allergyController.text.isNotEmpty ? _allergyController.text : null;
    String? medicalHistory =
        _mhistoryController.text.isNotEmpty ? _mhistoryController.text : null;

    if (allergy == null && medicalHistory == null) {
      return 1;
    }

    if (Platform.isAndroid) {
      DocumentReference userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uuid);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userDoc);

        if (!snapshot.exists) return;

        Map<String, dynamic> existingData =
            snapshot.data() as Map<String, dynamic>;

        String updatedAllergy =
            (existingData.containsKey('allergies') &&
                    existingData['allergies'] != null)
                ? "${existingData['allergies']}, $allergy"
                : allergy ?? '';

        String updatedMedicalHistory =
            (existingData.containsKey('medicalHistory') &&
                    existingData['medicalHistory'] != null)
                ? "${existingData['medicalHistory']}, $medicalHistory"
                : medicalHistory ?? '';

        Map<String, dynamic> updates = {};

        if (allergy != null) updates['allergies'] = updatedAllergy;
        if (medicalHistory != null) {
          updates['medicalHistory'] = updatedMedicalHistory;
        }

        transaction.update(userDoc, updates);
      });
    } else if (Platform.isLinux) {
      final url = Uri.parse(
        'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users/${widget.uuid}?key=$firebaseAPIKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String existingAllergy =
            data['fields']?['allergies']?['stringValue'] ?? '';
        String existingMedicalHistory =
            data['fields']?['medicalHistory']?['stringValue'] ?? '';
        String updatedAllergy =
            allergy != null
                ? (existingAllergy.isNotEmpty
                    ? "$existingAllergy, $allergy"
                    : allergy)
                : existingAllergy;

        String updatedMedicalHistory =
            medicalHistory != null
                ? (existingMedicalHistory.isNotEmpty
                    ? "$existingMedicalHistory, $medicalHistory"
                    : medicalHistory)
                : existingMedicalHistory;
        Map<String, dynamic> updates = {};
        if (updatedAllergy.isNotEmpty) {
          updates['allergies'] = {"stringValue": updatedAllergy};
        }
        if (updatedMedicalHistory.isNotEmpty) {
          updates['medicalHistory'] = {"stringValue": updatedMedicalHistory};
        }
        if (updates.isNotEmpty) {
          final updateUrl = Uri.parse(
            'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users/${widget.uuid}?updateMask.fieldPaths=allergies&updateMask.fieldPaths=medicalHistory&key=$firebaseAPIKey',
          );

          final updateResponse = await http.patch(
            updateUrl,
            headers: {"Content-Type": "application/json"},
            body: json.encode({"fields": updates}),
          );

          if (updateResponse.statusCode == 200) {
            // print('User details updated successfully');
          } else {
            // print('Failed to update user details: ${updateResponse.statusCode}');
          }
        }
      } else {
        // print('Failed to fetch user details: ${response.statusCode}');
      }
    }

    return 1;
  }

  Future<Map<String, dynamic>> _fetchDoctorInfo() async {
    if (Platform.isAndroid) {
      DocumentSnapshot docSnapshot =
          await FirebaseFirestore.instance.collection('doctors').doc(uid).get();
      return docSnapshot.data() as Map<String, dynamic>? ?? {};
    } else if (Platform.isLinux) {
      final response = await http.get(
        Uri.parse(
          'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/doctors/$uid?key=$firebaseAPIKey',
        ),
      );
      Map<String, dynamic> extractFieldValues(Map<String, dynamic> fields) {
        final Map<String, dynamic> extractedData = {};

        fields.forEach((key, value) {
          if (value.containsKey('stringValue')) {
            extractedData[key] = value['stringValue'];
          } else if (value.containsKey('integerValue')) {
            extractedData[key] = value['integerValue'];
          } else if (value.containsKey('booleanValue')) {
            extractedData[key] = value['booleanValue'];
          } else {
            extractedData[key] = 'N/A';
          }
        });

        return extractedData;
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('fields')) {
          return extractFieldValues(data['fields']);
        } else {
          throw Exception('Fields not found in response');
        }
      } else {
        throw Exception('Failed to fetch doctor info: ${response.statusCode}');
      }
    }

    return {};
  }

  Future<Map<String, dynamic>> _fetchPatientInfo() async {
    if (Platform.isAndroid) {
      DocumentSnapshot docSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.uuid)
              .get();
      return docSnapshot.data() as Map<String, dynamic>? ?? {};
    } else if (Platform.isLinux) {
      final response = await http.get(
        Uri.parse(
          'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users/${widget.uuid}?key=$firebaseAPIKey',
        ),
      );
      Map<String, dynamic> extractFieldValues(Map<String, dynamic> fields) {
        final Map<String, dynamic> extractedData = {};
        fields.forEach((key, value) {
          if (value.containsKey('stringValue')) {
            extractedData[key] = value['stringValue'];
          } else if (value.containsKey('integerValue')) {
            extractedData[key] = value['integerValue'];
          } else if (value.containsKey('booleanValue')) {
            extractedData[key] = value['booleanValue'];
          } else {
            extractedData[key] = 'N/A';
          }
        });
        return extractedData;
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('fields')) {
          return extractFieldValues(data['fields']);
        } else {
          throw Exception('Fields not found in response');
        }
      } else {
        throw Exception('Failed to fetch user info: ${response.statusCode}');
      }
    }
    return {};
  }

  Future<Uint8List> _fetchDoctorSignature(BuildContext context) async {
    String signatureUrl = '';
    if (Platform.isAndroid) {
      signatureUrl =
          await FirebaseStorage.instance.ref('sign/$uid.jpg').getDownloadURL();
    } else if (Platform.isLinux) {
      signatureUrl =
          'https://firebasestorage.googleapis.com/v0/b/$projectId.firebasestorage.app/o/sign%2F$uid.jpg?alt=media';
    }
    try {
      final response = await http.get(Uri.parse(signatureUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        _issign = false;
        throw Exception(
          'Failed to fetch signature image: ${response.statusCode}',
        );
      }
    } catch (e) {
      _issign = false;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error fetching signature')),
        );
        Navigator.of(context).pop();
      }

      throw Exception('Error fetching signature image: $e');
    }
  }

  Future<void> _uploadMedicineData(List<Map<String, dynamic>> medicines) async {
    final currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final String problem = _problemsController.text;
    Map<String, dynamic> doctorInfo = await _fetchDoctorInfo();
    final String doctorName = doctorInfo['name'] ?? 'N/A';

    if (Platform.isAndroid) {
      for (var medicine in medicines) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uuid)
            .collection('Medicine')
            .add({
              'date': currentDate,
              'medicine': medicine['medicine'],
              'morning': medicine['morning'],
              'noon': medicine['noon'],
              'evening': medicine['evening'],
              'days': medicine['days'],
              'doctor': doctorName,
              'problem': problem,
            });
      }
    } else if (Platform.isLinux) {
      for (var medicine in medicines) {
        try {
          final response = await http.post(
            Uri.parse(
              'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users/${widget.uuid}/Medicine?key=$firebaseAPIKey',
            ),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'fields': {
                'date': {'stringValue': currentDate},
                'medicine': {'stringValue': medicine['medicine']},
                'morning': {'integerValue': medicine['morning']?.toString()},
                'noon': {'integerValue': medicine['noon']?.toString()},
                'evening': {'integerValue': medicine['evening']?.toString()},
                'days': {'integerValue': medicine['days']?.toString()},
                'doctor': {'stringValue': doctorName},
                'problem': {'stringValue': problem},
              },
            }),
          );

          if (response.statusCode != 200) {
            throw Exception('Failed to add medicine: ${response.statusCode}');
          }
        } catch (e) {
          throw Exception('Error while posting medicine data: $e');
        }
      }
    }
  }

  Future<void> _submitForm() async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (_formKey.currentState!.validate()) {
        final problems = _problemsController.text;
        final diagnosis = _diagnosisController.text;
        final suggestion = _suggestionController.text;

        final medicines =
            _medicineControllers.map((map) {
              return {
                'medicine': map['medicine']!.text,
                'morning': int.tryParse(map['morning']!.text) ?? 0,
                'noon': int.tryParse(map['noon']!.text) ?? 0,
                'evening': int.tryParse(map['evening']!.text) ?? 0,
                'days': int.tryParse(map['days']!.text) ?? 0,
              };
            }).toList();

        final doctorInfo = await _fetchDoctorInfo();
        final patientInfo = await _fetchPatientInfo();
        Uint8List signatureBytes = Uint8List.fromList([]);
        if (mounted) {
          signatureBytes = await _fetchDoctorSignature(context);
        }

        final pdf = pw.Document();
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text("Doctor: ${doctorInfo['name'] ?? 'N/A'}"),
                          pw.Text(
                            "Qualification: ${doctorInfo['qualification'] ?? 'N/A'}",
                          ),
                          pw.Text(
                            "License No.: ${doctorInfo['licenseNumber'] ?? 'N/A'}",
                          ),
                          pw.Text("Phone: ${doctorInfo['phone'] ?? 'N/A'}"),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "Hospital: ${doctorInfo['hospital'] ?? 'N/A'}",
                          ),
                          pw.Text("Address: ${doctorInfo['address'] ?? 'N/A'}"),
                        ],
                      ),
                    ],
                  ),
                  pw.Divider(),
                  pw.Text(
                    "Date: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}",
                  ),
                  pw.Divider(),
                  pw.Text("Patient Info:"),
                  pw.Text("Name: ${patientInfo['name'] ?? 'N/A'}"),
                  pw.Text("Address: ${patientInfo['address'] ?? 'N/A'}"),
                  pw.SizedBox(height: 10),
                  pw.Text("Problem: $problems"),
                  pw.Text("Diagnosis: $diagnosis"),
                  pw.Text("Suggestions: $suggestion"),
                  pw.Divider(),
                  for (var medicine in medicines) ...[
                    pw.Text("Medicine: ${medicine['medicine'] ?? 'N/A'}"),
                    pw.Text(
                      "Dosage: Morning: ${medicine['morning'] ?? 'N/A'}, Noon: ${medicine['noon'] ?? 'N/A'}, Evening: ${medicine['evening'] ?? 'N/A'}",
                    ),
                    pw.Text("Days: ${medicine['days'] ?? 'N/A'}"),
                    pw.Divider(),
                  ],
                  pw.SizedBox(height: 10),
                  pw.Text("Doctor's Signature:"),
                  pw.Image(
                    pw.MemoryImage(signatureBytes),
                    height: 50,
                    width: 50,
                  ),
                ],
              );
            },
          ),
        );

        final outputDir = await getTemporaryDirectory();
        final filePath =
            Platform.isLinux
                ? '/home/cseb2/Downloads/prescription.pdf'
                : '${outputDir.path}/prescription.pdf';
        final file = File(filePath);
        await file.writeAsBytes(await pdf.save());

        final String currentDate = DateFormat(
          'dd-MM-yyyy',
        ).format(DateTime.now());
        final storagePath =
            'prescription/${widget.uuid}/$diagnosis$currentDate.pdf';

        if (Platform.isAndroid) {
          await FirebaseStorage.instance.ref(storagePath).putFile(file);
        } else if (Platform.isLinux) {
          const bucketName = "$projectId.firebasestorage.app";
          final encodedPath = Uri.encodeComponent(storagePath);
          final url =
              'https://firebasestorage.googleapis.com/v0/b/$bucketName/o/$encodedPath?uploadType=media';

          List<int> fileBytes = await file.readAsBytes();
          await http.post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/pdf',
              'Content-Length': fileBytes.length.toString(),
            },
            body: fileBytes,
          );
        }

        await _uploadMedicineData(medicines);
        await submitAllergy();
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Prescription uploaded successfully!'),
            ),
          );
        }
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
      if (!_issign) {
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Prescription upload Failed!')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopBar(
        onBackPress: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Upload Prescription',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _problemsController,
                    decoration: const InputDecoration(labelText: 'Problems'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter problems';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _diagnosisController,
                    decoration: const InputDecoration(labelText: 'Diagnosis'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a diagnosis';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _suggestionController,
                    decoration: const InputDecoration(labelText: 'Suggestion'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a suggestion';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _allergyController,
                    decoration: const InputDecoration(labelText: 'Allergy'),
                  ),

                  TextFormField(
                    controller: _mhistoryController,
                    decoration: const InputDecoration(
                      labelText: 'Medical History',
                    ),
                  ),

                  const SizedBox(height: 8),
                  for (int i = 0; i < _medicineControllers.length; i++) ...[
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _medicineControllers[i]['medicine'],
                      decoration: const InputDecoration(
                        labelText: 'Medicine Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter medicine name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _medicineControllers[i]['morning'],
                            decoration: const InputDecoration(
                              labelText: 'Morning',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _medicineControllers[i]['noon'],
                            decoration: const InputDecoration(
                              labelText: 'Noon',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _medicineControllers[i]['evening'],
                            decoration: const InputDecoration(
                              labelText: 'Evening',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _medicineControllers[i]['days'],
                      decoration: const InputDecoration(
                        labelText: 'Number of Days',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter number of days';
                        }
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: _addMedicineField,
                      child: const Text('Add Medicine'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      child:
                          _isLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 40, bottom: 10),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatPage()),
            );
          },
          backgroundColor: Colors.blue,
          child: ClipOval(
            child: Image.asset(
              'assets/images/bot_icon.png',
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class Appointment2Page extends StatefulWidget {
  const Appointment2Page({Key? key}) : super(key: key);

  @override
  Appointment2PageState createState() => Appointment2PageState();
}

class Appointment2PageState extends State<Appointment2Page> {
  late Map<DateTime, List<Map<String, dynamic>>> _appointments;
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _appointments = {};
    _fetchAppointmentsForSelectedDay();
  }

  Future<void> _fetchAppointmentsForSelectedDay() async {
    String formattedDate = _formatDate(_selectedDay);

    if (Platform.isAndroid) {
      final docRef = FirebaseFirestore.instance
          .collection('doctors')
          .doc(uid)
          .collection('appointments')
          .doc('accepted')
          .collection(formattedDate);

      QuerySnapshot snapshot = await docRef.get();
      if (snapshot.docs.isEmpty) {
        setState(() {
          _appointments[_selectedDay] = [];
        });
      } else {
        List<Map<String, dynamic>> appointmentList =
            snapshot.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              List<String> timeList = [];
              if (data.containsKey('time') && data['time'] is List) {
                timeList = List<String>.from(
                  data['time'].map((v) => v.toString()),
                );
              } else {
                timeList = ['Not yet assigned'];
              }

              return {'name': data['name'] ?? 'Unknown', 'time': timeList};
            }).toList();

        setState(() {
          _appointments[_selectedDay] = appointmentList;
        });
      }
    } else if (Platform.isLinux) {
      final url = Uri.parse(
        'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/doctors/$uid/appointments/accepted/$formattedDate?key=$firebaseAPIKey',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['documents'] == null) {
          setState(() {
            _appointments[_selectedDay] = [];
          });
        } else {
          List<Map<String, dynamic>> appointmentList =
              data['documents'].map<Map<String, dynamic>>((doc) {
                Map<String, dynamic> fields = doc['fields'];
                List<String> timeList = [];
                if (fields.containsKey('time') &&
                    fields['time'].containsKey('arrayValue')) {
                  timeList = List<String>.from(
                    fields['time']['arrayValue']['values'].map(
                      (v) => v['stringValue'].toString(),
                    ),
                  );
                } else {
                  timeList = ['Not yet assigned'];
                }

                return {
                  'name': fields['name']['stringValue'] ?? 'Unknown',
                  'time': timeList,
                };
              }).toList();

          setState(() {
            _appointments[_selectedDay] = appointmentList;
          });
        }
      } else {
        setState(() {
          _appointments[_selectedDay] = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopBar(
        onBackPress: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Home2Page()),
          );
        },
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Appointments",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay =
                        focusedDay.isAfter(DateTime(2025, 12, 31))
                            ? DateTime(2025, 12, 31)
                            : focusedDay;
                  });
                  _fetchAppointmentsForSelectedDay();
                },
                calendarFormat: CalendarFormat.month,
                availableCalendarFormats: const {CalendarFormat.month: 'Month'},
              ),
              const SizedBox(height: 20),
              _buildAppointmentsForDay(_selectedDay),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  Widget _buildAppointmentsForDay(DateTime day) {
    List<Map<String, dynamic>> appointmentsForDay = _appointments[day] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Appointments for ${_formatDate(day)}:',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        if (appointmentsForDay.isEmpty)
          const Text('No appointments for this day.'),
        ...appointmentsForDay.map(
          (appointment) => GestureDetector(
            onTap: () => _showAppointmentDetails(appointment),
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Patient: ${appointment['name']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAppointmentDetails(Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder: (context) {
        List<String> times =
            (appointment['time'] is List<String>)
                ? List<String>.from(appointment['time'])
                : ['Not yet assigned'];
        String timeDisplay = times.join(', ');

        return AlertDialog(
          title: const Text('Appointment Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Patient: ${appointment['name']}'),
              Text('Time: $timeDisplay'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return SizedBox(
      height: 120,
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _circularNavButton(
                Icons.home,
                "Home",
                context,
                const Home2Page(),
              ),
              _circularNavButton(
                Icons.search,
                "Search",
                context,
                const Search2Page(),
              ),
              _circularNavButton(
                Icons.calendar_today,
                "Appointments",
                context,
                const Appointment2Page(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circularNavButton(
    IconData icon,
    String label,
    BuildContext context,
    Widget page,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            if (ModalRoute.of(context)?.settings.name !=
                page.runtimeType.toString()) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => page,
                  settings: RouteSettings(name: page.runtimeType.toString()),
                ),
              );
            }
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: Center(child: Icon(icon, color: Colors.white, size: 28)),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class ChronicDiseasePage extends StatefulWidget {
  final String uuid;
  const ChronicDiseasePage({Key? key, required this.uuid}) : super(key: key);

  @override
  ChronicDiseasePageState createState() => ChronicDiseasePageState();
}

class ChronicDiseasePageState extends State<ChronicDiseasePage> {
  List<Map<String, String>> chronicDiseases = [];
  String _selectedFilter = "All";
  bool _showFilterOptions = false;
  final List<String> _filters = ["All", "Latest", "Earliest"];

  @override
  void initState() {
    super.initState();
    _fetchChronicDiseases();
  }

  Future<void> _fetchChronicDiseases() async {
    if (Platform.isAndroid) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uuid)
          .collection('chronic disease')
          .get()
          .then((QuerySnapshot snapshot) {
            setState(() {
              chronicDiseases =
                  snapshot.docs
                      .map(
                        (doc) => {
                          'type': doc['type']?.toString() ?? '',
                          'reading': doc['reading']?.toString() ?? '',
                          'date': doc['date']?.toString() ?? '',
                        },
                      )
                      .toList();
              _applyFilter();
            });
          });
    } else if (Platform.isLinux) {
      final String apiUrl =
          'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users/${widget.uuid}/chronic%20disease';

      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          chronicDiseases =
              data['documents']
                  .map<Map<String, String>>((doc) {
                    final fields = doc['fields'];
                    return {
                      'type': fields['type']['stringValue']?.toString() ?? '',
                      'reading':
                          fields['reading']['stringValue']?.toString() ?? '',
                      'date': fields['date']['stringValue']?.toString() ?? '',
                    };
                  })
                  .toList()
                  .cast<Map<String, String>>();
          _applyFilter();
        });
      }
    }
  }

  void _applyFilter() {
    if (_selectedFilter == "Latest") {
      chronicDiseases.sort((a, b) {
        DateTime? dateA = _parseDate(a['date']);
        DateTime? dateB = _parseDate(b['date']);
        return dateB.compareTo(dateA);
      });
    } else if (_selectedFilter == "Earliest") {
      chronicDiseases.sort((a, b) {
        DateTime? dateA = _parseDate(a['date']);
        DateTime? dateB = _parseDate(b['date']);
        return dateA.compareTo(dateB);
      });
    }
  }

  DateTime _parseDate(String? dateString) {
    if (dateString == null ||
        !RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(dateString)) {
      throw FormatException("Invalid date format: $dateString");
    }
    final parts = dateString.split('/');
    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (Platform.isAndroid || Platform.isIOS) {
            //do nothing
          }
        }
      },
      child: Scaffold(
        appBar: CustomTopBar(
          onBackPress: () {
            Navigator.pop(context);
          },
        ),
        body: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Chronic Diseases",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showFilterOptions = !_showFilterOptions;
                        });
                      },
                      icon: const Icon(Icons.filter_list),
                      label: const Text("Filter"),
                    ),
                    Text(
                      _selectedFilter,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (_showFilterOptions)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 4),
                    ],
                  ),
                  child: Column(
                    children:
                        _filters
                            .map(
                              (filter) => ListTile(
                                title: Text(filter),
                                onTap: () {
                                  setState(() {
                                    _selectedFilter = filter;
                                    _showFilterOptions = false;
                                    _applyFilter();
                                  });
                                },
                              ),
                            )
                            .toList(),
                  ),
                ),
              Expanded(
                child:
                    chronicDiseases.isEmpty
                        ? const Center(
                          child: Text(
                            "No Data Available",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: chronicDiseases.length,
                          itemBuilder: (context, index) {
                            final disease = chronicDiseases[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Type: ${disease['type']}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text("Reading: ${disease['reading']}"),
                                  const SizedBox(height: 8),
                                  Text("Date: ${disease['date']}"),
                                ],
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
        floatingActionButton: _buildChatBotButton(context), // ✅ FIXED
      ),
    );
  }

  Widget _buildChatBotButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatPage()),
        );
      },
      backgroundColor: Colors.blue,
      child: ClipOval(
        child: Image.asset(
          'assets/images/bot_icon.png',
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class PrescriptionsPage extends StatefulWidget {
  final String uuid;
  const PrescriptionsPage({Key? key, required this.uuid}) : super(key: key);

  @override
  PrescriptionsPageState createState() => PrescriptionsPageState();
}

class PrescriptionsPageState extends State<PrescriptionsPage> {
  String _selectedFilter = "Latest";
  bool _showFilterOptions = false;
  final List<String> _filters = ["Latest", "Earliest"];
  List<Reference> _files = [];

  @override
  void initState() {
    super.initState();
    _fetchPrescriptions();
  }

  Future<void> _fetchPrescriptions() async {
    final storageRef = FirebaseStorage.instance.ref().child(
      'prescription/${widget.uuid}/',
    );

    if (Platform.isAndroid) {
      final ListResult result = await storageRef.listAll();
      setState(() {
        _files = result.items;
        _applyFilter();
      });
    }
  }

  void _applyFilter() {
    if (_selectedFilter == "Latest") {
      _files.sort((a, b) {
        DateTime dateA = _parseDateFromName(a.name);
        DateTime dateB = _parseDateFromName(b.name);
        return dateB.compareTo(dateA);
      });
    } else if (_selectedFilter == "Earliest") {
      _files.sort((a, b) {
        DateTime dateA = _parseDateFromName(a.name);
        DateTime dateB = _parseDateFromName(b.name);
        return dateA.compareTo(dateB);
      });
    }
  }

  DateTime _parseDateFromName(String name) {
    try {
      String withoutExtension = name.substring(0, name.length - 4);
      String dateString = withoutExtension.substring(
        withoutExtension.length - 10,
      );
      List<String> parts = dateString.split('-');
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);

      return DateTime(year, month, day);
    } catch (e) {
      return DateTime.now();
    }
  }

  Future<void> _downloadAndOpenFile(Reference fileRef) async {
    final String fileName = path.basename(fileRef.name).replaceAll('.pdf', '');
    if (Platform.isAndroid) {
      final Directory tempDir = await getTemporaryDirectory();
      final File tempFile = File('${tempDir.path}/$fileName.pdf');
      await fileRef.writeToFile(tempFile);
      OpenFile.open(tempFile.path);
    } else if (Platform.isLinux) {
      final String downloadUrl = await fileRef.getDownloadURL();
      final Directory tempDir = await getApplicationDocumentsDirectory();
      final File localFile = File('${tempDir.path}/$fileName.pdf');
      final http.Response response = await http.get(Uri.parse(downloadUrl));
      await localFile.writeAsBytes(response.bodyBytes);
      OpenFile.open(localFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (Platform.isAndroid || Platform.isIOS) {
            //do nothing
          }
        }
      },
      child: Scaffold(
        appBar: CustomTopBar(
          onBackPress: () {
            Navigator.pop(context);
          },
        ),
        body: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Prescription",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showFilterOptions = !_showFilterOptions;
                        });
                      },
                      icon: const Icon(Icons.filter_list),
                      label: const Text("Filter"),
                    ),
                    Text(
                      _selectedFilter,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (_showFilterOptions)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 4),
                    ],
                  ),
                  child: Column(
                    children:
                        _filters.map((filter) {
                          return ListTile(
                            title: Text(filter),
                            onTap: () {
                              setState(() {
                                _selectedFilter = filter;
                                _showFilterOptions = false;
                                _applyFilter();
                              });
                            },
                          );
                        }).toList(),
                  ),
                ),
              Expanded(
                child:
                    _files.isEmpty
                        ? const Center(
                          child: Text(
                            "No prescriptions available",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _files.length,
                          itemBuilder: (context, index) {
                            final fileRef = _files[index];
                            final fileName = path
                                .basename(fileRef.name)
                                .replaceAll('.pdf', '');

                            return GestureDetector(
                              onTap: () => _downloadAndOpenFile(fileRef),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      fileName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "Click here to download File",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
        floatingActionButton: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 20),
            child: _buildChatBotButton(context),
          ),
        ),
      ),
    );
  }

  Widget _buildChatBotButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatPage()),
        );
      },
      backgroundColor: Colors.blue,
      child: ClipOval(
        child: Image.asset(
          'assets/images/bot_icon.png',
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
