import 'package:flutter/material.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({super.key});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  String _selectedLanguage = 'العربية';

  final List<Map<String, String>> _languages = [
    {'name': 'العربية', 'code': 'ar', 'flag': '🇸🇦'},
    {'name': 'English', 'code': 'en', 'flag': '🇺🇸'},
    {'name': 'Français', 'code': 'fr', 'flag': '🇫🇷'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Title
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(
                  Icons.language_outlined,
                  color: Color(0xFF6366F1),
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'اختر اللغة',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          
          // Languages List
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              itemCount: _languages.length,
              itemBuilder: (context, index) {
                final language = _languages[index];
                final isSelected = language['name'] == _selectedLanguage;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? const Color(0xFF6366F1).withOpacity(0.1)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected
                        ? Border.all(color: const Color(0xFF6366F1), width: 2)
                        : null,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedLanguage = language['name']!;
                        });
                        // TODO: تطبيق تغيير اللغة
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Text(
                              language['flag']!,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                language['name']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected 
                                      ? FontWeight.w600 
                                      : FontWeight.w500,
                                  color: isSelected 
                                      ? const Color(0xFF6366F1)
                                      : const Color(0xFF1E293B),
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFF6366F1),
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 