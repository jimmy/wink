task :default => :test

task :test do
  sh 'testrb -Ilib ' + FileList['test/**/*test.rb'].join(' ')
end

task :rcov do
  sh 'rcov -t -Ilib ' + FileList['test/**/*test.rb'].join(' ')
end

namespace :test do
  task :indie do
    FileList['test/**/*test.rb'].each do |test_file|
      sh "testrb -Ilib #{test_file}"
    end
  end
end
