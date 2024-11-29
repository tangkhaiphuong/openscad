include <bosl/std.scad>

// Declaration the size of ox
width = 90;
depth = 90;
height = 50;
thickness = 5;
inner_rounding = 10;
outer_rouding = 10;
knob_radius = 20;

lid_top_slot = 50;
lid_top_thickness = 1;
lid_middle_thickness = 2;
lid_middle_chamfer = 2;
lid_bottom_thickness = 5;
lid_bottom_wall_thickness = 1.5;

slot_width = 3;
slot_depth = 10;
slot_height = 3;

tolerance = 0.2;
knob_offset = 12;

tray_width = 16;
gap_width = 7;

// Setting
$fn = 50;

// Compulted values

lid_height = lid_top_thickness + lid_middle_thickness + lid_bottom_thickness;
edges = [ FWD + RIGHT, FWD + LEFT, BACK + LEFT, BACK + RIGHT ];

outer_width = width + thickness * 2;
outer_depth = depth + thickness * 2;
outer_height = height + thickness + lid_height;
outer_size = [ outer_width, outer_depth, outer_height ];

box_z = outer_height / 2 - lid_middle_thickness - lid_top_thickness;

module box() {

  // Components definition
  module component1(color = "red") {
    _bottom_size = [ outer_width, outer_depth, thickness ];
    color_this(color) cuboid(size = _bottom_size, rounding = outer_rouding,
                             edges = edges) children();
  }

  module component2(color = "orange") {
    _middle_size = [ outer_width, outer_depth ];
    color_this(color) rect_tube(h = height, size = _middle_size,
                                wall = thickness, irounding = inner_rounding,
                                rounding = outer_rouding) children();
  }

  module component3(color = "blue") {
    _size = [ outer_width, outer_depth ];
    _wall = thickness - lid_middle_chamfer * 2;

    _size1 = [ outer_width, lid_top_slot, lid_top_thickness ];
    _size2 = [ lid_top_slot, outer_depth, lid_top_thickness ];

    color_this(color) rect_tube(h = lid_top_thickness, size = _size,
                                wall = _wall, irounding = inner_rounding,
                                rounding = outer_rouding) children();
  }

  module component4(color = "yellow") {
    _top_size = [ outer_width, outer_depth ];
    _z = lid_middle_thickness / 2;
    _size1 = [ width + slot_width, slot_depth, slot_height ];
    _size2 = [ slot_depth, depth + slot_width, slot_height ];

    color_this(color) difference() {
      rect_tube(h = lid_bottom_thickness, size = _top_size, wall = thickness,
                irounding = inner_rounding, rounding = outer_rouding)
          children();
      up(_z) cube(size = _size1, center = true);
      up(_z) cube(size = _size2, center = true);
    }
  }

  module component5(color = "green") {
    _width1 = outer_width;
    _depth1 = outer_depth;

    _width2 = _width1 - lid_middle_chamfer * 2;
    _depth2 = _depth1 - lid_middle_chamfer * 2;

    _size1 = [ _width1, _depth1 ];
    _isize1 = [ width, depth ];

    _size2 = [ _width1, _depth1 ];
    _isize2 = [ _width2, _depth2 ];

    color_this(color)
        rect_tube(h = lid_middle_thickness, size1 = _size1, size2 = _size2,
                  isize = _isize1, isize2 = _isize2, wall = thickness,
                  irounding = inner_rounding, rounding = outer_rouding)
            children();
  }

  module component6(color = "maroon") {
    _size = [ outer_width, outer_depth ];
    _wall = thickness - lid_middle_chamfer * 2;

    _size1 = [ outer_width, lid_top_slot, lid_top_thickness ];
    _size2 = [ lid_top_slot, outer_depth, lid_top_thickness ];

    color_this(color) difference() {
      rect_tube(h = lid_top_thickness, size = _size, wall = _wall,
                irounding = inner_rounding, rounding = outer_rouding);
      cube(size = _size1, center = true);
      cube(size = _size2, center = true);
    }
    { children(); }
  }

  // Components assembly
  component1() attach(TOP, BOT) component2() attach(TOP, BOT) component3()
      attach(TOP, BOT) component4() attach(TOP, BOT) component5()
          attach(TOP, BOT) component6() children();
}

module lid1() {

