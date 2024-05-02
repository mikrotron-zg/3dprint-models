/*
 * This file is part of SFactor project
 * (https://github.com/mikrotron-zg/3dprint-models/tree/main/sfactor)
 * developed by Mikrotron d.o.o. (http://mikrotron.hr).
 * It contains project box 3D model.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version. See the LICENSE file at the 
 * top-level directory of this distribution for details 
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
 
// Use common library
include <../lib/common.scad>;

/****************************************************************************
 **************************** Global Variables ******************************
 ****************************************************************************/

/* List of shorthands in variable names:
 * mh -> short for 'mount hole'
 * dia -> diameter
 * pos -> position
 */
 
// 120 mm fan dimensions
fan_size = 120;
fan_depth = 25;
fan_bracket_width = 4;
fan_mh_dia = 4.3;
fan_mh_offset = 7.5;
fan_mh_pos = [ [fan_mh_offset, fan_mh_offset, -ex], 
               [fan_size - fan_mh_offset, fan_mh_offset, -ex], 
               [fan_size - fan_mh_offset, fan_size - fan_mh_offset, -ex], 
               [fan_mh_offset, fan_size - fan_mh_offset, -ex] ];
fan_dia = 114;
fan_center_dia = 40;
fan_offset = 0.5;

// Center grill
grill_height = 2.4;

// Filter
filter_height = 10;

// Box dimensions
box_wall = 2.4;
box_corner_radius = fan_mh_offset + fan_offset + box_wall;
box_side = 15;
box_overlap = 5;
box_overlap_tolerance = 0.1;
box_width = fan_size + 2* fan_offset + 2+box_wall;
box_length = box_width + box_side;
box_bottom_height = box_wall + fan_depth - box_overlap;
box_top_height = box_wall + filter_height + grill_height + box_overlap;


/****************************************************************************
 ****************************** Main Modules ********************************
 ****************************************************************************/
sfactor_box();
 
module sfactor_box() {
    box_bottom();
    translate([box_wall + fan_offset, box_wall + fan_offset, box_wall]) %fan();
    translate([1.1*box_length, 0, 0]) center_grill();
    translate([0, 1.1*box_width, 0]) box_top();
}

module box_top() {
    union() {
        difference() {
            // Main body
            rounded_rect(box_length, box_width, box_top_height, box_corner_radius);
            translate([box_wall, box_wall, box_wall])
                    rounded_rect(box_length - 2*box_wall, box_width - 2*box_wall, 
                    box_top_height, box_corner_radius - box_wall);
            // Overlap
            translate([box_wall/2 + box_overlap_tolerance/2, box_wall/2 + box_overlap_tolerance/2,
                       box_top_height - box_overlap - box_overlap_tolerance])
                rounded_rect(box_length - box_wall - box_overlap_tolerance, 
                             box_width - box_wall - box_overlap_tolerance, 
                             box_overlap + box_overlap_tolerance + ex, box_corner_radius - box_wall/2);
            // Remove to place a grill
                translate([box_wall + fan_offset, box_wall + fan_offset, -ex])
                    rounded_rect(fan_size, fan_size, box_wall + 2*ex, fan_mh_offset);
        }
        // Fan grill
        translate([box_wall + fan_offset, box_wall + fan_offset, 0]) center_grill(false);
        // Filter wall
        translate([box_wall + fan_size + 2*fan_offset, box_wall, box_wall])
            cube([box_wall/2, box_width - 2*box_wall, 
                  box_top_height - box_wall - box_overlap - box_overlap_tolerance]);
    }
}

