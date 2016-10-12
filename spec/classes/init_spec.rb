require 'spec_helper'
describe 'iucvtty_console' do

  context 'with defaults for all parameters' do
    it { should contain_class('iucvtty_console') }
  end
end
