import 'package:flutter/material.dart';

/// Localization strings for the AutoCheck app
/// Supports English, Sinhala, and Tamil
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('si'), // Sinhala
    Locale('ta'), // Tamil
  ];

  // Localized strings mapping
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': _englishStrings,
    'si': _sinhalaStrings,
    'ta': _tamilStrings,
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  // Common strings
  String get appName => get('app_name');
  String get welcome => get('welcome');
  String get continueText => get('continue');
  String get back => get('back');
  String get next => get('next');
  String get skip => get('skip');
  String get done => get('done');
  String get save => get('save');
  String get cancel => get('cancel');
  String get search => get('search');
  String get loading => get('loading');
  String get error => get('error');
  String get retry => get('retry');
  String get yes => get('yes');
  String get no => get('no');
  String get notSure => get('not_sure');

  // Onboarding
  String get onboardingTitle1 => get('onboarding_title_1');
  String get onboardingDesc1 => get('onboarding_desc_1');
  String get onboardingTitle2 => get('onboarding_title_2');
  String get onboardingDesc2 => get('onboarding_desc_2');
  String get onboardingTitle3 => get('onboarding_title_3');
  String get onboardingDesc3 => get('onboarding_desc_3');
  String get getStarted => get('get_started');
  String get selectRole => get('select_role');
  String get normalUser => get('normal_user');
  String get inspectionService => get('inspection_service');

  // Navigation
  String get home => get('home');
  String get inspect => get('inspect');
  String get compare => get('compare');
  String get history => get('history');
  String get profile => get('profile');

  // Auto Match
  String get autoMatch => get('auto_match');
  String get findPerfectVehicle => get('find_perfect_vehicle');
  String get budget => get('budget');
  String get familySize => get('family_size');
  String get drivingConditions => get('driving_conditions');
  String get fuelPreference => get('fuel_preference');
  String get priority => get('priority');
  String get recommendations => get('recommendations');

  // Inspection
  String get startInspection => get('start_inspection');
  String get inspectionChecklist => get('inspection_checklist');
  String get exterior => get('exterior');
  String get interior => get('interior');
  String get engine => get('engine');
  String get suspension => get('suspension');
  String get tyres => get('tyres');
  String get testDrive => get('test_drive');
  String get documents => get('documents');
  String get vibrationTest => get('vibration_test');

  // Health Score
  String get healthScore => get('health_score');
  String get safe => get('safe');
  String get mediumRisk => get('medium_risk');
  String get highRisk => get('high_risk');
  String get proceedToInspection => get('proceed_to_inspection');
  String get avoidVehicle => get('avoid_vehicle');

  // Blacklist
  String get blacklistCheck => get('blacklist_check');
  String get enterRegistration => get('enter_registration');
  String get enterChassis => get('enter_chassis');
  String get checkNow => get('check_now');
  String get noIssuesFound => get('no_issues_found');
  String get issuesFound => get('issues_found');

  // Marketplace
  String get findInspector => get('find_inspector');
  String get nearbyInspectors => get('nearby_inspectors');
  String get bookInspection => get('book_inspection');
  String get callNow => get('call_now');
  String get rating => get('rating');
  String get distance => get('distance');
  String get price => get('price');

  // Comparison
  String get compareVehicles => get('compare_vehicles');
  String get addVehicle => get('add_vehicle');
  String get removeVehicle => get('remove_vehicle');
  String get bestChoice => get('best_choice');

  // Reports
  String get inspectionHistory => get('inspection_history');
  String get generateReport => get('generate_report');
  String get shareReport => get('share_report');
  String get exportPdf => get('export_pdf');
}

