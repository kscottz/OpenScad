color("yellow")
//    translate([0,0,5])
//    cube([200,200,5], center = true);
intersection(){
    translate([0,0,11])
    cube([200,200,20], center = true);
    scale([1,1,0.1])
    surface("dickbutt.png", center = true);
}

color("blue")
translate(0,0,-9)
cylinder(r=100, h=3, center=true);

color("red")
translate([0,0,3])
difference(){
    cylinder(r=100, h=3, center=true);
    cylinder(r=90, h=5, center=true);
}
color("green")
difference(){
    translate([0,0,-105])
    rotate([90,0,0])
    difference(){
        cylinder(r=120, h=80, center=true);
        cylinder(r=110, h=90, center=true);
    }
    translate([0,0,100])
    cube([200,200,200],center = true);
}