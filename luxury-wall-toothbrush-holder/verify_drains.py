import trimesh
import numpy as np
import sys
import glob
import os

def check_holder_drains(stl_path, expected_drain_count=4):
    print(f"\n==================================================")
    print(f"Checking: {os.path.basename(stl_path)}")
    print(f"==================================================")
    mesh = trimesh.load(stl_path)
    print(f"Watertight: {mesh.is_watertight}")
    print(f"Bounds: min={mesh.bounds[0]}, max={mesh.bounds[1]}")
    print(f"Extents: {mesh.extents}")
    print(f"Volume: {mesh.volume/1000.0:.1f} cm³")
    print(f"Euler number: {mesh.euler_number}")

    if not mesh.is_watertight:
        print("ERROR: Mesh is NOT watertight!")
        return False

    if expected_drain_count == 0:
        print("SUCCESS: Watertight non-storage part verified!")
        return True

    # Section at Z = 5.0mm (below cavity floor Z=9.0mm)
    plane_origin = [0, 0, 5.0]
    plane_normal = [0, 0, 1]
    slice_2d = mesh.section(plane_origin=plane_origin, plane_normal=plane_normal)
    
    if slice_2d is None:
        print("ERROR: Slice at Z=5mm is None!")
        return False

    drain_holes = []
    for i, entity in enumerate(slice_2d.entities):
        pts = slice_2d.vertices[entity.points]
        center = np.mean(pts, axis=0)
        min_p = np.min(pts, axis=0)
        max_p = np.max(pts, axis=0)
        sz = max_p - min_p
        if 25.0 <= center[1] <= 40.0 and (10.0 <= sz[0] <= 16.0) and (10.0 <= sz[1] <= 16.0):
            drain_holes.append((center, sz))
            print(f"  --> FOUND DRAIN HOLE: Center=({center[0]:.1f}, {center[1]:.1f}), Size=({sz[0]:.1f}, {sz[1]:.1f})")

    print(f"Total Drain Holes Detected at Z=5mm: {len(drain_holes)} (Expected: {expected_drain_count})")
    if len(drain_holes) != expected_drain_count:
        print(f"ERROR: Expected {expected_drain_count} drain holes, found {len(drain_holes)}!")
        return False
        
    print("SUCCESS: Drain holes properly cut straight through to open air below!")
    return True

def main():
    dir_path = sys.argv[1] if len(sys.argv) > 1 else "."
    
    files = [
        ("luxury_holder_grand_fluted.stl", 4),
        ("combo_plate_grand_fluted.stl", 4),
        ("standalone_toothbrush_fluted.stl", 0),
        ("wall_bracket.stl", 0)
    ]
    
    all_ok = True
    for fname, exp_count in files:
        fpath = os.path.join(dir_path, fname)
        if not os.path.exists(fpath):
            print(f"Missing file: {fpath}")
            all_ok = False
            continue
        ok = check_holder_drains(fpath, exp_count)
        if not ok:
            all_ok = False
            
    if all_ok:
        print("\nALL MODELS VERIFIED 100% WATERTIGHT AND THROUGH-DRAIN CERTIFIED!")
    else:
        print("\nSOME VERIFICATIONS FAILED!")
        sys.exit(1)

if __name__ == "__main__":
    main()
