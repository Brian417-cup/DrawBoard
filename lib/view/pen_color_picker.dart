import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialog extends StatelessWidget {
  final Function(Color dstColor) onColorChange;
  Color dstColor = Colors.blue;
  final Color initColor;
//  为了防止没有调整任何操作就关闭对话框啊而导致最后的颜色发生改变的情况
  bool hasChanged = false;

  ColorPickerDialog(
      {Key? key, required this.onColorChange, required this.initColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      elevation: 0,
      backgroundColor: Colors.white10,
      child: ColorPickerBoard(context),
    );
  }

  Widget ColorPickerBoard(context) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SlidePicker(
              sliderTextStyle: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              pickerColor: initColor,
              onColorChanged: (curColor) {
                hasChanged = true;
                dstColor = curColor;
              },
              colorModel: ColorModel.rgb,
              enableAlpha: true,
              displayThumbColor: true,
              showIndicator: true,
              showParams: true,
              indicatorBorderRadius:
                  const BorderRadius.vertical(top: Radius.circular(25))),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (hasChanged) {
                  onColorChange(dstColor);
                }
                Navigator.of(context).pop();
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(color: Colors.blue),
                child: Center(
                  child: Text(
                    '确定',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
