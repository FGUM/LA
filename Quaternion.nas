#
# Authors: Axel Paccalin.
#
# Version 0.1
#

EULER_ORDER = {
    # The following axes orders are written in the mathematical multiplicative order. 
    ZYX: 0,  #<! Usual aircraft order : roll first (X) then pitch (Y), then yaw (Z).
};

Quaternion = {   
    xAxis: Vector.new([1, 0, 0]),
    yAxis: Vector.new([0, 1, 0]),
    zAxis: Vector.new([0, 0, 1]),
    
    #! brief:     : Array based constructor.
    #! param data : 4d-Complex coordinates of the quaternion (x, i, j, k).   
	new: func (data=nil) {
		var me = {parents: [Quaternion]};
		
		# Init member.
		me.data = data != nil ? data : [1, 0, 0, 0];
		
		return me;
	},
	
	quatMult: func(other){
	    return Quaternion.new([
	       -me.data[1]*other.data[1] - me.data[2]*other.data[2] - me.data[3]*other.data[3] + me.data[0]*other.data[0],
	        me.data[1]*other.data[0] + me.data[2]*other.data[3] - me.data[3]*other.data[2] + me.data[0]*other.data[1],
	       -me.data[1]*other.data[3] + me.data[2]*other.data[0] + me.data[3]*other.data[1] + me.data[0]*other.data[2],
	        me.data[1]*other.data[2] - me.data[2]*other.data[1] + me.data[3]*other.data[0] + me.data[0]*other.data[3]]);
	},
	
	conjugate: func(){
	    return Quaternion.new([me.data[0], -me.data[1], -me.data[2], -me.data[3]]);
	},
	
	magnitude: func(){
	    return math.sqrt(
	        math.pow(me.data[0],2)
	       +math.pow(me.data[1],2)
	       +math.pow(me.data[2],2)
	       +math.pow(me.data[3],2));
	},
	
	normalize: func(){
	    var mag = me.magnitude();
	    
	    me.data[0] /= mag; 
	    me.data[1] /= mag; 
	    me.data[2] /= mag; 
	    me.data[3] /= mag;
	    
	    return me; 
	},
	
	# Compute a rotation around 3 relatives axes
	threeAxisRotation: func(r11, r12, r21, r31, r32){
        return [math.atan2(r31, r32),
                math.asin(r21),
                math.atan2(r11, r12)];
    },
	
    toEuler: func(order=nil){
        order = order != nil ? order : EULER_ORDER.ZYX; 
        
        # Pre-compute values to avoid multiple computation & lighten syntax;
        var xx = me.data[0] * me.data[0];
        var xi = me.data[0] * me.data[1];
        var wk = me.data[0] * me.data[2];
        var wz = me.data[0] * me.data[3];
        var ii = me.data[1] * me.data[1];
        var ij = me.data[1] * me.data[2];
        var ik = me.data[1] * me.data[3];
        var jj = me.data[2] * me.data[2];
        var jk = me.data[2] * me.data[3];
        var kk = me.data[3] * me.data[3];
        
        
        if(order == EULER_ORDER.ZYX)
            return me.threeAxisRotation(2*(ij + wz),
                                        xx + ii - jj - kk,
                                        -2*(ik - wk),
                                        2*(jk + xi),
                                        xx - ii - jj + kk);
        else
            Die("The requested euler order is either invalid or not implemented");
    },
    
    # !WARNING! The vector parameter is expected to be normalized and not tested to save runtime!
    fromVectorAngle: func(vec, theta){
        theta /= 2;
        
        var st = math.sin(theta);
        var result = Quaternion.new();
        
        result.data[0] = math.cos(theta);
        result.data[1] = vec[0] * st;
        result.data[2] = vec[1] * st;
        result.data[3] = vec[2] * st;
        
        return result;
    },
    
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
};
