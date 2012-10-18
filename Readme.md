# Accept values for

## Description

This gem provides an rspec matcher that helps you to test ActiveModel validation.

## Usage

[RSpec matcher to test the validation](http://gusiev.com/2010/06/ultimate-rspec-matcher-to-test-validation/)

``` ruby
describe User do

  subject { User.new(@valid_attributes)}
  
  it { should accept_values_for(:email, "john@example.com", "lambda@gusiev.com") }
  it { should_not accept_values_for(:email, "invalid", nil, "a@b", "john@.com") }
end
```

You can specify which values should be accepted by model as valid and which values should not be accepted as invalid.


## Dependencies

* ActiveModel
* Rspec

## Install


### Gemfile

``` ruby
group :test do
  gem 'accept_values_for'
end
```


## Self-Promotion

Like accept\_values\_for? 

Follow the repository on [GitHub](https://github.com/bogdan/accept_values_for). 

Read [author blog](http://gusiev.com).
