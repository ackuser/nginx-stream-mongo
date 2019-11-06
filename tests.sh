echo "Testing nginx docker image"

rspecpath= $(which rspec)
echo ${rspecpath}

/usr/local/bin/rspec image/tests/spec/unit/Dockerfile_spec.rb
/usr/local/bin/rspec image/tests/spec/e2e/nginx_service.rb
