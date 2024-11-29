include <BOSL2/std.scad>

// Declaration of the slide box
width = 100;
depth = 100;
height = 40;

thickness = 5;
fillet = 2;
tolerance = 1;
angle = 45;

// Setting
$fn = 30;

// Compulted values
offset1 = tan(angle) * thickness;
offset2 = tan(angle) * (thickness - tolerance);

size = [width, depth, height];

module box()
{
  difference() {
    if (true) { // The outer box
      _thickness_double = thickness * 2;
      _width = width + _thickness_double;
      _depth = depth + _thickness_double;
      _height = height + _thickness_double;
      _size = [_width, _depth, _height];

      cuboid(size = _size, rounding = fillet);
    }

    if (true) { // The inner box
      up(thickness) {
        if (true) {
          cube(size = size, center = true);
        }
      }
    }

    if (true) { // The tray
      _height = height / 2;
      up(_height) {
        if (true) { // The inner tray
          _offset_double = offset1 * 2;

          _width1 = width + _offset_double;
          _depth1 = depth + offset1;

          _width2 = width;
          _depth2 = depth;

          _size1 = [_width1, _depth1];
          _size2 = [_width2, _depth2];

          prismoid(size1 = _size1, size2 = _size2, h = thickness);
        }

        if (true) { // The outer tray
          _x = (width + thickness) / 2  ;
          right(_x) {
            if (true) {
              _width1 = thickness ;
              _depth1 = depth + offset1;

              _width2 = thickness;
              _depth2 = depth;

              _size1 = [_width1, _depth1];
              _size2 = [_width2, _depth2];

              prismoid(size1 = _size1, size2 = _size2, h = thickness);
            }
          }
        }
      }
    }
  }
}

module lid() {
  if (true) { // The tray
    _x = 0;
    _z = height / 2 + tolerance;
    _v = [_x, 0, _z];
    translate(v = _v) {

      if (true) {
        _width1 = width - tolerance * 2 + (offset2);
        _depth1 = depth - tolerance * 2 + (offset2);

        _width2 = width - (tolerance * 2);
        _depth2 = depth - (tolerance * 2);

        _size1 = [_width1, _depth1];
        _size2 = [_width2, _depth2];
        _height = thickness - tolerance;

        prismoid(size1 = _size1, size2 = _size2, h = _height);
      }

      difference() {
        if (true) {
          _x = width / 2 + thickness / 2 - thickness / 2 ;
          right(_x) {
            if (true) {
              _width1 = thickness * 2;
              _depth1 = depth - tolerance * 2 + (offset2);

              _width2 = thickness * 2;
              _depth2 = depth - (tolerance * 2);

              _size1 = [_width1, _depth1];
              _size2 = [_width2, _depth2];
              _height = thickness - tolerance;

              prismoid(size1 = _size1, size2 = _size2, h = _height);
            }
          }

          if (true) {
            _x = width / 2 + thickness - fillet;
            _z = thickness / 2 - tolerance / 2;
            _v = [_x, 0, _z];
            translate(v = _v) {
              difference() {
                if (true) {
                  _width = fillet * 2;
                  _height = fillet * 2;
                  _size = [_width, depth, _height];

                  cube(size = _size, center = true);
                }

                if (true) {
                  _v = [90, 0, 0];
                  rotate(_v) {
                    _r1 = fillet;
                    _r2 = fillet;
                    _height = depth;

                    cylinder(r1 = _r1, r2 = _r2, h = _height, center = true);
                  }
                }

                if (true) {
                  _x = fillet / 2;
                  left(_x) {
                    _height = fillet * 2;
                    _size = [fillet, depth, _height];

                    cube(size = _size, center = true);
                  }
                }

                if (true) {
                  _z = fillet / 2;
                  down(_z) {
                    _width = fillet * 2;
                    _size = [_width, depth, fillet];
                    
                    cube(size = _size, center = true);
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

box();

lid();
