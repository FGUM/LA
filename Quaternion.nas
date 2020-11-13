#
# Authors: Axel Paccalin.
#
# Version 0.2
#
# Imported under "FGUM_LA"
#

EULER_ORDER = {
    # The following axes orders are written in the mathematical multiplicative order. 
    ZYX: 0,  #<! Usual aircraft order : roll first (X) then pitch (Y), then yaw (Z).
};

Quaternion = {   
    xAxis: Vector.new([1, 0, 0]),
    yAxis: Vector.new([0, 1, 0]),
    zAxis: Vector.new([0, 0, 1]),
    
    #! \brief Array based constructor.
    #! \param data: 4d-Complex coordinates of the quaternion (x, i, j, k) (Array).   
	new: func (data=nil) {
		var me = {parents: [Quaternion]};
		
		# Init member.
		me.data = data != nil ? data : [1, 0, 0, 0];
		
		return me;
	},
	
	#! \brief  Quaternion-Quaternion multiplication operator. 
    #! \param  other: The right hand side Quaternion to multiply with (Quaternion).
    #! \return The resulting Quaternion (Quaternion).
	quatMult: func(other){
	    return Quaternion.new([
	       -me.data[1]*other.data[1] - me.data[2]*other.data[2] - me.data[3]*other.data[3] + me.data[0]*other.data[0],
	        me.data[1]*other.data[0] + me.data[2]*other.data[3] - me.data[3]*other.data[2] + me.data[0]*other.data[1],
	       -me.data[1]*other.data[3] + me.data[2]*other.data[0] + me.data[3]*other.data[1] + me.data[0]*other.data[2],
	        me.data[1]*other.data[2] - me.data[2]*other.data[1] + me.data[3]*other.data[0] + me.data[0]*other.data[3]]);
	},
	
	#! \brief  Unary conjugate operator. 
    #! \return The conjugate (Quaternion).
	conjugate: func(){
	    return Quaternion.new([me.data[0], -me.data[1], -me.data[2], -me.data[3]]);
	},
	
	#! \brief  Magnitude computed accessor. 
    #! \return The magnitude (Positive scalar).
	magnitude: func(){
	    return math.sqrt(
	        math.pow(me.data[0],2)
	       +math.pow(me.data[1],2)
	       +math.pow(me.data[2],2)
	       +math.pow(me.data[3],2));
	},
	
	#! \brief normalization method. 
	normalize: func(){
	    var mag = me.magnitude();
	    
	    me.data[0] /= mag; 
	    me.data[1] /= mag; 
	    me.data[2] /= mag; 
	    me.data[3] /= mag;
	    
	    return me; 
	},
	
	# Compute a rotation around 3 relatives axes
	
	#! \brief  Compute a rotation around 3 relatives axes. 
    #! \return The the 3 rotations (Array).
	threeAxisRotation: func(r11, r12, r21, r31, r32){
        return [math.atan2(r31, r32),
                math.asin(r21),
                math.atan2(r11, r12)];
    },
		
	#! \brief  Convert the quaternion to Euler angles. 
    #! \param  order: Axis order used for the Euler representation (EULER_ORDER).  
    #! \return The euler angles (Array).
    toEuler: func(order=nil){
        order = order != nil ? order : EULER_ORDER.ZYX; 
        
        # Pre-compute values to avoid multiple computation & lighten syntax;
        var xx = me.data[0] * me.data[0];
        var xi = me.data[0] * me.data[1];
        var xj = me.data[0] * me.data[2];
        var xk = me.data[0] * me.data[3];
        var ii = me.data[1] * me.data[1];
        var ij = me.data[1] * me.data[2];
        var ik = me.data[1] * me.data[3];
        var jj = me.data[2] * me.data[2];
        var jk = me.data[2] * me.data[3];
        var kk = me.data[3] * me.data[3];
        
        
        if(order == EULER_ORDER.ZYX)
            return me.threeAxisRotation(2*(ij + xk),
                                        xx + ii - jj - kk,
                                        -2*(ik - xj),
                                        2*(jk + xi),
                                        xx - ii - jj + kk);
        else
            Die("The requested euler order is either invalid or not implemented");
    },
    
    #! \brief   Create a quaternion from a rotation angle around an arbitrary axis. 
    #! \param   vec: The support vector (axis) for the rotation (Array).  
    #! \param   theta: The rotation angle around the support vector (Radian).  
    #! \return  The resulting Quaternion (Quaternion).
    #! \warning The vector parameter is expected to be normalized and not tested to save runtime!
    fromAxisAngle: func(vec, theta){
        theta /= 2;
        
        var st = math.sin(theta);
        var result = Quaternion.new();
        
        result.data[0] = math.cos(theta);
        result.data[1] = vec[0] * st;
        result.data[2] = vec[1] * st;
        result.data[3] = vec[2] * st;
        
        return result;
    },
    
    #! \brief   Generate a quaternion from Euler angles.
    #! \param   data: The Euler angles (Array).  
    #! \param   order: Axis order used for the Euler representation (EULER_ORDER).
    #! \return  The resulting Quaternion (Quaternion).
    fromEuler: func(data, order=nil){
        order = order != nil ? order : EULER_ORDER.ZYX; 
        
        var xRotation = Quaternion.fromAxisAngle(Quaternion.xAxis.data, data[0]);
        var yRotation = Quaternion.fromAxisAngle(Quaternion.yAxis.data, data[1]);
        var zRotation = Quaternion.fromAxisAngle(Quaternion.zAxis.data, data[2]);
        
                
        if(order == EULER_ORDER.ZYX)
            return        zRotation
                .quatMult(yRotation
                .quatMult(xRotation));
        else
            die("The requested euler order is either invalid or not implemented");
    },
    
    #! \brief   Generate a quaternion from a vector. 
    #! \param   dir: The vector which direction we want to convert to a quaternion (Vector).
    #! \return  The resulting Quaternion (Quaternion).
    fromDirection: func(dir){
        var vec = Vector.new(dir).normalize();
        
        var axis  = Quaternion.xAxis.cross(vec);
        
        if (axis.squaredMagnitude() == 0)
            axis = Quaternion.yAxis;
        else
            axis.normalize();
        
        var angle = math.acos(Quaternion.xAxis.dot(vec));
        
        return Quaternion.fromAxisAngle(axis.data, angle);
    },
};
