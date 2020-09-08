// A simple busy board for small mamals, like rats, mice, hampsters, etc.

$fn=18; // don't set this too high, will take forever
board_w = 100; //y width of board
board_h = 100; // height of board
board_d = 3; //z  depth of the board
screw_d = 3.5; // screw body width
screw_offset = 2+screw_d; // offset of the edge


// Make the base board of a give size 
// with offcenter screw holes 
module base_board(board_w, // board width
                  board_h, // board height 
                  board_d, // board thickness
                  screw_offset){ // screw offset from the sides
    screw_head = 7; // screw head diameter
    head_height = 2; // screw clearance
    difference(){
        cube(size = [board_w,board_h,board_d]);

        // the corner holes / screw slots 
        // with space for the screw head
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
        
        // two additional screws holes near the center
        off_hole = 30;
        translate(v=[screw_offset+off_hole,screw_offset+off_hole,-1]) 
            cylinder(r=screw_d/2,h=2*board_d);
        translate(v=[screw_offset+off_hole,screw_offset+off_hole,board_d-head_height]) 
            cylinder(r=screw_head/2,h=2*board_d);

        translate(v=[board_w-screw_offset-off_hole,screw_offset+off_hole,-1]) 
            cylinder(r=screw_d/2,h=2*board_d);
        translate(v=[board_w-screw_offset-off_hole,screw_offset+off_hole,board_d-head_height]) 
            cylinder(r=screw_head/2,h=2*board_d);
    }
    // now make a three unit ridge all the way around
    ridge = 3;
    translate(v=[0,0,ridge])
    difference(){
        cube(size = [board_w,board_h,board_d]);
        translate(v=[ridge/2,ridge/2,0])
            cube(size = [board_w-ridge,board_h-ridge,board_d]);
    }
};

bowl_r = 15; // the radius of the "bowl" part
bowl_h = 12; // the height of the bowl part
bowl_thickness = 1; // the thickness of the board wall
// Create a bowl of a given radius and wall thickness. 
// The height modulates the aperture by subtracting a cube at the
// given height
module bowl(bowl_r, // the radius of the bowl
            bowl_h, // the height to truncate at
            bowl_thickness){ // the overall thickness
    difference(){
        difference(){
            difference(){ // create a sphere shell
                sphere(r=bowl_r);
                sphere(r=bowl_r-bowl_thickness);
            }
            translate(v=[0,0,-1*bowl_r]) // lop off a cube
                cube(size=[bowl_r*2,bowl_r*2,bowl_r*2],center=true);
        } 
    // now lop off the bottom
    translate([0,0,bowl_h+bowl_r])  
        cube(size=[bowl_r*2,bowl_r*2,bowl_r*2],center=true);
    }   
}


slide_w = 100; // the width
slide_h = 20;// the height 
slide_d = 10;// the depth
slide_t = 5; // wall thickness
hole_r = 4;  // the hole radius
// the box with holes in it
module slider(
    slide_w,  // width of the box
    slide_h,  // the height of the box
    slide_d,  // the thickness
    slide_t,  // top wall thickness approximately
    hole_r ){  // hole radius
    mk = 1;// the minkowski size 
    count = (slide_w - (4*hole_r)) / (3*hole_r); // number of holes
    difference(){
        difference(){
            cube(size = [slide_w,slide_h,slide_d]); // subtract a minkowski'd cube from our main form
            translate([0,(slide_t+mk)/2,0])
            minkowski(){
                cube(size = [slide_w,slide_h-slide_t-mk,slide_d-slide_t]);
                sphere(r=mk);
            }
        }   
        for(k=[0:count]){  // make the holes 
            translate(v=[(2*hole_r)+(3*k*hole_r),slide_h/2,0])            
            // random hole size with a fudge factor to clamp the distance between
            cylinder(r=rands(hole_r-2,hole_r+hole_r-2,1)[0],h=slide_d*2);    
        }
    }
}

point_r1 = 2;
point_r2 = 1;
point_h = 12;
point_r = 1.4;
// the little pointy bits between the tube
module point(
    point_r1, // bottom of the point radius
    point_r2, // top of the point radius
    point_h,  // the point height
    point_r){ // the ball at the end radius
    union(){
        cylinder(r1=point_r1,r2=point_r2,h=point_h);
        translate(v=[0,0,point_h])
        sphere(r=point_r);
    }
}

tube_od = 5;  // tube od
tube_id = 4;  
tube_h = 10;
// the tube parts
module tube( 
    tube_od, // outer diameter appx (plus minkowski)
    tube_id, // the inner diameter (minus minkowski)
    tube_h){ // tube height
        
    // drop the minkowski to speed stuff up
    minkowski(){
        difference(){
            cylinder(r=tube_od,h=tube_h);
            cylinder(r=tube_id,h=tube_h);
        };
        sphere(0.3);
    }
}
// MAIN ROUTINE

// Make the main board    
base_board( board_w,board_h,board_d,screw_offset);
// Make the bowls
translate(v=[17,20,board_d])
    bowl(bowl_r,bowl_h-1,bowl_thickness);
translate(v=[50,20,board_d])
    bowl(bowl_r,bowl_h+1,bowl_thickness);
translate(v=[83,20,board_d])
    bowl(bowl_r,bowl_h,bowl_thickness);
// Make the box with holes in it
translate([0,40,board_d])
    slider(slide_w,slide_h,slide_d,slide_t,hole_r);



// now make the point/row pairs
space = 5; // space between each tube/point
offset = tube_od+point_r1+space+space; // size of one tube/point pair with space between
xoff = 2; // side offset 
tube_min = tube_h-5; // max tube height
tube_max = tube_h+7; // min tube height
y = 67; // the y pos of our first row of points/tubes

// Make the first row of tubes / points
for(x = [space+xoff : offset : board_w-offset]){
    translate(v=[x+(point_r1/2),y,board_d]) // create the point
        point(point_r1,point_r2,point_h,point_r);
    translate(v=[x+point_r1+space+(tube_od/2),y,board_d]) // create the tube of rand height
        tube(tube_od,tube_id,rands(tube_min,tube_max,1)[0]);
    
}
// Do one last point to fill the row, not sure if this is just right
x = board_w-(offset/2);
translate(v=[x+(point_r1/2),y,board_d])
point(point_r1,point_r2,point_h,point_r);


// repeat the step above with a different order (tube first)
y2 = 80;
for(x = [space+xoff : offset : board_w-offset]){
    translate(v=[x+tube_od/2,y2,board_d])
        tube(tube_od,tube_id,rands(tube_min,tube_max,1)[0]);
    translate(v=[x+space+tube_od+(point_r1/2),y2,board_d])
        point(point_r1,point_r2,point_h,point_r);
}
// create the last element for that row
x2 = board_w-(offset/2);
translate(v=[x2+tube_od/2,y2,board_d])
tube(tube_od,tube_id,tube_h);

// do the last row but squeeze it between the screw holes. 
y3 = 93;
// magic numbers for squeezing. Need to recalculate a bit
for(x = [screw_offset+screw_d+2: offset : board_w-offset-screw_offset+10]){
    translate(v=[x+tube_od/2,y3,board_d])
        tube(tube_od,tube_id,rands(tube_min,tube_max,1)[0]);
    translate(v=[x+space+tube_od+(point_r1/2),y3,board_d])
        point(point_r1,point_r2,point_h,point_r);
}

