/*
 * This is simple tool holder for Prusa Mini Enclosure
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

mount_hole_dia = 3.3;
mount_holes_dist = 60;
mount_width = 10;
fillet_radius = 2.5;
wall = 1.6;
tool_holder_width = 30;
tool_holder_length = mount_holes_dist + tool_holder_width + mount_width + 2*fillet_radius;
tool_holder_height = 80;


//mount();
prusa_mini_enclosure_tool_holder();

module prusa_mini_enclosure_tool_holder() {
    difference() {
        rounded_rect(tool_holder_length, tool_holder_width, 
                     tool_holder_height, tool_holder_width/2 - ex/2);
        translate([wall, wall, wall])
            rounded_rect(tool_holder_length - 2*wall, tool_holder_width - 2*wall, 
                         tool_holder_height, tool_holder_width/2 - wall - ex/2);
    }
    translate([tool_holder_width/2, wall, tool_holder_height]) rotate([90, 0, 0]) mount();
    translate([tool_holder_length - tool_holder_width/2, 0, tool_holder_height]) rotate([90, 0, 180]) mount();
}

module mount() {
    translate([mount_width/2 + fillet_radius, mount_width/2, 0]) difference() {
        union() {
            cylinder(d = mount_width, h = wall);
            translate([-mount_width/2, -mount_width/2, 0]) {
                cube([mount_width, mount_width/2, wall]);
                rotate(90) fillet(fillet_radius, wall);
            }
            translate([mount_width/2, -mount_width/2, 0]) fillet(fillet_radius, wall);
        }
        translate(zex()) cylinder(d = mount_hole_dia, h = wall + 2*ex);
    }
}

module fillet(radius = 3, height = 1) {
    translate([radius, radius, 0]) rotate(180) difference() {
        cube([radius, radius, height]);
        translate([-ex, -ex, -ex]) cylinder_quarter(radius + ex, height + 2*ex);
    }
}