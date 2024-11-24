using CSV
using DataFrames
using CairoMakie

function calculate_regression_line(x_data, y_data)
  x̄, ȳ = sum(x_data)/length(x_data), sum(y_data)/length(y_data)
  slope = sum([(x - x̄) * (y - ȳ) for (x, y) in zip(x_data, y_data)]) / sum([(x - x̄)^2 for x in x_data])
  intercept = ȳ - slope * x̄
  return slope, intercept
end


function create_graph(file_path::String, output_path::String, x_column_index::Int = 2, y_column_index::Int = 3; title="", xlabel="", ylabel="", subtitle="")
    data_frame = DataFrame(CSV.File(file_path))
    x_data = data_frame[:, x_column_index]
    y_data = data_frame[:, y_column_index]
    data_points = Point2f.(x_data, y_data)
    
    slope, intercept = calculate_regression_line(x_data, y_data)
    
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
