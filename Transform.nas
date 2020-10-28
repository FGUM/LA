#
# Authors: Axel Paccalin.
#
# Version 0.1
#

Transform3 = {
    #! brief : Constructor.
    new: func () {
        var me = {parents: [Transform3, Identity.new(4)]};
        return me;
    },
    
    apply: func(vec){
        if(size(vec) == me.rows -1){
            setsize(vec, me.rows);
            vec[me.rows-1] = 1;
        }
        if(size(vec) != me.rows)
            die("ArgumentException: 3D transform can only be applied to 3D vectors");
        
        return me.vecMult(vec);
    },
};

Translation3 = {
    new: func (vec) {
        if(vec.size < 3)
            die("3D translations can only be constructed from 3D vectors");
        var me = {parents: [Translation3, Transform3.new()]};
        
        me.data[me.cellId(0, 4)] = vec[0];  # | 1, 0, 0, Tx |
        me.data[me.cellId(1, 4)] = vec[1];  # | 0, 1, 0, Ty |
        me.data[me.cellId(2, 4)] = vec[2];  # | 0, 0, 1, Tz |
                                            # | 0, 0, 0, 1  |
                                            
        return me;
    },
};

Scale3 = {
    new: func (vec) {
        if(vec.size < 3)
            die("3D scales can only be constructed from 3D vectors");
        var me = {parents: [Scale3, Transform3.new()]};
        
        me.data[me.cellId(0, 0)] = vec[0];  # | Sx, 0,  0,  0 |
        me.data[me.cellId(1, 1)] = vec[1];  # | 0,  Sy, 0,  0 |
        me.data[me.cellId(2, 2)] = vec[2];  # | 0,  0,  Sz, 0 |
                                            # | 0,  0,  0,  1 |
        
        return me;
    },
};

Rotation3 = {
    new: func (quat) {
        # Unit Quaternion(x, i, j, k) to 3d (4*4) rotation matrix:
        # | 1-2(jj+kk),   2(ij-kx),   2(ik+jx), 0 |
        # |   2(ij+kx), 1-2(ii+kk),   2(jk-ix), 0 |
        # |   2(ik-jx),   2(jk+ix), 1-2(ii+jj), 0 |
        # |          0,          0,          0, 1 |
        var me = {parents: [Rotation3, Transform3.new()]};
        
        # pre-compute to reduce number of total computation needed
        var ii = quat.data[1] * quat.data[1];
        var ij = quat.data[1] * quat.data[2];
        var ik = quat.data[1] * quat.data[3];
        var ix = quat.data[1] * quat.data[0];

        var jj = quat.data[2] * quat.data[2];
        var jk = quat.data[2] * quat.data[3];
        var jx = quat.data[2] * quat.data[0];

        var kk = quat.data[3] * quat.data[3];
        var kx = quat.data[3] * quat.data[0];
            
        me.data = [1-2*(jj+kk),   2*(ij-kx),   2*(ik+jx), 0,
                     2*(ij+kx), 1-2*(ii+kk),   2*(jk-ix), 0,
                     2*(ik-jx),   2*(jk+ix), 1-2*(ii+jj), 0,
                     0,           0,           0,         1];
                     
        return me;
    },
};