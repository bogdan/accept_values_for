# Accept values for

## Description

In order to spec ActiveRecord models.
I decided to write a few custom matchers that makes the work match easier:


## Matchers

* accept_values_for
* discover

### Accept values for

"Rpec matcher to test the validation":http://gusiev.com/2010/06/ultimate-rspec-matcher-to-test-validation/


``` ruby
describe User do

  subject { User.new(@valid_attributes)}
  
  it { should accept_values_for(:email, "john@example.com", "lambda@gusiev.com") }
  it { should_not accept_values_for(:email, "invalid", nil, "a@b", "john@.com") }
end
```

### Discovery matcher

"Rspec matcher to test named scopes":http://gusiev.com/2010/07/bdd-rspec-matcher-to-test-named_scope-scoped-rails


``` ruby
describe "#by_category_id named scope" do
  let(:given_category) do 
    Factory.create(:given_category)
  end


  let(:product_in_given_category) do
    Factory.create(
      :product,
      :categories => [category]
    )
  end

  let(:product_not_in_given_category) do
    Factory.create(
      :product,
      :categories => [Factory.create(:category)]
    )
  end

  # This might be tricky to redefine subject as the finder result
  # but in this way we can delegate the matcher to subject and 
  # avoid writing test descriptions.
  subject { described_class.by_category_id(given_category.id) }

  it { should discover(product_in_given_category) }
  it { should_not discover(product_not_in_given_category) }

end 
```


## Dependencies

  * ActiveRecord
  * Rspec

## Install


### Gemfile

``` ruby
gem 'accept_values_for'
```

### spec_helper.rb:

``` ruby
require 'accept_values_for'
require 'discover'
```
