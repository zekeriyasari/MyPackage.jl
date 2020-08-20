module MyPackage

"""
    greet() 

Prints a greetin message. 
"""
greet() = print("Hello World!")

# TODO: Test issue. @zekeriyasari

"""
    addone(x) 

Adds one to `x`.
"""
addone(x) = x + 1

struct Object end 

export greet, addone, Object

end # module
