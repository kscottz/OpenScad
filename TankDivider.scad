depth = 293; // overall aquarium depth, this is the inner lip depth
width = 15; // width of the top bar
height = 2.5; // how thick the top bar is (small as possible) so the glass fits
notch = 7; // how deep the notch is cut outto accomodate the lip 
paddle = 45 - notch; // how deep the paddle goes into the tank. This seems to work for me. 
                     // you could make it even longer to keep plants in place for water  
                     // changes
paddle_thick = 5; // paddle thickness 
paddle_depth = depth;// same as the overall body
bumper_thickness = -4.5;// how big the bumper will be (OD-ID/2). This is the overhang. 
                        // It is the difference between the outer edge of the lip and the
                        // glass. Negative bumps it out 
ledge_height = 3; // the cutout notch height to accomodate the plastic aquarium rim


attach_depth=50;   // the attachment area between the two units 
attach_width = 2;  // the attachment thickness all around.
attach_height = paddle;// the overall height of the attachment,  
attach_bottom = 2.5;

union(){
    difference()
    {
        union(){
            cube(size = [width,depth,height]);  // the top bar where the glass sits
            translate([(width/2)-(paddle_thick/2),notch,height])
            cube(size = [paddle_thick,paddle_depth,paddle]); // the main paddle
            translate([(width/2)-(paddle_thick/2),bumper_thickness,height+ledge_height])
            cube(size = [paddle_thick,depth-(bumper_thickness*2),paddle-ledge_height]);
        }
        // this cuts the unit in half which was the original design
        translate([0,depth/2,0])
        translate([-1,0,-1])
        cube(size = [400,400,400]);
    }
    // the sides of the press-fit attachment area in the middle 
    translate([(width/2)-(paddle_thick/2)-attach_width,(depth/2)-(attach_depth/2),height])
    cube(size=[attach_width,attach_depth,attach_height]);
    translate([(width/2)+(paddle_thick/2),(depth/2)-(attach_depth/2),height])
    cube(size=[attach_width,attach_depth,attach_height]);
    // the top of the attachment area
    cube(size = [width,(depth/2)+(attach_depth/2),height]); 
    // bottom of the attachment area
    translate([(width/2)-(paddle_thick/2)-attach_width,(depth/2)-(attach_depth/2),height+paddle])
    cube(size=[paddle_thick+(attach_width*2),attach_depth,attach_bottom]);
}

// the second assembly that has the male part of the press fit
translate([30,0,0])
union(){
    difference(){
        difference()
        {
            union(){
                // these are the same as above
                cube(size = [width,depth,height]); // the top bar where the glass sits
                translate([(width/2)-(paddle_thick/2),notch,height])
                cube(size = [paddle_thick,paddle_depth,paddle]); // the main paddle
                translate([(width/2)-(paddle_thick/2),bumper_thickness,height+ledge_height])
                cube(size = [paddle_thick,depth-(bumper_thickness*2),paddle-ledge_height]);
                }
            // cut it in half
            translate([0,depth/2,0])
            translate([-1,0,-1])
            cube(size = [400,400,400]);
        }
        // Now lop off the top bar where the support is going to go
        // this is a bit of a cheat but comes from iteration. 
        translate([0,(depth/2)-(attach_depth/2),0])
        cube(size = [width,depth,height]); // the top bar
    }
}