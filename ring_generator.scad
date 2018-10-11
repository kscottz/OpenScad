// sudo add-apt-repository ppa:openscad/releases
// sudo apt-get update
a = 5;
b = 35;
list1 = [ for (i = [0:1:360]) [a*cos(i)+a,b*sin(i)+b] ];   
echo(list1);
rotate_extrude($fn=100)
translate([90,0,0])
rotate([0,0,0])
color("gold")
polygon( points=list1 );

r = 50;
scale([150,100,r])
translate([0,0,0.7])
sphere(1, $fa=5, $fs=0.1); 

