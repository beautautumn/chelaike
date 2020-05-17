module ActiveRecord
  module Singleton

    # This pattern matches methods that should be made private because they
    # should not be used in singleton classes.
    PRIVATE = \
      /^all$|create(?!_reflection|_callback)|find(?!er|_callback)|firs|mini|max|new|d_sco|^upd/

    def self.included(model)
      model.class_eval do
        private_class_method *methods.grep(PRIVATE) # Deny existent others.

        class << self
          def exists? # Refuse arguments.
            super
          end

          def instance
            first || create
          end

          def inspect
            super.sub(/id: .+?, /) {} # Irrelevant.
          end

          def find(*)
            unless caller.first.include?("lib/active_record")
              raise NoMethodError,
                    "private method `find' called for #{inspect}"
            end
            super
          end

          def find_by_sql(*)
            unless caller.first.include?("lib/active_record")
              raise NoMethodError,
                    "private method `find_by_sql' called for #{inspect}"
            end
            super
          end
        end

        def clone
          raise TypeError, "can't clone instance of singleton #{self.class}"
        end

        def dup
          raise TypeError, "can't dup instance of singleton #{self.class}"
        end

        def inspect
          super.sub(/id: .+?, /) {} # Irrelevant.
        end
      end
    end
  end
end
