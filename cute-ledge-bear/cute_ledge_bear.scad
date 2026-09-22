/*
Sitting on a Ledge Figurine - Classic Cute Chibi Bear
Style: Smooth, Organic, Normal & Ultra-Cute Chibi Figurine Aesthetic
Watertight 2-Manifold Solid Model (CGAL Volumes: 2, Simple: yes)
Units: mm
*/

$fn = 48;

// ---------- Display flags ----------
show_table       = true;
show_edge_line   = true;
show_com_marker  = false;

// ---------- Proportions & Physics Constants ----------
phi              = (1 + sqrt(5)) / 2; // Golden ratio 1.618
head_h           = 24;
head_w           = head_h / phi * 1.34; // ~19.8 mm
head_d           = head_h / phi * 1.20; // ~17.8 mm
body_h           = head_h * 0.78;

ledge_x          = 0;
com_proxy        = [8.5, 0, 18.0];

// ---------- Math & Bezier Helpers ----------
function vadd(a,b) = [a[0]+b[0], a[1]+b[1], a[2]+b[2]];
function vsub(a,b) = [a[0]-b[0], a[1]-b[1], a[2]-b[2]];
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

// ---------- 1. Adorable Smooth Teddy Bear Ears (100% Solid Fused) ----------
module cute_bear_ear(side=1) {
    // Solid fleshy ear lobe (deeply rooted inside cranium)
    hull() {
        translate([16.5, side * 4.5, 41.0]) sphere(r=3.6, $fn=32);
        translate([16.5, side * 7.6, 44.2])
            rotate([0, side * 6, side * 14])
                scale([0.95, 0.90, 1.0]) sphere(r=3.8, $fn=36);
    }
    // Soft inner ear pad (classic teddy bear / chibi inner ear relief)
    translate([16.5, side * 7.6, 44.2])
        rotate([0, side * 6, side * 14])
            translate([-1.4, 0, 0])
                scale([0.45, 0.75, 0.85])
                    sphere(r=2.5, $fn=28);
}

// ---------- 2. Plump Muzzle, Button Nose & Convex Eyes ----------
module cute_bear_face() {
    // Plump chubby muzzle
    translate([8.8, 0, 34.6])
        scale([1.0, 1.32, 0.96])
            sphere(r=3.6, $fn=40);

    // Cute rounded oval nose button sitting proudly on muzzle
    translate([5.9, 0, 36.2])
        scale([0.65, 1.25, 0.85])
            sphere(r=1.35, $fn=24);

    // Convex glossy button eyes (non-recessed, perfectly rounded domes)
    for (side=[-1, 1]) {
        translate([9.1, side * 5.0, 39.2])
            scale([0.68, 1.0, 1.0])
                sphere(r=1.30, $fn=32);
    }