// English strings
const Map<String, String> _englishStrings = {
  'app_name': 'AutoCheck',
  'welcome': 'Welcome to AutoCheck',
  'continue': 'Continue',
  'back': 'Back',
  'next': 'Next',
  'skip': 'Skip',
  'done': 'Done',
  'save': 'Save',
  'cancel': 'Cancel',
  'search': 'Search',
  'loading': 'Loading...',
  'error': 'Error',
  'retry': 'Retry',
  'yes': 'Yes',
  'no': 'No',
  'not_sure': 'Not Sure',

  // Onboarding
  'onboarding_title_1': 'Find Your Perfect Vehicle',
  'onboarding_desc_1':
      'Answer simple questions and get personalized vehicle recommendations based on your needs.',
  'onboarding_title_2': 'Inspect Like a Pro',
  'onboarding_desc_2':
      'Follow our step-by-step checklist to check any vehicle thoroughly. No technical knowledge needed!',
  'onboarding_title_3': 'Avoid Scams & Save Money',
  'onboarding_desc_3':
      'Check for accident history, flood damage, and other hidden issues before you buy.',
  'get_started': 'Get Started',
  'select_role': 'How will you use AutoCheck?',
  'normal_user': 'I\'m Buying a Vehicle',
  'inspection_service': 'I\'m an Inspection Service',

  // Navigation
  'home': 'Home',
  'inspect': 'Inspect',
  'compare': 'Compare',
  'history': 'History',
  'profile': 'Profile',

  // Auto Match
  'auto_match': 'Auto Match',
  'find_perfect_vehicle': 'Find Your Perfect Vehicle',
  'budget': 'Budget',
  'family_size': 'Family Size',
  'driving_conditions': 'Driving Conditions',
  'fuel_preference': 'Fuel Preference',
  'priority': 'Priority',
  'recommendations': 'Recommendations',

  // Inspection
  'start_inspection': 'Start Inspection',
  'inspection_checklist': 'Inspection Checklist',
  'exterior': 'Exterior',
  'interior': 'Interior',
  'engine': 'Engine & Mechanical',
  'suspension': 'Suspension & Shocks',
  'tyres': 'Tyres & Wheels',
  'test_drive': 'Test Drive',
  'documents': 'Documents',
  'vibration_test': 'Engine Vibration Test',

  // Health Score
  'health_score': 'Health Score',
  'safe': 'Safe',
  'medium_risk': 'Medium Risk',
  'high_risk': 'High Risk',
  'proceed_to_inspection': 'You may proceed to professional inspection',
  'avoid_vehicle': 'Consider avoiding this vehicle',

  // Blacklist
  'blacklist_check': 'Blacklist Check',
  'enter_registration': 'Enter Registration Number',
  'enter_chassis': 'Enter Chassis Number',
  'check_now': 'Check Now',
  'no_issues_found': 'No issues found for this vehicle',
  'issues_found': 'Warning: Issues found',

  // Marketplace
  'find_inspector': 'Find Inspector',
  'nearby_inspectors': 'Nearby Inspection Services',
  'book_inspection': 'Book Inspection',
  'call_now': 'Call Now',
  'rating': 'Rating',
  'distance': 'Distance',
  'price': 'Price',

  // Comparison
  'compare_vehicles': 'Compare Vehicles',
  'add_vehicle': 'Add Vehicle',
  'remove_vehicle': 'Remove Vehicle',
  'best_choice': 'Best Choice',

  // Reports
  'inspection_history': 'Inspection History',
  'generate_report': 'Generate Report',
  'share_report': 'Share Report',
  'export_pdf': 'Export PDF',
};

