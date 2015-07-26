immutable NoncentralF <: ContinuousUnivariateDistribution
    ndf::Float64
    ddf::Float64
    λ::Float64

    function NoncentralF(n::Real, d::Real, nc::Real)
        n > zero(n) && d > zero(d) && nc >= zero(nc) ||
	       error("ndf and ddf must be > 0 and λ >= 0")
	    @compat new(Float64(n), Float64(d), Float64(nc))
    end
end

@distr_support NoncentralF 0.0 Inf

mean(d::NoncentralF) = d.ddf > 2.0 ? d.ddf / (d.ddf - 2.0) * (d.ndf + d.λ) / d.ndf : NaN

var(d::NoncentralF) = d.ddf > 4.0 ? 2.0 * d.ddf^2 *
		       ((d.ndf+d.λ)^2 + (d.ddf - 2.0)*(d.ndf + 2.0*d.λ)) /
		       (d.ndf * (d.ddf - 2.0)^2 * (d.ddf - 4.0)) : NaN

@_delegate_statsfuns NoncentralF nfdist ndf ddf λ

function rand(d::NoncentralF)
    rn = rand(NoncentralChisq(d.ndf,d.λ)) / d.ndf
    rd = rand(Chisq(d.ddf)) / d.ddf
    rn / rd
end
