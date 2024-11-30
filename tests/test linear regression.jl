using Test

include("../regression_et_graphique.jl")

# Tests
@testset "linear_regression tests" begin
    # Test 1: Simple linear relationship
    x_data = [1, 2, 3, 4, 5]
    y_data = [2, 4, 6, 8, 10]
    slope, intercept = linear_regression(x_data, y_data)
    @test isapprox(slope, 2.0, atol=1e-6)
    @test isapprox(intercept, 0.0, atol=1e-6)

    # Test 2: Horizontal line
    x_data = [1, 2, 3, 4, 5]
    y_data = [3, 3, 3, 3, 3]
    slope, intercept = linear_regression(x_data, y_data)
    @test isapprox(slope, 0.0, atol=1e-6)
    @test isapprox(intercept, 3.0, atol=1e-6)

    # Test 3: Vertical line (should handle error gracefully)
    x_data = [3, 3, 3, 3, 3]
    y_data = [1, 2, 3, 4, 5]
    @test_throws DivideError linear_regression(x_data, y_data)

    # Test 4: Empty inputs
    x_data = Float64[]
    y_data = Float64[]
    @test_throws ErrorException linear_regression(x_data, y_data)

    # Test 5: Single data point
    x_data = [2.0]
    y_data = [5.0]
    slope, intercept = linear_regression(x_data, y_data)
    @test isapprox(slope, 0.0, atol=1e-6)
    @test isapprox(intercept, 5.0, atol=1e-6)

    # Test 6: Negative slope
    x_data = [1, 2, 3, 4, 5]
    y_data = [10, 8, 6, 4, 2]
    slope, intercept = linear_regression(x_data, y_data)
    @test isapprox(slope, -2.0, atol=1e-6)
    @test isapprox(intercept, 12.0, atol=1e-6)
end
