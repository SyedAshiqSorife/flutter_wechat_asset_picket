import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AssetEntity? entity;
  Uint8List? data;
  List<AssetEntity>? gallaryEntity;

  String image = "assets/bike.jpeg";
  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                      onPressed: () {
                        pick(context);
                        setState(() {
                         
                        });
                      },
                      icon: const Icon(Icons.camera),
                      label: const Text('Take Picture')),
                  const SizedBox(
                    width: 15,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _takePicture(context);
                        setState(() {
                          
                        });
                      },
                      child: const Text('Upload Image')),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              (gallaryEntity == null)
                  ? (entity != null) ? AssetEntityImage(entity!, isOriginal: true, height: 100, width: 200,) : Image.asset(
                      image,
                      fit: BoxFit.fitWidth,
                      height: 100,
                      width: 200,
                    )
                  : AssetEntityImage(gallaryEntity![0], isOriginal: true, height: 100, width: 200,),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> _takePicture(BuildContext context) async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: const AssetPickerConfig(maxAssets: 1),
    );
    setState(() {
      gallaryEntity = result;
    });
  }

  Future<void> pick(BuildContext context) async {
    final Size size = MediaQuery.of(context).size;

    final double scale = MediaQuery.of(context).devicePixelRatio;
    try {
      final AssetEntity? _entity = await CameraPicker.pickFromCamera(
        context,
        pickerConfig: const CameraPickerConfig(),
      );
      if (_entity != null && entity != _entity) {
        setState(() {
          entity = _entity;
        });
        
        if (mounted) {
          setState(() {});
        }
        data = await _entity.thumbnailDataWithSize(
          ThumbnailSize(
            (size.width * scale).toInt(),
            (size.height * scale).toInt(),
          ),
        );
        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
