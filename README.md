# README
https://monster-siren.hypergryph.com/

## Setup development

```
docker build -t develop .
docker run -it --mount type=bind,src=$(pwd),dst=/develop develop bash
```

## Run

```
ruby run.rb
```
