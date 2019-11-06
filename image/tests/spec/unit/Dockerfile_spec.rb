# spec/Dockerfile_spec.rb
require_relative '../serverspec_init'


describe "Dockerfile" do

  it "should be available" do
    expect(@image).to_not be_nil
  end

  it "should have working directory" do
    expect(@image.json['Config']['WorkingDir']).to eq('/opt/produban')
  end

  it "should have environments variables" do
    expect(@image.json['Config']['Env']).to include("APP_HOME=/opt/app")
    expect(@image.json['Config']['Env']).to include("IMAGE_SCRIPTS_HOME=/opt/produban")
  end

  it "should expose the default tcp port" do
    expect(@image.json["ContainerConfig"]["ExposedPorts"]).to include("8081/tcp")
   end

  it "installs required packages" do
    expect(package("unzip")).to be_installed
    expect(package("tar")).to be_installed
    expect(package("strace")).to be_installed
    expect(package("ruby")).to be_installed
  end

end
