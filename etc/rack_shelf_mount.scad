/*
 * This is simple rack shelf mount
 * developed by Mikrotron d.o.o. (http://mikrotron.hr).
 * It contains LED board mockups used for this project.
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
 
// Screw dimensions
screw_dia = 3.5;
screw_height = 20;
screw_head_dia = 6.7;
screw_head_height = 3;

// Mount dimensions
mount_length = 30;
mount_width_top = 10;
mount_width_side = 15;
mount_wall = 2.5;

//screw_model();
rack_shelf_mount();

module rack_shelf_mount() {
    screw_position = mount_width_side*0.4;
    difference() {
        union() {
            rack_shelf_mount_top();
            translate([0, mount_width_top - mount_wall, mount_wall]) rack_shelf_mount_side();
        }
        translate([mount_length/2, mount_width_top - screw_head_height, screw_position]) rotate([-90, 0, 0])
            screw_model();
        // We need a tunnel for screw head
        translate([mount_length/2, 0, screw_position]) rotate([-90, 0, 0])
            cylinder(d = screw_head_dia, h = mount_width_top - screw_head_height + ex);
    }
}

module rack_shelf_mount_side() {
    radius = 3;
    cut_radius = 6;
    translate([0, mount_wall, -radius]) rotate([90, 0, 0]) difference() {
        union() {
            rounded_rect(mount_length, mount_width_side - mount_wall + radius, mount_wall, radius);
            translate([0, 0, mount_wall])
                cube([mount_length, (mount_width_side - mount_wall + radius)/2, mount_width_top/2]);
        }
        translate([-ex, -ex, -ex]) 
            cube([mount_length + 2*ex, radius + ex, mount_wall + mount_width_top/2 + 2*ex]);
        translate([-ex, 1.4*cut_radius, cut_radius + mount_wall]) rotate([0, 90, 0])
            cylinder(d = 2*cut_radius, h = mount_length + 2*ex);
    }
}

module rack_shelf_mount_top() {
    radius = 2;
    difference() {
        rounded_rect(mount_length, mount_width_top + radius, mount_wall, radius);
        translate([-ex, mount_width_top, -ex]) 
            cube([mount_length + 2*ex, radius + ex, mount_wall + 2*ex]);
    }
}

// Draws screw mockup, adds tolerances for holes
module screw_model(tolerance = 0.2) {
    screw_head_dia = screw_head_dia + tolerance;
    screw_dia = screw_dia + tolerance;
    tip_height = 5;
    cylinder(d1 = screw_head_dia, d2 = screw_dia, h = screw_head_height);
    translate([0, 0, screw_head_height])
        cylinder(d = screw_dia, h = screw_height - screw_head_height - tip_height);
    translate([0, 0, screw_height - tip_height])
        cylinder(d1 = screw_dia, d2 = 0, h = tip_height);
}