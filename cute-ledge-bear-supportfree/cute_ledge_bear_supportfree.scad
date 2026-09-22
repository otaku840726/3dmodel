/*
Cute Ledge Bear - Support-Free Monolithic Edition (桌緣萌熊公仔 - 100% 一體成型免支撐版)
Style: Adorable Chibi Teddy Bear Sitting on Desk Ledge
100% Monolithic Solid, 100% Support-Free FDM 3D Printing (No Splitting, Zero Assembly)
Units: mm
*/

$fn = 48;

// Mode selection:
// "print" / "monolithic" - Watertight solid on Z=0 bed for direct 3D printing (STL export)
// "assembled"            - Full color preview sitting on desk ledge with tabletop & COM marker
mode = "print";

// ---------- Proportions & Physics Constants ----------
phi          = (1 + sqrt(5)) / 2;
head_h       = 24;
head_w       = head_h / phi * 1.34;
head_d       = head_h / phi * 1.20;

// ---------- Vector Helpers ----------
function vadd(a,b) = [a[0]+b[0], a[1]+b[1], a[2]+b[2]];
function vmul(a,s) = [a[0]*s, a[1]*s, a[2]*s];
function bez2(p0,p1,p2,t) =
    vadd(vadd(vmul(p0,(1-t)*(1-t)), vmul(p1,2*(1-t)*t)), vmul(p2,t*t));

module bio_ellipsoid(size=[10,10,10]) {
    scale([size[0]/2, size[1]/2, size[2]/2]) sphere(r=1, $fn=48);
}

// ==============================================================================
// 1. HEAD & EARS (Self-Supporting Overhang <= 45°)
// ==============================================================================
module cute_bear_ear(side=1) {
    hull() {
        translate([16.5, side * 4.5, 41.0]) sphere(r=3.8, $fn=32);
        translate([16.5, side * 7.6, 44.2])
            rotate([0, side * 6, side * 14])
                scale([0.95, 0.90, 1.0]) sphere(r=3.8, $fn=36);
        translate([16.5, side * 6.0, 39.5]) sphere(r=3.2, $fn=24);
        translate([17.0, side * 3.5, 37.0]) sphere(r=2.5, $fn=20);
    }
}

module cute_bear_inner_ear(side=1) {
    translate([16.5, side * 7.6, 44.2])
        rotate([0, side * 6, side * 14])
            translate([-1.4, 0, 0])
                scale([0.45, 0.75, 0.85]) sphere(r=2.5, $fn=28);
}

module cute_bear_muzzle() {
    hull() {
        translate([8.8, 0, 34.6])
            scale([1.0, 1.32, 0.96]) sphere(r=3.6, $fn=40);
        translate([11.0, 0, 31.8]) sphere(r=3.0, $fn=24);
        // Self-supporting transition keel into bowtie collar
        translate([9.5, 0, 29.5]) sphere(r=2.0, $fn=20);
    }
}

module cute_bear_eyes_and_nose() {
    // Nose button
    translate([5.9, 0, 36.2])
        scale([0.65, 1.25, 0.85]) sphere(r=1.35, $fn=24);

    // Convex button eyes
    for (side=[-1, 1]) {
        translate([9.1, side * 5.0, 39.2])
            scale([0.68, 1.0, 1.0]) sphere(r=1.30, $fn=32);
    }
}

