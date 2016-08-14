use <parametric-bin.scad>

module hf93929_bin ( rows, columns ) {


    spacer = 1.3;
    colDim = 54.3;
    rowDim = 39;

    parametricBin(
        height        = 46.9,
        width         = columns * colDim,
        depth         = rows * rowDim,
        taper         = 0.95,
        radius        = 4,
        wallThickness = 1,
        footHeight    = 2
    );

}

module hf93929_small () {
  hf93929_bin( rows = 1, columns = 1 );
}

module hf93929_large () {
  hf93929_bin( rows = 2, columns = 1 );
}

translate ([ 100, 0, 0 ])hf93929_large();
hf93929_small();
