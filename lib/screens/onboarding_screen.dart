import 'package:flutter/material.dart';
import 'package:foodie/screens/login.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _pageController;

  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: PageView.builder(
                    itemCount: data.length,
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _pageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return OnboardContent(
                        image: data[index].image,
                        title: data[index].title,
                        desc: data[index].desc,
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              top: 700,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: data.map((item) {
                  int index = data.indexOf(item);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Dot(isActive: index == _pageIndex),
                  );
                }).toList(),
              ),
            ),
            Positioned(
              bottom: 150,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffdb7706),
                  ),
                  onPressed: () {
                    if (_pageIndex == data.length - 1) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  },
                  child: Text(
                    _pageIndex == data.length - 1 ? 'Začni' : 'Naprej',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xffFA9D31),
                  side: const BorderSide(
                    color: Color(0xffFA9D31),
                    width: 2.0,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: const Text("Preskoči"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Dot extends StatelessWidget {
  const Dot({
    Key? key,
    this.isActive = false,
  }) : super(key: key);

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xffdb7706)
            : const Color(0xffdb7706).withOpacity(0.4),
        borderRadius: const BorderRadius.all(Radius.circular(25)),
      ),
    );
  }
}

class OnBoard {
  final String image, title, desc;

  OnBoard({required this.image, required this.title, required this.desc});
}

final List<OnBoard> data = [
  OnBoard(
    image: 'assets/images/boarding1.png',
    title: 'Shranjujte',
    desc: 'Shranite in organizirajte svoje najljubše recepte na enem mestu',
  ),
  OnBoard(
    image: 'assets/images/boarding2.png',
    title: 'Delite',
    desc: 'Svoje kuharske mojstrovine delite s prijatelji',
  ),
  OnBoard(
    image: 'assets/images/boarding3.png',
    title: 'Uživajte',
    desc: 'Okusite radosti kuhanja in odkrijte nove okuse ter recepte',
  ),
];

class OnboardContent extends StatelessWidget {
  const OnboardContent({
    Key? key,
    required this.image,
    required this.title,
    required this.desc,
  }) : super(key: key);

  final String image, title, desc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 64),
            Image.asset(
              image,
              fit: BoxFit.contain,
              width: 300,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                fontFamily: 'Poppins',
                color: Color(0xffdb7706),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              desc,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
