task :default => :test

task :test do
  sh 'testrb -Ilib ' + FileList['test/**/*test.rb'].join(' ')
end

task :rcov do
  sh 'rcov -Ilib ' + FileList['test/**/*test.rb'].join(' ')
end
