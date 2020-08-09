clamp_size = 5; // the thickness of above and below the table edge
ledge_height = 18.9; // size of edge to attach Z. This is size of the table/bench 
overall_height = ledge_height+(clamp_size*2); // Z
dowel_d = 10.25; // dowel diameter, give it 0.2-0.3 of space as the minkowski hits it
ledge_depth = 40; // how much clamp goes over the ledge y
dowel_to_edge = 40; // how far off the edge the dowel will sit in y
overall_depth = ledge_depth + dowel_to_edge; // y, not including round part
overall_width = 15; // width x, how wide the clamps are. 


// make the main body


minkowski(){ // do a bit of rounding overal the whole structure
    difference(){ // do the cutout clamp section. 
        union(){
            // this makes the clamp section 
            difference(){
                cube([overall_width,overall_depth,overall_height],  center=true);
                translate([0,-dowel_to_edge,0])
                cube([overall_width,overall_depth,ledge_height],center=true);
            }
 
            // this section makes the rounded end
            rotate([0,90,0])
            translate([0,overall_depth/2,0])
            cylinder(overall_width,r=overall_height/2,center=true,$fa=0.1);
        }
        // make the dowel cutout
        rotate([0,90,0])
        translate([0,overall_depth/2,0])
        cylinder(overall_width*2,r=dowel_d/2,center=true,$fa=0.1);
        }
    sphere(0.1); // minkowski the whole thing
}