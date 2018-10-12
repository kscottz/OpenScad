// http://kitwallace.co.uk/3d/solid-index.xq?mode=solid&id=HexagonalPrism
//  http://kitwallace.co.uk/3d/solid-index.xq?mode=solid&id=HexagonalDipyramid
// hexdipy needs to ( cage size / diameter face depth ) * 2 
cageSz = 5;
diameter = 50;
height = 200;
count = 5;

makeCageWithBars(count,diameter,height,cageSz);

translate([0,0,height/2])
scale([diameter/2,diameter/2,diameter/2])
import("hexdipy.stl", convexity=3);

translate([0,0,-height/2])
scale([diameter/2,diameter/2,diameter/2])
import("hexdipy.stl", convexity=3);

    
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
        for(i=[-height/2:step:height/2]){
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
            cube(size = [cageSz/2,width/2,cageSz/2], center = true);
        }
    }
}

module makeCage(width,height,cageSz)
{
    difference()
    {
        buildHexRod(width,height,cageSz);
        for (i=[0:60:360]){
            rotate([0,0,i])
            translate([width/2,0,0])
            cube(size = [width/2,(width-cageSz)/2,height-(2*cageSz)], center = true);
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

