require 'rails_helper'
require 'huginn_agent/spec_helper'

describe Agents::FileUrlAgent do
  before(:each) do
    @valid_options = Agents::FileUrlAgent.new.default_options
    @checker = Agents::FileUrlAgent.new(:name => "FileUrlAgent", :options => @valid_options)
    @checker.user = users(:bob)
    @checker.save!
  end

  pending "add specs here"
end
