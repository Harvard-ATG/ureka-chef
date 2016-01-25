# spec_helper.rb
require 'chefspec'
require 'chefspec/berkshelf'

describe 'ureka::defualt' do
let(chef:run) {
     ChefSpec::Runner.new.converge(described_recipe)
}  

end
