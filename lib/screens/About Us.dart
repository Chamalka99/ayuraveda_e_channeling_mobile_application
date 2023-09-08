import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('About Us'),
        ),
        body: AboutUs(),
      ),
    );
  }
}

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Wrap with SingleChildScrollView
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to Hela Suwa – Your Trusted Ayurveda Doctor Consultation Platform!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Our Mission',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            'At Your Hela Suwa, our mission is to bring the age-old wisdom of Ayurveda into the modern world by providing easy access to experienced Ayurvedic doctors and personalized healthcare solutions. We believe in the holistic approach of Ayurveda, focusing on the balance of mind, body, and spirit for optimal well-being.',
          ),
          SizedBox(height: 16),
          Text(
            'Who We Are',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            'We are a team of dedicated individuals who are passionate about Ayurveda and its immense potential to improve lives. Our platform was created to bridge the gap between traditional Ayurvedic wisdom and the convenience of modern technology. We believe that everyone should have the opportunity to experience the benefits of Ayurveda and receive expert guidance from experienced Ayurvedic practitioners.',
          ),
          SizedBox(height: 16),
          Text(
            'Why Choose Your Hela SUwa',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            '- Experienced Ayurvedic Doctors: We have a network of highly qualified and experienced Ayurvedic doctors who are dedicated to your well-being. Our doctors have years of experience in diagnosing and treating a wide range of health conditions using Ayurvedic principles.',
          ),
          Text(
            '- Personalized Consultations: We understand that every individual is unique, and so are their health needs. Our doctors provide personalized consultations tailored to your specific health concerns, lifestyle, and goals.',
          ),
          Text(
            '- Convenience: With Your App Name, you can consult with an Ayurvedic doctor from the comfort of your home. No need to travel or wait in long queues. We make healthcare accessible and convenient for you.',
          ),
          Text(
            '- Natural Healing: Ayurveda emphasizes natural healing methods, including herbal remedies, diet, and lifestyle changes. Our doctors will guide you towards natural solutions that promote long-term well-being.',
          ),
          Text(
            '- Privacy and Security: We take your privacy and data security seriously. Your information is kept confidential and secure at all times.',
          ),
          SizedBox(height: 16),
          Text(
            'How It Works',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            '1. Sign Up: Create your account on Your App Name and provide some basic information about yourself.',
          ),
          Text(
            '2. Choose a Doctor: Browse through our list of experienced Ayurvedic doctors and select the one that suits your needs.',
          ),
          Text(
            '3. Book a Consultation: Schedule a consultation at a time that is convenient for you.',
          ),
          Text(
            '4. Consultation: Have a one-on-one video consultation with your chosen doctor. Discuss your health concerns and goals.',
          ),
          Text(
            '5. Personalized Treatment Plan: Your doctor will create a personalized treatment plan based on Ayurvedic principles. This may include dietary recommendations, herbal remedies, and lifestyle changes.',
          ),
          Text(
            '6. Follow-Up: Stay in touch with your doctor for follow-up consultations and progress updates.',
          ),
          SizedBox(height: 16),
          Text(
            'Contact Us',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            'We are here to answer your questions and assist you in your journey to better health. If you have any inquiries or need support, please don\'t hesitate to reach out to our customer support team.',
          ),
          SizedBox(height: 16),
          Text(
            'Thank you for choosing Your App Name as your trusted Ayurveda doctor consultation platform. We look forward to being a part of your wellness journey and helping you achieve a healthier, balanced life through the wisdom of Ayurveda.',
          ),
        ],
      ),
    );
  }
}