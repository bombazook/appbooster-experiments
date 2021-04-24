### To run locally

`docker-compose -f docker-compose-local.yml up -d --build`

### 600-new-ids load test using [drill](https://github.com/fcsonline/drill)

`drill --benchmark experiment_bench.yml --stats`

results for Macbook Air:
```
New Experiments           Total requests            6000
New Experiments           Successful requests       6000
New Experiments           Failed requests           0
New Experiments           Median time per request   18ms
New Experiments           Average time per request  20ms
New Experiments           Sample standard deviation 10ms

Time taken for tests      12.3 seconds
Total requests            6000
Successful requests       6000
Failed requests           0
Requests per second       488.43 [#/sec]
Median time per request   18ms
Average time per request  20ms
Sample standard deviation 10ms
```

### To run specs

`docker-compose -f docker-compose-local.yml run test bundle exec rspec spec`

### Live demo

[experiments.kostrov.net](https://experiments.kostrov.net)
