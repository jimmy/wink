gem 'dm-core', '=0.9.2' 
require 'dm-core' 
 
module DataMapper::Resource 
  alias [] attribute_get  
  alias []= attribute_set 
end
