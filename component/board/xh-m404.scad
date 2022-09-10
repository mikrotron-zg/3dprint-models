/* Name: XH-M404 step down module board
 * Manufacturer: unknown
 * Purchase link: https://www.diykits.eu/products/power/p_11883
 * Dimensions from: actual measurement (or link to specs)
 * Note: none
 * by Mikrotron d.o.o. 2022
 * see the project root for license
 */

include <../../lib/common.scad>;

// Short name (up to 10 charachters) to imprint on the mount
// plate. If you don't want/need this, leave the string empty
board_name = "XH-M404";

// PCB dimensions [x, y, z, corner radius]
pcb = [64.25, 47, 1.6, 0];

// Mount holes [x, y, diameter]
mount_hole = [ [3.1, 3.1, 3], 
               [pcb[0] - 3.1, 3.1, 3], 
               [pcb[0] - 3.1, pcb[1] - 3.1, 3],
               [3.1, pcb[1] - 3.1, 3] ];

// Metric bolt index, please see /lib/common.scad file for reference.
// Default value is 3, for M3 bolts
bolt_index = 3;

// Bolt length, default is 10 mm
bolt_length = 10;
               
// Set variable to true to show board mockup
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