import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _fadeController;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Predictive Precision',
      description:
          'Leverage advanced machine learning to analyze your health data and predict diabetes risk with clinical accuracy.',
      icon: Icons.psychology_outlined,
      gradientColors: [Color(0xFF0B1437), Color(0xFF1A3A6B)],
      accentColor: Color(0xFF00D4FF),
    ),
    OnboardingData(
      title: 'Real-Time Monitoring',
      description:
          'Track your glucose levels, activity, and health metrics in real-time with instant AI-powered insights.',
      icon: Icons.monitor_heart_outlined,
      gradientColors: [Color(0xFF0B2137), Color(0xFF0D4B6B)],
      accentColor: Color(0xFF00FF94),
    ),
    OnboardingData(
      title: 'Personalized Care',
      description:
          'Receive tailored recommendations and alerts based on your unique health profile and lifestyle patterns.',
      icon: Icons.favorite_outline,
      gradientColors: [Color(0xFF1A0B37), Color(0xFF3D1A6B)],
      accentColor: Color(0xFFFF6B9D),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildPage(_pages[index]);
            },
          ),
          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'DiaCare AI',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  if (_currentPage < _pages.length - 1)
                    GestureDetector(
                      onTap: _navigateToLogin,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Skip',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _pages.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: Colors.white,
                      dotColor: Colors.white.withOpacity(0.4),
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage == _pages.length - 1
                                ? 'Get Started'
                                : 'Next',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: data.gradientColors,
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: data.accentColor.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            top: 80,
            left: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: data.accentColor.withOpacity(0.06),
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 80),
                // Illustration area
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: _buildIllustration(data),
                  ),
                ),
                // Text content
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          data.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          data.description,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.75),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 160),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration(OnboardingData data) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer ring glow
        Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: data.accentColor.withOpacity(0.04),
            border: Border.all(
              color: data.accentColor.withOpacity(0.15),
              width: 1,
            ),
          ),
        ),
        // Middle ring
        Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: data.accentColor.withOpacity(0.06),
            border: Border.all(
              color: data.accentColor.withOpacity(0.25),
              width: 1.5,
            ),
          ),
        ),
        // Inner circle with icon
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                data.accentColor.withOpacity(0.3),
                data.accentColor.withOpacity(0.05),
              ],
            ),
            border: Border.all(
              color: data.accentColor.withOpacity(0.6),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: data.accentColor.withOpacity(0.3),
                blurRadius: 40,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Icon(
            data.icon,
            size: 72,
            color: data.accentColor,
          ),
        ),
        // Floating particles
        ..._buildParticles(data.accentColor),
      ],
    );
  }

  List<Widget> _buildParticles(Color color) {
    final positions = [
      const Offset(-120, -40),
      const Offset(110, -70),
      const Offset(-90, 90),
      const Offset(100, 80),
      const Offset(-30, -120),
      const Offset(50, 120),
    ];
    final sizes = [6.0, 4.0, 8.0, 5.0, 3.0, 7.0];

    return List.generate(positions.length, (i) {
      return Transform.translate(
        offset: positions[i],
        child: Container(
          width: sizes[i],
          height: sizes[i],
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.6),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      );
    });
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradientColors;
  final Color accentColor;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradientColors,
    required this.accentColor,
  });
}
