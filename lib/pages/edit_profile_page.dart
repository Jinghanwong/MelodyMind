import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String selectedProfile = 'assets/images/profile0.jpg';
  final List<String> profile = [
    'assets/images/profile1.jpg',
    'assets/images/profile2.jpg',
    'assets/images/profile3.jpg',
    'assets/images/profile4.jpg',
    'assets/images/profile5.jpg',
    'assets/images/profile6.jpg',
  ];
  
  bool _profileUpdated = false;
  String _originalUsername = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(user.uid)
          .get();
      
      if (userData.exists) {
        setState(() {
          _usernameController.text = (userData.value as Map)['username'] ?? '';
          _originalUsername = (userData.value as Map)['username'] ?? '';
          _emailController.text = (userData.value as Map)['email'] ?? '';
          selectedProfile = (userData.value as Map)['profilerPath'] ?? 'assets/images/profile0.jpg';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        if (_profileUpdated && _usernameController.text != _originalUsername) {
          Navigator.pop(context, _usernameController.text);
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF0F5),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF753027)),
            onPressed: () {
              if (_profileUpdated && _usernameController.text != _originalUsername) {
                Navigator.pop(context, _usernameController.text);
              } else {
                Navigator.pop(context);
              }
            },
          ),
          title: const Text(
            'Edit Profile',
            style: TextStyle(
              color: Color(0xFF753027),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: screenHeight * 0.04),
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(selectedProfile),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Select Character'),
                                  content: SizedBox(
                                    height: 200,
                                    width: 300,
                                    child: GridView.builder(
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                      ),
                                      itemCount: profile.length,
                                      itemBuilder: (context, index) => GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedProfile = profile[index];
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: CircleAvatar(
                                          backgroundImage: AssetImage(profile[index]),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Change Your Character',
                              style: TextStyle(
                                color: Color(0xFF753027),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Username',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person_outline, color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: screenHeight * 0.015,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        TextFormField(
                          controller: _emailController,
                          enabled: false,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: screenHeight * 0.015,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.1),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          );
                          
                          try {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              await FirebaseDatabase.instance
                                  .ref()
                                  .child('users')
                                  .child(user.uid)
                                  .update({
                                'username': _usernameController.text,
                                'profilerPath': selectedProfile,
                              });
                              
                              setState(() {
                                _profileUpdated = true;
                              });
                              
                              Navigator.pop(context);
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Update successful'),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          } catch (e) {
                            Navigator.pop(context);
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Update failed: ${e.toString()}'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xBFD99898),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}