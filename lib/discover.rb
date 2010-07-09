if defined?(ActiveRecord)

  # In order to spec ActiveRecord finders
  # Implemented discover custom matcher
  #
  # :call-seq:
  #   Class.named_scope.should discover(model1, model2).after(model3)
  #
  # matcher subject should be an instance of ActiverRecord::NamedScope::Scoped or Array
  # models should be an instace of ActiverRecord::Base
  #
  # Use this if you need to check the inclution of objects ActiveRecord finders result
  # and it's order
  #
  # == Examples
  #
  #   class Group < AR::Base
  #     named_scope :approved, :conditions => "approved = true"
  #     named_scope :order_by_name, :order => "name"
  #   end
  #
  #   Group.approved.should discover(Group.create!(:approved => true))
  #   Group.approved.should_not discover(Group.create!(:approved => false))
  #   Group.order_by_name.should discover(Group.create!(:name => "bear").after(Group.create!(:name => "apple")))
  #
  #
  def discover(*objects)
    Rspec::Discover.new(*objects)
  end

end

module Rspec
  class Discover  #:nodoc:

    def initialize(*objects)
      @objects = objects
    end

    def with_exact_order
      @with_exact_order = true
      self
    end

    def matches?(scope)
      @scope = scope
      return valid_findness? && valid_indexes?
    end

    def does_not_match?(scope)
      @scope = scope
      if @with_exact_order
        raise "calling #with_exact_order is not allowed with should_not match"
      end
      return valid_not_findness?
    end

    def failure_message_for_should
      result = @not_found_object_ids.any? ? 
        "expected #{@scope.inspect} to include objects: #{@not_found_object_ids.inspect} " :
        "expected #{@scope.inspect} to be ordered as: #{@objects.map(&:id).inspect}"
      result += ",but it was not.\n" 
      result += found_objects_string
      result
    end

    def failure_message_for_should_not
      result = "expected #{@scope.inspect} to not include objects: #{@found_object_ids.inspect} " 
      result += ", but it was." 
      result += found_objects_string
      result
    end


    def description
      "discover #{@objects.map(&:inspect).join(', ')} " + ordering_string
    end

    protected

    def valid_findness?
      result = true
      @not_found_object_ids = []
      @objects.each do |object|
        unless @scope.include?(object)
          @not_found_object_ids << object.id
          result = false
        end
      end
      result
    end


    def valid_indexes?
      return true unless @with_exact_order
      indexes = @objects.map{|o| @scope.index(o)}
      return indexes.sort == indexes
    end

    def valid_not_findness?
      result = true
      @found_object_ids = []
      @objects.each do |object|
        if @scope.include?(object)
          @found_object_ids << object.id
          result = false
        end
      end
      result
    end

    def found_objects_string
      "Found objects: " + @scope.map(&:id).inspect
    end


    def ordering_string
      @with_exact_order ? "with exact order" : ""
    end

  end
end


