board_w = 100; //y
board_h = 100; //x
board_d = 3; //z 
screw_d = 3.5;
screw_offset = 2+screw_d;


bowl_r = 15;
bowl_h = 12;
bowl_thickness = 1;

$fn=72;


module base_board( board_w,board_h,board_d,screw_offset){
    screw_head = 7;
    head_height = 2;
    difference(){
    cube(size = [board_w,board_h,board_d]);

    translate(v=[screw_offset,screw_offset,-1]) 
        cylinder(r=screw_d/2,h=2*board_d);
    translate(v=[screw_offset,screw_offset,board_d-head_height]) 
        cylinder(r=screw_head/2,h=2*board_d);

    translate(v=[board_w-screw_offset,screw_offset,-1]) 
        cylinder(r=screw_d/2,h=2*board_d);
    translate(v=[board_w-screw_offset,screw_offset,board_d-head_height]) 
        cylinder(r=screw_head/2,h=2*board_d);

    translate(v=[board_w-screw_offset,board_h-screw_offset,-1])
        cylinder(r=screw_d/2,h=2*board_d);    
    translate(v=[board_w-screw_offset,board_h-screw_offset,board_d-head_height])
        cylinder(r=screw_head/2,h=2*board_d);


    translate(v=[screw_offset,board_h-screw_offset,-1]) 
        cylinder(r=screw_d/2,h=2*board_d);
    translate(v=[screw_offset,board_h-screw_offset,board_d-head_height]) 
        cylinder(r=screw_head/2,h=2*board_d);
        
    }
 
    ridge = 3;
    translate(v=[0,0,ridge])
    difference(){
        cube(size = [board_w,board_h,board_d]);
        translate(v=[ridge/2,ridge/2,0])
            cube(size = [board_w-ridge,board_h-ridge,board_d]);
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
    
    mk = 1;
    difference(){
        difference(){
            cube(size = [slide_w,slide_h,slide_d]);
            translate([0,(slide_t+mk)/2,0])
            minkowski(){
                cube(size = [slide_w,slide_h-slide_t-mk,slide_d-slide_t]);
                sphere(r=mk);
            }
        }   
        for(k=[0:5]){
            translate(v=[(2*hole_r)+2.2*k*hole_r,slide_h/2,0])
            cylinder(r=hole_r,h=slide_d*2);    
        }
    }
}

point_r1 = 2;
point_r2 = 1;
point_h = 12;
point_r = 1.2;

module point(
    point_r1,
    point_r2,
    point_h,
    point_r){
    union(){
        cylinder(r1=point_r1,r2=point_r2,h=point_h);
        translate(v=[0,0,point_h])
        sphere(r=point_r);
    }
}

tube_od = 5;
tube_id = 4;
tube_h = 10;
module tube(
    tube_od,
    tube_id,
    tube_h){
    difference(){
        cylinder(r=tube_od,h=tube_h);
        cylinder(r=tube_id,h=tube_h);
    };
}


translate([0,40,board_d])
    slider(slide_w,slide_h,slide_d,slide_t,hole_r);
    
base_board( board_w,board_h,board_d,screw_offset);

translate(v=[17,20,board_d])
    bowl(bowl_r,bowl_h,bowl_thickness);
translate(v=[50,20,board_d])
    bowl(bowl_r,bowl_h,bowl_thickness);
translate(v=[83,20,board_d])
    bowl(bowl_r,bowl_h,bowl_thickness);


y = 67;
space = 5;
offset = tube_od+point_r1+space+space;
xoff = 2;
for(x = [space+xoff : offset : board_w-offset]){
    translate(v=[x+(point_r1/2),y,board_d])
    point(point_r1,point_r2,point_h,point_r);
    translate(v=[x+point_r1+space+(tube_od/2),y,board_d])
    tube(tube_od,tube_id,tube_h);
}
x = board_w-(offset/2);
translate(v=[x+(point_r1/2),y,board_d])
point(point_r1,point_r2,point_h,point_r);



y2 = 80;
for(x = [space+xoff : offset : board_w-offset]){
    translate(v=[x+tube_od/2,y2,board_d])
    tube(tube_od,tube_id,tube_h);
    translate(v=[x+space+tube_od+(point_r1/2),y2,board_d])
    point(point_r1,point_r2,point_h,point_r);
}
x = board_w-(offset/2);
translate(v=[x+tube_od/2,y2,board_d])
tube(tube_od,tube_id,tube_h);


y3 = 93;
for(x = [screw_offset+screw_d+2: offset : board_w-offset-screw_offset+10]){
    translate(v=[x+tube_od/2,y3,board_d])
    tube(tube_od,tube_id,tube_h);
    translate(v=[x+space+tube_od+(point_r1/2),y3,board_d])
    point(point_r1,point_r2,point_h,point_r);
}

