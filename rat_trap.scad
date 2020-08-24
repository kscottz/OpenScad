board_w = 100; //y
board_h = 100; //x
board_d = 10; //z 
screw_d = 5;
screw_offset = 5+screw_d;


bowl_r = 15;
bowl_h = 12;
bowl_thickness = 1;

$fn=36;


module base_board( board_w,board_h,board_d,screw_offset){
    difference(){
    cube(size = [board_w,board_h,board_d]);
    translate(v=[screw_offset,screw_offset,-1]) 
        cylinder(r=screw_d,h=2*board_d);
    translate(v=[board_w-screw_offset,screw_offset,-1]) 
        cylinder(r=screw_d,h=2*board_d);
    translate(v=[board_w-screw_offset,board_h-screw_offset,-1])
        cylinder(r=screw_d,h=2*board_d);
    translate(v=[screw_offset,board_h-screw_offset,-1]) 
        cylinder(r=screw_d,h=2*board_d);
    }
};


module bowl(bowl_r,bowl_h,bowl_thickness){
    difference(){
        difference(){
            difference(){
                sphere(r=bowl_r);
                sphere(r=bowl_r-bowl_thickness);
            }
            translate(v=[0,0,-1*bowl_r])
                cube(size=[bowl_r*2,bowl_r*2,bowl_r*2],center=true);
        }
    translate([0,0,bowl_h+bowl_r])  
        cube(size=[bowl_r*2,bowl_r*2,bowl_r*2],center=true);
    }   
}


slide_w = 100;
slide_h = 20;
slide_d = 10;
slide_t = 2;
hole_r = 7;
// A box with holes in it

module slider(
    slide_w,
    slide_h,
    slide_d,
    slide_t,
    hole_r ){
    difference(){
        difference(){
            cube(size = [slide_w,slide_h,slide_d]);
            translate([0,slide_t/2,0])
                cube(size = [slide_w,slide_h-slide_t,slide_d-slide_t]);
        }
        for(k=[0:5]){
            translate(v=[(2*hole_r)+2.2*k*hole_r,slide_h/2,0])
                cylinder(r=hole_r,h=slide_d*2);    
        }
    }
}


translate([0,40,board_d])
    slider(slide_w,slide_h,slide_d,slide_t,hole_r);
    
base_board( board_w,board_h,board_d,screw_offset);
translate(v=[30,20,board_d])
    bowl(bowl_r,bowl_h,bowl_thickness);
translate(v=[70,20,board_d])
    bowl(bowl_r,bowl_h,bowl_thickness);


