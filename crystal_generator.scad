// http://kitwallace.co.uk/3d/solid-index.xq?mode=solid&id=HexagonalPrism
//  http://kitwllace.co.uk/3d/solid-index.xq?mode=solid&id=HexagonalDipyramid
// hexdipy needs the face thickness to be set to ( cage size / diameter ) * 2 to render correctly eg (5/50)*2 and then scaled to unit length. 

//openface(solid_1,outer_inset_ratio=0.3,inner_inset_ratio=0.2,depth=0.1,fn=[]);
//

// All dimensions are (sz/10) = mm
// I.E. Everything is in tenths of mm
// Overal dimensions 
cageSz = 20; // the thickness of the bars --->fix
diameter = 90; //87; // overall inner diameter 
height = 350; // total lenght of the straight hexagnoal part
count = 3; // number of bars down the body 
high_def = 48;
low_def = 24;
// hinge params THIS IS RADIUS
innerD = 7; // 16 gauge is 1.291mm // hinge ID
outerD = innerD+8; // hinge OD
diff = 0.9*((outerD-innerD)/2);

shrink = 0.03;
bump = 1.002;
smooth =  0.1; // Minkowski value 

// Bale params 
bale_id = 5;
bale_od = 5+8;
bale_w = 8;

pin_w = 8;
pin_h = 8;
pin_d = 10;
$fn = 36; //36



//$fn=low_def;
//color([1,0,0]) 
//cylinder(h = height, r1 = 42, r2 = 42, center = true);

translate([-((diameter/2)+18),0,(height/4)])
sphere(d=20);

union()
{
    // difference(){
    //    makeCageWithBars(count,diameter,height,cageSz);
    //    sf = 1.3;
    //    translate([(-(diameter+cageSz)/2),0,(height/2)-(pin_h/2)])
    //    makePin(cageSz*3,sf*pin_w,sf*pin_h);
    // }

    //rotate([90,45,0])
    difference(){
        makeCageWithBars(count,diameter,height,cageSz);
        translate([(outerD+((diameter+cageSz)/2))-diff,0,(height/2)]) 
        rotate([90,45,0])
        cylinder(diameter/2,outerD,outerD,center=true);
    }
    
    
    translate([(outerD+((diameter+cageSz)/2))-diff,0,(height/2)])
    rotate([90,0,0])
    makeDoubleClasp(innerD,outerD,1.4*(diameter/2),shrink);
    
    // reinforcemnet for DRC
    translate([0,0,-(height/2+diameter-15)])
    cylinder(h = 10, r1=diameter*0.1, r2=diameter*0.1, 
             center = true, $fn=low_def);

//    translate([-1*((diameter/2)+cageSz),0,height/2])
//    sphere(10,center=true);

}
//rotate([0,10,0])
translate([0,0,40])
//translate([0,0,0])

union(){
    union(){
        difference(){
            translate([0,0,height/2])        
            makeTopPyramid(diameter,cageSz);
            translate([(outerD+((diameter+cageSz)/2))-diff,0,(smooth+(height/2))-3])
            rotate([90,45,0])
            cylinder(diameter,0.99*outerD,0.99*outerD,center=true);
        }
    
        // From prints the top clasp needs to be moved down a bit
        translate([(outerD+((diameter+cageSz)/2))-diff,0,(smooth+(height/2))-3])
        rotate([90,0,0])
        makeSingleClasp(innerD,outerD,diameter/2,shrink);
        wireSz = 10;
        translate([-((diameter/2)+(1.5*wireSz)),(diameter/2)*0.45,(height/2)+(  wireSz*0.85)])
        rotate([0,-90,0])
        wireClaspMount(10,diameter/5);

        translate([-((diameter/2)+(1.5*wireSz)),-(diameter/2)*0.45,(height/2)+( wireSz*0.85)])
        rotate([0,90,180])
        wireClaspMount(10,diameter/5);

    }
    // translate([-7+-(cageSz+diameter)/2,0,(height/2)-cageSz-4.3])
    // rotate([0,-90,-90]) 
    // press_fit_clasp();

    // translate([0,0,(height/2)+diameter+cageSz+(bale_od*0.8)])
    // rotate([90,0,90])
    // bale(bale_id,bale_od,bale_w);

