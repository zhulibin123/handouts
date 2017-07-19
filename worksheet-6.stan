data {
  int N;
  vector[N] log_weight;
  vector[N] hindfoot_length;
  int genus[N];
  int M;

} 
parameters {
  real beta0;
  vector[M] beta1;
  real beta2;
  real<lower=0> sigma;
  real<lower=0> sigma_genus;
}
transformed parameters {
  vector[N] mu;
  for (i in 1:N)
    mu = beta0 + beta1[genus]+ hindfoot_length * beta2;
}
model {
  log_weight ~ normal(mu, sigma);
  beta0 ~ normal(0, 10);
  beta1 ~ normal(0, sigma_genus);
  beta2 ~ normal(0, 10);
  sigma_genus ~ cauchy(0, 5);
}
