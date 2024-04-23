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

// Center grill
grill_height = 1.2;


/****************************************************************************
 ****************************** Main Modules ********************************
 ****************************************************************************/
sfactor_box();
 
module sfactor_box() {
    color("Orange") center_grill();
    translate([0, 0, grill_height]) %fan();
}

module center_grill() {
    difference() {
        // Main body
        rounded_rect(fan_size, fan_size, grill_height, fan_mh_offset);
        // Central hole
        translate([fan_size/2, fan_size/2, -ex]) cylinder(d = fan_dia, h = fan_depth + 2*ex);
    }
    // Grill
    translate([fan_size/2, fan_size/2, 0]) grill(grill_height);
}

module grill(height) {
    width = 3;
    cylinder(d = fan_center_dia, h = height);
    difference() {
        cylinder(d = 0.5*fan_dia, h = height);
        translate(zex()) cylinder(d = 0.5*fan_dia - width, h = height + 2*ex);
    }
    difference() {
        cylinder(d = 0.75*fan_dia, h = height);
        translate(zex()) cylinder(d = 0.75*fan_dia - width, h = height + 2*ex);
    }
    for (i = [0:45:360]) translate([0, 0, grill_height/2]) {
        rotate(i) cube([fan_dia, width, grill_height], center = true);
    }
    translate([-fan_size/2, -fan_size/2, grill_height]) for (i = [0:3]) translate(fan_mh_pos[i]) pin();
}

module pin() {
    pin_head_height = 3;
    divide = 1;
    difference() {
        union() {
            cylinder(d = fan_mh_dia*0.9, h = fan_bracket_width + pin_head_height);
            translate([0, 0, fan_bracket_width*1.5]) sphere(d = fan_mh_dia*1.1);
        }
        cube([fan_mh_dia*1.5, divide, fan_bracket_width*5], center = true);
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