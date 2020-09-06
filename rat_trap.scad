board_w = 100; //y
board_h = 100; //x
board_d = 3; //z 
screw_d = 5;
screw_offset = 5+screw_d;


bowl_r = 15;
bowl_h = 12;
bowl_thickness = 1;

$fn=72;


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
translate(v=[30,20,board_d])
    bowl(bowl_r,bowl_h,bowl_thickness);
translate(v=[70,20,board_d])
    bowl(bowl_r,bowl_h,bowl_thickness);

y = 67;
space = 5;
offset = tube_od+point_r1+space+space;
count = 0;
for(x = [space : offset : board_w-offset]){
    translate(v=[x+(point_r1/2),y,board_d])
    point(point_r1,point_r2,point_h,point_r);
    translate(v=[x+point_r1+space+(tube_od/2),y,board_d])
    tube(tube_od,tube_id,tube_h);
    count = count + 1;
}

//translate(v=[(2*space)+(count*offset)+point_r1/2,y,board_d])
//point(point_r1,point_r2,point_h,point_r);


y2 = 80;
for(x = [space : offset : board_w-offset]){
    translate(v=[x+tube_od/2,y2,board_d])
    tube(tube_od,tube_id,tube_h);
    translate(v=[x+space+tube_od+(point_r1/2),y2,board_d])
    point(point_r1,point_r2,point_h,point_r);
}

y3 = 93;
for(x = [space+screw_offset+screw_d : offset : board_w-offset-screw_offset]){
    translate(v=[x+tube_od/2,y3,board_d])
    tube(tube_od,tube_id,tube_h);
    translate(v=[x+space+tube_od+(point_r1/2),y3,board_d])
    point(point_r1,point_r2,point_h,point_r);
}

