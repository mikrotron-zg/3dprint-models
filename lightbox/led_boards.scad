/*
 * This file is part of Lightbox project
 * (https://github.com/mikrotron-zg/3dprint-models/tree/main/lightbox)
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
 
// Global variables
mh_dia = 3; // mount hole diameter
 
// Uncomment this to show board mockups
show_boards();
 
module show_boards() {
    board_3x4();
    translate([40, 0, 0]) board_5x4();
}
 
module board_3x4() {
    board = [29.5, 52.5, 0.76]; // board dimensions
    mh_position = [15.0, 50.0, -ex]; // mount hole position
    usb_position = [10.9, 0, 0.76]; // micro USB connector position
    led_matrix_origin = [2, 19, 0.76]; // LED matrix origin point
    led_matrix_size = [3, 4]; // LED matrix dimensions
    draw_board(board, mh_position, usb_position, led_matrix_origin, led_matrix_size);
}
 
module board_5x4() {
    board = [49.5, 52.0, 0.76]; // board dimensions
    mh_position = [24.5, 49.6, -ex]; // mount hole position
    usb_position = [21, 0, 0.76]; // micro USB connector position
    led_matrix_origin = [2, 19, 0.76]; // LED matrix origin point
    led_matrix_size = [5, 4]; // LED matrix dimensions
    draw_board(board, mh_position, usb_position, led_matrix_origin, led_matrix_size);
}
 
module draw_board(board, mh_position, usb_position, led_matrix_origin, led_matrix_size) {
    difference() {
        cube(board);
        translate(mh_position) cylinder(d = mh_dia, h = board[2] + 2*ex);
    }
    translate(usb_position) usb_connector();
    translate(led_matrix_origin) led_matrix(led_matrix_size);
}

module usb_connector() {
    connector = [7.5, 5.3, 2.4]; // micro USB connector dimensions
    color("Gray") cube(connector);
}

module led_matrix(matrix_size) {
    led = [5.8, 3.0, 0.8]; // LED dimensions
    x_spacing = led[0] + 4.0;
    y_spacing = led[1] + 5.0;
    for (x = [0 : matrix_size[0] - 1]) {
        translate([x*x_spacing, 0, 0]) {
            for (y = [0 : matrix_size[1] - 1]) {
                translate([0, y*y_spacing, 0]) color("Yellow") cube(led);
            }
        }
    }
}