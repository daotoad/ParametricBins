use <parametric-bin.scad>


module hf93929_small () {

    parametricBin(
        height        = 46.9,
        width         = 39,
        depth         = 54.3,
        taper         = 0.95,
        radius        = 4,
        wallThickness = 1,
        footHeight    = 2
    );

}

hf93929_small();
