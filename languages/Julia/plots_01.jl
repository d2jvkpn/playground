using Plots

mkpath("tmp");

####
x = 1:10
y = [12, 30, 11, 80, 5, 1, 78, 45, 90, 14]
gr()
plot(x, y)
savefig("tmp/plot_01a.pdf")

####
numIndustries = [17, 400, 5000, 15000, 20000, 45000]
globalTemperatures = [14.4, 14.5, 14.8, 15.2, 15.5, 15.8]

gr();

plot(
  numIndustries, globalTemperatures,
  label="line", title="Title",
  xlabel="Number of Industries", ylabel="Temperatures",
)

scatter!(numIndustries, globalTemperatures, label="points")
savefig("tmp/plot_01b.pdf")
