
mx_w = 14.25;
mx_h = 14.25;
mx_d = 10;

col_keys_count = 3;
col_keys_spacing_w = 2.5;
col_keys_spacing_h = 2.5;

placement_w = mx_w + col_keys_spacing_w * 2;
placement_h = mx_h + col_keys_spacing_h * 2;
placement_d = 1.5;
placement_padding = 2;

case_d = 12;

_1U = 1.0;
_1_25U = 1.25;

pro_micro_w = 18;
pro_micro_h = 33;

micro_usb_w = 8;
micro_usb_h = 3;

rp2040_zero_w = 18.5;
rp2040_zero_d = 24.5;
rp2040_zero_h = 1.5;

usb_c_w = 10;
usb_c_h = 3;

module switch_cutout() {
    square([mx_w, mx_h]);
}

module over_switch_cutout() {
    translate([-1, -2, 0])
    square([mx_w + 2, mx_h + 4]);
}

module switch_cuts_only(count, col_w) {
    dx0 = placement_padding + (col_w / 2 - (placement_w / 2));
    dy0 = placement_padding;
    
    
    translate([dx0, dy0])
    for (i = [0:1:count - 1]) {
        dy = col_keys_spacing_h + placement_h * i;
        translate([0, dy, 0])
            children();
    }
}

module keys_col(count, size = _1U, extra_pad = 0, offset_delta = 0) {
    col_h = count * placement_h + placement_padding * 2;
    col_w = placement_w * size + placement_padding * 2;

    if (offset_delta > 0) {
        switch_cuts_only(count, col_w) children();
    } else {
        difference() {
            union() {
                square([col_w, col_h]);
                
                // plug the hole
                translate([0, -extra_pad])
                square([col_w, extra_pad]);
            }
            switch_cuts_only(count, col_w) children();
        }
    }
}

module rows(offset_delta = 0) {
    row_offsets = [-2, 0, 5, 2.5 - placement_h, -5];
    col_counts = [3, 3, 3, 4, 3];
    extra_pads = [0, 0, 5, 0, 0];
    rows_count = len(row_offsets);

    for (i = [0:1:rows_count - 1]) {
        dx0 = placement_w * i;
        dy0 = row_offsets[i];
        count = col_counts[i];
        pad = extra_pads[i];
        translate([dx0, dy0, 0])
            keys_col(count, _1U, pad, offset_delta) children();
    }
}

module shift_key(offset_delta = 0) {
    translate([placement_w / 2, -placement_h - placement_padding * 2.5, 0])
    rotate([0, 0, 10])
    keys_col(1, _1_25U, 0, offset_delta) children();
}


module layer_key(offset_delta = 0) {
    translate([placement_w * 1.75, -placement_h - placement_padding * 1.75, 0])
    rotate([0, 0, 5])
    keys_col(1, _1_25U, 0, offset_delta) children();
}

module half(offset_delta = 0) {
    rows(offset_delta) children();
    shift_key(offset_delta) children();
    layer_key(offset_delta) children();
}

module left_plate(offset_delta = 0) {
    mirror([-1, 0, 0])
    half(offset_delta) children();
}

module right_plate(offset_delta = 0) {
    half(offset_delta) children();
}

module cable_hole() {
    union() {
        translate([placement_w / 2 - 2, placement_h * 3 + 10, 6])
        rotate([90, 0, 0])
        cylinder(h = 10, r = 3);
        
        rotate([0, 50, 0])
        translate([placement_w / 2 - 10, placement_h * 3, 10])
        cube([1, 15, 10]);
    }
}

module case_right() {
    
    difference() {
        difference() {
            // base
            linear_extrude(case_d)
            offset(delta = 2.5)
            right_plate();
            
            // cutout
            translate([0, 0, placement_d])
            linear_extrude(case_d)
            offset(delta = 0.75)
            right_plate();
        }
        
        // cable hole
        cable_hole();
    }
}

module plate() {
    cube([rp2040_zero_w, rp2040_zero_d, rp2040_zero_h]);
}

module plate_holder() {
    difference() {
        cube([20, 25, 4]);
        translate([2, -1, -0.5])
        cube([16, 24, 5]);
        translate([0.75, -0.25, 3]) plate();
    }
}

module controller_case() {
    
    c_w = pro_micro_w + placement_padding * 2;
    c_h = pro_micro_h + placement_padding * 4;
    
    difference() {
        // base
        linear_extrude(case_d)
        offset(delta = 2.5)
        square([c_w, c_h]);
        
        // cutout
        translate([0, 0, placement_d])
        linear_extrude(case_d)
        offset(delta = 0.75)
        square([c_w, c_h]);
        
        // usb hole
        translate([c_w / 2 - usb_c_w / 2, c_h, 6])
        cube([usb_c_w, 5, usb_c_h]);
    }
    rotate([0, 0, 180])
    translate([-21, -42, 0])
        plate_holder();
}


module case_left() {
    difference() {
        union() {
            translate([-126, 8, 0])
            controller_case();
            difference() {
                difference() {
                    // base
                    linear_extrude(case_d)
                    offset(delta = 2.5)
                    left_plate();
                    
                    // cutout
                    translate([0, 0, placement_d])
                    linear_extrude(case_d)
                    offset(delta = 0.75)
                    left_plate();
                }
                
                // part cable hole
                mirror([-1, 0, 0])
                cable_hole();

            }
        }
        // controller cable hold
        translate([-105, 12, 5])
        cube([10, 15, 4]);
        
        translate([-105, 15, 5])
        rotate([45, 0, 0,])
        cube([10, 1, 10]);
    }
}

module led_cover(h) {
    difference() {
        cube([23, 41, h], center = true);
        cube([12, 32, h * 2], center = true);
    }
}

module led_top_cover(h) {
    difference() {
        cube([27, 46, h], center = true);
        cube([12, 32, h * 2], center = true);
    }

}

module right_top_cover() {
    difference() {
        linear_extrude(4)
        offset(delta = 5)
        right_plate();
        translate([0, 0, -1])
        linear_extrude(4)
        offset(delta = 3.5)
        right_plate();
        
        translate([0, 0, 1])
        linear_extrude(4)
        right_plate(offset_delta = 1) over_switch_cutout();
    }
}

module right_top_cover_v2(h) {
    difference() {
        linear_extrude(h)
        offset(delta = 2.5)
        right_plate();
        
        translate([0, 0, -1])
        linear_extrude(h + 2)
        right_plate(offset_delta = 1) over_switch_cutout();
    }
}

module left_top_cover_v2(h) {
    union() {
        difference() {
            linear_extrude(h)
            offset(delta = 2.5)
            left_plate();
            
            translate([0, 0, -1])
            linear_extrude(h + 2)
            left_plate(offset_delta = 1) over_switch_cutout();
        }

        translate([-115, 28.5, 0.25])
        led_top_cover(h);
    }
}

// Right case part
//case_right();
//translate([0, 0, 11])
//linear_extrude(1) right_plate() switch_cutout();

//#case_right();
//translate([0, 0, 11])
//#right_plate() switch_cutout();
//translate([0, 0, 13])
//right_top_cover_v2(h = 0.56);


// Left case with controller holder
//case_left();
//translate([0, 0, 11])
linear_extrude(1) left_plate() switch_cutout();
//translate([-115, 29, 11])
//#led_cover(h = 1);
//
//translate([0, 0, 13])
//left_top_cover_v2(h = 0.56);


// Left and right are the same, just mirror then printing, for example:
//linear_extrude(placement_d)
//right_plate() switch_cutout();

