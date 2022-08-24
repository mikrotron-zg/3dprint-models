/* A library of common modules, functions and variables
 * used by other *.scad files in this repository
 * by Mikrotron d.o.o. 2022
 * see the project root for license
 */
 
 /****************************************************************************
  ****************************** Variables ***********************************
  ****************************************************************************/

// Extra dimension to remove wall ambiguity in preview mode, too small to make
// any difference in 3D print, but you can set it to 0 if it bothers you ;-)
ex = 0.001;

// Make rounded objects smoother, if it slows down rendering, decrease the value.
// This is a general case value, it might be overridden for some objects and
// changing this value will have no effect for these objects
$fn = 128;

// Hole dimension correction - if 3D printed holes turn out too small,
// increase the value, or decrease the value if they're too big
// Default value is 0.3 mm
hdc = 0.3;

// Some common nuts and bolts dimensions, first number is bolt diameter
// and the second one is metric nut size (wrench size). To get value for
// specific bolts and nuts use functions bolt_dia() and nut2radius(),
// passing nuts_bolts index as parameter. If you need extra values, do
// not insert them, add them to the end of list or you'll corrupt 
// existing models
nuts_bolts = [ [1.6, 3.2],  // M1.6, index = 0
               [2, 4],      // M2,   index = 1
               [2.5, 5],    // M2.5, index = 2
               [3, 5.5],    // M3,   index = 3
               [4, 7],      // M4,   index = 4
               [5, 8],      // M5,   index = 5
               [6, 10],     // M6,   index = 6
               [8, 13],     // M8,   index = 7
               [10, 16] ];  // M10,  index = 8

m2_dia = 2 + hdc;
m25_dia = 2.5 + hdc;
m3_dia = 3 + hdc;
m4_dia = 4 + hdc;
m5_dia = 5 + hdc;

// Set to true to see some example models, default is false
test = true;
if (test) test_draw();

/****************************************************************************
 ******************************* Modules ************************************
 ****************************************************************************/

// Set test variable to 'true' to see examples
module test_draw() {
    offset = 10;
    for (i = [0 : len(nuts_bolts) - 1]) {
        translate([0, i*nut2dia(i), 0]) difference() {
            cylinder(d = nut2dia(i), h = bolt2dia(i), $fn = 6);
            translate([0, 0, -ex]) cylinder(d = bolt2dia(i), h = bolt2dia(i) + 2*ex);
        }
    }
}

/****************************************************************************
 ****************************** Functions ***********************************
 ****************************************************************************/
  
// Calculates nut diameter for given bolt_nuts index,
// check bolts_nuts list for index reference
function nut2dia(index) = nuts_bolts[index][1]/cos(180/6) + hdc;

// Calculates bolt diameter for given bolt_nuts index,
// check bolts_nuts list for index reference
function bolt2dia(index) = nuts_bolts[index][0] + hdc;