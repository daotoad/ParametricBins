height=46.9;
topWidth=39;
topDepth=54.3;
bottomScale=0.95;
cornerRadius=4;
wallThickness=1;
footHeight=2;

module hemisphere ( r ) {
    difference() {
        sphere(r=r);
        translate( [0, 0, r]) {
            cube( 2 * r, center=true );
        }
    }
}


module binBody ( topWidth, topDepth, bottomWidth, bottomDepth, height, cornerRadius ) {

    tW  = topWidth - 2*cornerRadius;
    tD  = topDepth - 2*cornerRadius;
    bW  = bottomWidth - 2*cornerRadius;
    bD  = bottomDepth - 2*cornerRadius;
    h   = height - 1*cornerRadius;
    cR  = cornerRadius;
    vT  = cornerRadius;

    echo( "Body ---------" );
    echo( "Top: ", tW, " x ", tD );
    echo( "Bottom: ", bW, " x ", bD );
    echo ("Height: ", h );
    echo ("Corner: ", cR );
    echo ("Vertical Shift: ", vT );


    binPoints = [
        [  0-bW/2,   bD/2, 0 ],
        [    bW/2,   bD/2, 0 ],
        [    bW/2, 0-bD/2, 0 ],
        [  0-bW/2, 0-bD/2, 0 ],

        [ 0-tW/2,   tD/2, h ],
        [   tW/2,   tD/2, h ],
        [   tW/2, 0-tD/2, h ],
        [ 0-tW/2, 0-tD/2, h ],
    ];

    binFaces = [
        [0,1,2,3],  // bottom
        [4,5,1,0],  // front
        [7,6,5,4],  // top
        [5,6,2,1],  // right
        [6,7,3,2],  // back
        [7,4,0,3]   // left
    ];

    translate([0,0,vT ]) {
      minkowski() {
        hemisphere(r=cR, $fn=40);
        polyhedron( binPoints, binFaces );
      }
    }
}


module bin( width, depth, height, taper, radius, wallThickness, footHeight ) {
    tW  = width;
    tD  = depth;
    bW  = taper * width;
    bD  = taper * depth;
    h   = height;
    cR  = radius;
    
    iTW = width - 2 * wallThickness;
    iTD = depth - 2 * wallThickness;
    iBW = bW - 2 * wallThickness;
    iBD = bD - 2 * wallThickness;
    iH  = height;  // leave long to ensure clean opening at top.
    iCR = cR ;//- wallThickness;
    iVT = wallThickness;
  
    echo( " -------- OUTER ------ " );
    echo( "Top: ", tW, " x ", tD, " Bottom: ", bW, " x ", bD );
    echo( "Height: ", h, " Corner Radius: ", cR );
    echo( "Foot Height: ", footHeight );
    echo( " -------- INNER ------ " );
    echo( "Top: ", iTW, " x ", iTD, " Bottom: ", iBW, " x ", iBD );
    echo( "Height: ", iH, " Corner Radius: ", iCR );
        
    difference() {
        binOuter( topWidth=tW,   topDepth=tD, bottomWidth=bW, bottomDepth=bD, height=height, cornerRadius=cR, footThickness=wallThickness, footHeight=footHeight );
         translate([0,0,iVT]){
            binBody( topWidth=iTW, topDepth=iTD, bottomWidth=iBW, bottomDepth=iBD, height=iH+10, cornerRadius=iCR );
        }
    }
    
}



module binOuter (topWidth, topDepth, height, bottomDepth, cornerRadius, wallThickness, footHeight, footThickness) {
    tW  = topWidth;
    tD  = topDepth;
    bW  = bottomWidth;
    bD  = bottomDepth;
    h   = height;
    cR  = cornerRadius;
    fH  = footHeight;
    fT  = footThickness;
    fLW = bW/2 - 1*cR;
    fLD = bD/2 - 1*cR;
    
    echo( "  @@@@ OUTER @@@@  " );
    echo( "Top: ", tW, " x ", tD, " Bottom: ", bW, " x ", bD );
    echo( "Height: ", h, " Corner Radius: ", cR );
    echo( "Foot Height: ", fH, " Foot Thickness: ", fT );

    

    binBody( topWidth=tW, topDepth=tD, bottomWidth=bW, bottomDepth=bD, height=height, cornerRadius=cR );
    translate ([  fLW,  fLD, -fH ]) rotate(135) foot( r=cR, h=footHeight*2, wall=footThickness );
    translate ([ -fLW,  fLD, -fH ]) rotate(-135) foot( r=cR, h=footHeight*2, wall=footThickness );
    translate ([  fLW, -fLD, -fH ]) rotate(45) foot( r=cR, h=footHeight*2, wall=footThickness );
    translate ([ -fLW, -fLD, -fH ]) rotate(-45) foot( r=cR, h=footHeight*2, wall=footThickness );
    
}


module footShape( r ) {
    base = .9 * sqrt(2) * r;

    hull( $fn=30) {
        square( size=[ base, base/2 ], center=true);
        translate( [ base/2, 0, 0] ) circle( r=base/4 );
        translate( [ -base/2, 0, 0] ) circle( r=base/4 );
    
        translate([0,r/4,0]) {
            rotate (45) difference() {
                translate( [ 0, 0, 0 ] )circle( r=r );
                translate( [ -base, 0, 0 ] )square( 2*base );
                translate( [ 0, -base, 0 ] )square( 2*base );
            }
        }
    }       
}


module foot( r, h, wall ) {
    linear_extrude( height=h ) {
       // difference() {
            footShape( r=r );
       //     offset( - wall ) { footShape( r=r );}
       // }
    }
}


bin(
    width  = topWidth, 
    depth  = topDepth,
    height = height,
    taper  = bottomScale,
    radius = cornerRadius,
    wallThickness = wallThickness,
    footHeight = footHeight
);
