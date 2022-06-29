import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/models/user.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {

  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  void postImage(
      String uid,
      String username,
      String profImage,
      ) async {
    try {
      setState((){
        _isLoading = true;
      });
      String res = await FirestoreMethods().uploadPost(
          _descriptionController.text,
          _file!,
          uid,
          username,
          profImage,
      );

      if (res == "success") {
        setState((){
          _isLoading = false;
        });
        clearImage();
        showSnackBar('Posted!', context);
      } else {
        setState((){
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch(e) {
      showSnackBar(e.toString(), context);
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(context: context, builder: (context){
      return SimpleDialog(
        title: const Text('Create a post'),
        children: [
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Take a photo'),
            onPressed: () async {
              Navigator.of(context).pop();
              Uint8List file = await pickImage(
                ImageSource.camera,
              );
              setState((){
                _file = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Choose from gallery'),
            onPressed: () async {
              Navigator.of(context).pop();
              Uint8List file = await pickImage(
                ImageSource.gallery,
              );
              setState((){
                _file = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Cancel'),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }

  void clearImage() {
    setState((){
      _file = null;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final User user = Provider.of<UserProvider>(context).getUser;

    //null이면 업로드 화면 표출
    return _file == null ?
    Center(
      child: IconButton(
        icon: const Icon(Icons.upload),
        onPressed:()=> _selectImage(context)
      )
    )
    : Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: clearImage,
        ),
        title: const Text('Post to'),
        centerTitle: false, //false 하게되면 왼쪽으로 감.
        actions: [//우측 목록
          TextButton(onPressed: () => postImage(
              user.uid,
              user.username,
              user.photoUrl
          ),
              child: const Text(
                  'Post',
                  style:TextStyle(
                    color:Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
              ),
          )
        ],
      ),
      body: Column(
        children: [
          _isLoading
              ? const LinearProgressIndicator()
              : Padding(
                padding: EdgeInsets.only(top: 0),
                ) ,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  user.photoUrl
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.45,
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Writg a caption...',
                    border: InputBorder.none,
                  ),
                  maxLines: 8,
                ),
              ),
              SizedBox(
                height: 45,
                width: 45,
                child: AspectRatio(
                  /**
                   * 만약 aspectRatio를 3/2 로 표현하면, 너비가 3 / 높이가 2 이다.
                      소수로 표현하면? 1.5 일 경우 너비가 높이의 1.5배가 되는 것이다.
                      그런데 비율은 알겠는데 정확히 얼마만큼을 차지하게 될까?
                      일단 child 위젯 자신이 차지할 수 있는 최대한의 너비를 결정하고 나서, 높이는 aspectRatio에 설정한 값에 따라 결정된다고 한다. 그냥 위젯이 있는 공간 안에서 최대한으로 차지한다~ 정도인듯
                   * */
                  aspectRatio: 487/451,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(_file!),
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                      )
                    ),
                  ),
                ),
              ),
              const Divider()
            ],
          )
        ],
      ),

    );
  }
}
