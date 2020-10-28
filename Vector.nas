#
# Authors: Axel Paccalin.
#
# Version 0.1
#

Vector = {
    #! brief:     : Array based constructor.
    #! param data : 3D coordinates.   
	new: func (data=nil) {
		var me = {parents: [Vector]};
		
		# Init member (default value is 3D null vector).
		me.data = data != nil ? data : [0, 0, 0];
		
		return me;
	},
	
	neg: func(){
	    return Vector.new([-me.data[0],
	                       -me.data[1],
	                       -me.data[2]]);
	},
	
	vecAdd: func(other){
	    return Vector.new([me.data[x] + other.data[0],
	                       me.data[y] + other.data[1],
	                       me.data[z] + other.data[2]]);
	},
	
	vecSub: func(other){
	    return Vector.new([me.data[0] - other.data[0],
	                       me.data[1] - other.data[1],
	                       me.data[2] - other.data[2]]);
	},
	
	scalarMult: func(scalar){
	    return Vector.new([me.data[0] * scalar,
	                       me.data[1] * scalar,
	                       me.data[2] * scalar]);
	},
	
	magnitude: func(){
	    return math.sqrt(
	        math.pow(me.data[0],2)
	       +math.pow(me.data[1],2)
	       +math.pow(me.data[2],2));
	},
	
	normalize: func(){
	    var mag = me.magnitude();
	    
	    me.data[0] /= mag; 
	    me.data[1] /= mag; 
	    me.data[2] /= mag; 
	    
	    return me; 
	}
};
