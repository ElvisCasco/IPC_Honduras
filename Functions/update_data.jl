## Depurar fechas
global 	function StrToDate(x)
    try
        Dates.Date.(x)
    catch
        return missing
    end
end


global function StrToInt(x)
    try
        Base.parse.(Int64, x)
    catch
        return missing
    end
end


function StrToFloat(x)
    try
        Base.parse.(Float64, x)
    catch
        return 0
    end
end

function AnyToFloat(x)
    try
        Base.parse.(string, x)
        Base.parse.(Float64, x)
    catch
        return 0
    end
end

tf = PrettyTables.TextFormat(
  up_right_corner     = ' ',
  up_left_corner      = ' ',
  bottom_left_corner  = ' ',
  bottom_right_corner = ' ',
  up_intersection     = ' ',
  left_intersection   = ' ',
  right_intersection  = ' ',
  middle_intersection = ' ',
  bottom_intersection  = ' ',
  column              = ' ',
  row                 = '-',
  hlines              = [:begin,:header,:end]
  );

function formato_tabla(df)
    PrettyTables.pretty_table(
        df,
        formatters = ft_printf("%5.4f"),
        compact_printing = true, 
        #nosubheader=true; 
        backend = Val(:text),
        vlines = :all,
        crop=:none, 
        tf = tf)
end


function get_data()
	I_x = XLSX.readxlsx(wd * "/Data/base.xlsx")[1][:][3:end,2:end];
	I_x = Base.permutedims(I_x);
	#I_x = DataFrame(I_x);
	I_x = DataFrames.DataFrame(
		I_x,
		:auto
		);
	DataFrames.rename!(I_x, Base.names(I_x) .=> Symbol.(Vector(I_x[1,1:end])));
	DataFrames.rename!(I_x, "Productos" => "Fechas");
	I_x = I_x[3:end,:];
	I_x[!,1] = Dates.Date.(I_x[!,1]);
	I_x[!,2:end] = Float64.(I_x[!,2:end]);
	CSV.write(
		wd * "/Data/Base/data.csv", 
		delim = ';',
		I_x);
	return I_x;
end

function get_groups()
	grupos = XLSX.readxlsx(wd * "/Data/clasificar.xlsx")["tabla"][:];
	grupos = DataFrame(
		grupos,
		:auto
		);
	#grupos = DataFrames.DataFrame(grupos);
	DataFrames.rename!(grupos, Base.names(grupos) .=> Symbol.(Vector(grupos[1, :])));
	grupos = DataFrames.DataFrame(grupos[2:end, :]);
	CSV.write(
		wd * "/Data/Base/grupos.csv", 
		delim = ';',
		grupos);
	grupos = CSV.read(
		wd * "/Data/Base/grupos.csv", 
		DataFrames.DataFrame);
	return grupos;
end

function get_ipc()
	w_x = XLSX.readxlsx(wd * "/Data/base.xlsx")[1][:][4:end,1];
	I_x = get_data();
	ipc = Base.sum(Base.eachcol(Base.permutedims(w_x) .*
			Array(I_x[:,2:end]))) ./ 100;
	ipc = DataFrames.DataFrame(
		Fechas = Dates.Date.(I_x[:, 1]),
		ipc = ipc);
	CSV.write(
		wd * "/Data/Grupos/ipc.csv", 
		delim = ';',
		ipc);
	return ipc;
end

function join_data_groups()
	I_x = XLSX.readxlsx(wd * "/Data/base.xlsx")[1][:][3:end,2:end];
	I_x = DataFrame(
		I_x,
		:auto
		);
	#I_x = DataFrames.DataFrame(I_x);
	DataFrames.rename!(I_x, Base.names(I_x) .=> Symbol.(Vector(I_x[1,1:end])));
	I_x = I_x[2:end,:];
	I_x[!,1:2] = String.(I_x[!,1:2]);
	I_x[!,3:end] = Float64.(I_x[!,3:end]);

	## Agregar agrupaciones a índices
	grupos = get_groups()
	data = DataFrames.innerjoin(
		grupos, I_x,
		on = :Codigo,
		makeunique = true);
	CSV.write(
		wd * "/Data/Base/data_pond.csv", 
		delim = ';',
		data)
	return data;
end

global function formato(x)
	try
		Base.convert(
			Array{Float64, 1},
			x)
	catch
		Base.convert(
			Array{String, 1},
			x)
	end