    // translate([(-(cageSz+diameter)/2)+(pin_d/2),0,(height/2)-(pin_h/2)])
    // makePin(pin_d,pin_w,pin_h);

    // reinforcemnet for DRC    
    translate([0,0,height/2+diameter-15])
    cylinder(h = 10, r1=diameter*0.1, r2=diameter*0.1, 
             center = true, $fn=low_def);

    
    // Part of a wire press latch
//    translate([-1*bump*((diameter+outerD)/2),0,height/2])
//    rotate([90,0,0])
//    makeDoubleClasp(innerD,outerD,(diameter/2),shrink);

}

module wireClaspMount(wireD,mountL)
{
    wallThickness = 7; // size of the bit caps the wire tube
    newD = wallThickness+wireD;
    rotate([0,-90,90])
    difference(){
            union(){
                cylinder(h=mountL,r1=newD/2, r2=newD/2, center=true);
                translate([-newD/2,0,0])
                cube([newD,newD,mountL], center=true);
            }
            translate([0,0,wallThickness])
            cylinder(h=mountL,r1=wireD/2, r2=wireD/2, center=true);
    }
}
module makePin(pin_w,pin_h,pin_d)
{
   minkowski(){
        smoother = 0.05;
        smoother_inv = 1-smoother;
        pd = smoother_inv*pin_d;
        pw = smoother_inv*pin_w;
        ph = smoother_inv*pin_h;
        cube([pw,ph,pd],center=true);
        sphere([smoother,smoother.smoother]);
    }
}

module makeSingleClasp(innerD,outerD,length,shrink)
{
    difference(){
        final_length = (length/3)*(1-shrink);
        cylinder(h = final_length, r1 = outerD, r2=outerD, center = true,$fn=high_def);
        cylinder(h = final_length, r1 = innerD, r2=innerD, center = true,$fn=high_def);
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
            cylinder(h = length, r1 = outerD, r2=outerD, center = true,$fn=low_def);
            cylinder(h = length, r1 = innerD, r2=innerD, center = true,$fn= low_def);
        }
        cube([length,length,length/3],center=true);
    }
}

module makeTopPyramid(diameter,cageSz)
{
    minkowski(){
         s = (diameter+cageSz)/2;
        scale([s,s,s])
        difference(){
            import("hexdipy.stl", convexity=3);
            translate([0,0,-1])
            cube([3,3,2],center=true);
        }
        sphere(smooth);
    }
}

module makeBottomPyramid(diameter,cageSz)
{
    minkowski(){
         s = (diameter+cageSz)/2;
        scale([s,s,s])
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
    makeBottomPyramid(diameter,cageSz);
    }
}

module makeBar(width,cageSz)
{
    union(){
        for (i=[0:60:360]){
            rotate([0,0,i])
            translate([(width/2)+cageSz/4,0,0])
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
            translate([(width/2),0,0])
            cube(size = [width/2,(width-cageSz)/2,height-(2*cageSz)],      center = true);
        }
    }
}

module buildHexRod(width,height,cageSz)
{
    difference()
    {
        hexagon(cle=width+cageSz,h=height);
        hexagon(cle=width,h=height+2);
    }
}

module press_fit_clasp()
{
    c_m = 1; // mount depth     
    c_p = 4; // point length

    c_l = 20.5+c_m+c_p; // total length
    c_d = 10; // total width
    c_w = 6; // width of actual bar
    c_s = 12; // the point slope controller 
    c_b = 6; // bumpy ledge that holds
    smooth = 0;
    $fn = low_def;
    minkowski(){
        linear_extrude(height = 10, center = true, convexity = 10, twist = 0)
        minkowski()
        {
            polygon(points=[[-2,0],[c_l,0],[c_l,c_d],[(c_l-c_m),c_d],[(c_l-c_m),c_w],[c_p,c_w],[c_p,c_w+c_b],[-2,c_s]]);
            circle(0.1);
        }
    sphere(0.1);
    }

}

module bale(id,od,width){
 
    smoother = 0.1*id;
        minkowski(){
            linear_extrude(height = width, center = true)
            difference(){
                $fn = high_def;     
                circle(od,center=true);
                circle(id,center=true);
            }
            $fn = low_def;     
            sphere(smoother);
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

