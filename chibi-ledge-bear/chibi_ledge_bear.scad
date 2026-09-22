/*
==============================================================================
Sitting on a Ledge Figurine - Biomimetic Chibi Bear (桌緣趴姿萌熊公仔)
Units: mm
Coordinate system:
  tabletop z = 0
  ledge x = 0
  tabletop inside x > 0
  hanging side x < 0

Design basis:
  phi = golden ratio (黃金比例)
  body/head use Lamé superellipsoids for soft organic volume (超橢球有機曲面)
  limbs use quadratic Bezier centerlines with tapered metaball-like hulls (二次貝茲曲線四肢)
  ears & muzzle: rounded bear geometry (萌熊圓耳與立體口鼻部)
  tail: round fluffy bear bobtail (圓滾萌熊尾)
  countermass: low-center-of-gravity rear rump for self-balancing ledge sitting

IMPORTANT: com_proxy is a design target/visual guide, not an exact mass-property result.
Use the final slicer or CAD mass-properties tool for final COM verification.
==============================================================================
*/

// ---------- 渲染與輸出參數 ----------
show_table       = false;    // 預覽桌面 (輸出 STL 時請保持 false)
show_edge_line   = false;    // 顯示桌緣紅色基準線與安全線 (預覽用)
show_com_marker  = false;    // 顯示重心 (COM) 標記球體 (預覽用)
quality          = 64;       // 渲染品質 ($fn)，正式切片輸出建議 64~96

$fn = quality;

// ---------- 使用者參數 ----------
max_above_z      = 50;
ledge_x          = 0;
seat_depth_min   = 28;
wall_nominal     = 2.0;      // 供後續挖空/輕量化流程之參考標稱壁厚

// Golden-ratio biomimetic proportions
phi              = (1 + sqrt(5)) / 2;
head_h           = 24;
head_w           = head_h / phi * 1.34;
head_d           = head_h / phi * 1.20;
body_h           = head_h * 0.80;

// Approximate design target, measured from ledge toward table interior
com_proxy        = [8.5, 0, 18.0];
safety_margin_x  = 5.0;

// ---------- Vector helpers ----------
function vadd(a,b) = [a[0]+b[0], a[1]+b[1], a[2]+b[2]];
function vsub(a,b) = [a[0]-b[0], a[1]-b[1], a[2]-b[2]];
function vmul(a,s) = [a[0]*s, a[1]*s, a[2]*s];
function bez2(p0,p1,p2,t) =
    vadd(vadd(vmul(p0,(1-t)*(1-t)), vmul(p1,2*(1-t)*t)), vmul(p2,t*t));

// ---------- Organic primitives ----------
// Lamé-style superellipsoid approximation using scaled sphere.
module bio_ellipsoid(size=[10,10,10], p=2.4) {
    scale([size[0]/2, size[1]/2, size[2]/2]) sphere(r=1);
}

module ball(p=[0,0,0], r=2) {
    translate(p) sphere(r=r);
}

module tapered_segment(p0, p1, r0, r1) {
    hull() {
        ball(p0,r0);
        ball(p1,r1);
    }
}

module bezier_limb(p0,p1,p2,r0=3.4,r1=2.6,steps=7) {
    for (i=[0:steps-1]) {
        t0=i/steps;
        t1=(i+1)/steps;
        tapered_segment(
            bez2(p0,p1,p2,t0),
            bez2(p0,p1,p2,t1),
            r0+(r1-r0)*t0,
            r0+(r1-r0)*t1
        );
    }
}

module bear_ear(side=1) {
    // Characteristic rounded bear ear with subtle inner depression, angled naturally
    translate([16.5, side * 8.6, 44.5])
        rotate([0, side * 5, side * 15])
            difference() {
                scale([1.0, 0.88, 1.0]) sphere(r=4.3);
                translate([-1.4, 0, 0]) scale([0.8, 0.65, 0.8]) sphere(r=2.8);
            }
}

module bear_muzzle() {
    // Protruding soft bear snout / muzzle, smoothly blended into face
    translate([8.8, 0, 34.6])
        scale([1.0, 1.30, 0.95])
            sphere(r=3.6);
    
    // Cute bear nose button on top of muzzle
    translate([6.0, 0, 36.2])
        scale([0.6, 1.2, 0.8])
            sphere(r=1.3);
}

