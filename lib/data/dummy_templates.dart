import '../models/template_model.dart';

final List<TemplateModel> dummyTemplates = [
  // English - Motivational
  TemplateModel(
    id: '1',
    text: 'Believe in yourself and all that you are 💫',
    gradientColors: ['#6C63FF', '#9C95FF'],
    fontFamily: 'Poppins',
    category: 'Motivational',
    language: 'English',
  ),
  TemplateModel(
    id: '2',
    text: 'Good vibes only ✨',
    gradientColors: ['#FF6584', '#FFB347'],
    fontFamily: 'Pacifico',
    category: 'Motivational',
    language: 'English',
  ),
  TemplateModel(
    id: '3',
    text: 'Every day is a fresh start 🌅',
    gradientColors: ['#43D98C', '#0ED2F7'],
    fontFamily: 'Poppins',
    category: 'Motivational',
    language: 'English',
  ),
  TemplateModel(
    id: '4',
    text: 'Stay focused and never give up 🔥',
    gradientColors: ['#f7971e', '#ffd200'],
    fontFamily: 'Righteous',
    category: 'Motivational',
    language: 'English',
  ),

  // English - Attitude
  TemplateModel(
    id: '5',
    text: 'I am the architect of my own destiny 👑',
    gradientColors: ['#1A1A2E', '#16213E'],
    fontFamily: 'Poppins',
    category: 'Attitude',
    language: 'English',
  ),
  TemplateModel(
    id: '6',
    text: 'Too busy leveling up to look back 🚀',
    gradientColors: ['#f093fb', '#f5576c'],
    fontFamily: 'Righteous',
    category: 'Attitude',
    language: 'English',
  ),

  // Hindi - Motivational
  TemplateModel(
    id: '7',
    text: 'मेहनत इतनी खामोशी से करो कि\nसफलता शोर मचा दे 💪',
    gradientColors: ['#FF6584', '#FFB347'],
    fontFamily: 'Poppins',
    category: 'Motivational',
    language: 'Hindi',
  ),
  TemplateModel(
    id: '8',
    text: 'जो सपने देखते हैं\nवो ही इतिहास बनाते हैं ✨',
    gradientColors: ['#6C63FF', '#9C95FF'],
    fontFamily: 'Poppins',
    category: 'Motivational',
    language: 'Hindi',
  ),
  TemplateModel(
    id: '9',
    text: 'हर रोज़ एक नई शुरुआत है 🌅',
    gradientColors: ['#43D98C', '#0ED2F7'],
    fontFamily: 'Poppins',
    category: 'Motivational',
    language: 'Hindi',
  ),

  // Hindi - Attitude
  TemplateModel(
    id: '10',
    text: 'अपनी औकात नहीं\nअपना किरदार दिखाओ 👑',
    gradientColors: ['#1A1A2E', '#16213E'],
    fontFamily: 'Poppins',
    category: 'Attitude',
    language: 'Hindi',
  ),

  // Marathi
  TemplateModel(
    id: '11',
    text: 'स्वप्न पाहा, मेहनत करा\nयश मिळेल 💫',
    gradientColors: ['#f7971e', '#ffd200'],
    fontFamily: 'Poppins',
    category: 'Motivational',
    language: 'Marathi',
  ),
  TemplateModel(
    id: '12',
    text: 'आयुष्य सुंदर आहे\nते जगण्यात आनंद घ्या 🌸',
    gradientColors: ['#f093fb', '#f5576c'],
    fontFamily: 'Poppins',
    category: 'Life',
    language: 'Marathi',
  ),

  // IPL Special
  TemplateModel(
    id: '13',
    text: 'Cricket is not just a game\nIt\'s a religion 🏏',
    gradientColors: ['#f7971e', '#ffd200'],
    fontFamily: 'Righteous',
    category: 'IPL',
    language: 'English',
  ),
  TemplateModel(
    id: '14',
    text: 'Powered by chai\nand cricket 🏏☕',
    gradientColors: ['#43D98C', '#0ED2F7'],
    fontFamily: 'Pacifico',
    category: 'IPL',
    language: 'English',
  ),

  // Sad / Emotional
  TemplateModel(
    id: '15',
    text: 'Sometimes silence is the best answer 🌙',
    gradientColors: ['#1A1A2E', '#16213E'],
    fontFamily: 'Dancing Script',
    category: 'Sad',
    language: 'English',
  ),
  TemplateModel(
    id: '16',
    text: 'खामोशी भी बहुत कुछ\nकह देती है 🌙',
    gradientColors: ['#1A1A2E', '#16213E'],
    fontFamily: 'Poppins',
    category: 'Sad',
    language: 'Hindi',
  ),
];

const List<String> categories = [
  'All',
  'Motivational',
  'Attitude',
  'Sad',
  'Life',
  'IPL',
];
const List<String> languages = ['All', 'English', 'Hindi', 'Marathi'];