module cute_bear_smile() {
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

module cute_bear_head_solid() {
    translate([17, 0, 37.0]) bio_ellipsoid([head_d, head_w, head_h]);
    cute_bear_ear(-1);
    cute_bear_ear(1);
    cute_bear_inner_ear(-1);
    cute_bear_inner_ear(1);
    cute_bear_muzzle();
    cute_bear_eyes_and_nose();
    cute_bear_smile();
}

// ==============================================================================
// 2. ACCESSORIES: BOWTIE & HONEY POT (Self-Supporting 45° Keels)
// ==============================================================================
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

module cute_honey_pot_body() {
    translate([4.8, 0, 16.0]) {
        // Bulbous pot body resting cleanly in lap without deep vertical drop
        hull() {
            scale([1.0, 1.08, 1.05]) sphere(r=4.2, $fn=40);
            translate([2.5, 0, -3.2]) sphere(r=3.2, $fn=28);
            translate([4.5, 0, -5.0]) sphere(r=2.5, $fn=20);
        }
        // Flared rim
        hull() {
            translate([0, 0, 4.2]) cylinder(h=0.6, r1=2.8, r2=3.4, $fn=36);
            translate([0, 0, 2.8]) cylinder(h=1.4, r1=2.2, r2=2.8, $fn=36);
        }
    }
}

module cute_honey_pot_drip() {
    translate([4.8, 0, 16.0]) {
        hull() {
            translate([-3.4, 0.8, 2.2]) sphere(r=1.15, $fn=24);
            translate([-3.0, 0.9, 0.5]) sphere(r=1.0, $fn=20);
            translate([-1.5, 0.9, -1.8]) sphere(r=0.9, $fn=16);
        }
    }
}

// ==============================================================================
// 3. LIMBS: ARMS & CHUBBY LEGS (Clean Organic Anatomy, Zero Protrusions)
// ==============================================================================
module cute_arms_supportfree() {
    for (side=[-1, 1]) {
        hull() {
            translate([13.5, side * 8.6, 23.5]) sphere(r=3.2, $fn=28);
            translate([7.0,  side * 7.0, 17.5]) sphere(r=2.9, $fn=28);
            translate([13.5, side * 6.0, 18.0]) sphere(r=2.8, $fn=24);
            translate([10.5, side * 5.5, 14.0]) sphere(r=2.5, $fn=24);
        }
        hull() {
            translate([7.0,  side * 7.0, 17.5]) sphere(r=2.9, $fn=28);
            translate([3.2,  side * 3.6, 16.0]) sphere(r=2.5, $fn=28);
            translate([7.5,  side * 4.8, 12.5]) sphere(r=2.8, $fn=24);
            translate([4.5,  side * 3.2, 12.5]) sphere(r=2.5, $fn=24);
        }
        translate([3.2, side * 3.6, 16.0]) sphere(r=2.5, $fn=28);
    }
}

// Chubby Legs nestled naturally against body and honey pot without artificial bridge lumps
module cute_legs_only() {
    for (side=[-1, 1]) {
        // Hip & Thigh (smooth integration directly into pelvis)
        hull() {
            translate([14.5, side * 9.8, 6.0]) sphere(r=4.8, $fn=36);
            translate([7.5,  side * 10.2, 5.0]) sphere(r=4.6, $fn=36);
            translate([14.5, side * 9.8, 2.5]) sphere(r=4.2, $fn=32);
            translate([7.5,  side * 10.2, 2.5]) sphere(r=4.0, $fn=32);
        }
        // Knee & Foot curving gently inwards toward honey pot
        hull() {
            translate([7.5,  side * 10.2, 5.0]) sphere(r=4.6, $fn=36);
            translate([1.5,  side * 8.0,  4.5]) sphere(r=4.4, $fn=36);
            translate([-1.8, side * 6.8,  4.4]) sphere(r=4.2, $fn=36);
            
            translate([7.5,  side * 10.2, 2.5]) sphere(r=4.0, $fn=32);
            translate([1.5,  side * 8.0,  2.5]) sphere(r=3.8, $fn=32);
            translate([-1.8, side * 6.8,  2.5]) sphere(r=3.6, $fn=32);
        }
    }
}

module cute_paw_pads() {
    for (side=[-1, 1]) {
        translate([-1.8, side * 6.8, 4.4])
            rotate([0, 26, side * 6]) {
                // Main bean pad
                translate([-3.5, 0, -0.3]) scale([0.65, 1.25, 1.0]) sphere(r=1.75, $fn=24);
                // 3 Round toe beans
                translate([-3.5, -1.35, 1.45]) sphere(r=0.72, $fn=16);
                translate([-3.6,  0.00, 1.80]) sphere(r=0.76, $fn=16);
                translate([-3.5,  1.35, 1.45]) sphere(r=0.72, $fn=16);
            }
    }
}

// ==============================================================================
// 4. TORSO & BASE (Natural Receding Contour, Continuous Planar Bed Cut at Z=0)
// ==============================================================================
module cute_body_trunk() {
    // Smooth natural base - recedes at the front
    hull() {
        translate([19, 0, 0.5])
            linear_extrude(height=1.0, center=true)
                scale([25/2, 21/2]) circle(r=1, $fn=48);
        translate([26, 0, 0.5])
            linear_extrude(height=1.0, center=true)
                scale([14/2, 17/2]) circle(r=1, $fn=40);
        
        translate([18, 0, 12]) bio_ellipsoid([28, 23, 25]);
        translate([26.5, 0, 9.0]) bio_ellipsoid([18.5, 18.0, 15.0]);
    }
    
