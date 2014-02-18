# AcceptValuesFor

Writing specs for complex validations is annoying. AcceptValuesFor makes it easy
to test your validations with real world values, asserting which values should
be accepted by your model and which should not.

Read the [original blog post](http://gusiev.com/2010/06/ultimate-rspec-matcher-to-test-validation/).

## Usage

```ruby
describe User do
  describe "validation"
    subject(:user) { User.new }

    it "requires a valid email address" do
      expect(user).to accept_values_for(:email, "john@example.com", "jane@example.org")
      expect(user).not_to accept_values_for(:email, nil, " ", "john", "john@example")
    end
  end
end
```

## Dependencies

* Active Model (3 or 4)
* RSpec (2)

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