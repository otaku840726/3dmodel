/*
Sitting on a Ledge Figurine - Support-Free Cute Chibi Bear
Style: Smooth Organic Cute Figurine with 100% Support-Free FDM Printing Architecture
Units: mm
*/

$fn = 48;

// ---------- Mode Selection ----------
// "assembled"   - Full assembled preview sitting on desk ledge
// "plate"       - Complete 1-plate 0-support print layout (body + both legs on Z=0 bed)
// "body"        - Body only sitting flat on print bed (100% support-free)
// "legs"        - Both legs laid flat on bed (100% support-free)
// "monolithic"  - 1-piece assembled bear (for users preferring single-piece)
mode = "assembled";

// ---------- Proportions & Physics Constants ----------
phi              = (1 + sqrt(5)) / 2; // Golden ratio 1.618
head_h           = 24;
head_w           = head_h / phi * 1.34; // ~19.8 mm
head_d           = head_h / phi * 1.20; // ~17.8 mm
body_h           = head_h * 0.78;

ledge_x          = 0;

// Joint parameters (Pointed Arch Mortise & Tenon)
socket_depth = 8.0;
socket_w     = 5.0;
socket_h     = 5.6;
tol          = 0.22; // 0.22mm FDM push-fit clearance for firm, snug friction fit

// ---------- Math & Bezier Helpers ----------
function vadd(a,b) = [a[0]+b[0], a[1]+b[1], a[2]+b[2]];
function vmul(a,s) = [a[0]*s, a[1]*s, a[2]*s];
function bez2(p0,p1,p2,t) =
    vadd(vadd(vmul(p0,(1-t)*(1-t)), vmul(p1,2*(1-t)*t)), vmul(p2,t*t));

// ---------- Smooth Primitives ----------
module bio_ellipsoid(size=[10,10,10]) {
    scale([size[0]/2, size[1]/2, size[2]/2]) sphere(r=1, $fn=48);
}

module ball(p=[0,0,0], r=2) {
    translate(p) sphere(r=r, $fn=32);
}

module tapered_segment(p0, p1, r0, r1) {
    hull() {
        ball(p0, r0);
        ball(p1, r1);
    }
}

module bezier_limb(p0, p1, p2, r0=3.5, r1=2.7, steps=8) {
    for (i=[0:steps-1]) {
        t0 = i / steps;
        t1 = (i + 1) / steps;
        tapered_segment(
            bez2(p0, p1, p2, t0),
            bez2(p0, p1, p2, t1),
            r0 + (r1 - r0) * t0,
            r0 + (r1 - r0) * t1
        );
    }
}

// Pointed arch profile for 100% support-free horizontal printing
module arch_profile(w, h, r_roof=0.8) {
    hull() {
        translate([-w/2, 0]) square([w, h*0.55]);
        translate([0, h*0.95]) circle(r=r_roof, $fn=16);
    }
}

// ---------- 1. Self-Supporting Teddy Bear Ears ----------
module cute_bear_ear(side=1) {
    hull() {
        translate([16.5, side * 4.5, 41.0]) sphere(r=3.8, $fn=32);
        translate([16.5, side * 7.6, 44.2])
            rotate([0, side * 6, side * 14])
                scale([0.95, 0.90, 1.0]) sphere(r=3.8, $fn=36);
        // Self-supporting gusset into cranium (angle > 45°)
        translate([16.5, side * 6.0, 39.5]) sphere(r=3.2, $fn=24);
    }
    // Soft inner ear relief pad
    translate([16.5, side * 7.6, 44.2])
        rotate([0, side * 6, side * 14])
            translate([-1.4, 0, 0])
                scale([0.45, 0.75, 0.85]) sphere(r=2.5, $fn=28);
}

// ---------- 2. Self-Supporting Muzzle, Nose & Eyes ----------
module cute_bear_face() {
    // Chubby muzzle with 45° transition into chin
    hull() {
        translate([8.8, 0, 34.6])
            scale([1.0, 1.32, 0.96]) sphere(r=3.6, $fn=40);
        translate([11.0, 0, 31.8]) sphere(r=3.0, $fn=24);
    }

    // Button nose
    translate([5.9, 0, 36.2])
        scale([0.65, 1.25, 0.85]) sphere(r=1.35, $fn=24);

    // Convex glossy button eyes (non-recessed, smooth domes)
    for (side=[-1, 1]) {
        translate([9.1, side * 5.0, 39.2])
            scale([0.68, 1.0, 1.0]) sphere(r=1.30, $fn=32);
    }

