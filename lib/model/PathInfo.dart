import 'dart:ui';

class PathInfo{
  Path _data;
  Paint _pen;

  PathInfo(this._data, this._pen);

  Paint get pen => _pen;

  set pen(Paint value) {
    _pen = value;
  }

  Path get data => _data;

  set data(Path value) {
    _data = value;
  }


}