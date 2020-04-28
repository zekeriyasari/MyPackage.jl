module MyPackage

"""
    greet() 

Prints a greetin message. 
"""
greet() = print("Hello World!")


"""
    addone(x) 

Adds one to `x`.
"""
addone(x) = x + 1

export greet, addone

end # module