    // Smooth embossed smiling mouth (non-recessed)
    smile_r = 0.38;
    hull() {
        translate([5.50, 0, 35.6]) sphere(r=smile_r, $fn=16);
        translate([5.42, 0, 34.0]) sphere(r=smile_r, $fn=16);
    }
    steps = 8;
    for (side=[-1, 1]) {
        p0 = [5.42, 0, 34.0];
        p1 = [5.60, side * 1.6, 33.7];
        p2 = [6.55, side * 3.4, 35.1];
        for (i=[0:steps-1]) {
            t0 = i / steps;
            t1 = (i + 1) / steps;
            hull() {
                translate(bez2(p0, p1, p2, t0)) sphere(r=smile_r - 0.02 * t0, $fn=16);
                translate(bez2(p0, p1, p2, t1)) sphere(r=smile_r - 0.02 * t1, $fn=16);
            }
        }
    }
}

module cute_bear_head() {
    translate([17, 0, 37.0]) bio_ellipsoid([head_d, head_w, head_h]);
    cute_bear_ear(-1);
    cute_bear_ear(1);
    cute_bear_face();
}

// ---------- 3. 100% Self-Supporting Bowtie (45° Support Shelf) ----------
module cute_bowtie_supportfree() {
    translate([6.4, 0, 28.5]) {
        hull() {
            scale([0.85, 1.0, 1.0]) sphere(r=1.4, $fn=24);
            translate([2.2, 0, 0]) sphere(r=1.2, $fn=16);
            translate([3.5, 0, -4.5]) sphere(r=1.4, $fn=16);
            translate([2.0, 0, 3.2]) sphere(r=1.3, $fn=16);
        }
        for (side=[-1, 1]) {
            hull() {
                translate([0.1, 0, 0]) sphere(r=0.75, $fn=16);
                translate([0.15, side * 3.5,  1.6]) sphere(r=1.05, $fn=20);
                translate([0.15, side * 3.5, -0.4]) sphere(r=1.05, $fn=20);
                translate([3.5, side * 2.8, -4.5]) sphere(r=1.2, $fn=16);
                translate([1.5, side * 2.5,  2.8]) sphere(r=1.0, $fn=16);
            }
        }
    }
}

// ---------- 4. 100% Self-Supporting Honey Pot ----------
module cute_honey_pot_supportfree() {
    translate([5.0, 0, 18.0]) {
        hull() {
            scale([1.0, 1.08, 1.05]) sphere(r=4.2, $fn=40);
            translate([3.8, 0, -5.5]) sphere(r=3.2, $fn=24);
            translate([5.5, 0, -8.0]) sphere(r=2.5, $fn=20);
        }
        hull() {
            translate([0, 0, 4.2]) cylinder(h=0.6, r1=2.8, r2=3.4, $fn=36);
            translate([0, 0, 2.8]) cylinder(h=1.4, r1=2.2, r2=2.8, $fn=36);
        }
        hull() {
            translate([-3.4, 0.8, 2.2]) sphere(r=1.15, $fn=24);
            translate([-3.0, 0.9, 0.5]) sphere(r=1.0, $fn=20);
            translate([-1.5, 0.9, -1.8]) sphere(r=0.9, $fn=16);
        }
    }
}

// ---------- 5. 100% Self-Supporting Arms ----------
module cute_arms_supportfree() {
    for (side=[-1, 1]) {
        hull() {
            translate([13.5, side * 8.6, 24.5]) sphere(r=3.2, $fn=28);
            translate([7.5,  side * 7.0, 19.8]) sphere(r=2.9, $fn=28);
            translate([13.5, side * 6.0, 20.0]) sphere(r=2.8, $fn=24);
            translate([10.5, side * 5.5, 15.5]) sphere(r=2.5, $fn=24);
        }
        hull() {
            translate([7.5,  side * 7.0, 19.8]) sphere(r=2.9, $fn=28);
            translate([4.0,  side * 3.8, 18.0]) sphere(r=2.5, $fn=28);
            translate([8.5,  side * 5.0, 14.0]) sphere(r=2.8, $fn=24);
            translate([5.5,  side * 3.5, 14.0]) sphere(r=2.5, $fn=24);
        }
        translate([4.0, side * 3.8, 18.0]) sphere(r=2.5, $fn=28);
    }
}

