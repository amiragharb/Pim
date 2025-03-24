import 'package:flutter/material.dart';
import 'package:tesst1/Views/AssitantVocal/SpeechInteractionPage.dart';
import 'package:tesst1/Views/Chat/ChatListScreen.dart';
import 'package:tesst1/Views/HomePages/CustomBottomNavBar.dart';
import 'package:tesst1/Views/HomePages/avatarDefaultscreen.dart';

class HomePagePatient extends StatefulWidget {
  const HomePagePatient({super.key});

  @override
  _HomePagePatientState createState() => _HomePagePatientState();
}

class _HomePagePatientState extends State<HomePagePatient> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AvatarDefaultScreen()),
      );
    }
  }

  void _startVoiceAssistance() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SpeechInteractionPage()),
    );
  }

  void _openChat() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatListScreen()), // ✅ Rediriger vers la liste des conversations
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Accueil',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFF9D50BB),
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.message, color: Colors.white, size: 28), // ✅ Icône de messagerie
            onPressed: _openChat,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF723D92), Color(0xFF9D50BB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  )
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -40,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AvatarDefaultScreen()),
                      ),
                      child: const CircleAvatar(
                        radius: 80,
                        backgroundImage:
                            AssetImage('assets/splash_image.png'),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: _startVoiceAssistance,
        backgroundColor: const Color(0xFF9D50BB),
        shape: const CircleBorder(),
        elevation: 8,
        child: const Icon(Icons.mic, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: CustomBottomNavBarPatient(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }
}
