import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:mazzamera/constants.dart';
import 'package:mazzamera/screens/addMedia.dart';
import 'package:mazzamera/services/videoplayer.dart';

class Home extends StatefulWidget {
  static final String id = 'Home';
  @override
  _HomeState createState() => _HomeState();
}

final _globalKey = GlobalKey<ScaffoldState>();

class _HomeState extends State<Home> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text('Mazzamera', style: KTextDecoration),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                    
                      backgroundColor: Colors.blueGrey));
            }
            return ListView(
                children: snapshot.data.docs.map((DocumentSnapshot document) {
              if (document.data()['type'] == 'image') {
                return Container(
                  height: 310,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        
                        Image.network(document.data()['link'],fit: BoxFit.contain, height: 250, errorBuilder: (context,object,track){
                        
                          return Center(child: Text('Not Fount'));
                        },),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(document.data()['description']),
                            ),
                            IconButton(icon: Icon(Icons.thumb_up, color: Colors.blueGrey), onPressed: (){}),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              } else {
                if (document.data()['type'] == 'video') {
                  return Container(
                     margin: EdgeInsets.symmetric(vertical: 8.0),
                    height: 310,
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            child: Flexible(
                                                          child: ButterFlyNetworkVideo(
                                  video: document.data()['link'],
                                ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                            children: [
                              
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(document.data()['description']),
                                
                              ),
                              IconButton(icon: Icon(Icons.thumb_up,color: Colors.blueGrey,), onPressed: (){}),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }
              }
            }).toList());
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddMedia.id);
        },
        backgroundColor: Colors.blueGrey,
        child: FaIcon(
          FontAwesomeIcons.plus,
          size: 20,
        ),
      ),
    );
  }
}
