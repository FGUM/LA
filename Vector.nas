#
# Authors: Axel Paccalin.
#
# Version 0.2
#
# Imported under "FGUM_LA"
#

Vector = {
    #! \brief Vector constructor. 
    #! \param data: The raw data array of the vector (Array).
	new: func (data=nil) {
		var me = {parents: [Vector]};
		
		# Init member (default value is 3D null vector).
		me.data = data != nil ? data : [0, 0, 0];
		
		return me;
	},
	
    #! \brief  Unary - operator. 
    #! \return The negative (Vector).
	neg: func(){
	    return Vector.new([-me.data[0],
	                       -me.data[1],
	                       -me.data[2]]);
	},
	
    #! \brief  Vector-Vector + operator. 
    #! \param  other: The right hand side vector to add (Vector).
    #! \return The sum (Vector).
	vecAdd: func(other){
	    return Vector.new([me.data[x] + other.data[0],
	                       me.data[y] + other.data[1],
	                       me.data[z] + other.data[2]]);
	},
	
    #! \brief  Vector-Vector - operator. 
    #! \param  other: The right hand side vector to subtract (Vector).
    #! \return The difference (Vector).
	vecSub: func(other){
	    return Vector.new([me.data[0] - other.data[0],
	                       me.data[1] - other.data[1],
	                       me.data[2] - other.data[2]]);
	},
	
    #! \brief  Vector-Scalar * operator. 
    #! \param  other: The right hand side scalar to multiply with (Scalar).
    #! \return The product (Vector).
	scalarMult: func(scalar){
	    return Vector.new([me.data[0] * scalar,
	                       me.data[1] * scalar,
	                       me.data[2] * scalar]);
	},
	
    #! \brief  Vector-Vector cross product operator. 
    #! \param  other: The right hand side Vector to cross with (Vector).
    #! \return The cross product (Vector).
	cross: func(other){
	    return Vector.new([me.data[1] * other.data[2] - me.data[2] * other.data[1],
	                       me.data[2] * other.data[0] - me.data[0] * other.data[2],
	                       me.data[0] * other.data[1] - me.data[1] * other.data[0]]);
	},
	
    #! \brief  Vector-Vector dot product operator. 
    #! \param  other: The right hand side Vector to dot with (Vector).
    #! \return The dot product (Scalar).
	dot: func(other){
	    return me.data[0] * other.data[0]
	         + me.data[1] * other.data[1]
	         + me.data[2] * other.data[2];
	},
	
    #! \brief  Square magnitude computed accessor. 
    #! \return The square of the vector's magnitude (Positive scalar).
	squaredMagnitude: func(){
	    return math.pow(me.data[0],2)
	          +math.pow(me.data[1],2)
	          +math.pow(me.data[2],2);
	},
	
    #! \brief  Magnitude computed accessor. 
    #! \return The vector's magnitude (Positive scalar).
	magnitude: func(){
	    return math.sqrt(me.squaredMagnitude());
	},
	
    #! \brief Normalization method. 
	normalize: func(){
	    var mag = me.magnitude();
	    
	    me.data[0] /= mag; 
	    me.data[1] /= mag; 
	    me.data[2] /= mag; 
	    
	    return me; 
	},
	
    #! \brief   Orthogonal projection onto another vector. 
    #! \param   support: The support vector to project onto (Vector).
    #! \return  The orthogonal projection (Scalar).
	#! \Warning Can throw an exception if the support vector is null.
    orthogonalProjection: func(support){
        var supMag = support.magnitude();
        if(supMag == 0)
            die("Orthogonal projection on a null vector support");
        
        return me.dot(support) / supMag;
    },
};
