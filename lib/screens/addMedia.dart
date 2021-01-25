import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mazzamera/components/mediaTile.dart';
import 'package:mazzamera/services/videoplayer.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMedia extends StatefulWidget {
  static final String id = 'AddMedia';
  @override
  _AddMediaState createState() => _AddMediaState();
}

class _AddMediaState extends State<AddMedia> {
  String title, description;
  bool _activeSwith = false;
  File _image, _video, _audio;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final _global = GlobalKey<ScaffoldState>();
  bool addImage = false, addVideo = false, addAudio = false, _isPicked = false;
  VideoPlayerController videoPlayerController;

  Future<void> uploadFile(String filePath, String type) async {
    File file = File(filePath);
    FocusScope.of(context).unfocus();
    Map<String, dynamic> media = {};
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('uploads/$title')
          .putFile(file)
          .then((value) async {
        media = {
          'type': type,
          'link': await value.ref.getDownloadURL(),
          'description': description,
        };
      });
      await FirebaseFirestore.instance.collection('posts').add(media);

      _global.currentState.showSnackBar(SnackBar(
          content: Text(
              'The Post Will be add in background process, meanwhile you can enjoy our app content')));
      Navigator.pop(context);
    } on firebase_storage.FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      if (e.code == 'canceled')
        _global.currentState
            .showSnackBar(SnackBar(content: Text('The post were canceled')));
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('You want to cancel the post?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('yes'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        addImage = true;
        _isPicked = true;
        //uploadFile(_image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future _getVideo() async {
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _video = File(pickedFile.path);
        addVideo = true;
        _isPicked = true;
      } else {
        print('No image selected.');
      }
    });
  }

  Future _getAudio() async {
    // var path = await AudioPicker.pickAudio();

    setState(() {
      // if (path != null) {

      //   //uploadFile(_image.path);
      // } else {
      //   print('No image selected.');
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _global,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Add Post',
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.blueGrey,
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  if (addImage) {
                    uploadFile(_image.path, 'image');
                  } else {
                    if (addVideo) {
                      uploadFile(_video.path, 'video');
                    } else {
                      if (addAudio) {
                        uploadFile(_audio.path, 'audio');
                      }
                    }
                  }
                }
              }),
        ],
        leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.blueGrey,
            ),
            onPressed: () {
              _showMyDialog();
            }),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.all(0),
          child: ListView(
            children: [
              Card(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      (addImage)
                          ? Container(
                              child: AspectRatio(
                                  aspectRatio: 2 / 2,
                                  child: Image.file(_image)),
                            )
                          : SizedBox(
                              width: 1,
                            ),
                      (addVideo)
                          ? Container(
                              child: ButterFlyAssetVideo(
                                video: _video,
                              ),
                            )
                          : SizedBox(
                              width: 1,
                            ),
                      TextFormField(
                        onChanged: (value) {
                          title = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) return 'Add a title';
                          return null;
                        },
                        cursorColor: Colors.blueGrey,
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.blueGrey),
                            labelText: 'Title',
                            border: InputBorder.none),
                      ),
                      TextFormField(
                          onChanged: (value) {
                            description = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) return 'Add a Description';
                            return null;
                          },
                          cursorColor: Colors.blueGrey,
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.blueGrey),
                              labelText: 'Description',
                              border: InputBorder.none)),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              (!_isPicked)
                  ? Card(
                      child: Column(
                        children: [
                          MediaTile(
                            title: 'Post Image to Mazzamera account',
                            trailingText: 'Image',
                            onTap: () => _getImage(),
                          ),
                          MediaTile(
                            title: 'Post Video to Mazzamera account',
                            trailingText: 'Video',
                            onTap: () => _getVideo(),
                          ),
                          MediaTile(
                            title: 'Post Audio to Mazzamera account',
                            trailingText: 'Audio',
                            onTap: () => _getAudio(),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      width: 1,
                    ),
              SizedBox(
                height: 10,
              ),
              Card(
                  child: SwitchListTile(
                value: _activeSwith,
                onChanged: (value) {
                  setState(() {
                    _activeSwith = value;
                  });
                },
                title: Text(
                  'Show your email address on the post',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 18,
                  ),
                ),
                activeColor: Colors.blueGrey,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
