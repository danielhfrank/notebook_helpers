require 'digest'

BASE_DIR = '/tmp/nbviewer'

def notebook_name(ipynb)
  /(.*)\.ipynb/.match(ipynb)[1]
end

def notebook_signature(ipynb)
  Digest::MD5.file(ipynb).hexdigest
end

notebooks = Dir["**/*.ipynb"].reject do |ipynb|
  ipynb.end_with?(".built.ipynb") ||
  ipynb.split('/').include?('.ipynb_checkpoints')
end

notebooks.each do |ipynb|

  Rake.load_rakefile(ipynb.sub('.ipynb', '.rake')) if File.file?(ipynb.sub('.ipynb', '.rake'))

  name = notebook_name(ipynb)
  dir = File.dirname(name)
  sig = notebook_signature(ipynb)

  # Generate html repr tagged with sig, to its own persistent dir
  file "#{BASE_DIR}/#{name}.#{sig}.html" do |t|
    mkdir_p File.dirname(t.name)
    sh "runipy --skip-exceptions #{ipynb} --html #{t.name}"
  end

  # Link from deploy dir to original html file for this signature in persistent dir
  # DON'T explicitly depend on the html file in /tmp/nbviewer - will set off chain reaction
  # of building everything because base dependency is in this repo (ie newer than /tmp/nbviewer)
  file "nbviewer/#{name}.html" do |t|
    mkdir_p "nbviewer/#{dir}"
    orig_html_file = "#{BASE_DIR}/#{name}.#{sig}.html"
    Rake::Task[orig_html_file].invoke unless File.exist?(orig_html_file)
    sh "ln -s #{orig_html_file} #{t.name}"
  end

end

task :build_notebooks => notebooks.map {|ipynb| "nbviewer/#{notebook_name(ipynb)}.html"} do 
  puts "I'm finished!"
end


task :setup_pre_commit_hook do
  repo_abs_path = `git rev-parse --show-toplevel`

  sh "ln -s #{repo_abs_path.strip}/hooks/pre-commit .git/hooks/pre-commit"
end