// ==============================================================================
// PART 1: BODY (Flat-cut at Z=0, Self-Supporting Hulled Base)
// ==============================================================================
module bear_body_supportfree() {
    difference() {
        union() {
            // Self-supporting hulled base (0 to 12 mm)
            hull() {
                // Wide flat bed contact footprint
                translate([18, 0, 0.5])
                    linear_extrude(height=1.0, center=true)
                        scale([29/2, 23/2]) circle(r=1, $fn=48);
                translate([26, 0, 0.5])
                    linear_extrude(height=1.0, center=true)
                        scale([14/2, 17/2]) circle(r=1, $fn=40);
                
                // Torso core
                translate([18, 0, 12]) bio_ellipsoid([29, 24, 25]);
                // Rear countermass
                translate([26.5, 0, 9.0]) bio_ellipsoid([18.5, 18.0, 15.0]);
            }
            
            // Puffy bear tail
            hull() {
                translate([31.8, 0, 11.5]) sphere(r=4.8, $fn=40);
                translate([28.0, 0, 1.5]) sphere(r=2.5, $fn=24);
            }
            
            // Upper torso & chest
            translate([17, 0, 23.5]) bio_ellipsoid([23, 20, 25]);
            translate([11.5, 0, 19.5]) bio_ellipsoid([13, 16, 16]);
            translate([16.5, 0, 29.5]) bio_ellipsoid([18.0, 16.5, 11.0]);
            cute_bowtie_supportfree();
            cute_honey_pot_supportfree();
            cute_arms_supportfree();
            
            // Head tilted cutely
            translate([17, 0, 37.0])
                rotate([6.0, 3.0, -3.5])
                    translate([-17, 0, -37.0])
                        cute_bear_head();
        }
        
        // Clean cut at Z=0 guaranteeing 100% flat bed adhesion
        translate([0, 0, -50]) cube([200, 200, 100], center=true);
        
        // Self-supporting pointed arch hip sockets (no ceiling overhang)
        for (side=[-1, 1]) {
            translate([8.0, side * 7.5, 8.0])
                rotate([0, 0, side * 90])
                    linear_extrude(height=socket_depth + 1)
                        arch_profile(socket_w, socket_h);
        }
    }
}

// ==============================================================================
// PART 2: MODULAR LEGS (With matching pointed arch tenon peg)
// ==============================================================================
module single_leg(side=-1) {
    union() {
        // Pointed arch tenon peg that plugs into hip socket
        translate([8.0, side * 7.5, 8.0])
            rotate([0, 0, side * 90])
                translate([0, 0, 0.5])
                    linear_extrude(height=socket_depth - 0.5)
                        arch_profile(socket_w - tol*2, socket_h - tol*2);
                        
        // Smooth thick knee & limb
        bezier_limb([8.0, side * 7.5, 8.0], [-1.0, side * 7.5, 1.0], [-8.0, side * 7.2, -13.5], 3.6, 2.8, 8);
        hull() {
            ball([-8.0, side * 7.2, -13.5], 3.0);
            ball([-13.0, side * 7.2, -15.0], 3.7);
        }
        // Paw pads
        translate([-13.0, side * 7.2, -15.0])
            rotate([0, 35, 0]) {
                translate([-3.4, 0, -0.6]) scale([0.62, 1.18, 1.0]) sphere(r=1.65, $fn=24);
                translate([-3.4, -1.35, 1.3]) sphere(r=0.68, $fn=16);
                translate([-3.5,  0.00, 1.65]) sphere(r=0.72, $fn=16);
                translate([-3.4,  1.35, 1.3]) sphere(r=0.68, $fn=16);
            }
    }
}

// Flat-bed printable leg module (laying flat at Z=0 for 100% support-free printing)
module leg_flat_printable(side=-1) {
    difference() {
        translate([0, 0, 3.2])
            rotate([side * 90, 0, 0])
                translate([-8.0, -side * 7.5, -8.0])
                    single_leg(side);
        // Clean cut at Z=0
        translate([0, 0, -25]) cube([100, 100, 50], center=true);
    }
}

// ==============================================================================
// Output Selector based on 'mode'
// ==============================================================================
if (mode == "body") {
    bear_body_supportfree();
} else if (mode == "legs") {
    translate([0, -16, 0]) leg_flat_printable(-1);
    translate([0,  16, 0]) leg_flat_printable(1);
} else if (mode == "plate") {
    // 1-Plate Complete 0-Support Print Layout
    bear_body_supportfree();
    translate([18, -26, 0]) leg_flat_printable(-1);
    translate([18,  26, 0]) leg_flat_printable(1);
} else if (mode == "monolithic") {
    // 1-piece assembled bear
    bear_body_supportfree();
    single_leg(-1);
    single_leg(1);
} else {
    // "assembled": Preview sitting on desk ledge
    color([0.86, 0.60, 0.40]) {
        bear_body_supportfree();
        single_leg(-1);
        single_leg(1);
    }
    // Tabletop
    color([0.72, 0.76, 0.80, 0.35])
        translate([35, 0, -1.25]) cube([70, 80, 2.5], center=true);
    // Ledge edge line
    color("red") translate([0, 0, 0.15]) cube([0.6, 76, 0.6], center=true);
    // Center of mass marker
    color("lime") translate([17.6, 0, 19.2]) sphere(r=1.8);
    color("lime") translate([17.6, 0, 0]) cylinder(h=19.2, r=0.35);
}
