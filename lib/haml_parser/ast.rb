module HamlParser
  module Ast
    module HasChildren
      def initialize(*)
        super
        self.children ||= []
      end

      def <<(ast)
        self.children << ast
      end

      def to_h
        super.merge(children: children.map(&:to_h))
      end
    end

    class Root < Struct.new(:children)
      include HasChildren

      def to_h
        super.merge(type: 'root')
      end
    end

    class Doctype < Struct.new(:doctype, :filename, :lineno)
      def to_h
        super.merge(type: 'doctype')
      end
    end

    class Element < Struct.new(
      :children,
      :tag_name,
      :static_class,
      :static_id,
      :attributes,
      :oneline_child,
      :self_closing,
      :nuke_inner_whitespace,
      :nuke_outer_whitespace,
      :filename,
      :lineno,
    )
      include HasChildren

      def initialize(*)
        super
        self.static_class ||= ''
        self.static_id ||= ''
        self.attributes ||= ''
        self.self_closing ||= false
        self.nuke_inner_whitespace ||= false
        self.nuke_outer_whitespace ||= false
      end

      def to_h
        super.merge(
          type: 'element',
          oneline_child: oneline_child && oneline_child.to_h,
        )
      end
    end

    class Script < Struct.new(
      :children,
      :script,
      :escape_html,
      :preserve,
      :filename,
      :lineno,
    )
      include HasChildren

      def initialize(*)
        super
        if escape_html.nil?
          self.escape_html = true
        end
        if preserve.nil?
          self.preserve = false
        end
      end

      def to_h
        super.merge(type: 'script')
      end
    end

    class SilentScript < Struct.new(:children, :script, :mid_block_keyword, :filename, :lineno)
      include HasChildren

      def initialize(*)
        super
        if mid_block_keyword.nil?
          self.mid_block_keyword = false
        end
      end

      def to_h
        super.merge(type: 'silent_script')
      end
    end

    class HtmlComment < Struct.new(:children, :comment, :conditional, :filename, :lineno)
      include HasChildren

      def initialize(*)
        super
        self.comment ||= ''
        self.conditional ||= ''
      end

      def to_h
        super.merge(type: 'html_comment')
      end
    end

    class HamlComment < Struct.new(:children, :filename, :lineno)
      include HasChildren

      def to_h
        super.merge(type: 'haml_comment')
      end
    end

    class Text < Struct.new(:text, :escape_html, :filename, :lineno)
      def initialize(*)
        super
        if escape_html.nil?
          self.escape_html = true
        end
      end

      def to_h
        super.merge(type: 'text')
      end
    end

    class Filter < Struct.new(:name, :texts, :filename, :lineno)
      def initialize(*)
        super
        self.texts ||= []
      end

      def to_h
        super.merge(type: 'filter')
      end
    end

    class Empty < Struct.new(:filename, :lineno)
      def to_h
        super.merge(type: 'empty')
      end
    end
  end
end