// Sinhala strings
const Map<String, String> _sinhalaStrings = {
  'app_name': 'ඔටෝචෙක්',
  'welcome': 'ඔටෝචෙක් වෙත සාදරයෙන් පිළිගනිමු',
  'continue': 'ඉදිරියට',
  'back': 'ආපසු',
  'next': 'ඊළඟ',
  'skip': 'මඟ හරින්න',
  'done': 'අවසන්',
  'save': 'සුරකින්න',
  'cancel': 'අවලංගු කරන්න',
  'search': 'සොයන්න',
  'loading': 'පූරණය වෙමින්...',
  'error': 'දෝෂයකි',
  'retry': 'නැවත උත්සාහ කරන්න',
  'yes': 'ඔව්',
  'no': 'නැත',
  'not_sure': 'විශ්වාස නැත',

  // Onboarding
  'onboarding_title_1': 'ඔබට සුදුසු වාහනය සොයන්න',
  'onboarding_desc_1':
      'සරල ප්‍රශ්න වලට පිළිතුරු දී ඔබේ අවශ්‍යතා මත පදනම් වූ වාහන නිර්දේශ ලබා ගන්න.',
  'onboarding_title_2': 'වාහනයක් වෘත්තිකයෙකු මෙන් පරීක්ෂා කරන්න',
  'onboarding_desc_2':
      'ඕනෑම වාහනයක් හොඳින් පරීක්ෂා කිරීමට අපගේ පියවරෙන් පියවර මාර්ගෝපදේශය අනුගමනය කරන්න.',
  'onboarding_title_3': 'වංචා වලින් වළකින්න, මුදල් ඉතිරි කරන්න',
  'onboarding_desc_3':
      'මිලදී ගැනීමට පෙර අනතුරු ඉතිහාසය, ගංවතුර හානි, සහ වෙනත් සැඟවුණු ගැටළු පරීක්ෂා කරන්න.',
  'get_started': 'ආරම්භ කරන්න',
  'select_role': 'ඔබ ඔටෝචෙක් භාවිතා කරන්නේ කෙසේද?',
  'normal_user': 'මම වාහනයක් මිලදී ගන්නවා',
  'inspection_service': 'මම පරීක්ෂණ සේවාවක්',

  // Navigation
  'home': 'මුල් පිටුව',
  'inspect': 'පරීක්ෂා කරන්න',
  'compare': 'සංසන්දනය',
  'history': 'ඉතිහාසය',
  'profile': 'පැතිකඩ',

  // Auto Match
  'auto_match': 'ඔටෝ මැච්',
  'find_perfect_vehicle': 'ඔබට සුදුසු වාහනය සොයන්න',
  'budget': 'අයවැය',
  'family_size': 'පවුලේ ප්‍රමාණය',
  'driving_conditions': 'රියදුරු තත්ත්වයන්',
  'fuel_preference': 'ඉන්ධන මනාපය',
  'priority': 'ප්‍රමුඛතාව',
  'recommendations': 'නිර්දේශ',

  // Inspection
  'start_inspection': 'පරීක්ෂාව ආරම්භ කරන්න',
  'inspection_checklist': 'පරීක්ෂණ ලැයිස්තුව',
  'exterior': 'බාහිර',
  'interior': 'අභ්‍යන්තර',
  'engine': 'එන්ජින් සහ යාන්ත්‍රික',
  'suspension': 'සසුපෙන්ෂන් සහ ෂොක්',
  'tyres': 'ටයර් සහ රෝද',
  'test_drive': 'ටෙස්ට් ඩ්‍රයිව්',
  'documents': 'ලේඛන',
  'vibration_test': 'එන්ජින් කම්පන පරීක්ෂණය',

  // Health Score
  'health_score': 'සෞඛ්‍ය ලකුණු',
  'safe': 'ආරක්ෂිතයි',
  'medium_risk': 'මධ්‍යම අවදානම',
  'high_risk': 'ඉහළ අවදානම',
  'proceed_to_inspection': 'ඔබට වෘත්තීය පරීක්ෂණයක් සිදු කළ හැකිය',
  'avoid_vehicle': 'මෙම වාහනය වළක්වා ගැනීම සලකා බලන්න',

  // Blacklist
  'blacklist_check': 'කළු ලැයිස්තු පරීක්ෂාව',
  'enter_registration': 'ලියාපදිංචි අංකය ඇතුළත් කරන්න',
  'enter_chassis': 'චැසි අංකය ඇතුළත් කරන්න',
  'check_now': 'දැන් පරීක්ෂා කරන්න',
  'no_issues_found': 'මෙම වාහනය සඳහා ගැටළු හමු නොවීය',
  'issues_found': 'අනතුරු ඇඟවීම: ගැටළු හමු විය',

  // Marketplace
  'find_inspector': 'පරීක්ෂක සොයන්න',
  'nearby_inspectors': 'අසල ඇති පරීක්ෂණ සේවා',
  'book_inspection': 'පරීක්ෂණය වෙන් කරන්න',
  'call_now': 'දැන් අමතන්න',
  'rating': 'ශ්‍රේණිගත කිරීම',
  'distance': 'දුර',
  'price': 'මිල',

  // Comparison
  'compare_vehicles': 'වාහන සංසන්දනය කරන්න',
  'add_vehicle': 'වාහනයක් එක් කරන්න',
  'remove_vehicle': 'වාහනය ඉවත් කරන්න',
  'best_choice': 'හොඳම තේරීම',

  // Reports
  'inspection_history': 'පරීක්ෂණ ඉතිහාසය',
  'generate_report': 'වාර්තාව ජනනය කරන්න',
  'share_report': 'වාර්තාව බෙදා ගන්න',
  'export_pdf': 'PDF අපනයනය',
};