  // Components definition
  module component1(color = "indigo") {
    _width = outer_width - lid_middle_chamfer - tolerance * 2;
    _depth = outer_depth - lid_middle_chamfer - tolerance * 2;
    _height = lid_top_thickness - tolerance;
    _size = [ _width, _depth, _height ];

    _size1 = [
      outer_width, lid_top_slot - tolerance * 2, lid_top_thickness - tolerance
    ];
    _size2 = [
      lid_top_slot - tolerance * 2, outer_depth, lid_top_thickness - tolerance
    ];

    _height2 = lid_top_thickness + lid_middle_thickness + lid_bottom_thickness;

    color_this(color) difference() {
      union() {
        cuboid(size = _size, rounding = inner_rounding, edges = edges) {
          children();
        }
        cube(size = _size1, center = true);
        cube(size = _size2, center = true);
      }
      down(lid_top_thickness / 2) cylinder(h = _height2, r = knob_radius);
    }
  }

  module component2(color = "violet") {
    _width1 = width - tolerance * 2;
    _depth1 = depth - tolerance * 2;
    _width2 = width + lid_middle_chamfer * 2 - tolerance * 2;
    _depth2 = depth + lid_middle_chamfer * 2 - tolerance * 2;
    _size2 = [ _width1, _depth1 ];
    _size1 = [ _width2, _depth2 ];

    color_this(color)
        prismoid(size1 = _size1, size2 = _size2, h = lid_middle_thickness,
                 rounding = inner_rounding) children();
  }

  module component3a(color = "pink") {
    _width = width - lid_bottom_wall_thickness * 2 - tolerance * 4;
    _depth = depth - lid_bottom_wall_thickness * 2 - tolerance * 4;
    _size = [ _width, _depth ];
    _id = knob_radius * 2 + knob_offset;

    _tray_width = tray_width + lid_bottom_wall_thickness * 2;
    _outer_size1 = [ _width, _tray_width, lid_bottom_thickness ];
    _outer_size2 = [ _tray_width, _depth, lid_bottom_thickness ];

    _inner_size1 = [ width, tray_width, lid_bottom_thickness ];
    _inner_size2 = [ tray_width, depth, lid_bottom_thickness ];
    _od = knob_radius * 2 + knob_offset;

    _horizontal_spacing = [ width / 2, _depth - lid_bottom_wall_thickness ];
    _gap_horizontal_size =
        [ gap_width, lid_bottom_wall_thickness, lid_bottom_thickness ];

    _gap_vertical_size =
        [ lid_bottom_wall_thickness, gap_width, lid_bottom_thickness ];
    _vertical_spacing = [ _width - lid_bottom_wall_thickness, depth / 2 ];

    _size2 = [
      tray_width / 2, width / 2 - lid_bottom_wall_thickness,
      lid_bottom_thickness
    ];

    // Components assembly
    color_this(color) union() {
      difference() {
        union() {
          rect_tube(h = lid_bottom_thickness, size = _size,
                    wall = lid_bottom_wall_thickness,
                    rounding = inner_rounding) {
            children();
          }
          tube(h = lid_bottom_thickness, id = _id,
               wall = lid_bottom_wall_thickness);
          cube(size = _outer_size1, center = true);
          cube(size = _outer_size2, center = true);
        }
        cube(size = _inner_size1, center = true);
        cube(size = _inner_size2, center = true);

        tube(h = lid_bottom_thickness, od = _od, wall = knob_radius);

        grid_copies(spacing = _horizontal_spacing, n = [ 2, 2 ])
            cube(size = _gap_horizontal_size, center = true);

        grid_copies(_vertical_spacing, n = [ 2, 2 ])
            cube(size = _gap_vertical_size, center = true);
      }
      left(_tray_width) back(width / 4 - lid_bottom_wall_thickness / 2 - 10)
#cube(_size2);
    }
  }

  module component3b(color = "brown") {
    _width = width - lid_bottom_wall_thickness * 2 - tolerance * 2;
    _depth = depth - lid_bottom_wall_thickness * 2 - tolerance * 2;

    _spacing1 = [ width / 2, _depth - lid_bottom_wall_thickness ];
    _spacing2 = [ _width - lid_bottom_wall_thickness, depth / 2 ];

