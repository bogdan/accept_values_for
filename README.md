# AcceptValuesFor

Writing specs for complex validations is annoying. AcceptValuesFor makes it easy
to test your validations with real world values, asserting which values should
be accepted by your model and which should not.

Read the [original blog post](http://gusiev.com/2010/06/ultimate-rspec-matcher-to-test-validation/).

[![Gem Version](https://badge.fury.io/rb/accept_values_for.png)](http://badge.fury.io/rb/accept_values_for)
[![Build Status](https://github.com/bogdan/accept_values_for/workflows/CI/badge.svg?branch=master)](https://github.com/bogdan/accept_values_for/actions)
[![Code Climate](https://codeclimate.com/github/bogdan/accept_values_for.png)](https://codeclimate.com/github/bogdan/accept_values_for)

## Usage

```ruby
describe User do
  describe "validation" do
    subject(:user) { User.new }

    it { should accept_values_for(:email, "john@example.com", "jane@example.org") }
    it { should_not accept_values_for(:email, nil, " ", "john", "john@example") }
  end
end
```

## Dependencies

* Active Model (6, 7, 8)
* RSpec (3)

## Installation

### Gemfile

```ruby
group :test do
  gem "accept_values_for"
end
```

## Self-Promotion

Like AcceptValuesFor?

Watch the repository on [GitHub](https://github.com/bogdan/accept_values_for)
and read [my blog](http://gusiev.com).
