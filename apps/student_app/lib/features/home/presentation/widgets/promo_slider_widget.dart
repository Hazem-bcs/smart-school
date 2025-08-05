import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PromoSlider extends StatelessWidget {
  final List<String> imageUrls = [
    'https://plus.unsplash.com/premium_photo-1680807869780-e0876a6f3cd5?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8c2Nob29sfGVufDB8fDB8fHww',
    'https://images.unsplash.com/photo-1573706376056-55f27105ff17?q=80&w=1171&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1580974852861-c381510bc98a?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fHNjaG9vbHxlbnwwfHwwfHx8MA%3D%3D',
    'https://plus.unsplash.com/premium_photo-1671070290623-d6f76bdbb3db?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTd8fHNjaG9vbHxlbnwwfHwwfHx8MA%3D%3D',
    'https://images.unsplash.com/photo-1601780313063-ab9174e43dcc?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzJ8fCVEOSU4NCVEOCVCNyVEOSU4NCVEOCVBNyVEOCVBOCUyMCVEOCVBNyVEOSU4NCVEOSU4NSVEOCVBRiVEOCVBNyVEOCVCMSVEOCVCMyUyMCVEOCVBQSVEOCVBRCVEOSU4MSVEOSU4QSVEOCVCMiUyMCVEOCVCOSVEOCVBOCVEOCVBNyVEOCVCMSVEOCVBNyVEOCVBQXxlbnwwfHwwfHx8MA%3D%3D',
    'https://plus.unsplash.com/premium_photo-1735775899897-278b39a81679?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzN8fCVEOSU4NCVEOCVCNyVEOSU4NCVEOCVBNyVEOCVBOCUyMCVEOCVBNyVEOSU4NCVEOSU4NSVEOCVBRiVEOCVBNyVEOCVCMSVEOCVCMyUyMCVEOCVBQSVEOCVBRCVEOSU4MSVEOSU4QSVEOCVCMiUyMCVEOCVCOSVEOCVBOCVEOCVBNyVEOCVCMSVEOCVBNyVEOCVBQXxlbnwwfHwwfHx8MA%3D%3D',
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0, // ارتفاع الكارد
        autoPlay: true, // تشغيل الشرائح تلقائياً
        autoPlayInterval: Duration(seconds: 3), // مدة عرض كل شريحة
        enlargeCenterPage: true, // جعل الشريحة المركزية أكبر
        viewportFraction: 0.8, // نسبة عرض الشريحة من مساحة الشاشة
      ),
      items: imageUrls.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  i,
                  fit: BoxFit.cover,
                  // يمكنك إضافة Placeholder هنا للتحميل
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}