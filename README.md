## produban's nginx image

This image is based on Redhat nginx image, this docker image supports binary deployment.

## Maintainers

```
Produban
```

### Binary deployment

This image is able to download statics files and configuration, both kind of files must be packaged as tgz/tar.gz following this directory structure:
```
*.tgz
    html/ (all the statics files must be stored in this directory)
    conf.d/ (all the nginx configuration files must be stored in this directory)
```

If you want to override the 80 port server configuration place a file inside the `*.tgz` in the folder `conf.d` called `default.conf`. You can base it's content in the file with the same name in this repo.

In order to download the tgz (binary deployment file) this image uses the next environment variables:

- ARTIFACT_URL

This docker image is able to download an artifact with static files from any https/http web server, the articaft can be tgz/tar.gz.

docker run -ti --rm --env ARTIFACT_URL=http://192.168.1.39:8383/static.tar.gz produban/nginx:latest

It is possible to package differents kind of files using tgz/tar.gz artifact, at least one of them must be static files, even config files but it is most uselfull to use ARTIFACTCONF_URL for that.The package tgz/tar.gz is deployed in the /opt/app directory.

- ARTIFACTCONF_URL

This docker image is able to download an artifact with the configuration files from any https/http web server. The artifact configutarion can be default.conf.

docker run -ti --rm --env ARTIFACTCONF_URL=http://192.168.1.39:8383/conf.tar.gz produban/nginx:latest

It is only to package configuration files using tgz/tar.gz. The package tgz/tar.gz is deployed in the /opt/app directory.

> NOTE: Please, pay attention to the file formats supported by this image since it will fail in another case

### Templating nginx config files

The "*.conf" files located inside the "conf.d" folder of the "*.tgz" package are all preprocessed using [ruby templates](https://en.wikipedia.org/wiki/ERuby) with erb.

With this feature you can for example interpolate environment variables:
```
    location /api {
        proxy_pass <%= ENV["API_BACKEND"] %>;
    }
```

Or also make conditional statements:
```
    <% if ENV["FORCE_HTTPS"] %>
      if ($http_x_forwarded_proto = http) {
        return 301 https://$host$request_uri;
      }
    <% end %>
```

### Time Zone

This image uses the default time zone "Europe/Madrid", if you want to change the default time zone, you must provide the environment variable TZ.