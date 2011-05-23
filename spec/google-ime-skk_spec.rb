# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'kconv'

describe "GoogleImeSkk" do
  before :all do
    @ime = GoogleImeSkk.new("localhost", 12343, nil, 3600)
  end

  it "can search" do
    Kconv.toutf8(@ime.social_ime_search(Kconv.toeuc("ねこ"))).should match "猫"
  end
end

describe "GoogleImeSkk::CLI" do
  it "can calculate by day" do
    GoogleImeSkk::CLI.time_parse("1d").should == 24*60*60
  end
  it "can calculate by hour" do
    GoogleImeSkk::CLI.time_parse("2h").should == 2*60*60
  end
  it "can calculate by minute" do
    GoogleImeSkk::CLI.time_parse("1m").should == 60
  end
  it "can calculate by second" do
    GoogleImeSkk::CLI.time_parse("13s").should == 13
  end
  it "can calculate without suffix" do
    GoogleImeSkk::CLI.time_parse("13").should == 13
  end
end
