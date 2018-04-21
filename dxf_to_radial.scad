R = 45;  // radius 
H = 2;   // height 
L = 130; // centering offset 
step = 5; 

$fn=360/step; 

for (i=[0:step:360]) 
{ 
  radian = R*PI/180; 
  rotate([0, i, 0])   translate([0,0,R-H/2]) // cylinder stuff 
  intersection() 
  { 
    translate([L-i*radian, 0, 0])  // shift dxf over the window 
    linear_extrude(height = H, center = true, convexity = 4) 
    import("/home/kscottz/code/OpenScad/test.dxf"); 
    cube([radian*step, 100, H+1], center = true);  // window 
  } 
} 