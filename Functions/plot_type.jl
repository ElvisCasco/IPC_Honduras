function dynamic_plot(df, col_name, plot_type)
	Plots.plotly()
	base_plot(df, col_name, plot_type)
	ticks_dynamic(df)
end

function static_plot(df, col_name, plot_type)
	Plots.gr()
	base_plot(df, col_name, plot_type)
	ticks_static(df)
end

function ticks_dynamic(df)
	tick_years = Dates.Date.(df.Fechas)
	DateTick = Dates.format.(tick_years, "uuu-yyyy")
	Plots.plot!(
		xgrid = false,
		xticks = (tick_years, DateTick),
		framestyle = :zerolines,
		nticks = 1,
		#xrot=60,
		xtickfontsize = 1)
end

function ticks_static(df)
	tick_years = Dates.Date.(["2000","2005","2010","2015","2020"])
	DateTick = Dates.format.(tick_years, "yyyy")
	Plots.plot!(
		xticks = (tick_years, DateTick)
	)
end

function base_plot(df, col_name, plot_type)
	col_name = Symbol(col_name)
	plot_type = Symbol(plot_type)
	#Plots.plot!(
	Plots.plot(
			df.Fechas, 
		df[:, col_name],
		seriestype = plot_type,
		legend = false,
		label = String(col_name),
		title = String(col_name),
	)
end