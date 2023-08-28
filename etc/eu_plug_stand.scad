/*
 * EU plug stand for USB chargers and adapters
 * developed by Mikrotron d.o.o. (http://mikrotron.hr).
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

// Global dimensions
wall = 1.6;
default_tolerance = 0.5;
plug_body_length = 35.3;
plug_body_width = 13.7;
plug_body_height = 10;
plug_length = 19;
plug_gap = 17.5;
bracket_offset = 15;
bracket_length = plug_body_length + 2*wall;
bracket_width = plug_body_width + 2*wall;
base_height = wall;

// Entry point
eu_plug_stand();

// Main module
module eu_plug_stand() {
    columns = 3; // number of columns
    rows = 4; // number of plugs in each column
    tolerances = [0.5, 0.25, 0.75]; // number of tolerances should be equal to number of columns
    
    // Draw base
    rounded_rect((bracket_length + bracket_offset)*columns + bracket_offset/4, 
                 (bracket_width + bracket_offset)*rows + bracket_offset/4, base_height);
    
    // Draw brackets
    translate([bracket_length/2 + bracket_offset/2, bracket_width/2 + bracket_offset/2, base_height]) {
        for(x = [0 : columns - 1]) {
            for(y = [0 : rows - 1]) {
                translate([(bracket_length + bracket_offset)*x, (bracket_width + bracket_offset)*y, 0])
                    plug_bracket(tolerances[x]);
            }
        }
    }
}

// Plug bracket
module plug_bracket(tolerance = default_tolerance) {
    translate([-bracket_length/2, -bracket_width/2, 0]) difference() {
        plug_body(bracket_length, bracket_width, tolerance);
        translate([wall, wall, ex]) 
            plug_body(plug_body_length, plug_body_width, tolerance);
    }
}

// EU plug body
module plug_body(length = plug_body_length, width = plug_body_width, tolerance = default_tolerance) {
    length = length + 2*tolerance;
    width = width + 2*tolerance;
    height = plug_body_height + plug_length;
    difference() {
        cube([length, width, height]);
        translate([0, width/2, -ex]) rotate(45) 
            cube([width, width, height + 2*ex]);
        translate([0, width/2, -ex]) rotate(225) 
            cube([width, width, height + 2*ex]);
        translate([length, width/2, -ex]) rotate(45) 
            cube([width, width, height + 2*ex]);
        translate([length, width/2, -ex]) rotate(225) 
            cube([width, width, height + 2*ex]);
    }
}
