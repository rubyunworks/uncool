feature "Unit Test Coverage Report" do

  scenario "coverage via command-line require" do
    out = `ns="Example" ruby -Ilib -runcool test/fixtures/example_run.rb`
    out.assert =~ /^\+.*?Example#f/
  end

  scenario "coverage via command-line tool" do
    out = `ruby -Ilib -- ./bin/uncool-ruby -n Example test/fixtures/example_run.rb`
    out.assert =~ /^\+.*?Example#f/
  end

end