// Tamil strings
const Map<String, String> _tamilStrings = {
  'app_name': 'ஆட்டோசெக்',
  'welcome': 'ஆட்டோசெக் க்கு வரவேற்கிறோம்',
  'continue': 'தொடர்க',
  'back': 'பின்னால்',
  'next': 'அடுத்து',
  'skip': 'தவிர்',
  'done': 'முடிந்தது',
  'save': 'சேமி',
  'cancel': 'ரத்து செய்',
  'search': 'தேடு',
  'loading': 'ஏற்றுகிறது...',
  'error': 'பிழை',
  'retry': 'மீண்டும் முயற்சி',
  'yes': 'ஆம்',
  'no': 'இல்லை',
  'not_sure': 'தெரியாது',

  // Onboarding
  'onboarding_title_1': 'உங்கள் சரியான வாகனத்தைக் கண்டறியுங்கள்',
  'onboarding_desc_1':
      'எளிய கேள்விகளுக்கு பதிலளித்து உங்கள் தேவைகளின் அடிப்படையில் வாகன பரிந்துரைகளைப் பெறுங்கள்.',
  'onboarding_title_2': 'நிபுணர் போல ஆய்வு செய்யுங்கள்',
  'onboarding_desc_2':
      'எந்த வாகனத்தையும் முழுமையாக சோதிக்க எங்கள் படிப்படியான வழிகாட்டியைப் பின்பற்றுங்கள்.',
  'onboarding_title_3': 'மோசடிகளை தவிர்த்து பணத்தை சேமியுங்கள்',
  'onboarding_desc_3':
      'வாங்குவதற்கு முன் விபத்து வரலாறு, வெள்ள சேதம் மற்றும் பிற மறைந்த சிக்கல்களை சோதிக்கவும்.',
  'get_started': 'தொடங்கு',
  'select_role': 'ஆட்டோசெக்கை எப்படி பயன்படுத்துவீர்கள்?',
  'normal_user': 'நான் வாகனம் வாங்குகிறேன்',
  'inspection_service': 'நான் ஆய்வு சேவை',

  // Navigation
  'home': 'முகப்பு',
  'inspect': 'ஆய்வு',
  'compare': 'ஒப்பிடு',
  'history': 'வரலாறு',
  'profile': 'சுயவிவரம்',

  // Auto Match
  'auto_match': 'ஆட்டோ மேட்ச்',
  'find_perfect_vehicle': 'உங்கள் சரியான வாகனத்தைக் கண்டறியுங்கள்',
  'budget': 'வரவு செலவு',
  'family_size': 'குடும்ப அளவு',
  'driving_conditions': 'ஓட்டுநர் நிலைமைகள்',
  'fuel_preference': 'எரிபொருள் விருப்பம்',
  'priority': 'முன்னுரிமை',
  'recommendations': 'பரிந்துரைகள்',

  // Inspection
  'start_inspection': 'ஆய்வைத் தொடங்கு',
  'inspection_checklist': 'ஆய்வு சோதனைப்பட்டியல்',
  'exterior': 'வெளிப்புறம்',
  'interior': 'உட்புறம்',
  'engine': 'எஞ்சின் மற்றும் இயந்திரம்',
  'suspension': 'சஸ்பென்ஷன் மற்றும் ஷாக்',
  'tyres': 'டயர்கள் மற்றும் சக்கரங்கள்',
  'test_drive': 'டெஸ்ட் டிரைவ்',
  'documents': 'ஆவணங்கள்',
  'vibration_test': 'எஞ்சின் அதிர்வு சோதனை',

  // Health Score
  'health_score': 'ஆரோக்கிய மதிப்பெண்',
  'safe': 'பாதுகாப்பானது',
  'medium_risk': 'நடுத்தர ஆபத்து',
  'high_risk': 'அதிக ஆபத்து',
  'proceed_to_inspection': 'தொழில்முறை ஆய்வுக்கு செல்லலாம்',
  'avoid_vehicle': 'இந்த வாகனத்தை தவிர்க்க பரிசீலிக்கவும்',

  // Blacklist
  'blacklist_check': 'கருப்பு பட்டியல் சோதனை',
  'enter_registration': 'பதிவு எண்ணை உள்ளிடவும்',
  'enter_chassis': 'சேஸிஸ் எண்ணை உள்ளிடவும்',
  'check_now': 'இப்போது சோதிக்கவும்',
  'no_issues_found': 'இந்த வாகனத்திற்கு சிக்கல்கள் இல்லை',
  'issues_found': 'எச்சரிக்கை: சிக்கல்கள் கண்டறியப்பட்டன',

  // Marketplace
  'find_inspector': 'ஆய்வாளரைக் கண்டறியவும்',
  'nearby_inspectors': 'அருகிலுள்ள ஆய்வு சேவைகள்',
  'book_inspection': 'ஆய்வை முன்பதிவு செய்யவும்',
  'call_now': 'இப்போது அழைக்கவும்',
  'rating': 'மதிப்பீடு',
  'distance': 'தூரம்',
  'price': 'விலை',

  // Comparison
  'compare_vehicles': 'வாகனங்களை ஒப்பிடுங்கள்',
  'add_vehicle': 'வாகனத்தைச் சேர்க்கவும்',
  'remove_vehicle': 'வாகனத்தை நீக்கவும்',
  'best_choice': 'சிறந்த தேர்வு',

  // Reports
  'inspection_history': 'ஆய்வு வரலாறு',
  'generate_report': 'அறிக்கையை உருவாக்கவும்',
  'share_report': 'அறிக்கையைப் பகிரவும்',
  'export_pdf': 'PDF ஏற்றுமதி',
};

/// Localization delegate
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'si', 'ta'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
