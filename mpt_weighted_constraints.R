library(quadprog)
library(quantmod)

# Define the tickers of the stocks and ETF
tickers <- c("VFC", "WBD", "MTCH", "PYPL", "PARA", "ILMN", "ETSY", "WBA", "GNRC", "CHTR")

# Set the start and end dates
end_date <- Sys.Date()  # Today's date
start_date <- end_date - 36*30  # 36 months ago (roughly)

# Fetch the data for selected date range
getSymbols(tickers, from = start_date, to = end_date, src = "yahoo")

# Create a data frame to store adjusted closing prices
prices <- NULL

# Extract adjusted closing prices and create a data frame
for (ticker in tickers) {
  prices <- cbind(prices, Ad(get(ticker)))
}

prices = data.frame(prices)

# Rename columns with ticker symbols
colnames(prices) <- tickers

# Ensure train_data and test_data are numeric matrices
prices <- as.matrix(prices)

# Calculate log daily returns 
price_returns <- diff(log(prices), lag = 1)

# Estimate the expected return and the covariance matrix
mu <- colMeans(price_returns)
sigma <- cov(price_returns)
n <- length(mu)

## Create optimised portfolio

# Function to compute portfolio return and risk
portfolio_stats <- function(weights, mu, sigma) {
  portfolio_return <- sum(weights * mu)
  portfolio_std_dev <- sqrt(t(weights) %*% sigma %*% weights)
  return(c(portfolio_return, portfolio_std_dev))
}

# Function to find optimal portfolio weights using quadratic programming
optimize_portfolio <- function(mu, sigma, target_return, constraint_matrix, constraint_vector) {
  n <- length(mu)
  dvec <- rep(0, n)
  Dmat <- sigma
  Amat <- constraint_matrix
  bvec <- constraint_vector
  opt_portfolio <- solve.QP(Dmat, dvec, Amat, bvec=bvec, meq=1)
  return(opt_portfolio$solution)
}

# Constraint matrix and vector
constraint_matrix <- matrix(c(rep(1, n)), nrow=1)
constraint_vector <- c(1)

# Find optimal portfolio weights
target_return <- 0.05
optimal_weights <- optimize_portfolio(mu, sigma, target_return, t(constraint_matrix), constraint_vector)

# Print results
print(optimal_weights)
portfolio_stats(optimal_weights, mu, sigma)
