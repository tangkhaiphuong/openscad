include <bosl/std.scad>

// Declaration the size of ox
width = 130;
depth = 130;
height = 76;
thickness = 5;
outer_rounding = 3;
inner_rounding = 0;

slots_number = 2;
slots_radius = 1.5;
slots_length = 30;
slots_spacing = 50;

tolerance = 0.2;
angle = 45;

// Setting
$fn = 100;

// Compulted values
offset1 = tan(angle) * thickness;
offset2 = tan(angle) * (thickness - tolerance);

size = [ width, depth, height ];

module box() {

  difference() {
    // The outer box
    let(_thickness_double = thickness * 2, _width = width + _thickness_double,
        _depth = depth + _thickness_double,
        _height = height + _thickness_double,
        _size = [ _width, _depth, _height ]) {
      up(_thickness_double / 2) { cuboid(size = _size, rounding = outer_rounding); }
    }

    // The inner box
    up(thickness) {
      cuboid(size = size, rounding = inner_rounding,
             edges = [ FWD + RIGHT, FWD + LEFT, BACK + LEFT, BACK + RIGHT ]);
    }

    // The tray
    let(_height = height / 2 + thickness) {
      up(_height) {
        // The inner tray
        let(_offset_double = offset1 * 2, _width1 = width + _offset_double,
            _depth1 = depth + offset1, _width2 = width, _depth2 = depth,
            _size1 = [ _width1, _depth1 ], _size2 = [ _width2, _depth2 ]) {
          prismoid(size1 = _size1, size2 = _size2, h = thickness);
        }
        // The outer tray
        let(_x = (width + thickness) / 2) {
          right(_x) {
            let(_width1 = thickness, _depth1 = depth + offset1,

                _width2 = thickness, _depth2 = depth,

                _size1 = [ _width1, _depth1 ], _size2 = [ _width2, _depth2 ]) {
              prismoid(size1 = _size1, size2 = _size2, h = thickness);
            }
          }
        }
      }
    }

    let(_x = (width + thickness) / 2, _z = height / 2 + thickness + tolerance,
        _v = [ _x, 0, _z ]) {
      translate(v = _v) {
        ycopies(slots_spacing, slots_number) {
          cylinder(h = slots_length, r = slots_radius, orient = FWD,
                   center = true);
        }
      }
    }
  }
}

module lid() {
  _x = 0;
  _z = height / 2 + tolerance + thickness;
  _v = [ _x, 0, _z ];
  translate(v = _v) {
    let(_width1 = width - tolerance * 2 + (offset2),
        _depth1 = depth - tolerance * 2 + (offset2),

        _width2 = width - (tolerance * 2), _depth2 = depth - (tolerance * 2),

        _size1 = [ _width1, _depth1 ], _size2 = [ _width2, _depth2 ],
        _height = thickness - tolerance) {
      prismoid(size1 = _size1, size2 = _size2, h = _height);
    }

    difference() {
      let(_x = width / 2) {
        right(_x) {
          let(_width1 = thickness * 2,
              _depth1 = depth - tolerance * 2 + (offset2),

              _width2 = thickness * 2, _depth2 = depth - (tolerance * 2),

              _size1 = [ _width1, _depth1 ], _size2 = [ _width2, _depth2 ],
              _height = thickness - tolerance) {
            prismoid(size1 = _size1, size2 = _size2, h = _height);
          }
        }
      }

      let(_x = width / 2 + thickness - outer_rounding,
          _z = thickness - outer_rounding - tolerance, _v = [ _x, 0, _z ]) {
        translate(v = _v) {
          difference() {
            let(_width = outer_rounding * 2, _height = outer_rounding * 2, _depth = depth * 2,
                _size = [ _width, _depth, _height ]) {
              cube(size = _size, center = true);
            }

            let(_v = [ 90, 0, 0 ]) {
              rotate(_v) {
                _r1 = outer_rounding;
                _r2 = outer_rounding;
                _height = depth * 2;
                cylinder(r1 = _r1, r2 = _r2, h = _height, center = true);
              }
            }

            let(_x = outer_rounding / 2) {
              left(_x) {
                _height = outer_rounding * 2;
                _depth = depth * 2;
                _size = [ outer_rounding, _depth, _height ];

                cube(size = _size, center = true);
              }
            }

            let(_z = outer_rounding / 2) {
              down(_z) {
                _width = outer_rounding * 2;
                _depth = depth * 2;
                _size = [ _width, _depth, outer_rounding ];

                cube(size = _size, center = true);
              }
            }
          }
        }
      }
    }

    let(_x = (width + thickness) / 2, _v = [ _x, 0, 0 ],
        _slots_radius = slots_radius - tolerance,
        _slots_length = slots_length - tolerance) {
      translate(v = _v) {
        ycopies(slots_spacing, slots_number) {
          cylinder(h = _slots_length, r = _slots_radius, orient = FWD,
                   center = true);
        }
      }
    }
  }
}

