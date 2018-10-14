// http://kitwallace.co.uk/3d/solid-index.xq?mode=solid&id=HexagonalPrism
//  http://kitwllace.co.uk/3d/solid-index.xq?mode=solid&id=HexagonalDipyramid
// hexdipy needs the face thickness to be set to ( cage size / diameter ) * 2 to render correctly eg (5/50)*2 and then scaled to unit length. 

//openface(solid_1,outer_inset_ratio=0.3,inner_inset_ratio=0.2,depth=0.1,fn=[]);
//

// Overal dimensions 
cageSz = 5; // the thickness of the bars 
diameter = 50; // overall radius
height = 200; // total lenght of the straight hexagnoal part
count = 3; // number of bars down the body 

// hinge params 
innerD = 0.75; // hinge ID
outerD = 1.5; // hinge OD
shrink = 0.03;
bump = 1.002;
smooth = 0; // Minkowski value 

// Bale params 
bale_id = 2;
bale_od = 4;
bale_w = 2;

$fn = 24;


//bale(bale_id,bale_od,bale_w);


union()
{
    makeCageWithBars(count,diameter,height,cageSz);
    translate([(bump*(diameter+outerD)/2),0,height/2])
    rotate([90,0,0])
    makeDoubleClasp(innerD,outerD,(diameter/2),shrink);
}
//rotate([0,10,0])
translate([0,0,1])
union(){
    translate([0,0,height/2])
    makeTopPyramid(diameter);
    translate([bump*((diameter+outerD)/2),0,height/2])
    rotate([90,0,0])
    makeSingleClasp(innerD,outerD,diameter/2,shrink);

    translate([-1+-diameter/2,0,(height/2)-6.4])
    scale([0.05,0.05,0.05])
    rotate([0,-90,-90]) 
    press_fit_clasp();

    translate([0,0,(height/2)+diameter+1])
    rotate([90,0,0])
    bale(bale_id,bale_od,bale_w);

//    translate([-1*bump*((diameter+outerD)/2),0,height/2])
//    rotate([90,0,0])
//    makeDoubleClasp(innerD,outerD,(diameter/2),shrink);

}

module makeSingleClasp(innerD,outerD,length,shrink)
{
    difference(){
        final_length = (length/3)*(1-shrink);
        cylinder(h = final_length, r1 = outerD, r2=outerD, center = true,$fn=72);
        cylinder(h = final_length, r1 = innerD, r2=innerD, center = true,$fn=72);
    }
}

module makeDoubleClasp(innerD,outerD,length,shrink)
{
    // derive diameter to side length
//    a = d/2
//    p = 6*a 
//    p = 6*d/2
//    p = 3*d
//    s = p/6
//    p = 6*s
//    3*d = 6*s
//    3*d/6 = s
//    d/2 = s 
    difference(){
        difference(){
            cylinder(h = length, r1 = outerD, r2=outerD, center = true,$fn=72);
            cylinder(h = length, r1 = innerD, r2=innerD, center = true,$fn=72);
        }
        cube([length,length,length/3],center=true);
    }
}

module makeTopPyramid(diameter)
{
    minkowski(){
        scale([diameter/2,diameter/2,diameter/2])
        difference(){
            import("hexdipy.stl", convexity=3);
            translate([0,0,-1])
            cube([3,3,2],center=true);
        }
        sphere(smooth);
    }
}

module makeBottomPyramid(diameter)
{
    minkowski(){
        scale([diameter/2,diameter/2,diameter/2])
        difference(){
            import("hexdipy.stl", convexity=3);
            translate([0,0,+1])
            cube([3,3,2],center=true);
        }
        sphere(smooth);
    }
}


module hex(cle)
{
	angle = 360/6;		// 6 pans
	cote = cle * cot(angle);
	union()
	{
		rotate([0,0,0])
			square([cle,cote],center=true);
		rotate([0,0,angle])
			square([cle,cote],center=true);
		rotate([0,0,2*angle])
			square([cle,cote],center=true);
	}
}   


module makeCageWithBars(count,width,height,cageSz)
{
    union(){
        minkowski(){    
            step = height/(count+1);
            union(){
                makeCage(width,height,cageSz);
                for(i=[-(height/2)+step:step:(height/2)-step]){
                    echo(i);
                    translate([0,0,i])
                    makeBar(width,cageSz);
                }
            }
            sphere(smooth);
    }
    translate([0,0,(-height/2)])
    makeBottomPyramid(diameter);
    }
}

module makeBar(width,cageSz)
{
    union(){
        for (i=[0:60:360]){
            rotate([0,0,i])
            translate([width/2-cageSz/4,,0])
            cube(size = [cageSz/2,width/2,(cageSz/2)], center = true);
        }
    }
}

module makeCage(width,height,cageSz)
{
    difference(){
        buildHexRod(width,height,cageSz);
        for (i=[0:60:360]){
            rotate([0,0,i])
            translate([width/2,0,0])
            cube(size = [width/2,(width-cageSz)/2,height-(2*cageSz)],      center = true);
        }
    }
}

module buildHexRod(width,height,cageSz)
{
    difference()
    {
        hexagon(cle=width,h=height);
        hexagon(cle=width-cageSz,h=height+2);
    }
}

module press_fit_clasp()
{
    c_l = 200; // total length
    c_d = 40; // total width
    c_m = 110; // mount depth
    c_w = 10; // width of actual bar
    c_p = 20; // point length
    c_s = 20; // the point slope controller 
    c_b = 20; // bumpy ledge that holds
    smooth = 0;
    minkowski(){
        linear_extrude(height = 30, center = true, convexity = 10, twist = 0)
        minkowski()
        {
            polygon(points=[[0,0],[c_l,0],[c_l,c_d],[(c_l-c_m),c_d],[(c_l-c_m),c_w],[c_p,c_w],[c_p,c_w+c_b],[0,c_s]]);
            circle(3);
        }
    sphere(3);
    }
}

module bale(id,od,width){
 
    smoother = 0.1*id;
 //       minkowski(){
            
            linear_extrude(height = width, center = true)
            difference(){
                circle(od,center=true);
                circle(id,center=true);
            }
//            sphere(smoother);
//       }
}

module hexagon(cle,h)
{
	angle = 360/6;		// 6 pans
	cote = cle * cot(angle);
	union()
	{
		rotate([0,0,0])
			cube([cle,cote,h],center=true);
		rotate([0,0,angle])
			cube([cle,cote,h],center=true);
		rotate([0,0,2*angle])
			cube([cle,cote,h],center=true);
	}

}


function cot(x)=1/tan(x);