    // Classic sweet smiling mouth (smooth raised embossed line, non-recessed)
    smile_r = 0.38;
    // Philtrum vertical drop
    hull() {
        translate([5.50, 0, 35.6]) sphere(r=smile_r, $fn=16);
        translate([5.42, 0, 34.0]) sphere(r=smile_r, $fn=16);
    }
    // Bilateral upturned smile arcs
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

// ---------- 3. Dapper Smooth Bowtie ----------
module cute_bowtie() {
    translate([6.4, 0, 28.5]) {
        // Central rounded knot (deeply rooted into chest)
        hull() {
            scale([0.85, 1.0, 1.0]) sphere(r=1.35, $fn=24);
            translate([2.2, 0, 0]) sphere(r=1.1, $fn=16);
        }
        // Left & right rounded butterfly wings
        for (side=[-1, 1]) {
            hull() {
                translate([0.1, 0, 0]) sphere(r=0.75, $fn=16);
                translate([0.15, side * 3.5,  1.6]) sphere(r=1.05, $fn=20);
                translate([0.15, side * 3.5, -1.6]) sphere(r=1.05, $fn=20);
                // Anchor into chest
                translate([2.2, side * 2.5, 0]) sphere(r=0.85, $fn=16);
            }
        }
    }
}

// ---------- 4. Mini Honey Pot with Honey Drip ----------
module cute_honey_pot() {
    translate([4.6, 0, 18.0]) {
        // Bulbous pot body
        scale([1.0, 1.08, 1.15]) sphere(r=4.3, $fn=40);
        
        // Flared rim
        translate([0, 0, 4.4])
            rotate_extrude($fn=36)
                translate([3.2, 0, 0])
                    circle(r=0.62, $fn=20);
                    
        // Organic honey drip running over rim
        translate([-3.4, 0.8, 2.2])
            scale([0.72, 0.85, 1.45])
                sphere(r=1.15, $fn=24);
        translate([-3.0, 0.9, 0.5])
            scale([0.65, 0.75, 1.0])
                sphere(r=1.0, $fn=20);
    }
}

// ---------- 5. Chubby Arms Hugging Honey Pot ----------
module cute_arms() {
    for (side=[-1, 1]) {
        bezier_limb(
            [13.5, side * 8.6, 24.5],
            [7.5,  side * 7.0, 19.8],
            [3.3,  side * 3.8, 18.0],
            3.2, 2.5, 7
        );
        // Rounded paw welded into pot side
        translate([3.3, side * 3.8, 18.0])
            sphere(r=2.4, $fn=28);
    }
}

// ---------- 6. Base, Countermass & Puffy Tail ----------
module flat_seat_contact() {
    translate([17, 0, 1.3])
        minkowski() {
            cube([23, 21, 0.8], center=true);
            sphere(r=1.0, $fn=28);
        }
}

module rear_countermass() {
    translate([26.5, 0, 8.5]) bio_ellipsoid([18.5, 18.0, 15.0]);
}

module puffy_bear_tail() {
    translate([31.8, 0, 11.5]) sphere(r=4.8, $fn=40);
}

// Tactile paw pads on foot soles
module cute_paw_pads(pos=[-13.0, 7.0, -15.0], rot=[0, 35, 0]) {
    translate(pos)
        rotate(rot) {
            // Main palm pad (soft bean shape)
            translate([-3.4, 0, -0.6])
                scale([0.62, 1.18, 1.0])
                    sphere(r=1.65, $fn=24);
            // 3 Round toe beans
            translate([-3.4, -1.35, 1.3]) sphere(r=0.68, $fn=16);
            translate([-3.5,  0.00, 1.65]) sphere(r=0.72, $fn=16);
            translate([-3.4,  1.35, 1.3]) sphere(r=0.68, $fn=16);
        }
}

// ---------- 7. Full Cute Bear Assembly ----------
module cute_ledge_bear_assembly() {
    union() {
        // 1. Base, Rump & Countermass
        flat_seat_contact();
        translate([18, 0, 12]) bio_ellipsoid([29, 24, 25]);
        rear_countermass();
        puffy_bear_tail();

        // 2. Chubby Belly & Torso
        translate([17, 0, 23.5]) bio_ellipsoid([23, 20, 25]);
        translate([11.5, 0, 19.5]) bio_ellipsoid([13, 16, 16]); // protruding round tummy!
        
        // 3. Neck bridge (eliminates hollow chin gap)
        translate([16.5, 0, 29.5]) bio_ellipsoid([18.0, 16.5, 11.0]);

        // 4. Bowtie
        cute_bowtie();

        // 5. Honey Pot
        cute_honey_pot();

        // 6. Arms
        cute_arms();

        // 7. Head with adorable 6° inquisitive tilt
        translate([17, 0, 37.0])
            rotate([6.0, 3.0, -3.5])
                translate([-17, 0, -37.0])
                    cute_bear_head();

        // 8. Dangling Legs (thick, robust continuous knees, NO notches!)
        // Left leg (relaxed straight drape)
        bezier_limb([7.0, -6.3, 8.0], [-1.0, -7.2, 1.0], [-8.0, -7.0, -13.5], 3.6, 2.8, 8);
        hull() {
            ball([-8.0, -7.0, -13.5], 3.0);
            ball([-13.0, -7.0, -15.0], 3.7);
        }
        cute_paw_pads([-13.0, -7.0, -15.0], [0, 35, 0]);

        // Right leg (playful subtle outward kick)
        bezier_limb([7.0, 6.3, 8.0], [-1.0, 7.5, 1.5], [-9.5, 7.8, -12.5], 3.6, 2.8, 8);
        hull() {
            ball([-9.5, 7.8, -12.5], 3.0);
            ball([-14.5, 8.0, -13.8], 3.7);
        }
        cute_paw_pads([-14.5, 8.0, -13.8], [0, 35, 5]);
    }
}

// Scene rendering
color([0.86, 0.60, 0.40]) cute_ledge_bear_assembly();

if (show_table) {
    color([0.72, 0.76, 0.80, 0.35])
        translate([35, 0, -1.25]) cube([70, 80, 2.5], center=true);
}
if (show_edge_line) {
    color("red") translate([ledge_x, 0, 0.15]) cube([0.6, 76, 0.6], center=true);
}
if (show_com_marker) {
    color("lime") translate(com_proxy) sphere(r=1.8);
    color("lime") translate([com_proxy[0], com_proxy[1], 0]) cylinder(h=com_proxy[2], r=0.35);
}
