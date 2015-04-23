


# HTTP with backup server(s)

[![Linux Build Status](https://travis-ci.org/metacran/spareserver.svg?branch=master)](https://travis-ci.org/metacran/spareserver)
[![Windows Build status](https://ci.appveyor.com/api/projects/status/github/metacran/spareserver?svg=true)](https://ci.appveyor.com/project/gaborcsardi/spareserver)
[![CRAN RStudio mirror downloads](http://cranlogs.r-pkg.org/badges/spareserver)](http://cran.r-project.org/web/packages/spareserver/index.html)

An extremely simple fallback algorithm, to query a backup HTTP server,
if the first choice HTTP server is down.

The algorithm works fine if a server is completely down, but might fail if
the network is unreliable and/or slow. Consider this before you use this
package. Suggestions for improvements are welcome.

## Installation


```r
library(devtools)
install_github("metacran/spareserver")
```

## Usage

You can define services, and will use multiple servers.
Each server has a default priority, and the servers are
tried in the order of decreasing priority.


```r
library(spareserver)
```

```
#> Loading required package: methods
```

```r
add_service("cran-packages",
  server("http://cran.r-project.org/web/packages", priority = 10),
  server("http://cran.rstudio.com/web/packages", priority = 5)
)
```

Then you can make a robust query. Here we use the `httr` package.


```r
library(httr)
spare_q("cran-packages", "/ggplot2/index.html", GET)
```

```
#> Response [http://cran.r-project.org/web/packages/ggplot2/index.html]
#>   Date: 2015-04-23 15:10
#>   Status: 200
#>   Content-Type: text/html
#>   Size: 25.8 kB
#> <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3....
#> <html xmlns="http://www.w3.org/1999/xhtml">
#> <head>
#> <title>CRAN - Package ggplot2</title>
#> <link rel="stylesheet" type="text/css" href="../../CRAN_web.css" />
#> <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
#> <meta name="citation_title" content="An Implementation of the Grammar of...
#> <meta name="citation_author" content="Hadley Wickham" />
#> <meta name="citation_author" content="Winston Chang" />
#> <meta name="citation_publication_date" content="2015-03-17" />
#> ...
```

```r
remove_service("cran-packages")
```

In the next example, the first server is unreachable,
so we will use the fallback server.


```r
add_service("cran-packages",
  server("http://192.0.2.1/foobar", priority = 10),
  server("http://cran.rstudio.com/web/packages", priority = 5)
)
```


```r
spare_q("cran-packages", "/ggplot2/index.html", GET)
```

```
#> Response [http://cran.rstudio.com/web/packages/ggplot2/index.html]
#>   Date: 2015-04-23 15:10
#>   Status: 200
#>   Content-Type: text/html
#>   Size: 25.8 kB
#> <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3....
#> <html xmlns="http://www.w3.org/1999/xhtml">
#> <head>
#> <title>CRAN - Package ggplot2</title>
#> <link rel="stylesheet" type="text/css" href="../../CRAN_web.css" />
#> <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
#> <meta name="citation_title" content="An Implementation of the Grammar of...
#> <meta name="citation_author" content="Hadley Wickham" />
#> <meta name="citation_author" content="Winston Chang" />
#> <meta name="citation_publication_date" content="2015-03-17" />
#> ...
```

```r
remove_service("cran-packages")
```

## Algorithm

* Each server has a state, with a time label. The state is simply 'on',
  'off' or 'unknown'.
* States expire, relatively quickly, right now in three minutes. Then they
  become 'unknown', effectively.
* Sort the servers according to their priorities.
* Find the first server with an 'on' state. If needed, ping
  servers in an 'unknown' state, to see if they are up.
* Try the server with the 'on' state. If it works, good, update
  its time stamp.
* Otherwise set its state to 'off' with the current timestamp,
  and continue with the next server.

If all servers are down, then we start over, with fives times bigger
timeout. We only do two rounds currently.

## License

MIT
