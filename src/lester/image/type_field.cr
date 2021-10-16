struct Lester::Image
  module TypeField
    macro included
      @type : String?

      def type : Lester::Image::Type?
        @type.try { |type| Lester::Image::Type.parse(type.gsub '-', '_') }
      end
    end
  end
end
