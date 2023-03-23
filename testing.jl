using DelimitedFiles, Printf

const filamentDir = "/media/chris/data/testrun/tips";

function loadFilamentData(n; processes=4, filDir=filamentDir)
	tmp = []
	for p in 0:(processes-1)
		file = @sprintf("%s/%04d/tips%03d.0001",filDir,n,p);
		try
			push!(tmp, readdlm(file));
		catch
			@warn "File $file could not be read!"
		end
	end
	if !isempty(tmp)
		return reduce(vcat, tmp)
	else
		return Array{Float64,2}(undef,1,3)
	end
end

using Distances, Clustering, NearestNeighbors

R = pairwise(Euclidean(), points, dims=1);

hcl = hclust(R)
groups=cutree(hcl; k=3)

pl = plot()
scatter!(pl, points[:,1], points[:,2], points[:,3], label="Unsorted")
for k in 1:3
	plot!(pl, points[findall(groups.==k),1], points[findall(groups.==k),2], points[findall(groups.==k),3], label="k=$(k)")
end
plot!(pl, xlabel="z", ylabel="x", zlabel="y")
display(pl)

