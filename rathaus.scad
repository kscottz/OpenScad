module dome(r, // radius
            thickness)
{
    difference(){
        scale([1,1,0.3])
        difference(){
            sphere(r = r);
            sphere(r = r - thickness);
        }
        translate([0,0,-1*r])
        cube([2*r,2*r,2*r], center=true);
    }
 }
 
module bowl(r, // radius
            thickness)
{
    difference(){
        scale([1,1,0.3])
        difference(){
            sphere(r = r);
            sphere(r = r - thickness);
        }
        translate([0,0,r])
        cube([2*r,2*r,2*r], center=true);
    }
 }

module tube(r, // radius
            height, // in z
            thickness)
{
    difference(){
        cylinder(height,r,r,center=true);
        cylinder(height*2,r-thickness,r-thickness,center=true);
    }
}

module pill(r, // radius
            height, // (overall)
            thickness)
{
    union(){
        tube_h = height-(2*r);
        tube(r,tube_h,thickness);
        translate([0,0,tube_h/2])
        dome(r,thickness);
        translate([0,0,tube_h/-2])
        bowl(r,thickness);
    }
}

module body(r,
            height,
            thickness,
            hole_r,
            doors)
{
    
//    translate([r,0,0])
//    rotate([0,90,0])
//    cylinder(r,hole_r,hole_r,center=true);
//  
//    translate([0,r,0])
//    rotate([0,90,90])
//    cylinder(r,hole_r,hole_r,center=true);
// 
//    translate([-r,0,0])
//    rotate([0,90,0])
//    cylinder(r,hole_r,hole_r,center=true);
//
//    translate([0,-r,0])
//    rotate([0,90,90])

    difference(){
        pill(r,height,thickness);
        t = doors;
        for ( i = [0:t] )
        {
            x = -1*r*sin(360*(i/t));
            y = r*cos(360*(i/t));
            z = 90+90*sin(360*(i/t));
            if( y < 0 )
            {
                wtf = -1*z; // openscad doesn't support re-assignment DERP
                translate( [x,y,0])
                rotate([0,90,wtf])
                cylinder(r,hole_r,hole_r,center=true);
            }
            else{
                echo(x,y,z);
                translate( [x,y,0])
                rotate([0,90,z])
                cylinder(r,hole_r,hole_r,center=true);
            }
        }
    }
}
// there is 9mm between cage bar so the thicknes must be 1/3 of that. 
r = 50;
height = 150;
thickness = 3;
hole_r = 25;

//minkowski(){
body(r,height,thickness,hole_r,3);
//sphere(0.2);
//}

hanger_thickness = 3;
hanger_width = 15;
hanger_height = 25;
hanger_overhang = 5;
hanger_x_space = (2/3)*r;
hanger_y_space = 61;//*r;
hang_z = 0.45*(height/2);

module make_hook(
    hanger_thickness,
    hanger_width,
    hanger_height,
    hanger_overhang)
{   
    translate([-hanger_width/2,-hanger_thickness*3/2,0])
        minkowski(){
            union(){
                // main body
                cube([hanger_width,hanger_thickness,hanger_height]);
                // the top of the hanger
                translate([0,hanger_thickness,hanger_height-hanger_thickness])
                    cube([hanger_width,hanger_thickness*2,hanger_thickness]);
                // now do the overhang that completes the hook
                translate([0,hanger_thickness*2,hanger_height-hanger_thickness-             hanger_overhang])
                    cube([hanger_width,hanger_thickness,hanger_overhang]);
            }
            sphere(0.1);
        }
}
translate([hanger_x_space/2,hanger_y_space/2,hang_z])
    make_hook(hanger_thickness,hanger_width,hanger_height,hanger_overhang);
translate([-hanger_x_space/2,hanger_y_space/2,hang_z])
    make_hook(hanger_thickness,hanger_width,hanger_height,hanger_overhang);
translate([hanger_x_space/2,-hanger_y_space/2,hang_z])
rotate([0,0,-180])
    make_hook(hanger_thickness,hanger_width,hanger_height,hanger_overhang);
translate([-hanger_x_space/2,-hanger_y_space/2,hang_z])
rotate([0,0,-180])
    make_hook(hanger_thickness,hanger_width,hanger_height,hanger_overhang);


//linear_extrude(height = 30)
//{
//    polygon(points = [ [0, 0],[10,20],[20,0]]);
//}