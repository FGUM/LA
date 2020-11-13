#
# Authors: Axel Paccalin.
#
# Version 0.1
#

Matrix = {
    #! brief      : Array based constructor. 
    #! param data : 4d-Complex coordinates of the quaternion (x, i, j, k).   
	new: func(rows, columns, data=nil) {
		var me = {parents: [Matrix]};
		
		me.rows    = rows;
		me.columns = columns;
		
		# Either copy data if provided and valid, or initialize with zeroes
		if (data == nil){
		    me.data = [];
		    setsize(me.data, rows * columns);
		    foreach(cell; me.data)
		        cell = 0;
		} 
		else if(size(data) != rows * columns)
		    die("Raw data array has incorrect size: got (" ~ size(data) ~ ") expected (" ~ rows * columns ~ ")");
        else
            me.data = data;
		
		return me;
	},
	
	cellId: func(r, c){
	    return r * me.columns + c;
	},
	
	matMult: func(other){
	    if(me.columns != other.rows)
	        die("Argument Exception: Invalid matrix * matrix shape multiplication");
	        
	    var result = Matrix.new(me.rows, other.columns);

        for(var r=0; r<result.rows; r+=1)
            for(var c=0; c < result.columns; c+=1)
                for(var i=0; i < me.columns; i+=1)
                    result.data[result.cellId(r, c)] += me.data[me.cellId(r, i)] * other.data[other.cellId(i, c)];
                    
        return result;
	},
	
	vecMult: func(vec){
	    if(size(vec) != me.rows)
	        die("Argument Exception: Invalid vector * matrix shape multiplication");
        
        var result = [];
        setsize(result, me.rows);
        
        for(var r=0; r<me.rows; r+=1){
            result[r] = 0;
            for(var c=0; c<me.columns; c+=1)
                result[r] += me.data[me.cellId(r, c)] * vec[r];
        }
        
        return result;
	},
	
	transpose: func(){
	    var result = Matrix.new(me.columns, me.rows);
	    
	    for(var r=0; r<me.rows; r+=1)
            for(var c=0; r<me.columns; c+=1)
                result.data[result.cellId(c, r)] = me.data[me.cellId(r, c)];
     
        return result;           
	},
};

Identity = {
    new: func(dim) {
        var me = {parents: [Quaternion, Matrix.new(dim, dim)]};
        
    	for(var i=0; i<dim; i+=1)
    	    me.data[me.cellId(i, i)] = 1;
        
        return me;
    },
};