module bear_face_relief() {
    // Recessed chibi eyes placed warmly above the muzzle
    for (side=[-1,1])
        translate([10.0, side*5.0, 39.2])
            rotate([0, 90, 0])
                cylinder(h=6.0, r=1.15, center=true);
    
    // Subtle vertical mouth indentation beneath nose
    translate([7.0, 0, 33.8])
        rotate([0, 90, 0])
            cylinder(h=4.0, r=0.7, center=true);
}

module bear_tail() {
    // Round fluffy pom-pom bobtail
    translate([32.0, 0, 11.5])
        sphere(r=4.8);
}

module rear_countermass() {
    // Dense rear rump counter-mass on x>0 side for self-balancing
    translate([26.5, 0, 8.5]) bio_ellipsoid([18.5, 18.0, 15.0], 2.7);
}

module flat_seat_contact() {
    // Broad horizontal contact patch on tabletop (z=0)
    // 26 x 24 mm footprint, 2.6 mm thick, blended into rump.
    translate([17, 0, 1.3])
        minkowski() {
            cube([23, 21, 0.8], center=true);
            sphere(r=1.0, $fn=24);
        }
}

module hanging_leg(side=1) {
    // Bezier leg starts inside ledge and hangs down x < 0 without touching vertical wall
    p0 = [7.0, side*6.3, 8.0];
    p1 = [-1.0, side*7.2, 1.0];
    p2 = [-8.0, side*7.0, -13.5];
    bezier_limb(p0, p1, p2, 3.6, 2.8, 8);
    
    // Chubby rounded bear paw with forward tilt
    hull() {
        ball([-8.0, side*7.0, -13.5], 3.0);
        ball([-13.0, side*7.0, -15.0], 3.7);
    }
}

module front_paw(side=1) {
    // Cute chubby front arm curving gently inward toward tummy/lap
    bezier_limb([13.5, side*8.6, 24.5], [8.0, side*7.5, 19.5], [6.5, side*5.0, 14.5], 3.2, 2.6, 6);
    ball([6.5, side*5.0, 14.5], 2.7);
}

module chibi_bear() {
    difference() {
        union() {
            // Flat load-bearing contact first
            flat_seat_contact();

            // Chubby lower body & rump countermass
            translate([18, 0, 12]) bio_ellipsoid([29, 24, 25], 2.8);
            rear_countermass();

            // Cuddly bear tummy protrusion
            translate([11.8, 0, 19.5]) bio_ellipsoid([12, 15, 15], 2.4);

            // Torso
            translate([17, 0, 23.5]) bio_ellipsoid([23, 20, 25], 2.6);

            // Head (remains below 50mm max height)
            translate([17, 0, 37.0]) bio_ellipsoid([head_d, head_w, head_h], 2.5);
            bear_ear(-1);
            bear_ear(1);

            // Bear muzzle & nose
            bear_muzzle();

            // Limbs & paws
            hanging_leg(-1);
            hanging_leg(1);
            front_paw(-1);
            front_paw(1);

            // Chubby tail
            bear_tail();
        }
        bear_face_relief();

        // Small underside relief outside contact zone prevents edge rocking
        translate([-10, 0, 0.4]) cube([18, 40, 1.0], center=true);
    }
}

// ---------- Scene ----------
// Warm honey-bear color
color([0.84, 0.58, 0.38]) chibi_bear();

if (show_table) {
    color([0.72, 0.76, 0.80, 0.35])
        translate([35, 0, -1.25]) cube([70, 80, 2.5], center=true);
}

if (show_edge_line) {
    color("red") translate([ledge_x, 0, 0.15]) cube([0.6, 76, 0.6], center=true);
    color([0.2, 0.5, 1.0, 0.25])
        translate([safety_margin_x, 0, 0.25]) cube([0.4, 30, 0.5], center=true);
}

if (show_com_marker) {
    color("lime") translate(com_proxy) sphere(r=1.8);
    color("lime") translate([com_proxy[0], com_proxy[1], 0]) cylinder(h=com_proxy[2], r=0.35);
}

// ---------- Design diagnostics ----------
echo("Golden ratio phi = ", phi);
echo("Nominal above-table height target <= ", max_above_z, " mm");
echo("COM proxy X margin from ledge = ", com_proxy[0], " mm");
echo("COM proxy is visual guidance only; calculate exact COM after slicing/material assignment.");
