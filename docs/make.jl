using Documenter
using TaylorMap

makedocs(
    sitename = "TaylorMap",
    format = Documenter.HTML(),
    modules = [TaylorMap]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
