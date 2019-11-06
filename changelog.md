# ChangeLog

## Version 3.0.4
- Maintenance

## Version 3.0.3
- Dynamic configuration has been added

## Version 3.0.2
- Server header vulnerability has been fixed

## Version 3.0.1

- Updated nginx version to 1.12.1

## Version 2.0.1
- Fixed git clone
## Version 2.0.0
- Image base is Rhel 7
- Nginx version is 1.10.3

## Version 1.6.2
- nginx user run with uid
- connect-timeout to 60 secs.
- --no-cache=true in build.sh

## Version 1.5.7
- Added new field called ARTIFACTCONF_URL to add configuration files to image.
- nginx user run the nginx process. root user can not do it.
- A new page have been added to request with pages error for 40x and 50x error http.

## Version 1.5.1
- Added generic network for server status.

## Version 1.5.0
- If there is /conf.d but no /html now it is treated as nginx configuration.
  If there is /html and /conf.d old behaviour is maintained.
- Added Changelog

## Version 1.4.1
- Added documentation in the template description. Image was not modified.

## Version 1.4.0
- Added support for cloning git repositories
- Added support for deploying folder root when there is no /html folder
