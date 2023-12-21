function sarima(x, seas, steps_ahead)
	## Logarithms
	#x = Base.log.(x)
	
	## SARIMA((0,1,1),(0,1,1))
	model_sarima = StateSpaceModels.SARIMA(
		x; 
		order = (0, 1, 1), 
		seasonal_order = (0, 1, 1, seas))
	StateSpaceModels.fit!(
		model_sarima; 
		save_hyperparameter_distribution = false)
	forec_sarima = StateSpaceModels.forecast(model_sarima, steps_ahead)
	#return Base.hcat(forec_sarima.expected_value...)

	df_sarima = DataFrames.DataFrame(
		Base.hcat(forec_sarima.expected_value...)', :auto)
	DataFrames.rename!(df_sarima, [:sarima])
	return df_sarima
end

function uc(x, seas, steps_ahead)
	## Logarithms
	#x = Base.log.(x)
	
	## Unobserved Components, Linear Trend, Seasonal
	model_uc = StateSpaceModels.UnobservedComponents(
		x; 
		trend = "local linear trend", 
		seasonal = "stochastic " * Base.string(seas))
	StateSpaceModels.fit!(
		model_uc; 
		save_hyperparameter_distribution = false)
	forec_uc = StateSpaceModels.forecast(model_uc, steps_ahead)
	df_uc = DataFrames.DataFrame(Base.hcat(forec_uc.expected_value...)', :auto)
	DataFrames.rename!(df_uc, [:uc])

	return df_uc
end

function ets(x, seas, steps_ahead)
	## Logarithms
	#x = Base.log.(x)
	
	## Exponential Smoothing
	model_ets = StateSpaceModels.ExponentialSmoothing(
		x; 
		trend = true, 
		seasonal = seas)
	StateSpaceModels.fit!(
		model_ets; 
		save_hyperparameter_distribution = false)
	forec_ets = StateSpaceModels.forecast(model_ets, steps_ahead)
	df_ets = DataFrames.DataFrame(Base.hcat(forec_ets.expected_value...)', :auto)
	DataFrames.rename!(df_ets, [:ets])
	return df_ets
end

function seas_naive(x, seas, steps_ahead)
	## Logarithms
	#x = Base.log.(x)
	
	## Seasonal Naive
	model_seas_naive = StateSpaceModels.SeasonalNaive(
		x, 
		seas)
	StateSpaceModels.fit!(
		model_seas_naive)
	forec_seas_naive = StateSpaceModels.forecast(
		model_seas_naive, steps_ahead)
	df_seas_naive = DataFrames.DataFrame(
		Base.hcat(forec_seas_naive.expected_value...)', :auto)
	DataFrames.rename!(df_seas_naive, [:seas_naive])
	return df_seas_naive
end

function auto_arima(x, seas, steps_ahead)
	## Logarithms
	#x = Base.log.(x)
	
	## Automatic ARIMA
	model_auto_arima = StateSpaceModels.auto_arima(
		x; 
		seasonal = seas)
	StateSpaceModels.fit!(
		model_auto_arima; 
		save_hyperparameter_distribution = false)
	forec_auto_arima = StateSpaceModels.forecast(model_auto_arima, steps_ahead)
	df_auto_arima = DataFrames.DataFrame(
		Base.hcat(forec_auto_arima.expected_value...)', :auto)
	DataFrames.rename!(df_auto_arima, [:auto_arima])
	return df_auto_arima
end

function struc_ss(x, seas, steps_ahead)
	## Logarithms
	#x = Base.log.(x)
	
	## Basic Structural State-Space
	model_struc_ss = StateSpaceModels.BasicStructural(
		x,
		seas)
	StateSpaceModels.fit!(
		model_struc_ss; 
		save_hyperparameter_distribution = false)
	forec_struc_ss = StateSpaceModels.forecast(model_struc_ss, steps_ahead)
	df_struc_ss = DataFrames.DataFrame(
		Base.hcat(forec_struc_ss.expected_value...)', :auto)
	DataFrames.rename!(df_struc_ss, [:struc_ss])
	return df_struc_ss
end

function ll(x, seas, steps_ahead)
	## Logarithms
	#x = Base.log.(x)
	
	## Local Level
	model_ll = StateSpaceModels.LocalLevel(
		x)
	StateSpaceModels.fit!(
		model_ll; 
		save_hyperparameter_distribution = false)
	forec_ll = StateSpaceModels.forecast(model_ll, steps_ahead)
	df_ll = DataFrames.DataFrame(Base.hcat(forec_ll.expected_value...)', :auto)
	DataFrames.rename!(df_ll, [:ll])
	return df_ll
end

function ll_trend(x, seas, steps_ahead)
	## Logarithms
	#x = Base.log.(x)
	
	## Local Linear Trend
	model_ll_trend = StateSpaceModels.LocalLinearTrend(
		x)
	StateSpaceModels.fit!(
		model_ll_trend; 
		save_hyperparameter_distribution = false)
	forec_ll_trend = StateSpaceModels.forecast(model_ll_trend, steps_ahead)
	df_ll_trend = DataFrames.DataFrame(
		Base.hcat(forec_ll_trend.expected_value...)', :auto)
	DataFrames.rename!(df_ll_trend, [:ll_trend])
	return df_ll_trend
end

function exper_seas_naive(x, seas, steps_ahead)
	## Logarithms
	#x = Base.log.(x)
	
	# Seasonal Naive model
	model_exper_seas_naive = StateSpaceModels.ExperimentalSeasonalNaive(
		x, 
		seas)
	StateSpaceModels.fit!(
		model_exper_seas_naive)
	forec_exper_seas_naive = StateSpaceModels.forecast(
		model_exper_seas_naive, steps_ahead)
	df_exper_seas_naive = DataFrames.DataFrame(
		Base.hcat(forec_exper_seas_naive.expected_value...)', :auto)
	DataFrames.rename!(df_exper_seas_naive, [:exper_seas_naive])
	return df_exper_seas_naive
end

function univariate_models(x, seas, steps_ahead)
	## Logarithms
	#x = Base.log.(x)
	#x = Base.log(Base.Complex(x))
	
	## SARIMA((0,1,1),(0,1,1))
	model_sarima = StateSpaceModels.SARIMA(
		x; 
		order = (0, 1, 1), 
		seasonal_order = (0, 1, 1, seas))
	StateSpaceModels.fit!(
		model_sarima; 
		save_hyperparameter_distribution = false)
	forec_sarima = StateSpaceModels.forecast(model_sarima, steps_ahead)
	df_sarima = DataFrames.DataFrame(
		Base.hcat(forec_sarima.expected_value...)', :auto)
	DataFrames.rename!(df_sarima, [:sarima])

	## Unobserved Components, Linear Trend, Seasonal
	model_uc = StateSpaceModels.UnobservedComponents(
		x; 
		trend = "local linear trend", 
		seasonal = "stochastic " * Base.string(seas))
	StateSpaceModels.fit!(
		model_uc; 
		save_hyperparameter_distribution = false)
	forec_uc = StateSpaceModels.forecast(model_uc, steps_ahead)
	df_uc = DataFrames.DataFrame(Base.hcat(forec_uc.expected_value...)', :auto)
	DataFrames.rename!(df_uc, [:uc])

	## Exponential Smoothing
	model_ets = StateSpaceModels.ExponentialSmoothing(
		x; 
		trend = true, 
		seasonal = seas)
	StateSpaceModels.fit!(
		model_ets; 
		save_hyperparameter_distribution = false)
	forec_ets = StateSpaceModels.forecast(model_ets, steps_ahead)
	df_ets = DataFrames.DataFrame(Base.hcat(forec_ets.expected_value...)', :auto)
	DataFrames.rename!(df_ets, [:ets])

	## Seasonal Naive
	model_seasonal_naive = StateSpaceModels.SeasonalNaive(
		x, 
		seas)
	StateSpaceModels.fit!(
		model_seasonal_naive)
	forec_seasonal_naive = StateSpaceModels.forecast(
		model_seasonal_naive, steps_ahead)
	df_seasonal_naive = DataFrames.DataFrame(
		Base.hcat(forec_seasonal_naive.expected_value...)', :auto)
	DataFrames.rename!(df_seasonal_naive, [:seasonal_naive])

	## Automatic Exponential Smoothing
	model_auto_ets = StateSpaceModels.auto_ets(
		x; 
		seasonal = seas)
	StateSpaceModels.fit!(model_auto_ets)
	forec_auto_ets = StateSpaceModels.forecast(model_auto_ets, steps_ahead)
	df_auto_ets = DataFrames.DataFrame(
		Base.hcat(forec_auto_ets.expected_value...)', :auto)
	DataFrames.rename!(df_auto_ets, [:auto_ets])

	## Automatic ARIMA
	model_auto_arima = StateSpaceModels.auto_arima(
		x; 
		seasonal = seas)
	StateSpaceModels.fit!(
		model_auto_arima; 
		save_hyperparameter_distribution = false)
	forec_auto_arima = StateSpaceModels.forecast(model_auto_arima, steps_ahead)
	df_auto_arima = DataFrames.DataFrame(
		Base.hcat(forec_auto_arima.expected_value...)', :auto)
	DataFrames.rename!(df_auto_arima, [:auto_arima])

	## Basic Structural State-Space
	model_struc_ss = StateSpaceModels.BasicStructural(
		x,
		seas)
	StateSpaceModels.fit!(
		model_struc_ss; 
		save_hyperparameter_distribution = false)
	forec_struc_ss = StateSpaceModels.forecast(model_struc_ss, steps_ahead)
	df_struc_ss = DataFrames.DataFrame(
		Base.hcat(forec_struc_ss.expected_value...)', :auto)
	DataFrames.rename!(df_struc_ss, [:struc_ss])

	## Local Level
	model_ll = StateSpaceModels.LocalLevel(
		x)
	StateSpaceModels.fit!(
		model_ll; 
		save_hyperparameter_distribution = false)
	forec_ll = StateSpaceModels.forecast(model_ll, steps_ahead)
	df_ll = DataFrames.DataFrame(Base.hcat(forec_ll.expected_value...)', :auto)
	DataFrames.rename!(df_ll, [:ll])

	#=
	## Local Level Cycle
	model_ll_cycle = StateSpaceModels.LocalLevelCycle(
		x)
	StateSpaceModels.fit!(
		model_ll_cycle; 
		save_hyperparameter_distribution = false)
	forec_ll_cycle = StateSpaceModels.forecast(model_ll_cycle, steps_ahead)
	df_ll_cycle = DataFrames.DataFrame(
		Base.hcat(forec_ll_cycle.expected_value...)', :auto)
	DataFrames.rename!(df_ll_cycle, [:ll_cycle])
	=#

	## Local Linear Trend
	model_ll_trend = StateSpaceModels.LocalLinearTrend(
		x)
	StateSpaceModels.fit!(
		model_ll_trend; 
		save_hyperparameter_distribution = false)
	forec_ll_trend = StateSpaceModels.forecast(model_ll_trend, steps_ahead)
	df_ll_trend = DataFrames.DataFrame(
		Base.hcat(forec_ll_trend.expected_value...)', :auto)
	DataFrames.rename!(df_ll_trend, [:ll_trend])

	#=
	## Naive
	model_naive = StateSpaceModels.Naive(x)
	StateSpaceModels.fit!(model_naive)
	forec_naive = StateSpaceModels.forecast(model_naive, steps_ahead)
	df_naive = DataFrames.DataFrame(
		Base.hcat(forec_naive.expected_value...)', :auto)
	DataFrames.rename!(df_naive, [:naive])
	=#

	# Seasonal Naive model
	model_exper_seas_naive = StateSpaceModels.ExperimentalSeasonalNaive(
		x, 
		seas)
	StateSpaceModels.fit!(
		model_exper_seas_naive)
	forec_exper_seas_naive = StateSpaceModels.forecast(
		model_exper_seas_naive, steps_ahead)
	df_exper_seas_naive = DataFrames.DataFrame(
		Base.hcat(forec_exper_seas_naive.expected_value...)', :auto)
	DataFrames.rename!(df_exper_seas_naive, [:exper_seas_naive])

	## Results to DataFrame
	results = Base.hcat(
		df_sarima, 
		df_auto_arima,
		df_uc, 
		df_ets, 
		df_auto_ets, 
		#df_ll_cycle,
		df_ll_trend, 
		# df_exper_seas_naive,
		 df_struc_ss#, 
		#df_ll, df_ll_cycle,
		#df_seasonal_naive, df_naive 
	)
	#results = Base.exp.(results)
	return results
end

function forecast_series(df, serie, year, month)
	y = year # Año a pronosticar (matriz years)
	m = month # Mes final observado de y
	df0 = df # DataFrame a analizar
	s = serie # Número de serie (corresponde a número de columnas de df menos 1)
	steps_ahead = 12 - m
	months_for = Base.collect((m + 1):12)
	fechas_ini = Dates.Date.(years, months_for[1], 1)
	fechas_for = Base.collect(
		(fechas_ini[y]):Dates.Month(1):(fechas_ini[y] + Dates.Month(steps_ahead-1)))
	fechas_for = Base.collect(
		(fechas_ini[y]):Dates.Month(1):(fechas_ini[y] + Dates.Month(steps_ahead-1)))
	df_test = DataFrames.subset(df0,
	   :Fechas => ByRow(<(fechas_ini[y])))[!, (s)]
	df_for = univariate_models(df_test, seas, steps_ahead)
	df_for = hcat(fechas_for, df_for)
	DataFrames.rename!(
		df_for, 
		Base.names(df_for) .=> Symbol.(["Fechas"; models_name]))
	return df_for
end

function forecast_df(dfx, dfx_name)
	for m in 1:11
		for s in 2:Base.size(dfx)[2]
			df_for = forecast_series(dfx, s, 1, m)
			for y in 2:Base.size(years)[1]
				df_for = Base.vcat(
					df_for, forecast_series(dfx, s, y, m)
				)
			end
		CSV.write("./Results/" * dfx_name * "/" * dfx_name * "_" * string.(Base.collect(s-1)) * "_" * string(Dates.monthabbr(m + 1)) * ".csv", df_for)
		end
	end
end

function rmse(y_true, y_pred)
	rmse = Base.sqrt(Base.sum(skipmissing(y_true .- y_pred).^2) / Base.length(y_true))
	return rmse
end


function create_df(f_i, m_n)
	# Estimar matriz A
	k = Base.size(df)[2]-1
	A = Base.zeros(Float64, steps, methods_n, k)
	df0 = DataFrames.subset(df,
	   :Fechas => ByRow(<=(Dates.Date(fechas[f_i]))))
	for j in 1:k
		A[:, :, j] .= univariate_models(
			df0[:, (j + 1)], 
			seas_type, 
			steps)
	end

	# Agregar matriz a DataFrame
	dfx = DataFrame()
	dfx[!, :Fechas] = 
		Dates.Date(fechas[f_i]):Dates.Month(1):(Dates.Date(fechas[f_i])+Dates.Month(steps-1))
	for m in 1:methods_n
		dfx[!, Symbol(methods_name[m])] .= 0.0
	end
	for j in 1:methods_n
		dfx[!, j+1] .= A[:, j, m_n]
	end
	dfx
end