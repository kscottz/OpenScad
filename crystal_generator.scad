// http://kitwallace.co.uk/3d/solid-index.xq?mode=solid&id=HexagonalPrism
//  http://kitwllace.co.uk/3d/solid-index.xq?mode=solid&id=HexagonalDipyramid
// hexdipy needs the face thickness to be set to ( cage size / diameter ) * 2 to render correctly eg (5/50)*2 and then scaled to unit length. 

// Current Set 
//cageSz = 5;
//diameter = 50;
//height = 200;
//count = 3;
//solid_2 = openface(solid_1,outer_inset_ratio=0.3,inner_inset_ratio=0.2,depth=0.1,fn=[]);
// 
cageSz = 5;
diameter = 50;
height = 200;
count = 3;
innerD = 0.75;
outerD = 1.5;
shrink = 0.03;
bump = 1.002;


union()
{
    makeCageWithBars(count,diameter,height,cageSz);
    translate([(bump*(diameter+outerD)/2),0,height/2])
    rotate([90,0,0])
    makeDoubleClasp(innerD,outerD,(diameter/2),shrink);
}

rotate([0,10,0])
translate([-18,0,15])
union(){
    translate([0,0,height/2])
    makeTopPyramid(diameter);
    translate([bump*((diameter+outerD)/2),0,height/2])
    rotate([90,0,0])
    makeSingleClasp(innerD,outerD,diameter/2,shrink);
    translate([-1*bump*((diameter+outerD)/2),0,height/2])
    rotate([90,0,0])
    makeDoubleClasp(innerD,outerD,(diameter/2),shrink);

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
    scale([diameter/2,diameter/2,diameter/2])
    difference(){
        import("hexdipy.stl", convexity=3);
        translate([0,0,-1])
        cube([3,3,2],center=true);
    }
}

module makeBottomPyramid(diameter)
{
    scale([diameter/2,diameter/2,diameter/2])
    difference(){
        import("hexdipy.stl", convexity=3);
        translate([0,0,+1])
        cube([3,3,2],center=true);
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
    step = height/(count+1);
    union(){
        makeCage(width,height,cageSz);
        for(i=[-(height/2)+step:step:(height/2)-step]){
            echo(i);
            translate([0,0,i])
            makeBar(width,cageSz);
        }
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
    union(){
        difference()
        {
            buildHexRod(width,height,cageSz);
            for (i=[0:60:360]){
                rotate([0,0,i])
                translate([width/2,0,0])
                cube(size = [width/2,(width-cageSz)/2,height-(2*cageSz)],          center = true);
            }
        }
        
    translate([0,0,(-height/2)])
    makeBottomPyramid(diameter);
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