    // Components assembly
    module component1() {
      _spacing1 = [ width / 2, _depth - lid_bottom_wall_thickness ];
      _spacing2 = [ _width - lid_bottom_wall_thickness, depth / 2 ];

      _gap_horizontal_size = [
        gap_width - tolerance * 2, lid_bottom_wall_thickness,
        lid_bottom_thickness
      ];

      _gap_vertical_size = [
        lid_bottom_wall_thickness, gap_width - tolerance * 2,
        lid_bottom_thickness
      ];

      color_this(color) union() {
        grid_copies(spacing = _spacing1, n = [ 2, 2 ])
            cube(size = _gap_horizontal_size, center = true);

        grid_copies(spacing = _spacing2, n = [ 2, 2 ])
            cube(size = _gap_vertical_size, center = true);
      }
    }

    module component2() {
      _spacing1 = [
        width / 2, _depth - lid_bottom_wall_thickness +
        lid_bottom_wall_thickness
      ];
      _spacing2 = [
        _width - lid_bottom_wall_thickness + lid_bottom_wall_thickness,
        depth / 2
      ];

      _gap_horizontal_size = [
        gap_width - tolerance * 2, lid_bottom_wall_thickness,
        lid_bottom_wall_thickness
      ];

      _gap_vertical_size = [
        lid_bottom_wall_thickness, gap_width - tolerance * 2,
        lid_bottom_wall_thickness
      ];

      rounding = lid_bottom_wall_thickness / 3;
      _edges1 = [ FWD + TOP, FWD + DOWN, BACK + TOP, BACK + DOWN ];
      _edges2 = [ RIGHT + TOP, RIGHT + DOWN, LEFT + TOP, LEFT + DOWN ];

      color_this(color) union() {
        grid_copies(spacing = _spacing1, n = [ 2, 2 ]) cuboid(
            size = _gap_horizontal_size, rounding = rounding, edges = _edges1);

        grid_copies(spacing = _spacing2, n = [ 2, 2 ]) cuboid(
            size = _gap_vertical_size, rounding = rounding, edges = _edges2);
      }
    }

    component1();
    up(lid_bottom_thickness - lid_bottom_wall_thickness) component2();
  }

  //  Components assembly
  component1() attach(TOP, BOT) component2() {
    attach(TOP, BOT) component3a();
    attach(TOP, BOT) component3b();
  }
}

module lid2() {
  // Components definition
  module component1(color = "black") {
    _width = width - tolerance * 2;
    _depth = depth - tolerance * 2;
    _size = [ _width, _depth, lid_top_thickness ];

    echo(_size);
    color_this(color) cuboid(size = _size, rounding = inner_rounding,
                             edges = edges) children();
  }

  module component2(color = "white") {
    _width = width - tolerance * 2;
    _depth = depth - tolerance * 2;
    _size = [ _width, _depth ];

    _inner_size1 = [
      width + tolerance * 2, tray_width + tolerance * 2, lid_bottom_thickness +
      tolerance
    ];
    _inner_size2 = [
      tray_width + tolerance * 2, depth, lid_bottom_thickness + tolerance * 2
    ];

    _spacing1 = [ width / 2, _depth - lid_bottom_wall_thickness ];
    _spacing2 = [ _width - lid_bottom_wall_thickness, depth / 2 ];

    _gap_horizontal_size =
        [ gap_width, lid_bottom_wall_thickness, lid_bottom_wall_thickness ];

    _gap_vertical_size =
        [ lid_bottom_wall_thickness, gap_width, lid_bottom_wall_thickness ];

    color_this(color) difference() {
      rect_tube(h = lid_bottom_thickness, size = _size,
                wall = lid_bottom_wall_thickness, rounding = inner_rounding);

      cube(size = _inner_size1, center = true);
      cube(size = _inner_size2, center = true);

      grid_copies(spacing = _spacing1, n = [ 2, 2 ])
          cube(size = _gap_horizontal_size);

      grid_copies(spacing = _spacing2, n = [ 2, 2 ])
          cube(size = _gap_vertical_size);
    }
  }

  // Component assembly
  component1() attach(TOP, BOT) component2();
}

module main() {
  xdistribute(spacing = 15, sizes = [ width, width, width ]) {
    box();
    lid1();
    lid2();
  }
}

main();