module box_bottom() {
    union() {
        difference() {
            // Main body
            rounded_rect(box_length, box_width, box_bottom_height, box_corner_radius);
            translate([box_wall, box_wall, box_wall])
                rounded_rect(box_length - 2*box_wall, box_width - 2*box_wall, 
                box_bottom_height, box_corner_radius - box_wall);
            // Remove to place a grill
            translate([box_wall + fan_offset, box_wall + fan_offset, -ex])
                rounded_rect(fan_size, fan_size, box_wall + 2*ex, fan_mh_offset);
            // Power connector cutout
            translate([box_width - box_wall + box_side/2, 15, -ex])
                cylinder(d = 7.8, h = box_wall + 2*ex);
            // Power switch cutout
            translate([box_width, 25, -ex])
                cube([12.7, 19.7, box_wall + 2*ex]);
        }
        // Fan grill
        translate([box_wall + fan_offset, box_wall + fan_offset, 0]) center_grill();
        // Box overlap
        translate([box_wall/2, box_wall/2, box_bottom_height]) difference() {
            rounded_rect(box_length - box_wall, box_width - box_wall, 
                            box_overlap, box_corner_radius - box_wall/2);
            translate([box_wall/2, box_wall/2, -ex]) 
                rounded_rect(box_length - 2*box_wall, box_width - 2*box_wall, 
                            box_overlap + 2*ex, box_corner_radius - box_wall);
        }
    }
}

module center_grill(pins = true) {
    difference() {
        // Main body
        rounded_rect(fan_size, fan_size, grill_height, fan_mh_offset);
        // Central hole
        translate([fan_size/2, fan_size/2, -ex]) cylinder(d = fan_dia, h = fan_depth + 2*ex);
    }
    // Grill
    if (pins) {
        translate([fan_size/2, fan_size/2, 0]) grill(grill_height/2);
    } else {
        translate([fan_size/2, fan_size/2, 0]) grill(grill_height/2, false);
    }
}

module grill(height, pins = true) {
    width = 3;
    difference() {
        cylinder(d = 0.5*fan_dia, h = height);
        translate(zex()) cylinder(d = 0.5*fan_dia - width, h = height + 2*ex);
    }
    difference() {
        cylinder(d = 0.75*fan_dia, h = height);
        translate(zex()) cylinder(d = 0.75*fan_dia - width, h = height + 2*ex);
    }
    for (i = [0:45:360]) translate([0, 0, height/2]) {
        rotate(i) cube([fan_dia, width, height], center = true);
    }
    if (pins)
        translate([-fan_size/2, -fan_size/2, grill_height]) for (i = [0:3]) translate(fan_mh_pos[i]) 
            cylinder(d = fan_mh_dia*0.9, h = box_wall);
}

module pin() {
    pin_head_height = 3;
    divide = 1;
    difference() {
        union() {
            cylinder(d = fan_mh_dia*0.9, h = fan_bracket_width + pin_head_height);
            translate([0, 0, fan_bracket_width*1.5]) sphere(d = fan_mh_dia*1.1);
        }
        translate([0, 0, box_wall + fan_bracket_width]) 
            cube([fan_mh_dia*1.5, divide, 2*fan_bracket_width], center = true);
    }
}

 /****************************************************************************
 ***************** Additional Modules and Functions *************************
 ****************************************************************************/
 
 // Draws fan mockup
module fan() {
    difference() {
        // Main body
        rounded_rect(fan_size, fan_size, fan_depth, fan_mh_offset);
        // Mount holes
        for (i = [0:3]) translate(fan_mh_pos[i]) cylinder(d = fan_mh_dia, h = fan_depth + 2*ex);
        // Central hole
        translate([fan_size/2, fan_size/2, -ex]) cylinder(d = fan_dia, h = fan_depth + 2*ex);
        // Brackets
        translate([0, 0, fan_bracket_width]){
            fan_bracket_cutout();
            translate([fan_size, 0, 0]) fan_bracket_cutout();
            translate([fan_size, fan_size, 0]) fan_bracket_cutout();
            translate([0, fan_size, 0]) fan_bracket_cutout();
        }
    }
    // Fan center
    translate([fan_size/2, fan_size/2, 0]) cylinder(d = fan_center_dia, h = fan_depth);
}

module fan_bracket_cutout() {
    cylinder(r = 2*fan_mh_offset, h = fan_depth - 2*fan_bracket_width);
}