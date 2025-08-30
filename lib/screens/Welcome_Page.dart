import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/screens/login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a consistent color scheme for the welcome page
    const primaryColor = Color(0xFF6E41E2);
    const backgroundColor = Color(0xFF121212);
    const cardBackgroundColor = Color(0xFF1E1E1E);
    const textColor = Colors.white;
    const secondaryTextColor = Colors.white70;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'UltrafastSMM',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text(
              'Sign In',
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(
              context,
              primaryColor,
              textColor,
              secondaryTextColor,
            ),
            _buildWhyChooseUsSection(
              cardBackgroundColor,
              textColor,
              secondaryTextColor,
            ),
            _buildHowItWorksSection(
              primaryColor,
              cardBackgroundColor,
              textColor,
              secondaryTextColor,
            ),
            _buildServicesPreviewSection(
              cardBackgroundColor,
              textColor,
              secondaryTextColor,
            ),
            _buildFooter(secondaryTextColor),
          ],
        ),
      ),
    );
  }

  // Section 1: Hero Section with headline and call to action
  Widget _buildHeroSection(
    BuildContext context,
    Color primaryColor,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'The #1 SMM Panel for Resellers',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: textColor,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'We provide the cheapest SMM Panel services amongst our competitors. If you\'re looking for a super-easy way to offer additional marketing services to your existing and new clients, look no further!',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              fontSize: 18,
              color: secondaryTextColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Get Started Now',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Section 2: Features / "Why Choose Us"
  Widget _buildWhyChooseUsSection(
    Color cardBackgroundColor,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
      color: const Color(0xFF1A1A1A),
      child: Column(
        children: [
          Text(
            'Why Our Panel Is The Best',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: const [
              FeatureCard(
                icon: Icons.flash_on,
                title: 'Instant Delivery',
                description:
                    'Our services kick in the moment you order, ensuring rapid results.',
              ),
              FeatureCard(
                icon: Icons.verified_user,
                title: 'High Quality',
                description:
                    'We provide top-tier, reliable services to boost your social presence.',
              ),
              FeatureCard(
                icon: Icons.support_agent,
                title: '24/7 Support',
                description:
                    'Our dedicated support team is always available to assist you.',
              ),
              FeatureCard(
                icon: Icons.savings,
                title: 'Best Prices',
                description:
                    'Get the most competitive prices in the market without compromising quality.',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Section 3: "How It Works"
  Widget _buildHowItWorksSection(
    Color primaryColor,
    Color cardBackgroundColor,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
      child: Column(
        children: [
          Text(
            'Get Started in 3 Easy Steps',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              HowItWorksStep(
                number: '1',
                title: 'Register',
                description: 'Create an account with us in just a few clicks.',
              ),
              // You can add a divider here if you like
              HowItWorksStep(
                number: '2',
                title: 'Add Funds',
                description:
                    'Easily deposit money into your account with various payment methods.',
              ),
              HowItWorksStep(
                number: '3',
                title: 'Place Order',
                description:
                    'Choose from our wide range of services and place your order.',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Section 4: Services Preview
  Widget _buildServicesPreviewSection(
    Color cardBackgroundColor,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
      color: const Color(0xFF1A1A1A),
      child: Column(
        children: [
          Text(
            'Our Services',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'We offer a wide variety of services for all major social media platforms.',
            style: GoogleFonts.lato(color: secondaryTextColor, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: const [
              ServiceIcon(icon: Icons.camera_alt, label: 'Instagram'),
              ServiceIcon(icon: Icons.facebook, label: 'Facebook'),
              ServiceIcon(icon: Icons.play_arrow, label: 'YouTube'),
              ServiceIcon(icon: Icons.chat_bubble, label: 'X (Twitter)'),
              ServiceIcon(icon: Icons.music_note, label: 'TikTok'),
              ServiceIcon(icon: Icons.send, label: 'Telegram'),
            ],
          ),
        ],
      ),
    );
  }

  // Section 5: Footer
  Widget _buildFooter(Color secondaryTextColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Text(
        '© 2024 UltrafastSMM. All Rights Reserved.',
        style: TextStyle(color: secondaryTextColor),
      ),
    );
  }
}

// --- Helper Widgets for the Welcome Page ---

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF6E41E2), size: 40),
          const SizedBox(height: 15),
          Text(
            title,
            style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class HowItWorksStep extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const HowItWorksStep({
    super.key,
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xFF6E41E2),
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class ServiceIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const ServiceIcon({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: const Color(0xFF1E1E1E),
          child: Icon(icon, size: 30, color: const Color(0xFF6E41E2)),
        ),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
