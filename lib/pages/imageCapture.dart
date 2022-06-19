import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

String imageUrl = "";
String uploadurl = "";

class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    setState(() {
      _imageFile = selected;
    });
  }

  void _clear() {
    setState(() {
      _imageFile = null;
    });
  }

  Future<void> _cropImage() async {
    File result = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      cropStyle: CropStyle.rectangle,
    );

    //var result = await FlutterImageCompress.compressAndGetFile(_imageFile.path, _imageFile.path,quality: 50);

    setState(() {
      _imageFile = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 10.0),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  print("Clicked");
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 20.0),
                  child: Icon(
                    Icons.arrow_back,
                    size: 25.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
          if (_imageFile != null) ...[
            Image.file(
              _imageFile,
              width: 400,
              height: 430,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.crop),
                  onPressed: _cropImage,
                ),
                FlatButton(
                  child: Icon(Icons.refresh),
                  onPressed: _clear,
                ),
              ],
            ),
            Uploader(file: _imageFile)
          ],
        ],
      ),
    );
  }
}

class Uploader extends StatefulWidget {
  final File file;

  Uploader({Key key, this.file}) : super(key: key);

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://expense-manager-1babd.appspot.com');

  StorageUploadTask _uploadTask;
  String filePath = 'images/${DateTime.now()}.jpg';

  void _startUpload() async {
    _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    await _uploadTask.onComplete;
    _storage.ref().child(filePath).getDownloadURL().then((fileURL) {
      setState(() {
        imageUrl = fileURL;
        Navigator.pop(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (context, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return Column(
              children: [
                if (_uploadTask.isComplete) Text('Upload Successful.'),
              ],
            );
          });
    } else {
      return FlatButton.icon(
          onPressed: _startUpload,
          icon: Icon(Icons.cloud_upload),
          label: Text('Upload'));
    }
  }
}
