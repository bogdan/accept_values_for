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
      @after_objects = []
    end

    def after(object)
      @after_objects << object
      self
    end

    def matches?(scope)
      @scope = scope
      return valid_findness? && valid_indexes?
    end

    def does_not_match?(scope)
      @scope = scope
      if @after_objects.any?
        raise "calling #after is not allowed with should_not match"
      end
      return valid_not_findness?
    end

    def failure_message_for_should
      result = "expected #{@scope.inspect} to include objects: #{@objects.inspect} " 
      result += after_string
      result += ",but it was not.\n" 
      result += found_objects_string
      result
    end

    def failure_message_for_should_not
      result = "expected #{@scope.inspect} to include objects: #{@objects.inspect} " 
      result += after_string
      result += ", but it was." 
      result += found_objects_string
      result
    end


    def description
      "discover #{@objects.map(&:inspect).join(', ')} " + after_string
    end

    protected

    def valid_findness?
      ((@objects + @after_objects) - @scope).empty?
    end


    def valid_indexes?
      return true if @after_objects.blank?
      min_index = @objects.map{|o| @scope.index(o)}.min
      index_range = @after_objects.map{|o| @scope.index(o)}.reverse + [min_index]
      index_range == index_range.sort
    end

    def valid_not_findness?
      @scope - @objects == @scope
    end

    def invalid_scope_string
      "expected #{scope} to be an instance of ActiveRecord::NamedScope::Scope but it wasn't"
    end

    def found_objects_string
      "Found objects: " + @scope.map(&:id).inspect
    end


    def after_string
      return "" if @after_objects.blank?
      result = ""
      @after_objects.each do |after_object|
        result += "after: #{after_object.inspect} "
      end
      result
    end

  end
end


