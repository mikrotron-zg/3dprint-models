/* Different board mounts - the design changes
 * according to parameters defined in board
 * model file in /component/board directory and
 * imported in this file in include statement
 * by Mikrotron d.o.o. 2022
 * see the project root for license
 */
 
// Include board model file:
// This is where you should be using some board definiton,
// uncomment the one you need or make your own using
// /component/board/template.scad
include <../component/board/arduino-uno.scad>;
//include <../component/board/xh-m404.scad>;

// Plate thickness - defalut value is 2.5 mm, increase to make it
// more rigid, or decrease for faster prints
plate_thickness = 2.5;

// Standoff height - depends on the length of bolts you use, take
// into account PCB and maount plate thickness. Default is 6.4 mm,
// which makes 10 mm bolts a perfect fit for most cases
standoff_height = 6.4;

// Metric bolt index, please see /lib/common.scad file for reference.
// Default value is 3, for M3 bolts
bolt_index = 3;

// Margins make mount plate bigger then the board. If you set them
// to zero, it'll be the same size as the board. On the other hand,
// if mount holes are close to the edge (as they tend to be), you
// might need to set margins so that standoffs don't end up sticking
// out of the mount plate. Margins are defined in the following order:
// [top, right, bottom, left]. Defalut value is 2 mm for all margins.
margin = [2, 2, 2, 2];

// Corner radius for mount plate, if set to 0, renders as simple cube
corner_radius = 3;
 
// Entry point:
board_mount();
 
module board_mount() {
    difference() {
        union() {
            mount_plate();
            standoffs();
        }
        nuts_and_bolts();
        name_imprint();
    }
}

// Draws only plate
module mount_plate() {
    x = pcb[0] + margin[1] + margin[3];
    y = pcb[1] + margin[0] + margin[2];
    z = plate_thickness;
    if (corner_radius > 0) {
        rounded_rect(x, y, z, corner_radius);
    } else {
        cube([x, y, z]);
    }
}

// Draws all standoffs
module standoffs() {
    translate([margin[3], margin[2], plate_thickness]) {
        for (i = [0 : len(mount_hole) -1]) {
            translate([mount_hole[i][0], mount_hole[i][1], 0])
                cylinder(d1 = mount_hole[i][2] + 4, // make base a bit bigger
                         d2 = mount_hole[i][2] + 1.5, // make top fit mount hole margin
                         h = standoff_height);
        }
    }
}

// Adds nut traps to the bottom of the plate and bolt holes for standoffs
module nuts_and_bolts(nut_height = 2) {
    translate([margin[3], margin[2], -ex]) {
        for (i = [0 : len(mount_hole) -1]) {
            translate([mount_hole[i][0], mount_hole[i][1], 0]) {
                cylinder(d = nut2dia(bolt_index), h = nut_height, $fn = 6);
                cylinder(d = bolt2dia(bolt_index), 
                         h = plate_thickness + standoff_height + 2*ex);
            }
        }
    }
}

// Imprints board name on the top of the plate
module name_imprint(text_depth = 0.4) {
    if (board_name != "") {
        translate([(pcb[0] + margin[1] + margin[3])/2,
                   (pcb[1] + margin[0] + margin[2])/2,
                    plate_thickness - text_depth])
            linear_extrude(text_depth + ex)
            text(board_name, font = "Liberation Sans:style=Bold",
                 size = 5, valign = "center", halign = "center");
    }
}