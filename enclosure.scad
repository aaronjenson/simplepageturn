// control which part gets rendered, to allow each part to be saved independently
// has no effect in preview mode, all parts are rendered instead
part_to_render = "";

/* parameters */

// These default values are for a seeed studio xiao nrf52840 board with cherry MX keyswitch

// width of xiao board
xiao_width = 18;
// length of xiao board (does not include usbc stickout
xiao_length = 21.1;
// length of usbc stickout from end of board
xiao_usbc_stickout = 1.5;
// dist from bottom of board to bottom of usbc
xiao_usbc_height_offset = 1;
// width/height of usbc port
usbc_width = 9;
usbc_height = 3.5;
// depth/width space to leave under sides of board for solder clearance
xiao_solder_clearance_depth = 1.5;
xiao_solder_clearance_width = 2;

// minimum distance between outside walls and any internal feature (except where smaller is required)
min_wall = 2;

// width/length of hole for keyswitch
switch_width = 14;
switch_length = 14;
// thickness of top surface immediately surrounding keyswitch hole
switch_plate_height = 1;
// size of ring around keyswitch hole that will be switch_plate_height thickness. Anything more than this far from hole will be at least min_wall thick
switch_plate_clearance = 2;
// clearance to leave between for the underside of the keyswitch
switch_depth = 10;

// size of screw holes in base (not intended to engage threads)
screw_through_hole_dia = 3.5;
// size of screw holes in top (should engage threads)
screw_thread_dia = 3;
// size of screw head
screw_head_dia = 6;
// depth of overall screw hole
screw_overall_depth = 12;
// depth screw head should be inset by
screw_shoulder_depth = 4;

/* calculations, driven by above variables */

// distance from edge of part reserved for screw holes on the base of the part
base_screw_region_length = (min_wall + screw_through_hole_dia / 2 + screw_head_dia / 2 + min_wall);
top_screw_region_length = (min_wall + screw_thread_dia / 2 + screw_head_dia / 2 + min_wall);

xiao_min_width = xiao_width + 2 * base_screw_region_length;
xiao_min_length = xiao_length + xiao_usbc_stickout + min_wall;

switch_min_width = switch_width + 2 * top_screw_region_length;
switch_min_length = switch_length + 2 * top_screw_region_length;

box_side_length = max(xiao_min_width, xiao_min_length, switch_min_width, switch_min_length);

base_height = min_wall + xiao_solder_clearance_depth + xiao_usbc_height_offset + usbc_height;
top_height = switch_depth + switch_plate_height;

module base() {
  difference() {
    union() {
      linear_extrude(min_wall) square(box_side_length);
      linear_extrude(min_wall + xiao_solder_clearance_depth) difference() {
        square(box_side_length);
        translate([(box_side_length - xiao_width) / 2, xiao_usbc_stickout]) square([xiao_solder_clearance_width, xiao_length]);
        translate([box_side_length - (box_side_length - xiao_width) / 2 - xiao_solder_clearance_width, xiao_usbc_stickout]) square([xiao_solder_clearance_width, xiao_length]);
      }
      linear_extrude(min_wall + xiao_solder_clearance_depth + xiao_usbc_height_offset) difference() {
        square(box_side_length);
        translate([(box_side_length - xiao_width) / 2, xiao_usbc_stickout]) square([xiao_width, xiao_length]);
      }
      linear_extrude(base_height) difference() {
        square(box_side_length);
        translate([(box_side_length - xiao_width) / 2, xiao_usbc_stickout]) square([xiao_width, xiao_length]);
        translate([(box_side_length - usbc_width) / 2, 0]) square([usbc_width, xiao_usbc_stickout + 1]);
      }
    }
    translate([(min_wall + screw_head_dia / 2), (min_wall + screw_head_dia / 2), -1]) cylinder(base_height + 2, r=screw_through_hole_dia / 2);
    translate([box_side_length - (min_wall + screw_head_dia / 2), (min_wall + screw_head_dia / 2), -1]) cylinder(base_height + 2, r=screw_through_hole_dia / 2);
    translate([(min_wall + screw_head_dia / 2), box_side_length - (min_wall + screw_head_dia / 2), -1]) cylinder(base_height + 2, r=screw_through_hole_dia / 2);
    translate([box_side_length - (min_wall + screw_head_dia / 2), box_side_length - (min_wall + screw_head_dia / 2), -1]) cylinder(base_height + 2, r=screw_through_hole_dia / 2);
    translate([(min_wall + screw_head_dia / 2), (min_wall + screw_head_dia / 2), -1]) cylinder(screw_shoulder_depth + 1, r=screw_head_dia / 2);
    translate([box_side_length - (min_wall + screw_head_dia / 2), (min_wall + screw_head_dia / 2), -1]) cylinder(screw_shoulder_depth + 1, r=screw_head_dia / 2);
    translate([(min_wall + screw_head_dia / 2), box_side_length - (min_wall + screw_head_dia / 2), -1]) cylinder(screw_shoulder_depth + 1, r=screw_head_dia / 2);
    translate([box_side_length - (min_wall + screw_head_dia / 2), box_side_length - (min_wall + screw_head_dia / 2), -1]) cylinder(screw_shoulder_depth + 1, r=screw_head_dia / 2);
  }
}

module top() {
  difference() {
    union() {
      linear_extrude(switch_plate_height) difference() {
        square(box_side_length, [0, 0, 0]);
        translate([(box_side_length - switch_width) / 2, (box_side_length - switch_length) / 2]) square([switch_width, switch_length], [0, 0, 0]);
      }
      linear_extrude(min_wall) difference() {
        square(box_side_length, [0, 0, 0]);
        translate([(box_side_length - switch_width - switch_plate_clearance * 2) / 2, (box_side_length - switch_length - switch_plate_clearance * 2) / 2]) square([switch_width + switch_plate_clearance * 2, switch_length + switch_plate_clearance * 2], [0, 0, 0]);
      }
      linear_extrude(top_height) difference() {
        square(box_side_length, [0, 0, 0]);
        translate([box_side_length / 2, box_side_length / 2]) circle(box_side_length / 2 - min_wall);
      }
    }
    translate([(min_wall + screw_head_dia / 2), (min_wall + screw_head_dia / 2), top_height - screw_overall_depth + screw_shoulder_depth]) cylinder(screw_overall_depth - screw_shoulder_depth + 1, r=screw_thread_dia / 2);
    translate([box_side_length - (min_wall + screw_head_dia / 2), (min_wall + screw_head_dia / 2), top_height - screw_overall_depth + screw_shoulder_depth]) cylinder(screw_overall_depth - screw_shoulder_depth + 1, r=screw_thread_dia / 2);
    translate([(min_wall + screw_head_dia / 2), box_side_length - (min_wall + screw_head_dia / 2), top_height - screw_overall_depth + screw_shoulder_depth]) cylinder(screw_overall_depth - screw_shoulder_depth + 1, r=screw_thread_dia / 2);
    translate([box_side_length - (min_wall + screw_head_dia / 2), box_side_length - (min_wall + screw_head_dia / 2), top_height - screw_overall_depth + screw_shoulder_depth]) cylinder(screw_overall_depth - screw_shoulder_depth + 1, r=screw_thread_dia / 2);
  }
}

$fn=360;

if($preview) {
  base();
  translate([box_side_length * 1.5, 0]) top();
} else if(part_to_render == "base") {
  base();
} else if(part_to_render == "top") {
  top();
}
