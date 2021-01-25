import 'package:flutter/material.dart';

class MediaTile extends StatelessWidget {
  final String title, trailingText;

  final Function onTap;
  MediaTile({@required this.title, @required this.trailingText, this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(title),
      trailing: Text(
        trailingText,
        style: TextStyle(
            color: Colors.blueGrey, fontSize: 18, fontWeight: FontWeight.w700),
      ),
    );
  }
}

// ListTile(
//                       onTap: (){
//                         _getVideo();
//                       },
//                       title: Text('Post Videos to Mazzamera account'),
//                       trailing: Text(
//                         'Video',
//                         style: TextStyle(
//                             color: Colors.blueGrey,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w700),
//                       ),
//                     ),
