//import 'package:uuid/uuid.dart';

int id = 0;

Map sampleNews () {
  // var uuid = Uuid();
  // String id = uuid.v1();
  return {
    'id': (++id).toString(),
    'title': 'پرواز مسافت',
    'description': 'پرواز مسافت  34  🐣 sd در گردنه رخ',
    'body': 'متن خبر.',
    'pictures': [
      {
        'url': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOoSUslnIOAn8EjfHZMURueXC1eb1AcnlH_ocjV2oLYvL_xO4I',
        'thumbnail': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOoSUslnIOAn8EjfHZMURueXC1eb1AcnlH_ocjV2oLYvL_xO4I',
      },
    ],
    'created_at': '2018-08-16T03:02:13.552Z',
  };
}