depth = 295; // overall aquarium depth
width = 15; // width of the top bar
height = 2.5; // how thick the top bar is (small as possible).
notch = 4; // how deep the notch is cut out 
paddle = 45 - notch; // how deep the paddle goes into the tank
paddle_thick = 5; // how wide the paddle is 
paddle_depth = depth - (notch*2);
bumper_thickness = 0.5;// how big the bumper will be (OD-ID/2)
ledge_height = 3; // how thick the edge is 


attach_depth=50; // 
attach_width = 2; // support thickness
attach_height = 38;// support height

union(){
    difference()
    {
        union(){
            cube(size = [width,depth,height]); // the top bar
            translate([(width/2)-(paddle_thick/2),notch,height])
            cube(size = [paddle_thick,paddle_depth,paddle]); // the main paddle
            translate([(width/2)-(paddle_thick/2),bumper_thickness,height+ledge_height])
            cube(size = [paddle_thick,depth-(bumper_thickness*2),paddle-ledge_height]);
        }
        translate([0,depth/2,0])
        translate([-1,0,-1])
        cube(size = [400,400,400]);
    }
    // the support section in the middle 
    translate([(width/2)-(paddle_thick/2)-attach_width,(depth/2)-(attach_depth/2),height])
    cube(size=[attach_width,attach_depth,attach_height]);
    translate([(width/2)+(paddle_thick/2),(depth/2)-(attach_depth/2),height])
    cube(size=[attach_width,attach_depth,attach_height]);
}

// the second assembly
translate([30,0,0])
union(){
    difference()
    {
        union(){
            cube(size = [width,depth,height]); // the top bar
            translate([(width/2)-(paddle_thick/2),notch,height])
            cube(size = [paddle_thick,paddle_depth,paddle]); // the main paddle
            translate([(width/2)-(paddle_thick/2),bumper_thickness,height+ledge_height])
            cube(size = [paddle_thick,depth-(bumper_thickness*2),paddle-ledge_height]);
        }
        translate([0,depth/2,0])
        translate([-1,0,-1])
        cube(size = [400,400,400]);
    }

}