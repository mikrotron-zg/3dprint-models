/* XL-4015 step-down module with extension for 
 * cable strain relief. Make sure "board_mount"
 * includes the right board from components:
 * "include <../component/board/xl-4015.scad>;"
 * should be uncommented
 */

include <../board_mount.scad>;

margin = [2, 35, 2, 2]; // override the original values in board_mount.scad
cable_dia = 4.8; // USB cable diameter
// Strain relief mount dimensions and position
sr_mount_dim = [5, 15, standoff_height + pcb[2] + cable_dia/2];
sr_mount_pos = [pcb[0] + margin[1] + margin[3] - sr_mount_dim[0],
                     (pcb[1] + margin[0] + margin[2])/2 - sr_mount_dim[1]/2,
                     plate_thickness];

echo ("Mount height: ", sr_mount_dim[2]);

// Entry point
xl4015_extended();

module xl4015_extended() {
    board_mount();
    strain_relief_mount();
    strain_relief_clamp();
}

module strain_relief_mount() {    
    translate(sr_mount_pos) difference() {
        cube(sr_mount_dim);
        cable_hole();
        bolt_holes();
    }
}

module strain_relief_clamp(height = 3.6) {
    translate([sr_mount_pos[0] + sr_mount_dim[0] + 10, sr_mount_pos[1], 0]) difference() {
        cube([sr_mount_dim[0], sr_mount_dim[1], height]);
        cable_hole(height);
        bolt_holes(height);
    }
}

module cable_hole(height = sr_mount_dim[2]) {
    translate([-ex, sr_mount_dim[1]/2, height]) rotate([0, 90, 0])
            cylinder(d = cable_dia, h = sr_mount_dim[0] + 2*ex);
}

module bolt_holes(length = sr_mount_dim[2]) {
    dia = 3; // for M3 bolt
    offset = sr_mount_dim[0]/2;
    translate([offset, offset, -ex]) cylinder(d = dia, h = length +2*ex);
    translate([offset, sr_mount_dim[1] - offset, -ex]) cylinder(d = dia, h = length +2*ex);
}