// FCK AFD Cookie Cutter V7 - 70 x 70 mm inner cutting size
// Derived from V6. Two-line mirrored outline lettering and four-beam backing.
// Units: millimeters. Print with the grip-side (z=0) on the build plate.

/* [Cookie dimensions] */
cookie_size = 70;        // maximum inside width/height of cutting outline
corner_radius = 7;       // outside corner radius
wall_thickness = 1.6;    // lower wall thickness
cutting_thickness = 0.8; // wall thickness at the cutting lip
height_total = 15;
lip_height = 2.0;        // height of tapered cutting lip

/* [Grip flange] */
grip_extension = 2.4;   // extra width OUTSIDE the wall on each side
grip_height = 2.0;

/* [Lettering] */
font_size = 18.5;
font_name = "Liberation Sans:style=Bold";
outline_width = 1.2;
line_offset = 11.2;
mirror_letters = true;
imprint_depth = 3;      // difference between cutting lip and lettering tip

/* [Decorative bars] */
bar_width = 49;
bar_thickness = 2.5;
bar_offset = 26.7;

/* [Four-beam support] */
base_thickness = 2.4;
horizontal_width = font_size * 0.5;
vertical_width = 4;
vertical_offset = 23;
base_rim = 3;
letter_support = 0.8;

$fn = 64;
outer_size = cookie_size + 2 * wall_thickness;
wall_start = base_thickness;
cutting_start = height_total - lip_height;
letter_height = height_total - imprint_depth - base_thickness;

module rounded_rect(w,h,r) {
    offset(r=r) square([w-2*r,h-2*r],center=true);
}
module outline_2d(s) {
    difference() {
        offset(delta=outline_width/2)
            text(s,size=font_size,font=font_name,halign="center",valign="center");
        offset(delta=-outline_width/2)
            text(s,size=font_size,font=font_name,halign="center",valign="center");
    }
}
module lettering_2d(s,y) {
    translate([0,y])
        if(mirror_letters) mirror([1,0,0]) outline_2d(s);
        else outline_2d(s);
}
module bars_2d() {
    for(y=[-bar_offset,bar_offset])
        translate([0,y]) square([bar_width,bar_thickness],center=true);
}
module backing_2d() {
    intersection() {
        rounded_rect(outer_size,outer_size,corner_radius+wall_thickness);
        union() {
            difference() {
                rounded_rect(outer_size,outer_size,corner_radius+wall_thickness);
                offset(delta=-base_rim)
                    rounded_rect(outer_size,outer_size,corner_radius+wall_thickness);
            }
            for(y=[-line_offset,line_offset])
                translate([0,y]) square([outer_size,horizontal_width],center=true);
            for(x=[-vertical_offset,vertical_offset])
                translate([x,0]) square([vertical_width,outer_size],center=true);
            offset(delta=letter_support) lettering_2d("FCK",line_offset);
            offset(delta=letter_support) lettering_2d("AFD",-line_offset);
            bars_2d();
        }
    }
}
// Four-beam backing (same design as V6, adjusted to new footprint)
linear_extrude(height=base_thickness) backing_2d();

// Straight wall and tapered cutting edge. Inner cutout is constant:
// its outermost X/Y dimensions are exactly cookie_size (70 mm).
translate([0,0,wall_start])
    linear_extrude(height=cutting_start-wall_start)
        difference() {
            rounded_rect(outer_size,outer_size,corner_radius+wall_thickness);
            rounded_rect(cookie_size,cookie_size,corner_radius);
        }
translate([0,0,cutting_start])
    difference() {
        linear_extrude(height=lip_height,scale=(cookie_size+2*cutting_thickness)/(cookie_size+2*wall_thickness))
            rounded_rect(cookie_size+2*wall_thickness,cookie_size+2*wall_thickness,corner_radius+wall_thickness);
        translate([0,0,-0.01])
            linear_extrude(height=lip_height+0.02)
                rounded_rect(cookie_size,cookie_size,corner_radius);
    }

// Grip flange on the opposite side from the cutting edge.
linear_extrude(height=grip_height)
    difference() {
        rounded_rect(outer_size+2*grip_extension,outer_size+2*grip_extension,corner_radius+wall_thickness+grip_extension);
        rounded_rect(cookie_size,cookie_size,corner_radius);
    }

// Raised stamp details, tips 3 mm below the cutting edge.
translate([0,0,base_thickness])
    linear_extrude(height=letter_height)
        union() {
            lettering_2d("FCK",line_offset);
            lettering_2d("AFD",-line_offset);
            bars_2d();
        }
