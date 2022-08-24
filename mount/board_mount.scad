/* Different board mounts - the design changes
 * according to parameters defined in board
 * model file in component/board directory and
 * imported in this file in include statement
 * by Mikrotron d.o.o. 2022
 * see the project root for license
 */
 
// Includes
include <../lib/common.scad>;
// This is where you should be using some board definiton:
// include <../component/board/template.scad>;
 
// Entry point:
board_mount();
 
module board_mount() {
    // TODO: main module
}