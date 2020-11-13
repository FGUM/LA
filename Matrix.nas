#
# Authors: Axel Paccalin.
#
# Version 0.2
#
# Imported under "FGUM_LA"
#

Matrix = {
    #! \brief Matrix constructor. 
    #! \param rows: The amount of rows in the matrix (Strictly positive integer).   
    #! \param columns: The amount of columns in the matrix (Strictly positive integer).
    #! \param data: The raw data array of the matrix (Array)(must be of size rows*columns).
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
	
    #! \brief  Matrix cell id accessor. 
    #! \param  r: The row of the cell we want the ID of (Positive integer).   
    #! \param  c: The column of the cell we want the ID of (Positive integer).
    #! \return The array id of the cell (Positive integer).
	cellId: func(r, c){
	    return r * me.columns + c;
	},
	
	#! \brief  Matrix-Matrix multiplication operator. 
    #! \param  other: The right hand side Matrix to multiply with (Matrix).
    #! \return The resulting Matrix (Matrix).
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
	
	#! \brief  Matrix-Vector multiplication operator. 
    #! \param  vec: The right hand side Vector to multiply with (Array).
    #! \return The resulting Vector (Array).
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
	
	#! \brief  Matrix transpose unary operator. 
    #! \return The transposed matrix (Matrix).
	transpose: func(){
	    var result = Matrix.new(me.columns, me.rows);
	    
	    for(var r=0; r<me.rows; r+=1)
            for(var c=0; r<me.columns; c+=1)
                result.data[result.cellId(c, r)] = me.data[me.cellId(r, c)];
     
        return result;           
	},
};

# Matrix identity: (<In> as: [for any Mrc where c=n, Mrc * In = Mrc] and [for any Mrc where r=n, In * Mrc = Mrc]).
Identity = {
    #! \brief Matrix identity constructor. 
    #! \param dim: The identity dimension.   
    new: func(dim) {
        var me = {parents: [Quaternion, Matrix.new(dim, dim)]};
        
    	for(var i=0; i<dim; i+=1)
    	    me.data[me.cellId(i, i)] = 1;
        
        return me;
    },
};