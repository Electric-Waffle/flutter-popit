import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';

class Player {

  late final int _id;

  late final double _vie;
  late final double _vieBase;

  late final int _point;

  Player(int this._id, double this._vie, double this._vieBase, int this._point);

  int getId()
  {
    return this._id;
  }

  double getVie()
  {
    return this._vie;
  }
  double getVieBase()
  {
    return this._vieBase;
  }

  int getPoints()
  {
    return this._point;
  }
  
}