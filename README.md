## Requirements
  * [Redis](https://redis.io/topics/quickstart)

## Installation

```sh
$ cd rate-limiter
```

```sh
$ bundle install
```

```sh
$ rails db:create && rails db:migrate && rails db:seed
```


## Start

```sh
$ foreman start
```

Check out the example response from the link below
```sh
http://localhost:3001/api/v1/users
```

## Tests

```sh
$ rspec --format documentation
```
