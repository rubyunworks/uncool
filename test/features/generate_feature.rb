feature "Unit Test Code Generation" do

  scenario "Generate example via API" do
    require 'uncool/app'
    app = Uncool::App.new(:namespaces=>"Example")
    out = app.generate(['test/fixtures/example_run.rb'])
    out.assert =~ /^TestCase\ Example/
  end

  scenario "Generate example via command-line" do
    out = `ruby -Ilib -- ./bin/uncool-ruby -g -n Example test/fixtures/example_run.rb`
    out.assert =~ /^TestCase\ Example/
  end

end

