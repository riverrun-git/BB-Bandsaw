#include <BOSL2/std.scad>

outer_dust_holes = false;
inner_dust_holes = false;
wide_centre_slit = false;
hole_diameter = 79.5;
screw_hole_distance = 66.52 - 6.71;
screw_hole_diameter = 8.75;
dust_hole_diameter = 8.75;
inner_dust_hole_distance = 16.5;
screw_head_diameter = 16.5; // 14.32;
screw_head_depth = 5.48;
thickness = 5.88;
bottom_chamfer = 1;
slit_length = 50;
slit_width = 1;
slit_centre_width = 3;

module __Customizer_End__()
{
}

$fn = 100;
SMIDGEN = 0.001;
slit_centre_length = (slit_length - hole_diameter / 2) * 2;

module disc()
{
    cyl(d = hole_diameter, h = thickness, chamfer2 = bottom_chamfer, anchor = BOTTOM);
}

module screw_cutter()
{
    bottom_height = thickness - screw_head_depth + SMIDGEN;
    down(SMIDGEN / 2) union()
    {
        cyl(d1 = screw_head_diameter, d2 = screw_hole_diameter, h = screw_head_depth, anchor = BOTTOM);
        up(screw_head_depth) cyl(d = screw_hole_diameter, h = bottom_height, anchor = BOTTOM);
    }
}

module screw_holes()
{
    for (x = [-1:2:1])
        translate([ x * screw_hole_distance / 2, 0, 0 ]) screw_cutter();
}

module dust_hole_cutter()
{
    down(SMIDGEN / 2) cyl(d = dust_hole_diameter, h = thickness + SMIDGEN, anchor = BOTTOM);
}

module outer_dust_holes()
{
    if (outer_dust_holes)
    {
        for (angle = [-60:30:240])
        {
            rotate([ 0, 0, angle ]) translate([ screw_hole_distance / 2, 0, 0 ]) dust_hole_cutter();
        }
    }
}

module inner_dust_holes()
{
    if (inner_dust_holes)
    {
        for (angle = [-60:60:240])
        {
            rotate([ 0, 0, angle ]) translate([ inner_dust_hole_distance, 0, 0 ]) dust_hole_cutter();
        }
    }
}

module slit()
{
    translate([ 0, -hole_diameter / 2 + SMIDGEN, 0 ])
    {
        cuboid([ slit_width, slit_length, thickness * 2 ], anchor = FRONT);
    }
    if (wide_centre_slit)
    {
        translate([ 0, -slit_centre_length / 2, 0 ])
            cuboid([ slit_centre_width, slit_centre_length, thickness * 2 ], anchor = FRONT);
    }
}

module stl()
{
    difference()
    {
        disc();
        screw_holes();
        inner_dust_holes();
        outer_dust_holes();
        slit();
    }
}

stl();