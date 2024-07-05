/*
 * This file is part of 3D print models project
 * (https://github.com/mikrotron-zg/3dprint-models)
 * developed by Mikrotron d.o.o. (http://mikrotron.hr).
 * It contains CYD (Cheap Yellow Display) box 3D model.
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

// CYD dimensions
cyd_length = 86;
cyd_width = 50;
cyd_pcb_height = 1.6;
cyd_corner_radius = 4;
cyd_mh_dia = 3.3;
cyd_mh_pos = [ [cyd_corner_radius, cyd_corner_radius], 
               [cyd_length - cyd_corner_radius, cyd_corner_radius],
               [cyd_length - cyd_corner_radius, cyd_width - cyd_corner_radius],
               [cyd_corner_radius, cyd_width - cyd_corner_radius] ];
cyd_display_length = 69;
cyd_display_width = 50;
cyd_display_height = 3.8;
cyd_display_offset = 8;
cyd_view_area_offset = [7, 2, 2, 2];

// Connectors
io_connector = [7, 4.25, 3.6]; // 4-pin connector dimensions
p1_connector_pos = [io_connector[1], 12.3, -io_connector[2]];
cn1_connector_pos = [51 + io_connector[0], cyd_width, -io_connector[2]];
p3_connector_pos = [67 + io_connector[0], cyd_width, -io_connector[2]];
usb_connector = [8, 6, 3];
usb_connector_pos = [usb_connector[1] - 1, 30.5, -usb_connector[2]];
sp_connector = [4.4, 3.4, 4.6];
sp_connector_pos = [25.6, 0, -sp_connector[2]];

// SD card reader
sd_reader = [15, 15, 2];
sd_reader_pos = [30.8 + sd_reader[0], cyd_width, -sd_reader[2]];

// Buttons
button = [3.5, 6, 3.4];

// Box dimensions
box_wall = 2.4;
box_overlap = 5;

/****************************************************************************
 ****************************** Main Modules ********************************
 ****************************************************************************/
cyd_box();
 
module cyd_box() {
    %cyd();
    box_bottom();
}

module box_bottom() {

}


/****************************************************************************
***************** Additional Modules and Functions **************************
*****************************************************************************/

// Draws CYD mockup
module cyd() {
    // PCB
    difference() {
            rounded_rect(cyd_length, cyd_width, cyd_pcb_height, cyd_corner_radius);
        for (i = [0 : len(cyd_mh_pos) - 1]) {
            translate([cyd_mh_pos[i][0], cyd_mh_pos[i][1], -ex])
                cylinder(d = cyd_mh_dia, h = cyd_pcb_height + 2*ex);
        }
    }
    // Display
    translate([cyd_display_offset, 0, cyd_pcb_height]) {
        cube([cyd_display_length, cyd_display_width, cyd_display_height]);
        translate([cyd_view_area_offset[0], cyd_view_area_offset[1], cyd_display_height])
            cube([cyd_display_length - cyd_view_area_offset[0] - cyd_view_area_offset[2],
                  cyd_display_width - cyd_view_area_offset[1] - cyd_view_area_offset[3], ex]);
    }
    // Connectors
    translate(p1_connector_pos) rotate(90) cube(io_connector);
    translate(cn1_connector_pos) rotate(180) cube(io_connector);
    translate(p3_connector_pos) rotate(180) cube(io_connector);
    translate(usb_connector_pos) rotate(90) cube(usb_connector);
    translate(sp_connector_pos) cube(sp_connector);
    translate(sd_reader_pos) rotate(180) cube(sd_reader);
}
