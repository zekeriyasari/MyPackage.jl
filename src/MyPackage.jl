module MyPackage

"""
    greet() 

Prints a greetin message. 
"""
greet() = print("Hello World!")


function some_test_function() end 

"""
    addone(x) 

Adds one to `x`.
"""
addone(x) = x + 1

struct Object end 

export greet, addone, Object

end # module