end

function get_grouped_indices()
	grupos = get_groups();
	data_pond = join_data_groups();
	#I_x = get_data();
	listas = DataFrames.names(grupos)[4:end]

	for g in 1:Base.size(listas)[1]
		inicio = Base.size(grupos, 2) + 2
		final = Base.size(data_pond)[2]
		I_g = DataFrames.select(data_pond,collect(inicio:final))
		I_g = Base.hcat(data_pond[!,[2,g+3]],I_g)
		pesos = DataFrames.combine(
			DataFrames.groupby(I_g,listas[g]),
			:peso => sum  => :peso)
		I_g = DataFrames.leftjoin(I_g, pesos, on=listas[g], makeunique=true)
		I_g = DataFrames.select(I_g,1,size(I_g)[2],2,3:(size(I_g)[2]-1))
		for x in 4:size(I_g)[2]
			I_g[!,x] = I_g[!,x] .* I_g[!,1] ./ I_g[!,2] 
		end
		I_g = DataFrames.select(I_g,3:size(I_g)[2])
		I_g = DataFrames.combine(
			DataFrames.groupby(I_g,listas[g]),
			[DataFrames.names(I_g)[i] => sum  => DataFrames.names(I_g)[i] for i in 2:size(I_g)[2]])
		nombres = Symbol.(I_g[!, 1]);
		fechas = DataFrames.names(I_g)[2:end];
		I_g = DataFrames.DataFrame(
			Base.permutedims(Array(I_g)),
			:auto
			)
		DataFrames.rename!(I_g, Base.names(I_g) .=> nombres);
		I_g = I_g[2:Base.size(I_g, 1), :]
		I_g = Base.hcat(fechas,I_g)
		DataFrames.rename!(I_g, Base.names(I_g)[1] .=> :Fechas);
		DataFrames.rename!(I_g, Base.names(I_g)[2:end] .=> nombres);
		CSV.write(
			wd * "/Data/Grupos/" * listas[g] * ".csv", 
			delim = ';',
			I_g);
	end
end

function get_weights_groups()
	#wd = "C:/IE/Julia/Inflacion_Componentes";
	grupos = get_groups();
	listas = DataFrames.names(grupos)[4:end]
	w_x = grupos[!,2]
	for g in 1:size(listas)[1]
		grupo = grupos[!,g+3]
		grupo = Vector(grupo)
		G = DataFrames.DataFrame(
			Matrix(hcat(grupo,w_x)),
			:auto
			)
		#G = DataFrames.DataFrame(Matrix(hcat(grupo,w_x)))
		DataFrames.rename!(G, Base.names(G) .=> Symbol.([listas[g],:w_g]));
		G[!,1] = Symbol.(G[!,1])
		G[!,2] = Float64.(G[!,2])
		w_g = DataFrames.combine(
			DataFrames.groupby(
			G, Symbol(listas[g])),
			:w_g => sum  => :w_g)
		CSV.write(
			wd * "/Data/Pesos/" * listas[g] * ".csv",
			delim = ';',
			w_g);
	end
end

