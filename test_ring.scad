//gem_w = 111.5*1.01;
//gem_h = 175*1.01;
gold_b = 6;
gem_w = 150+(2*gold_b);
gem_h = 200+(2*gold_b);

bezel_extent = 1.2;
ramp_up = 0.9;
under_window = 0.6;
falloff = 1.7;
bezel_w = 1.05*gem_w*bezel_extent;
bezel_h = 1.05*gem_h*bezel_extent;
fnv = 250;
fnvb = 18;
d = 1;
convexity = 3;
union(){
translate([0,-33.5,0])
scale([8.4,8.4,8.4])
import("/home/kscottz/code/OpenScad/organic_ring.stl", convexity=3);

// TEST SIZING
//rotate([90,0,0])
//linear_extrude(height = 200, 
//                    center = true, 
//                    convexity = 3,
//                    $fn=fnv)
//circle(r = 175/2);}

//difference()
//{

      //translate([0,0,50])
      //          linear_extrude(height = 80, 
      //          center = true, 
      //          convexity = 30,
      //          $fn=fnvb)
      //      scale([(bezel_w*under_window),
      //          (bezel_h*under_window),1])
      //      circle(r = d/2);
//}

rotate([0,0,0])
translate([0,0,110])
union(){
    //difference(){
        difference(){
            union(){    
            translate([0,0,5])
                linear_extrude(height = 10, 
                    center = true, 
                    convexity = convexity,
                    scale=[ramp_up,ramp_up],
                    $fn=fnvb)
                scale([bezel_w,bezel_h,1])
                circle(r = d/2);
                translate([0,0,-5])
                linear_extrude(height = 10, 
                    center = true, 
                    convexity = convexity,
                    scale=[1,1],
                    $fn=fnvb)
                scale([bezel_w,bezel_h,1])
                circle(r = d/2);
                translate([0,0,-15])
                linear_extrude(height = 10, 
                    center = true, 
                    convexity = convexity,
                    scale=[falloff,falloff],
                    $fn=fnvb)
                scale([bezel_w/falloff,bezel_h/falloff,1])
                circle(r = d/2);
                }
//            linear_extrude(height = 1000, 
//                center = true, trees
//                convexity = convexity,
//                $fn=fnvb)
//            scale([(bezel_w*under_window),
//                (bezel_h*under_window),1])
//            circle(r = d/2);
//            }
//            
        translate([0,0,5])
        linear_extrude(height = 20, 
            center = true, 
            convexity = convexity,
            $fn=fnv)
        scale([gem_w,gem_h,1])
        circle(r = d/2);
    }
}
}