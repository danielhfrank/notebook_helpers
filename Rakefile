
def notebook_name(ipynb)
  /(.*)\.ipynb/.match(ipynb)[1]
end

notebooks = Dir["**/*.ipynb"].reject{|ipynb| ipynb.start_with?("vendor/") || ipynb.end_with?('.built.ipynb')}

notebooks.each do |ipynb|

  Rake.load_rakefile(ipynb.sub('.ipynb', '.rake')) if File.file?(ipynb.sub('.ipynb', '.rake'))
  
  file "#{notebook_name(ipynb)}.built.ipynb" => :deps do
    sh "python scripts/repopulate_notebook_outputs.py #{notebook_name(ipynb)}.ipynb > #{notebook_name(ipynb)}.built.ipynb"
  end 

  file "#{notebook_name(ipynb)}.html" => ["#{notebook_name(ipynb)}.built.ipynb"] do 
    sh "ipython nbconvert #{notebook_name(ipynb)}.built.ipynb --stdout > #{notebook_name(ipynb)}.html"
  end

end

task :default => notebooks.map {|ipynb| "#{notebook_name(ipynb)}.html"} do 
  puts "I'm finished!"
end

task :clean do
  notebooks.map {|ipynb| ["#{notebook_name(ipynb)}.html", "#{notebook_name(ipynb)}.built.ipynb"]}.flatten.each do |f|
    if File.file?(f)
      puts "Removing #{f}"
      File.delete(f) 
    end
  end
end
