import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:table_calendar/table_calendar.dart';





void main() {
  runApp(VitalChainApp());
}

class VitalChainApp extends StatelessWidget {
  const VitalChainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vital Chain',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LandingPage(),
    );
  }
}

class CustomTopBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackPress; // Custom back action

  const CustomTopBar({Key? key, this.onBackPress}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60); // Increased height

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onBackPress != null) {
          onBackPress!(); // Use custom back function if provided
        } else if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(); // Default back action
        }
      },
      child: Container(
        width: double.infinity, // Ensures full width
        color: Colors.lightBlue[100], // Light blue background
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Adjusted padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end, // Align contents to the bottom
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end, // Lowers the contents
              children: [
                // Logo
                Image.asset(
                  'web/icons/WhatsApp Image 2025-01-26 at 8.44.37 AM.jpeg',
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 10), // Space between logo and text

                // Text "VITAL CHAIN"
                const Text(
                  'VITAL CHAIN',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CommonScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;

  const CommonScaffold({Key? key, required this.body, this.appBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar, // Custom or default app bar
      body: body, // The body content passed in
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the ChatPage when the chat button is clicked
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatPage()),
          );
        },
        backgroundColor: Colors.blue,
        child: ClipOval( // Ensures the image is circular inside the button
          child: Image.asset(
            'assets/images/bot_icon.png', // Path to your custom image
            height: 50,  // Set the height of the image (button size)
            width: 50,   // Set the width of the image (button size)
            fit: BoxFit.cover,  // Makes the image fill the button area and maintain aspect ratio
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
      appBar: const CustomTopBar(), // Custom Top Bar
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Slideshow (PageView) widget with bigger rectangular size
              SizedBox(
                width: 350, // Increased width for a more rectangular look
                height: 250, // Increased height for a larger size
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    // Slide 1
                    Container(
                      color: Colors.blue[100],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
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
                    // Slide 2
                    Container(
                      color: Colors.green[100],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
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
                    // Slide 3
                    Container(
                      color: Colors.red[100],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
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
                              'Search nearby hospitals and doctors.',
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
                    // Slide 4
                    Container(
                      color: Colors.orange[100],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
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
                    // Slide 5
                    Container(
                      color: Colors.purple[100],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
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
              const SizedBox(height: 10), // Space between slideshow and indicators

              // Slide indicators
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
              const SizedBox(height: 30), // Space between slideshow and buttons

              // Row with Login and Register Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Login Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Button background color
                      side: const BorderSide(color: Colors.blue), // Blue border
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.blue, // Text color
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20), // Space between the buttons

                  // Register Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button background color
                      side: const BorderSide(color: Colors.white), // White border
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                      ),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white, // Text color
                        fontSize: 16,
                      ),
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
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LandingPage()),
        );
        return false; // Prevents default back action
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
                Align(
                  alignment: Alignment.topRight,
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // App Icon
                Image.asset(
                  'web/icons/WhatsApp Image 2025-01-26 at 8.44.37 AM.jpeg',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 20),

                // App Name
                const Text(
                  'VITAL CHAIN',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 40),

                // Email TextField
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 20),

                // Password TextField
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 30),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 18),
                    ),
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
            Align(
              alignment: Alignment.topRight,
              child: const Text(
                'Register',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
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

                  // User Button
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
                      child: const Text(
                        'User',
                        style: TextStyle(fontSize: 18),
                      ),
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

  Future<void> _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      String userMessage = _controller.text.trim();

      setState(() {
        _messages.add({"role": "user", "content": userMessage});
        _isLoading = true;
      });

      _controller.clear(); // Clears input field after capturing the message

      try {
        final response = await http.post(
          Uri.parse("https://api.groq.com/openai/v1/chat/completions"), // Direct API call to Groq API
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer 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", // Replace with your Groq API key
          },
          body: jsonEncode({
            "messages": [{"role": "user", "content": userMessage}],
            "model": "llama3-8b-8192", // Adjust model as needed
          }),
        );

        // Debugging: Check the status code and response body
        print('Response Status: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          print('Response Data: $responseData'); // Log the full response

          final reply = responseData["choices"]?[0]["message"]["content"] ?? "No response from server";
          setState(() {
            _messages.add({"role": "bot", "content": reply});
          });
        } else {
          setState(() {
            _messages.add({"role": "bot", "content": "Failed to fetch response from the server."});
          });
        }
      } catch (error) {
        print('Error: $error'); // Log the error
        setState(() {
          _messages.add({"role": "bot", "content": "Error connecting to server."});
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
      onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard when tapping outside
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
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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

  // Controllers for the form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();  // OTP Controller

  bool _isOtpEntered = false;  // To track if OTP is entered

  void _showOtpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Enter OTP'),
              content: TextField(
                controller: _otpController,
                decoration: const InputDecoration(
                  hintText: 'Enter OTP',
                ),
                onChanged: (text) {
                  // Updating state within the dialog using StatefulBuilder
                  setState(() {
                    _isOtpEntered = text.isNotEmpty;
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: _isOtpEntered
                      ? () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LandingPage()), // Navigate back to the first page
                          (Route<dynamic> route) => false, // Removes all previous routes
                    );
                  }
                      : null, // Disable the button if OTP is not entered
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomTopBar(), // Your custom app bar
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
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Name field
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Age field
                  TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your age';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Gender field
                  TextFormField(
                    controller: _genderController,
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your gender';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Address field
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

                  // Phone number field
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Email field
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
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Password field
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
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _showOtpDialog();
                        }
                      },
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

          // Floating Chat Button
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                // Navigate to chat page
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

  // Controllers for the form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController(); // License number controller
  final TextEditingController _hospitalController = TextEditingController(); // Hospital name controller
  final TextEditingController _departmentController = TextEditingController(); // Department controller
  final TextEditingController _otpController = TextEditingController(); // OTP controller

  bool _isOtpEntered = false; // To track if OTP is entered

  void _showOtpDialog() {
    _otpController.clear(); // Clear the OTP field every time the dialog is opened
    _isOtpEntered = false; // Reset the OTP state

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Enter OTP'),
              content: TextField(
                controller: _otpController, // Use the OTP controller here
                decoration: const InputDecoration(
                  hintText: 'Enter OTP',
                ),
                keyboardType: TextInputType.text, // Normal keyboard
                onChanged: (text) {
                  setState(() {
                    _isOtpEntered = text.isNotEmpty; // Update button state
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: _isOtpEntered
                      ? () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LandingPage()), // Navigate back to the first page
                          (Route<dynamic> route) => false, // Removes all previous routes
                    );
                  }
                      : null, // Disable the button if OTP is not entered
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomTopBar(), // Your custom app bar
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
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Name field
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Age field
                  TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your age';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Gender field
                  TextFormField(
                    controller: _genderController,
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your gender';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Address field
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

                  // Phone number field
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Email field
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
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Password field
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
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // License Number field (Doctor-specific)
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

                  // Hospital Name field
                  TextFormField(
                    controller: _hospitalController,
                    decoration: const InputDecoration(
                      labelText: 'Hospital Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the hospital name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Department field
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

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _showOtpDialog();
                        }
                      },
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

          // Floating Chat Button
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                // Navigate to chat page
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




class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  void _showSettings(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Settings",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Align(
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
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0),
              child: const Text(
                'Profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/profile_pic.png'),
                  ),
                  const SizedBox(height: 10),
                  const Text('NAME', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  const Text('Check-Up ALERT', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 20),

                  // Buttons with equal sizes
                  SizedBox(
                    width: 250,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child:ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const EditingPage()),
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

            // Patient Details Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Patient Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text('Age: ', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text('Weight: ', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text('Height: ', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text('Gender:', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text('User Condition: ', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  const Text('Allergies', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text('', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  const Text('Medical History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text('', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class SettingsPage extends StatelessWidget {
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
          const SizedBox(height: 25), // Added space to lower the text
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Settings",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                // Add more settings options here if needed
              ],
            ),
          ),
          const Spacer(), // Pushes buttons to the bottom
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Delete Account"),
                          content: const Text(
                              "Do you want to delete your account permanently?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close dialog
                              },
                              child: const Text("No"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close dialog
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LandingPage()),
                                );
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
                    Navigator.pop(context); // Close settings panel
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 50), // Full width button
                  ),
                  child:
                  const Text("Logout", style: TextStyle(color: Colors.white)),
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









class EditingPage extends StatelessWidget {
  const EditingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomTopBar(), // Custom top bar
      resizeToAvoidBottomInset: true, // Ensures content resizes when keyboard appears
      body: SingleChildScrollView( // Wrap the content in a scrollable view
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Section
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/profile_pic.png'), // Placeholder for profile pic
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Handle edit profile picture action
                      },
                      child: const Text("Edit Profile Picture"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Edit Profile Section
              const Text(
                "Edit Profile",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Profile fields
              TextFormField(
                decoration: const InputDecoration(labelText: "Name"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: "Age"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: "Weight"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: "Height"),
              ),
              const SizedBox(height: 20),

              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to Profile Page
                  },
                  child: const Text("Save Changes"),
                ),
              ),
            ],
          ),
        ),
      ),

      // Chatbot Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to chat page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatPage()),
          );
        },
        backgroundColor: Colors.blue,
        child: ClipOval(
          child: Image.asset(
            'assets/images/bot_icon.png', // Assuming this is your chatbot icon
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}



class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid || Platform.isIOS) {
          exit(0);
        }
        return false;
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                              MaterialPageRoute(builder: (context) => const ProfilePage()),
                            );
                          },
                          child: const CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage('assets/images/profile_icon.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: const [
                        Text("Tap the profile icon to go to Profile Page"),
                      ],
                    ),
                  ),
                  // 3x2 Grid of oval buttons with updated sizes
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Wrap(
                      spacing: 16.0,
                      runSpacing: 16.0,
                      children: [
                        _buildFeatureButton("Document", Icons.description, context),
                        _buildFeatureButton("Medication", Icons.medication, context),
                        _buildFeatureButton("Appointments", Icons.calendar_today, context),
                        _buildFeatureButton("Lab Results", Icons.medical_services, context),
                        _buildFeatureButton("Chronic Diseases", Icons.health_and_safety, context),
                        _buildFeatureButton("Health Insurance", Icons.insights, context),
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

  static Widget _buildFeatureButton(String label, IconData icon, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (label == "Appointments") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AppointmentPage()),
          );
        } else {
          print('$label tapped');
        }
      },
      child: Container(
        width: 140, // Increased width for round-rectangle shape
        height: 80,  // Reduced height
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(30), // Smooth rounded edges
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
    return Container(
      height: 100,
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavButton(Icons.home, "Home", context, const HomePage()),
            _buildNavButton(Icons.search, "Search", context, const SearchPage()),
            _buildNavButton(Icons.show_chart, "Graph", context, const GraphPage()),
            _buildNavButton(Icons.medical_services, "Prescription", context, const PrescriptionPage()),
          ],
        ),
      ),
    );
  }

  static Widget _buildNavButton(IconData icon, String label, BuildContext context, Widget page) {
    return GestureDetector(
      onTap: () {
        if (context.widget.runtimeType != page.runtimeType) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => page),
            ModalRoute.withName('/'),
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
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}



class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          ModalRoute.withName('/'),
        );
        return false;
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Search",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Search results will appear here...",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              ],
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
    return Container(
      height: 100,
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavButton(Icons.home, "Home", context, const HomePage()),
            _buildNavButton(Icons.search, "Search", context, const SearchPage()),
            _buildNavButton(Icons.show_chart, "Graph", context, const GraphPage()),
            _buildNavButton(Icons.medical_services, "Prescription", context, const PrescriptionPage()),
          ],
        ),
      ),
    );
  }

  static Widget _buildNavButton(IconData icon, String label, BuildContext context, Widget page) {
    return GestureDetector(
      onTap: () {
        if (context.widget.runtimeType != page.runtimeType) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => page),
            ModalRoute.withName('/'),
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
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class GraphPage extends StatelessWidget {
  const GraphPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          ModalRoute.withName('/'),
        );
        return false;
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
                  "Graph Data",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    height: 300,
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: const Center(
                      child: Text(
                        "Graph will be displayed here...",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
    return Container(
      height: 100,
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavButton(Icons.home, "Home", context, const HomePage()),
            _buildNavButton(Icons.search, "Search", context, const SearchPage()),
            _buildNavButton(Icons.show_chart, "Graph", context, const GraphPage()),
            _buildNavButton(Icons.medical_services, "Prescription", context, const PrescriptionPage()),
          ],
        ),
      ),
    );
  }

  static Widget _buildNavButton(IconData icon, String label, BuildContext context, Widget page) {
    return GestureDetector(
      onTap: () {
        if (context.widget.runtimeType != page.runtimeType) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => page),
            ModalRoute.withName('/'),
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
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class PrescriptionPage extends StatefulWidget {
  const PrescriptionPage({Key? key}) : super(key: key);

  @override
  _PrescriptionPageState createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  String _selectedFilter = "Default";
  bool _showFilterOptions = false;
  final List<String> _filters = ["Latest", "Earliest", "Default"];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          ModalRoute.withName('/'),
        );
        return false;
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
                  "Prescriptions",
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
                    Text(_selectedFilter, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                  ),
                  child: Column(
                    children: _filters.map((filter) {
                      return ListTile(
                        title: Text(filter),
                        onTap: () {
                          setState(() {
                            _selectedFilter = filter;
                            _showFilterOptions = false;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: 5, // Example count, replace with actual data
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Prescription Title", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text("Prescription details will appear here...", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
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

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 100,
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavButton(Icons.home, "Home", context, const HomePage()),
            _buildNavButton(Icons.search, "Search", context, const SearchPage()),
            _buildNavButton(Icons.show_chart, "Graph", context, const GraphPage()),
            _buildNavButton(Icons.medical_services, "Prescription", context, const PrescriptionPage()),
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

  Widget _buildNavButton(IconData icon, String label, BuildContext context, Widget page) {
    return GestureDetector(
      onTap: () {
        if (context.widget.runtimeType != page.runtimeType) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => page),
            ModalRoute.withName('/'),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blue,
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key? key}) : super(key: key);

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  late Map<DateTime, List<String>> _appointments;
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _appointments = {}; // ✅ Initialize appointments map

    // Ensure _focusedDay does not exceed last allowed day
    DateTime lastAllowedDay = DateTime(2025, 12, 31);
    if (_focusedDay.isAfter(lastAllowedDay)) {
      _focusedDay = lastAllowedDay;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: const CustomTopBar(), // ✅ Use Custom Top Bar
      body: SingleChildScrollView( // ✅ Fix Overflow
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

              // ✅ Fixed Calendar Overflow Issue
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay.isAfter(DateTime(2025, 12, 31))
                        ? DateTime(2025, 12, 31)
                        : focusedDay;
                  });
                },
                calendarFormat: CalendarFormat.month, // ✅ Set fixed month format
                availableCalendarFormats: {CalendarFormat.month: 'Month'}, // ✅ Disable format toggle
              ),


              const SizedBox(height: 20),

              // ✅ Make Appointments List Scrollable to Avoid Overflow
              _buildAppointmentsForDay(_selectedDay),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Helper function to display appointments
  Widget _buildAppointmentsForDay(DateTime day) {
    String formattedDate =
        '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
    List<String> appointmentsForDay = _appointments[day] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Appointments for $formattedDate:',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        if (appointmentsForDay.isEmpty)
          const Text('No appointments for this day.'),
        ...appointmentsForDay.map(
              (appointment) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(appointment),
          ),
        ),
      ],
    );
  }
}