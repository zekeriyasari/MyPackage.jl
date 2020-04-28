using MyPackage
using Test

@testset "MyPackage.jl" begin
    @test addone(2) == 3
end
