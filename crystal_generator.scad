makeCage(50,200,5);

module makeCage(width,height,cageSz)
{
    difference()
    {
        buildHexRod(width,height,cageSz);
        for (i=[0:60:360]){
            rotate([0,0,i])
            translate([20,0,0])
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
	echo(angle, cot(angle), cote);
	echo(acos(.6));

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

