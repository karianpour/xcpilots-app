Map translations = {
  'glide': 'گلاید',
  'glide_magazin': 'مجله گلاید',
  'radio_paraglider': 'رادیو پاراگلایدر',
  'news': 'اخبار',
  'top_flights': 'پروازهای برجسته',
  'about_us': 'درباره ما',
  'xc_pilots': 'ایکسی‌پایلوتس',
  'about_us_title': 'درباره ما',
  'about_us_content': 'ما خلبانان مسافت و عاشقان پرواز ایم.',
  'news_page_title': 'اخبار',
  'single_news_page_title': 'خبر',
  'publish_time': 'زمان انتشار',
  'kayvan arianpour': 'کیوان آرین‌پور',
  'sadegh barikani': 'صادق باریکانی',
  'matin firoozi': 'متین فیروزی',
  'bowo': 'بوُوُ',
  'version': 'نسخه',
  'faild to load, press to retry': '',
  'problem while connecting to the server': 'مشکلی در ارتباط با سرور بوجود آمد. مجدد تلاش کنید!',
  'no data': 'داده‌ای نیست!',

  'the_best_ir_7': 'پروازهای ۷ روز گذشته ایران',
  'the_best_ir_30': 'پروازهای ۳۰ روز گذشته ایران',
  'the_best_ir': 'تمام پروازهای ایران',
  'the_best_all_7': 'پروازهای ۷ روز گذشته جهان',
  'the_best_all_30': 'پروازهای ۳۰ روز گذشته جهان',
  'the_best_all': 'تمام پروازهای جهان',
  'points': 'امتیاز',
  'site_name': 'نام سایت',
  'point_name': 'نام خلبان',
  'glider_name': 'بال',
  'flight_date': 'زمان',
  'show_flihgt': 'نمایش',
};

String translate(String key){
  String t = translations[key];
  if(t!=null){
    return t;
  }
  return key;
}