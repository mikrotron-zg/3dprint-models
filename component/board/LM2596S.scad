/* Name: LM2596S step down module
 * Manufacturer: unknown
 * Purchase link: https://www.diykits.eu/products/p_11904
 * Dimensions from: actual measurement
 * Note: 
 * by Mikrotron d.o.o.
 * see the project root for license
 */

// We need this include for every board, just leave it as it is
include <../../lib/common.scad>;

// Short name (up to 10 charachters) to imprint on the mount
// plate. If you don't want/need this, leave the string empty
board_name = "LM2596S";

// PCB dimensions [x, y, z, corner radius] - if there is no
// corner radius, set it to 0
pcb = [43.1, 20.9, 1.6, 0];

// Mount holes [x, y, diameter] - as many times as there are
// mount holes on board. Example has four (on the corners),
// but you may add or substract as many as you need. You can
// use only numbers for coordinates, or you can use PCB
// dimensions to make it easier (in the example below there
// is a mix of both.
mount_hole = [ [pcb[0] - 6.6, 2.7, 3.2], 
               [6.6, pcb[1] - 2.7, 3.2] ];

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