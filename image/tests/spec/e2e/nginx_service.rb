require_relative '../serverspec_init'

describe 'Nginx image integration test' do
 it 'returns port 8080 web page' do
    sleep 5
    expect(command('curl --write-out %{http_code} --silent --output /dev/null http://127.0.0.1:8080').stdout).to eq('200')
    expect(command('curl -L http://127.0.0.1:8080').stdout).to include 'Welcome'
 end

it 'returns port 8081 status web page' do
    expect(command('curl --write-out %{http_code} --silent --output /dev/null http://127.0.0.1:8081/nginx_status').stdout).to eq('200')#
    expect(command('curl -L http://127.0.0.1:8081/nginx_status').stdout).to include 'Active connections'
 end

end
