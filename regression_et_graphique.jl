import Pkg; Pkg.add(["CSV", "DataFrames", "CairoMakie"])
using CSV
using DataFrames
using CairoMakie

function linear_regression(x_data::Vector{R}, y_data::Vector{R}) where R <: Real
  
  length_x, length_y = length(x_data), length(y_data)
  length_x !== length_y ? throw(ArgumentError("X and Y must have the same length.")) : nothing
  length_x == 0 ? throw(ErrorException("Either X or Y is empty")) : nothing

  if length_x == 1
      return 0.0, y_data[1]
  end

  x̄, ȳ = sum(x_data) / length_x, sum(y_data) / length_y
  
  denominator = sum([(x - x̄)^2 for x in x_data])
  denominator == 0 ? throw(DivideError("The denominator can't be equal to zero")) : nothing

  slope = sum([(x - x̄) * (y - ȳ) for (x, y) in zip(x_data, y_data)]) / denominator
  intercept = ȳ - slope * x̄

  return slope, intercept
end

find_theoritical_value(x, intercept, slope) = x*slope + intercept


function create_graph(file_path::String, output_path::String, x_column_index::Int = 2, y_column_index::Int = 3; title="", xlabel="", ylabel="", subtitle="")
    data_frame = DataFrame(CSV.File(file_path))
    x_data = data_frame[:, x_column_index]
    y_data = data_frame[:, y_column_index]
    data_points = Point2f.(x_data, y_data)
    
    slope, intercept = linear_regression(x_data, y_data)
    
    fig = Figure()
    axis = Axis(fig[1, 1],
        xlabel = xlabel,
        ylabel = ylabel,
        title = title,
        subtitle = subtitle,
        xticks = 0:50:600,
        yticks = 1000:500:5000)
    
    scatter!(axis, data_points)
    ablines!(axis, intercept, slope, label = "Droite de régression")
    axislegend(axis, position = :rb)
    CairoMakie.save(output_path, fig)
end