function get_delta()
	# Grupos
	grupos = get_groups();
	listas = DataFrames.names(grupos)[4:end]
	## Índices
	for g in 1:Base.size(listas)[1]
		I_g = CSV.read(
			wd * "/Data/Grupos/" * listas[g] * ".csv", 
			delim = ';',
			DataFrames.DataFrame);
	## Variaciones Mensuales
		Delta_1_I_g = copy(I_g)
		Delta_1_I_g[1,2:end] .= 0
		Delta_1_I_g[2:end,2:end] = I_g[2:end,2:end] ./ I_g[1:(end-1),2:end] .* 100 .- 100
		CSV.write(
			wd * "/Data/Mensual/" * listas[g] * ".csv", 
			delim = ';',
			Delta_1_I_g);

	## Variaciones Mensuales, Contribución
		# Primer componente: $\Delta I_{g,t}$
		Delta_1_I_g_Matrix = Array(Delta_1_I_g[2:end,2:end])
		# Segundo componente: \frac{w_g \cdot I_{g,t-1}}{ipc_{t-1}}
		w_g = CSV.read(
			wd * "/Data/Pesos/" * listas[g] * ".csv", 
			delim = ';',
			DataFrames.DataFrame);
		w_g = Vector(Float64.(w_g[:,2]) ./ 100)'
		w_g_I_g_1 = w_g .* Array(I_g[1:(end-1),2:end])
		ipc = get_ipc()
		ipc_1 = Vector(ipc[1:(end-1),2])
		contrib_t1 = w_g_I_g_1 ./ ipc_1
		# Contribución a la variación
		
		contrib = copy(I_g)
		contrib[1,2:end] .= 0
		contrib[2:end,2:end] = Delta_1_I_g_Matrix .* contrib_t1
			
		#contrib = Delta_1_I_g_Matrix .* contrib_t1
		#contrib = DataFrames.DataFrame(hcat(I_g[2:end,1],contrib),:auto)
		#contrib = DataFrames.DataFrame(hcat(I_g[!,1],contrib))
		#DataFrames.rename!(contrib, Base.names(contrib) .=> Base.names(I_g));
		#contrib.Fechas = Dates.Date.(contrib.Fechas)
		#contrib[!,2:end] = Float64.(contrib[!,2:end])
		CSV.write(
			wd * "/Data/Contrib_1/" * listas[g] * ".csv", 
			delim = ';',
			contrib);

	## Variaciones Interanuales
		Delta_12_I_g = copy(I_g)
		Delta_12_I_g[1:12,2:end] .= 0
		Delta_12_I_g[13:end,2:end] = I_g[13:end,2:end] ./ I_g[1:(end-12),2:end] .* 100 .- 100
		CSV.write(
			wd * "/Data/Interanual/" * listas[g] * ".csv", 
			delim = ';',
			Delta_12_I_g);

	## Variaciones Interanuales, Contribución
		# Primer componente: $\Delta I_{g,t}$
		Delta_12_I_g_Matrix = Array(Delta_12_I_g[13:end,2:end])
		# Segundo componente: \frac{w_g \cdot I_{g,t-1}}{ipc_{t-1}}
		#=w_g = CSV.read(
			wd * "/Data/Pesos/" * listas[g] * ".csv", 
			delim = ';',
			DataFrames.DataFrame);
		w_g = Vector(Float64.(w_g[:,2]) ./ 100)'=#
		w_g_I_g_12 = w_g .* Array(I_g[1:(end-12),2:end])
		ipc = get_ipc()
		ipc_12 = Vector(ipc[1:(end-12),2])
		contrib_t12 = w_g_I_g_12 ./ ipc_12
		# Contribución a la variación
		
		contrib_12 = copy(I_g)
		contrib_12[1:12,2:end] .= 0
		contrib_12[13:end,2:end] = Delta_12_I_g_Matrix .* contrib_t12

		#contrib_12 = Delta_12_I_g_Matrix .* contrib_t12
		#contrib_12 = DataFrames.DataFrame(hcat(I_g[13:end,1],contrib_12),:auto)
		#contrib_12 = DataFrames.DataFrame(hcat(I_g[!,1],contrib_12))
		#DataFrames.rename!(contrib_12, Base.names(contrib_12) .=> Base.names(I_g));
		contrib_12.Fechas = Dates.Date.(contrib_12.Fechas)
		contrib_12[!,2:end] = Float64.(contrib_12[!,2:end])
		CSV.write(
			wd * "/Data/Contrib_12/" * listas[g] * ".csv", 
			delim = ';',
			contrib_12);

	end

	# IPC
	## Índices
	ipc = CSV.read(
		wd * "/Data/Grupos/ipc.csv", 
		DataFrames.DataFrame); 
	## Variaciones Mensuales
	Delta_1_ipc = copy(ipc)
	Delta_1_ipc[1,2:end] .= 0
	Delta_1_ipc[2:end,2:end] = ipc[2:end,2:end] ./ ipc[1:(end-1),2:end] .* 100 .- 100
	CSV.write(
		wd * "/Data/Mensual/ipc.csv", 
		delim = ';',
		Delta_1_ipc);

	## Variaciones Interanuales
	Delta_12_ipc = copy(ipc)
	Delta_12_ipc[1:12,2:end] .= 0
	Delta_12_ipc[13:end,2:end] = ipc[13:end,2:end] ./ ipc[1:(end-12),2:end] .* 100 .- 100
	CSV.write(
		wd * "/Data/Interanual/ipc.csv", 
		delim = ';',
		Delta_12_ipc);
end

function crear_CSVs()
	get_data();
	get_ipc();
	get_groups();
	get_weights_groups()
	join_data_groups();
	get_grouped_indices();
	get_delta();
end