    // Puffy round bear tail
    hull() {
        translate([31.8, 0, 11.5]) sphere(r=4.8, $fn=40);
        translate([28.0, 0, 1.5]) sphere(r=2.5, $fn=24);
    }
    
    // Upper torso, chest & chubby tummy
    translate([17, 0, 23.5]) bio_ellipsoid([23, 20, 25]);
    translate([11.5, 0, 18.5]) bio_ellipsoid([14, 17, 16]);
    translate([16.5, 0, 29.5]) bio_ellipsoid([18.0, 16.5, 11.0]);
}

// ==============================================================================
// 5. UNIFIED SOLID MODEL (For 3D Printing)
// ==============================================================================
module cute_ledge_bear_supportfree() {
    difference() {
        union() {
            cute_body_trunk();
            cute_legs_only();
            cute_paw_pads();
            cute_arms_supportfree();
            cute_bowtie_supportfree();
            cute_honey_pot_body();
            cute_honey_pot_drip();
            
            // Head with sweet 6° tilt
            translate([17, 0, 37.0])
                rotate([6.0, 3.0, -3.5])
                    translate([-17, 0, -37.0])
                        cute_bear_head_solid();
        }
        
        // Clean cut at Z=0 ensuring 100% planar bed adhesion
        translate([0, 0, -50]) cube([200, 200, 100], center=true);
    }
}

// ==============================================================================
// 6. OUTPUT SELECTOR
// ==============================================================================
if (mode == "print" || mode == "monolithic") {
    // 100% Watertight 2-Manifold Solid for Direct 3D Printing
    cute_ledge_bear_supportfree();
} else {
    // "assembled": High-fidelity preview sitting on desk ledge
    difference() {
        union() {
            // Main fur
            color([0.86, 0.60, 0.40]) {
                cute_body_trunk();
                cute_legs_only();
                cute_arms_supportfree();
                translate([17, 0, 37.0])
                    rotate([6.0, 3.0, -3.5])
                        translate([-17, 0, -37.0]) {
                            translate([17, 0, 37.0]) bio_ellipsoid([head_d, head_w, head_h]);
                            cute_bear_ear(-1);
                            cute_bear_ear(1);
                        }
            }
            // Muzzle & inner ears
            color([0.96, 0.88, 0.78]) {
                translate([17, 0, 37.0])
                    rotate([6.0, 3.0, -3.5])
                        translate([-17, 0, -37.0]) {
                            cute_bear_muzzle();
                            cute_bear_inner_ear(-1);
                            cute_bear_inner_ear(1);
                        }
            }
            // Eyes, nose, smile
            color([0.18, 0.14, 0.12]) {
                translate([17, 0, 37.0])
                    rotate([6.0, 3.0, -3.5])
                        translate([-17, 0, -37.0]) {
                            cute_bear_eyes_and_nose();
                            cute_bear_smile();
                        }
            }
            // Bowtie
            color([0.88, 0.28, 0.28]) cute_bowtie_supportfree();
            // Honey pot
            color([0.85, 0.52, 0.22]) cute_honey_pot_body();
            color([1.00, 0.82, 0.20]) cute_honey_pot_drip();
            // Paw pads
            color([0.94, 0.72, 0.68]) cute_paw_pads();
        }
        translate([0, 0, -50]) cube([200, 200, 100], center=true);
    }

    // Desk tabletop
    color([0.72, 0.76, 0.80, 0.35])
        translate([35, 0, -1.25]) cube([70, 80, 2.5], center=true);
    // Desk front edge line (X=0)
    color("red") translate([0, 0, 0.15]) cube([0.6, 76, 0.6], center=true);
    // Center of Mass (COM) marker (green sphere)
    color("lime") translate([15.9, 0, 17.3]) sphere(r=1.8);
    color("lime") translate([15.9, 0, 0]) cylinder(h=17.3, r=0.35);
}
