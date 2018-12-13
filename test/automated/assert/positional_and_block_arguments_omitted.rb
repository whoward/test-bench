require_relative '../../test_init'

context "Assert" do
  context "Positional And Block Arguments Omitted" do
    begin
      Controls::Evaluate.() do
        assert
      end
    rescue ArgumentError => argument_error
    end

    test "Raises argument error" do
      refute(argument_error.nil?)
    end
  end
end
