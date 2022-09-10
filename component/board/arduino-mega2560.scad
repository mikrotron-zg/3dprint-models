/* Name: Arduino MEGA2560
 * Manufacturer: Arduino
 * Purchase link: https://store.arduino.cc/products/arduino-mega-2560-rev3
 * Dimensions from: https://www.wayneandlayne.com/files/common/arduino_mega_drawing.svg
 * Note: original Arduino MEGA2560 board, clones might differ in dimensions
 * by Mikrotron
 * see the project root for license
 */

// We need this include for every board, just leave it as it is
include <../../lib/common.scad>;

// Short name (up to 10 charachters) to imprint on the mount
// plate. If you don't want/need this, leave the string empty
board_name = "MEGA2560";

// PCB dimensions [x, y, z, corner radius] - if there is no
// corner radius, set it to 0
pcb = [101.6, 53.35, 1.6, 0];

// Mount holes [x, y, diameter] - as many times as there are
// mount holes on board. Example has four (on the corners),
// but you may add or substract as many as you need. You can
// use only numbers for coordinates, or you can use PCB
// dimensions to make it easier (in the example below there
// is a mix of both.
mount_hole = [ [13.97, 2.54, 3.175], 
               [66.05, 7.62, 3.175], 
               [96.52, 2.54, 3.175],
               [90.17, 50.80, 3.175],
               [66.05, 35.55, 3.175],
               [15.24, 50.80, 3.175] ];

// Metric bolt index, please see /lib/common.scad file for reference.
// Default value is 3, for M3 bolts
bolt_index = 3;

// Bolt length, default is 10 mm
bolt_length = 10;
               
// Set variable to true to show board mockup, but set it
// back to 'false' once you're done or it'll show up in the
// file that is including this one
show_mockup = false;
if (show_mockup) %board();

// Draw board. You can add any components you like, but only
// template elements are required
module board() {
    difference() {
        if (pcb[3] > 0) {
            rounded_rect(pcb[0], pcb[1], pcb[2], pcb[3]);
        } else {
            cube([pcb.x, pcb.y, pcb.z]);
        }
        for (i = [0 : len(mount_hole) - 1]) {
            translate([mount_hole[i][0], mount_hole[i][1], -ex])
                cylinder(d = mount_hole[i][2], h = pcb[2] + 2*ex);
        }
    }
}