/*
 * Simple USB cable organizer
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
compartment_length = 35;
compartment_widths = [10, 15, 20, 30];
compartment_height = 100;
compartments_in_row = 5;

// Entry point
usb_cable_organizer();

// Main module
module usb_cable_organizer() {
    // Define outer dimensions
    length = compartment_length*compartments_in_row + wall*(compartments_in_row + 1);
    width = vectorSum(compartment_widths) + wall*(len(compartment_widths) + 1);
    height = compartment_height + wall;
    corner_radius = 3;
    
    // Draw outer shell
    difference() {
        rounded_rect(length, width, height, corner_radius);
        translate([wall, wall, wall]) 
            rounded_rect(length - 2*wall, width - 2*wall, height, corner_radius - wall);
    }
    
    // Draw compartments
    for(x = [1 : compartments_in_row - 1]) {
        translate([x*compartment_length + x*wall, 0, wall])
            cube([wall, width, height - wall]);
    }
    for(y = [len(compartment_widths) - 1 : -1 : 0]) {
        translate([0, vectorSum(compartment_widths, y) + (len(compartment_widths) - y)*wall, wall])
            cube([length, wall, height - wall]);
    }
    
}

