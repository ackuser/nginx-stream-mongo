# spec/Dockerfile_spec_with_errors.rb

require "serverspec"
require "docker-api"
#require "json"

describe "Dockerfile" do
  before(:all) do
    @image = Docker::Image.build_from_dir('/var/lib/jenkins/jobs/nginx/workspace/image', { 'dockerfile' => 'Dockerfile'})

    set :os, :family => 'redhat', :release => '7', :arch => 'x86_64'
    set :backend, :docker
    set :docker_image, @image.id
  end


  it "should be available" do
    expect(image).to_not be_nil
  end

  it "should have working directory" do
    expect(@image.json['Config']['WorkingDir']).to eq('/opt/produban')
  end

  it "should have environments variables" do
    expect(@image.json['Config']['Env']).to include("APP_HOME=/opt/app")
    expect(@image.json['Config']['Env']).to include("IMAGE_SCRIPT_HOME=/opt/produban")
  end

  it "should expose the default tcp port" do
    expect(@image.json["ContainerConfig"]["ExposedPorts"]).to include("8080/tcp")
   end

  it "installs required packages" do
    expect(package("unzip")).to be_installed
    expect(package("git")).to be_installed
    expect(package("strace")).to be_installed
    expect(package("ruby")).to be_installed
  end


  #it "installs the right version of Ubuntu" do
   # expect(os_version).to include("Red Hat Enterprise Linux Server release 7.2")
  #end

  #def os_version
  #  command("lsb_release -a").stdout
  #end
end
