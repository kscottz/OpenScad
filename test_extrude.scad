use <"MCAD/curves.scad">

helix_curve(10,10,10);

color("green")
rotate_extrude()
    translate([10,0])
    square([5],center=true);

intersection(){
        translate([0,0,2])
        cube([20,100,3], center = true);
        scale([1,1,0.03])
        surface("profile.png", center = true);
    }