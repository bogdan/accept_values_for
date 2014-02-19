require "spec_helper"

describe AcceptValuesFor do
  let(:person) { Person.new(:name => "John", :gender => "MALE") }
  let(:matcher) { AcceptValuesFor::Matcher.new(:gender, *values) }

  describe "#matches?" do
    context "when a single value is accepted" do
      let(:values) { ["MALE"] }

      it "passes" do
        expect(matcher.matches?(person)).to be_true
      end
    end

    context "when multiple values are accepted" do
      let(:values) { ["MALE", "FEMALE"] }

      it "passes" do
        expect(matcher.matches?(person)).to be_true
      end
    end

    context "when a single value is rejected" do
      let(:values) { ["INVALID"] }

      it "fails" do
        expect(matcher.matches?(person)).to be_false
      end

      it "provides a proper failure message" do
        matcher.matches?(person)

        expect(matcher.failure_message_for_should).to eq(<<-MSG)

expected to accept values: ["INVALID"]
                 accepted: []

Errors:
  "INVALID": ["is not included in the list"]

        MSG
      end
    end

    context "when multiple values are rejected" do
      let(:values) { ["INVALID", "WRONG"] }

      it "fails" do
        expect(matcher.matches?(person)).to be_false
      end

      it "provides a proper failure message" do
        matcher.matches?(person)

        expect(matcher.failure_message_for_should).to eq(<<-MSG)

expected to accept values: ["INVALID", "WRONG"]
                 accepted: []

Errors:
  "INVALID": ["is not included in the list"]
    "WRONG": ["is not included in the list"]

        MSG
      end
    end

    context "when one value is accepted and another is rejected" do
      let(:values) { ["MALE", "INVALID"] }

      it "fails" do
        expect(matcher.matches?(person)).to be_false
      end

      it "provides a proper failure message" do
        matcher.matches?(person)

        expect(matcher.failure_message_for_should).to eq(<<-MSG)

expected to accept values: ["MALE", "INVALID"]
                 accepted: ["MALE"]

Errors:
  "INVALID": ["is not included in the list"]

        MSG
      end
    end
  end

  describe "#does_not_match?" do
    context "when a single value is accepted" do
      let(:values) { ["MALE"] }

      it "fails" do
        expect(matcher.does_not_match?(person)).to be_false
      end

      it "provides a proper failure message" do
        matcher.does_not_match?(person)

        expect(matcher.failure_message_for_should_not).to eq(<<-MSG)

expected to reject values: ["MALE"]
                 rejected: []

        MSG
      end
    end

    context "when multiple values are accepted" do
      let(:values) { ["MALE", "FEMALE"] }

      it "fails" do
        expect(matcher.does_not_match?(person)).to be_false
      end

      it "provides a proper failure message" do
        matcher.does_not_match?(person)

        expect(matcher.failure_message_for_should_not).to eq(<<-MSG)

expected to reject values: ["MALE", "FEMALE"]
                 rejected: []

        MSG
      end
    end

    context "when a single value is rejected" do
      let(:values) { ["INVALID"] }

      it "passes" do
        expect(matcher.does_not_match?(person)).to be_true
      end
    end

    context "when multiple values are rejected" do
      let(:values) { ["INVALID", "WRONG"] }

      it "passes" do
        expect(matcher.does_not_match?(person)).to be_true
      end
    end

    context "when one value is accepted and another is rejected" do
      let(:values) { ["MALE", "INVALID"] }

      it "fails" do
        expect(matcher.does_not_match?(person)).to be_false
      end

      it "provides a proper failure message" do
        matcher.matches?(person)

        expect(matcher.failure_message_for_should_not).to eq(<<-MSG)

expected to reject values: ["MALE", "INVALID"]
                 rejected: ["INVALID"]

        MSG
      end
    end
  end

  describe "API" do
    it "provides the accept_values_for convenience method" do
      expect(person).to accept_values_for(:gender, "MALE", "FEMALE")
      expect(person).not_to accept_values_for(:gender, "INVALID", "WRONG")
      expect(person).to accept_values_for(:name, "John")
      expect(person).not_to accept_values_for(:name, nil)
    end
  end
end
