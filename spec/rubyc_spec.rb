require File.expand_path("../spec_helper", __FILE__)

module Danger
  describe Danger::DangerRubyc do
    it "should be a plugin" do
      expect(Danger::DangerRubyc.new(nil)).to be_a Danger::Plugin
    end

    #
    # You should test your custom attributes and methods here
    #
    describe "with Dangerfile" do
      before do
        @dangerfile = testing_dangerfile
        @my_plugin = @dangerfile.rubyc

        # mock the PR data
        # you can then use this, eg. github.pr_author, later in the spec
        json = File.read(File.dirname(__FILE__) + '/support/fixtures/github_pr.json') # example json: `curl https://github.com/skatkov/danger-rubyc/pull/1 > github_pr.json`
        allow(@my_plugin.github).to receive(:pr_json).and_return(json)
      end

      # Some examples for writing tests
      # You should replace these with your own.

      it "#lint files" do
        @my_plugin.lint

        expect(@dangerfile.status_report[:warnings]).to eq(["Trying to merge code on a Monday"])
      end
    end
  end
end
