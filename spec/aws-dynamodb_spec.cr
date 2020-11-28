require "./spec_helper"

describe Aws::DynamoDB do
  it "holds a version" do
    Aws::DynamoDB::VERSION.should_not be_empty
  end

  it "holds metadata" do
    Aws::DynamoDB::METADATA.should_not be_empty
    Aws::DynamoDB::METADATA[:service_name].should_not be_empty
    Aws::DynamoDB::METADATA[:service_id].should_not be_empty
    Aws::DynamoDB::METADATA[:target_prefix].should_not be_empty
  end
end
