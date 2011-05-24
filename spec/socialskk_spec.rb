# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'kconv'

describe "SosicalSKK" do
  before :all do
    @ime = SocialSKK.new("localhost", 12345, nil, 3600)
  end

  describe "searching other servers" do
    # pending "this needs to access other SKK servers
    context "when the server has a candidate" do
      subject { @ime.__send__(:search_others, (Kconv.toeuc("1じゅうかき \n"))) }
      it { should be_include Kconv.toeuc("重火器") }
    end

    context "when the server has no candidates" do
      subject { @ime.__send__(:search_others, (Kconv.toeuc("1ないたんご \n"))) }
      it { should be_nil }
    end
    # end
  end
end
