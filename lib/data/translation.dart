Map translations = {
  'glide': 'گلاید',
  'glide_magazin': 'مجله گلاید',
  'radio_paraglider': 'رادیو پاراگلایدر',
  'news': 'اخبار',
  'flights_highlight': 'پروازهای برجسته',
  'about_us': 'درباره ما',
  'xc_pilots': 'ایکسی‌پایلوتس',
  'about_us_title': 'درباره ما',
  'about_us_content': 'ما خلبانان مسافت و عاشقان پرواز ایم.',
  'news_page_title': 'اخبار',
  'single_news_page_title': 'خبر',
  'publish_time': 'زمان انتشار',
  '': '',
};

String translate(String key){
  String t = translations[key];
  if(t!=null){
    return t;
  }
  return key;
}