module slots(width, depth, row, column, gap, flip = false) {

  module _slots(width, depth, row, column) {
    _slot_width = (width - (column - 1) * gap) / column;
    _slot_depth = (depth - (row - 1) * gap) / row;

    _rounding = min(_slot_width, _slot_depth) / 2;

    module columns(column) {
      for (i = [0:1:(column - 1)]) {
        let(_x = i * (_slot_width + gap) + _slot_width / 2,
            _y = _slot_depth / 2, _v = [ _x, _y, 0 ],
            _size = [ _slot_width, _slot_depth ]) {
          translate(v = _v) { rect(_size, rounding = _rounding); }
        }
      }
    }

    difference() {
      union() {
        for (i = [0:1:(row - 1)]) {
          let(_old = i % 2 == 0 ? 0 : 1, _x = (_slot_width + gap) / 2 * -_old,
              _y = i * (_slot_depth + gap), _v = [ _x, _y, 0 ],
              _column = column + _old) {
            translate(v = _v) { columns(_column); }
          }
        }
      }

      let(_x = -_slot_width, _y = depth / 2, _v = [ _x, _y, 0 ],
          _width = _slot_width * 2, _size = [ _width, depth ]) {
        translate(v = _v) rect(_size);
      }

      let(_x = width + _slot_width, _y = depth / 2, _v = [ _x, _y, 0 ],
          _width = _slot_width * 2, _size = [ _width, depth ]) {
        translate(v = _v) rect(_size);
      }
    }
  }
  if (flip) {
    right(width) {
      rotate([ 0, 0, 90 ]) { _slots(depth, width, column, row); }
    }
  } else {
    _slots(width, depth, row, column);
  }
}

module cutting(xy = [ 15, 7 ], xz = [ 4, 15 ], yz = [ 15, 4 ]) {

  let(_width = width - thickness * 2, _depth = depth - thickness * 2,
      _x = _width / -2, _y = _depth / -2, _z = -height, _v = [ _x, _y, _z ]) {
    translate(v = _v) {
      _height = height * 2;
      linear_extrude(_height) {
        slots(_width, _depth, xy[0], xy[1], thickness);
      }
    }
  }

  let(_width = width - thickness * 2, _depth = height - thickness * 2,
      _x = _width / -2, _y = _depth / -2 + thickness, _z = -width,
      _v = [ _x, _y, _z ]) {
    rotate([ 90, 0, 0 ]) {
      translate(v = _v) {
        _height = width * 2;
        linear_extrude(_height) {
          slots(_width, _depth, xz[0], xz[1], thickness, true);
        }
      }
    }
  }

  let(_width = height - thickness * 2, _depth = depth - thickness * 2,
      _x = _width / -2 - thickness, _y = _depth / -2, _z = -depth,
      _v = [ _x, _y, _z ]) {
    rotate([ 0, 90, 0 ]) {
      translate(v = _v) {
        _height = depth * 2;
        linear_extrude(_height) {
          slots(_width, _depth, yz[0], yz[1], thickness);
        }
      }
    }
  }
}

module main() {
  difference() {
    union() {
      box();
      color("red") lid();
    }
    cutting();
  }
}

main();