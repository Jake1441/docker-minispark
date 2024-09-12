#!/bin/bash

for i in {14..24}; do
	data=20$i.csv.gz
    wget -c https://www.ncei.noaa.gov/pub/data/ghcn/daily/by_year/$data -O $(pwd)/daily/$data
done
